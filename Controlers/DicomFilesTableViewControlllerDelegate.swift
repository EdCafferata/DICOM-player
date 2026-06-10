import CoreGraphics
import UIKit

// MARK: - Output model

struct ParsedDICOM {
    let patientName: String
    let modality: String
    let rows: Int
    let columns: Int
    let frames: [CGImage]
    let windowCenter: Double
    let windowWidth: Double

    // Raw pixeldata per frame (alleen grijswaarden, niet-gecomprimeerd) zodat
    // de viewer met Window/Level-presets opnieuw kan vensteren. Leeg bij
    // JPEG-gecomprimeerde of kleurbeelden — presets dan niet beschikbaar.
    var rawFrames: [Data] = []
    var bitsAllocated: Int = 16
    var isSigned: Bool = false
    var invert: Bool = false
    var rescaleSlope: Double = 1      // (0028,1053) — voor HU-conversie
    var rescaleIntercept: Double = 0  // (0028,1052)

    var kanHervensteren: Bool { !rawFrames.isEmpty }

    /// Rendert de raw frames opnieuw met een ander venster (center/width in
    /// raw pixelwaarden — gebruik huNaarRaw voor HU-presets).
    func render(center: Double, width: Double) -> [CGImage] {
        rawFrames.compactMap {
            DICOMParser.renderFrame($0, rows: rows, columns: columns,
                                    bits: bitsAllocated, isSigned: isSigned,
                                    invert: invert, center: center, width: width)
        }
    }

    /// Zet een venster in Hounsfield Units om naar raw pixelwaarden
    /// via Rescale Slope/Intercept (HU = raw × slope + intercept).
    func huNaarRaw(center hu: Double, width huWidth: Double) -> (Double, Double) {
        let slope = rescaleSlope != 0 ? rescaleSlope : 1
        return ((hu - rescaleIntercept) / slope, huWidth / slope)
    }
}

/// Lichtgewicht header-info voor de Series navigator — leest géén pixeldata,
/// zodat een hele map snel gegroepeerd kan worden.
struct DICOMHeader {
    let patientName: String
    let modality: String
    let seriesUID: String          // (0020,000E) Series Instance UID
    let seriesDescription: String  // (0008,103E)
    let instanceNumber: Int        // (0020,0013) — volgorde binnen de serie
}

enum DICOMError: LocalizedError {
    case notDICOM
    case missingPixelData
    case badDimensions
    case parseError(String)

    var errorDescription: String? {
        switch self {
        case .notDICOM:          return "Not a valid DICOM file"
        case .missingPixelData:  return "No pixel data found"
        case .badDimensions:     return "Invalid image dimensions"
        case .parseError(let s): return s
        }
    }
}

// MARK: - Byte reader

private final class ByteReader {
    let data: Data
    var offset: Int

    init(_ data: Data, offset: Int = 0) { self.data = data; self.offset = offset }

    var isAtEnd: Bool { offset >= data.count }
    var remaining: Int { max(0, data.count - offset) }

    func readU16() -> UInt16? {
        guard remaining >= 2 else { return nil }
        let v = UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
        offset += 2; return v
    }

    func readU32() -> UInt32? {
        guard remaining >= 4 else { return nil }
        let v = UInt32(data[offset])
            | (UInt32(data[offset + 1]) << 8)
            | (UInt32(data[offset + 2]) << 16)
            | (UInt32(data[offset + 3]) << 24)
        offset += 4; return v
    }

    func readBytes(_ n: Int) -> Data? {
        guard n >= 0, remaining >= n else { return nil }
        defer { offset += n }
        return Data(data[offset..<offset + n])
    }

    func skip(_ n: Int) { offset += min(max(0, n), remaining) }

    func readASCII(_ n: Int) -> String {
        guard let d = readBytes(n) else { return "" }
        return (String(data: d, encoding: .ascii) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Parser

struct DICOMParser {

    static func parse(url: URL) throws -> ParsedDICOM {
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        return try parse(data: data)
    }

    static func parse(data: Data) throws -> ParsedDICOM {
        // Validate DICOM magic at byte 128
        guard data.count > 132,
              data[128] == 0x44, data[129] == 0x49,
              data[130] == 0x43, data[131] == 0x4D
        else { throw DICOMError.notDICOM }

        let r = ByteReader(data, offset: 132)

        var transferSyntax    = "1.2.840.10008.1.2.1"   // Explicit VR LE (default)
        var patientName       = ""
        var modality          = ""
        var rows              = 0
        var columns           = 0
        var bitsAllocated     = 16
        var pixelRep: UInt16  = 0
        var nFrames           = 1
        var samplesPerPixel   = 1
        var photometric       = "MONOCHROME2"
        var windowCenter      = 0.0
        var windowWidth       = 0.0
        var rescaleSlope      = 1.0
        var rescaleIntercept  = 0.0
        var rawPixels: Data?  = nil
        var encBlob: Data     = Data()
        var encapsulated      = false
        var explicitVR        = true
        var metaDone          = false

        while !r.isAtEnd {
            guard let group = r.readU16(), let element = r.readU16() else { break }

            // Sequence / item delimiters: skip 4-byte length and continue
            if group == 0xFFFE { r.skip(4); continue }

            // Switch to dataset VR mode once past File Meta group (0002)
            if group > 0x0002 && !metaDone {
                metaDone  = true
                explicitVR = transferSyntax != "1.2.840.10008.1.2"
            }

            let vr: String
            let valueLen: UInt32

            if explicitVR || group == 0x0002 {
                guard let vrData = r.readBytes(2) else { break }
                vr = String(data: vrData, encoding: .ascii) ?? "UN"
                if ["OB","OD","OF","OL","OV","OW","SQ","UC","UN","UR","UT","SV","UV"].contains(vr) {
                    r.skip(2)
                    guard let l = r.readU32() else { break }
                    valueLen = l
                } else {
                    guard let l = r.readU16() else { break }
                    valueLen = UInt32(l)
                }
            } else {
                vr = Self.implicitVR(group: group, element: element)
                guard let l = r.readU32() else { break }
                valueLen = l
            }

            let undefined = valueLen == 0xFFFFFFFF
            let tag = (UInt32(group) << 16) | UInt32(element)

            // Skip sequences
            if vr == "SQ" || (undefined && tag != 0x7FE00010) {
                if undefined { Self.skipToDelimiter(r, explicit: explicitVR) } else { r.skip(Int(valueLen)) }
                continue
            }

            // Pixel data
            if tag == 0x7FE00010 {
                if undefined {
                    encapsulated = true
                    encBlob      = Self.extractEncapsulated(r)
                } else {
                    rawPixels = r.readBytes(Int(valueLen))
                }
                continue
            }

            let len = Int(valueLen)

            switch tag {
            case 0x00020010:
                let s = r.readASCII(len)
                if !s.isEmpty { transferSyntax = s }

            case 0x00100010:
                if let d = r.readBytes(len) {
                    patientName = (String(data: d, encoding: .utf8) ?? "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "^", with: " ")
                        .trimmingCharacters(in: .whitespaces)
                }

            case 0x00080060: modality = r.readASCII(len)

            case 0x00280010:
                if let d = r.readBytes(len), d.count >= 2 {
                    rows = Int(UInt16(d[0]) | (UInt16(d[1]) << 8))
                }

            case 0x00280011:
                if let d = r.readBytes(len), d.count >= 2 {
                    columns = Int(UInt16(d[0]) | (UInt16(d[1]) << 8))
                }

            case 0x00280100:
                if let d = r.readBytes(len), d.count >= 2 {
                    bitsAllocated = Int(UInt16(d[0]) | (UInt16(d[1]) << 8))
                }

            case 0x00280103:
                if let d = r.readBytes(len), d.count >= 2 {
                    pixelRep = UInt16(d[0]) | (UInt16(d[1]) << 8)
                }

            case 0x00280008:
                nFrames = max(1, Int(r.readASCII(len)) ?? 1)

            case 0x00280002:
                if let d = r.readBytes(len), d.count >= 2 {
                    samplesPerPixel = Int(UInt16(d[0]) | (UInt16(d[1]) << 8))
                }

            case 0x00280004:
                photometric = r.readASCII(len)

            case 0x00281050:
                let s = r.readASCII(len)
                windowCenter = Double(s.components(separatedBy: "\\").first ?? s) ?? 0

            case 0x00281051:
                let s = r.readASCII(len)
                windowWidth = Double(s.components(separatedBy: "\\").first ?? s) ?? 0

            case 0x00281052:
                rescaleIntercept = Double(r.readASCII(len)) ?? 0

            case 0x00281053:
                rescaleSlope = Double(r.readASCII(len)) ?? 1

            default:
                r.skip(len)
            }
        }

        guard rows > 0, columns > 0 else { throw DICOMError.badDimensions }

        let isSigned = pixelRep == 1
        let invert   = photometric == "MONOCHROME1"

        let frames: [CGImage]
        var rawFrames: [Data] = []
        if encapsulated {
            frames = Self.decodeJPEG(encBlob)
        } else {
            guard let pixels = rawPixels else { throw DICOMError.missingPixelData }
            if windowWidth <= 0 {
                (windowCenter, windowWidth) = Self.autoWindow(
                    pixels, bits: bitsAllocated, isSigned: isSigned, isColor: samplesPerPixel > 1)
            }
            frames = Self.decodeRaw(pixels,
                                    rows: rows, columns: columns, nFrames: nFrames,
                                    bits: bitsAllocated, samples: samplesPerPixel,
                                    isSigned: isSigned, invert: invert,
                                    center: windowCenter, width: windowWidth)
            // Raw grijswaarden bewaren voor Window/Level-presets (geen kleur)
            if samplesPerPixel == 1 {
                rawFrames = Self.sliceFrames(pixels, rows: rows, columns: columns,
                                             nFrames: nFrames, bits: bitsAllocated)
            }
        }
        if frames.isEmpty { throw DICOMError.missingPixelData }

        return ParsedDICOM(
            patientName: patientName,
            modality: modality,
            rows: rows, columns: columns,
            frames: frames,
            windowCenter: windowCenter,
            windowWidth: windowWidth,
            rawFrames: rawFrames,
            bitsAllocated: bitsAllocated,
            isSigned: isSigned,
            invert: invert,
            rescaleSlope: rescaleSlope,
            rescaleIntercept: rescaleIntercept
        )
    }

    /// Knipt het raw pixelblok in losse frames (voor hervensteren).
    private static func sliceFrames(_ data: Data, rows: Int, columns: Int,
                                    nFrames: Int, bits: Int) -> [Data] {
        let bytesPerSample = max(1, bits / 8)
        let frameSize = rows * columns * bytesPerSample
        guard frameSize > 0, data.count >= frameSize else { return [] }
        return (0..<nFrames).compactMap { f in
            let start = f * frameSize
            guard start + frameSize <= data.count else { return nil }
            return Data(data[start..<start + frameSize])
        }
    }

    /// Publieke render van één raw frame met opgegeven venster — gebruikt
    /// door ParsedDICOM.render() voor de Window/Level-presets.
    static func renderFrame(_ data: Data, rows: Int, columns: Int,
                            bits: Int, isSigned: Bool, invert: Bool,
                            center: Double, width: Double) -> CGImage? {
        makeImage(data, rows: rows, columns: columns,
                  bits: bits, samples: 1,
                  isSigned: isSigned, invert: invert,
                  center: center, width: width)
    }

    // MARK: - Header-only parse (Series navigator)

    /// Leest alleen de metadata-tags die nodig zijn om series te groeperen.
    /// Stopt vóór de pixeldata, dus dit is snel genoeg om bij elke reload
    /// over alle bestanden te draaien.
    static func parseHeader(url: URL) -> DICOMHeader? {
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe),
              data.count > 132,
              data[128] == 0x44, data[129] == 0x49,
              data[130] == 0x43, data[131] == 0x4D
        else { return nil }

        let r = ByteReader(data, offset: 132)

        var transferSyntax = "1.2.840.10008.1.2.1"
        var patientName = "", modality = ""
        var seriesUID = "", seriesDescription = ""
        var instanceNumber = 0
        var explicitVR = true
        var metaDone = false

        while !r.isAtEnd {
            guard let group = r.readU16(), let element = r.readU16() else { break }
            if group == 0xFFFE { r.skip(4); continue }

            if group > 0x0002 && !metaDone {
                metaDone = true
                explicitVR = transferSyntax != "1.2.840.10008.1.2"
            }
            // Alles wat we nodig hebben zit vóór groep 0028 — daarna stoppen.
            if metaDone && group > 0x0020 { break }

            let vr: String
            let valueLen: UInt32
            if explicitVR || group == 0x0002 {
                guard let vrData = r.readBytes(2) else { break }
                vr = String(data: vrData, encoding: .ascii) ?? "UN"
                if ["OB","OD","OF","OL","OV","OW","SQ","UC","UN","UR","UT","SV","UV"].contains(vr) {
                    r.skip(2)
                    guard let l = r.readU32() else { break }
                    valueLen = l
                } else {
                    guard let l = r.readU16() else { break }
                    valueLen = UInt32(l)
                }
            } else {
                vr = Self.implicitVR(group: group, element: element)
                guard let l = r.readU32() else { break }
                valueLen = l
            }

            let undefined = valueLen == 0xFFFFFFFF
            if vr == "SQ" || undefined {
                if undefined { Self.skipToDelimiter(r, explicit: explicitVR) }
                else { r.skip(Int(valueLen)) }
                continue
            }

            let len = Int(valueLen)
            let tag = (UInt32(group) << 16) | UInt32(element)
            switch tag {
            case 0x00020010:
                let s = r.readASCII(len)
                if !s.isEmpty { transferSyntax = s }
            case 0x00100010:
                if let d = r.readBytes(len) {
                    patientName = (String(data: d, encoding: .utf8) ?? "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: "^", with: " ")
                        .trimmingCharacters(in: .whitespaces)
                }
            case 0x00080060: modality = r.readASCII(len)
            case 0x0008103E: seriesDescription = r.readASCII(len)
            case 0x0020000E: seriesUID = r.readASCII(len)
            case 0x00200013: instanceNumber = Int(r.readASCII(len)) ?? 0
            default: r.skip(len)
            }
        }

        return DICOMHeader(
            patientName: patientName,
            modality: modality,
            seriesUID: seriesUID,
            seriesDescription: seriesDescription,
            instanceNumber: instanceNumber
        )
    }

    // MARK: - Sequence helpers

    // Skips tags until it finds a sequence delimiter (E0DD) or item delimiter (E00D),
    // then returns. Must know whether the dataset uses explicit or implicit VR.
    private static func skipToDelimiter(_ r: ByteReader, explicit: Bool) {
        while !r.isAtEnd {
            guard let g = r.readU16(), let e = r.readU16() else { break }

            if g == 0xFFFE {
                guard let l = r.readU32() else { break }
                if e == 0xE0DD || e == 0xE00D { return }          // sequence or item end
                if l == 0xFFFFFFFF { skipToDelimiter(r, explicit: explicit) }
                else { r.skip(Int(l)) }
                continue
            }

            let length: Int
            if explicit {
                guard let vrBytes = r.readBytes(2) else { break }
                let vr = String(data: vrBytes, encoding: .ascii) ?? "UN"
                let longVRs = ["OB","OD","OF","OL","OV","OW","SQ","UC","UN","UR","UT","SV","UV"]
                if longVRs.contains(vr) {
                    r.skip(2)
                    guard let l = r.readU32() else { break }
                    length = Int(l)
                } else {
                    guard let l = r.readU16() else { break }
                    length = Int(l)
                }
            } else {
                guard let l = r.readU32() else { break }
                length = Int(l)
            }

            if length == Int(bitPattern: UInt(0xFFFFFFFF)) {
                skipToDelimiter(r, explicit: explicit)
            } else {
                r.skip(length)
            }
        }
    }

    // Collects all encapsulated items into one concatenated blob (skipping the BOT).
    // Items are often split across multiple FFFE,E000 chunks for one frame, so we
    // concatenate everything and let the marker-based splitter find frame boundaries.
    private static func extractEncapsulated(_ r: ByteReader) -> Data {
        var blob = Data()
        var isFirst = true
        while !r.isAtEnd {
            guard let g = r.readU16(), let e = r.readU16() else { break }
            if g == 0xFFFE && e == 0xE0DD { r.skip(4); break }   // sequence delimiter
            guard g == 0xFFFE, e == 0xE000 else { break }         // must be item
            guard let l = r.readU32() else { break }
            if l == 0xFFFFFFFF { continue }
            if isFirst { isFirst = false; r.skip(Int(l)); continue } // skip BOT
            if let item = r.readBytes(Int(l)) { blob.append(item) }
        }
        return blob
    }

    // MARK: - Compressed decode (JPEG, JPEG 2000, JPEG-LS — whatever iOS supports)

    private static func decodeJPEG(_ blob: Data) -> [CGImage] {
        // Split on SOI/EOI markers first — handles multi-frame and single-frame equally.
        // Direct decode is skipped because it would return only the first frame for
        // concatenated multi-frame blobs (JPEG Lossless and JPEG 2000 multi-frame).
        let split = splitAndDecode(blob)
        if !split.isEmpty { return split }
        // Fallback for blobs without standard SOI/EOI delimiters
        if let img = cgImage(from: blob) { return [img] }
        return []
    }

    // Searches for JPEG (FF D8) and JPEG 2000 (FF 4F) start markers + FF D9 end marker.
    private static func splitAndDecode(_ data: Data) -> [CGImage] {
        let startMarkers: [Data] = [Data([0xFF, 0xD8]), Data([0xFF, 0x4F])]
        let endMarker = Data([0xFF, 0xD9])
        var frames: [CGImage] = []
        var pos = data.startIndex

        while pos < data.endIndex {
            var earliest: Range<Data.Index>? = nil
            for marker in startMarkers {
                if let found = data.range(of: marker, in: pos..<data.endIndex) {
                    if earliest == nil || found.lowerBound < earliest?.lowerBound ?? data.endIndex { earliest = found }
                }
            }
            guard let soi = earliest else { break }
            if let eoi = data.range(of: endMarker, in: soi.upperBound..<data.endIndex) {
                if let img = cgImage(from: Data(data[soi.lowerBound..<eoi.upperBound])) {
                    frames.append(img)
                }
                pos = eoi.upperBound
            } else {
                if let img = cgImage(from: Data(data[soi.lowerBound...])) { frames.append(img) }
                break
            }
        }
        return frames
    }

    private static func cgImage(from data: Data) -> CGImage? {
        // Detect JPEG Lossless (SOF3 = FF C3) in first 300 bytes → skip CGImageSource,
        // which on iOS "succeeds" on the JFIF header but returns a black image for SOF3.
        let probe = min(data.count - 1, 299)
        var hasSof3 = false
        for i in 0..<probe where data[i] == 0xFF && data[i + 1] == 0xC3 { hasSof3 = true; break }
        if !hasSof3 {
            if let src = CGImageSourceCreateWithData(data as CFData, nil),
               let img = CGImageSourceCreateImageAtIndex(src, 0, nil) { return img }
        }
        return JpegLossless.decode(data)
    }

    // MARK: - Raw pixel decode

    private static func autoWindow(_ data: Data, bits: Int, isSigned: Bool, isColor: Bool)
        -> (Double, Double)
    {
        guard !isColor, bits == 16, data.count >= 2 else { return (128, 256) }
        var mn = Int32.max, mx = Int32.min
        for i in stride(from: 0, through: data.count - 2, by: 2) {
            let raw = UInt16(data[i]) | (UInt16(data[i + 1]) << 8)
            let v   = isSigned ? Int32(Int16(bitPattern: raw)) : Int32(raw)
            if v < mn { mn = v }
            if v > mx { mx = v }
        }
        return (Double(mn + mx) / 2, max(1, Double(mx - mn)))
    }

    private static func decodeRaw(
        _ data: Data, rows: Int, columns: Int, nFrames: Int,
        bits: Int, samples: Int, isSigned: Bool, invert: Bool,
        center: Double, width: Double
    ) -> [CGImage] {
        let bytesPerSample = max(1, bits / 8)
        guard rows > 0, columns > 0, rows <= 16384, columns <= 16384 else { return [] }
        let (a, o1) = rows.multipliedReportingOverflow(by: columns)
        let (b, o2) = a.multipliedReportingOverflow(by: samples)
        let (frameSize, o3) = b.multipliedReportingOverflow(by: bytesPerSample)
        guard !o1, !o2, !o3, frameSize > 0, data.count >= frameSize else { return [] }

        return (0..<nFrames).compactMap { f in
            let start = f * frameSize
            guard start + frameSize <= data.count else { return nil }
            return makeImage(Data(data[start..<start + frameSize]),
                             rows: rows, columns: columns,
                             bits: bits, samples: samples,
                             isSigned: isSigned, invert: invert,
                             center: center, width: width)
        }
    }

    private static func makeImage(
        _ data: Data, rows: Int, columns: Int,
        bits: Int, samples: Int,
        isSigned: Bool, invert: Bool,
        center: Double, width: Double
    ) -> CGImage? {
        let isRGB      = samples == 3
        let bpp        = isRGB ? 3 : 1
        let (pixelCount, pcOvf) = rows.multipliedReportingOverflow(by: columns)
        let (outCount, ocOvf)   = pixelCount.multipliedReportingOverflow(by: bpp)
        guard !pcOvf, !ocOvf, outCount > 0 else { return nil }
        var out = [UInt8](repeating: 0, count: outCount)
        let lo         = center - width / 2
        let scale      = 255.0 / max(1, width)

        data.withUnsafeBytes { src in
            if isRGB {
                for i in 0..<min(out.count, src.count) { out[i] = src[i] }
            } else if bits == 8 {
                for i in 0..<min(pixelCount, src.count) {
                    var v = (Double(src[i]) - lo) * scale
                    v = min(255, max(0, v))
                    out[i] = invert ? UInt8(255.0 - v) : UInt8(v)
                }
            } else {
                for i in 0..<pixelCount {
                    let idx = i * 2
                    guard idx + 1 < src.count else { break }
                    let raw = UInt16(src[idx]) | (UInt16(src[idx + 1]) << 8)
                    let val = isSigned ? Double(Int16(bitPattern: raw)) : Double(raw)
                    var v   = (val - lo) * scale
                    v = min(255, max(0, v))
                    out[i] = invert ? UInt8(255.0 - v) : UInt8(v)
                }
            }
        }

        let space = isRGB ? CGColorSpaceCreateDeviceRGB() : CGColorSpaceCreateDeviceGray()
        return out.withUnsafeMutableBytes { ptr -> CGImage? in
            guard let ctx = CGContext(
                data: ptr.baseAddress,
                width: columns, height: rows,
                bitsPerComponent: 8,
                bytesPerRow: columns * bpp,
                space: space,
                bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) else { return nil }
            return ctx.makeImage()
        }
    }

    // MARK: - Implicit VR inference

    private static func implicitVR(group: UInt16, element: UInt16) -> String {
        switch (group, element) {
        case (0x0028, 0x0002), (0x0028, 0x0010), (0x0028, 0x0011),
             (0x0028, 0x0100), (0x0028, 0x0101), (0x0028, 0x0103): return "US"
        case (0x0028, 0x0008):                                       return "IS"
        case (0x0028, 0x1050), (0x0028, 0x1051):                     return "DS"
        case (0x7FE0, 0x0010):                                       return "OW"
        default:                                                      return "UN"
        }
    }
}

// MARK: - JPEG Lossless (SOF3) decoder

private enum JpegLossless {

    // Bit reader with JPEG stuffed-byte removal (ISO 10918-1 §F.1.2.3).
    private final class Bits {
        private let src: Data
        private var pos: Int
        private var buf = 0
        private var avail = 0

        init(_ src: Data, start: Int) { self.src = src; pos = start }

        func read(_ n: Int) -> Int {
            if n == 0 { return 0 }
            while avail < n {
                guard pos < src.count else { buf <<= 8; avail += 8; continue }
                let b = Int(src[pos]); pos += 1
                if b == 0xFF, pos < src.count {
                    let nx = Int(src[pos])
                    if nx == 0x00 { pos += 1 }
                    else if nx >= 0xD0, nx <= 0xD7 { pos += 1; continue }
                }
                buf = (buf << 8) | b; avail += 8
            }
            avail -= n
            return (buf >> avail) & ((1 << n) - 1)
        }
    }

    // Huffman table with O(1) lookup via valOffset trick.
    private struct HTable {
        var minCode = [Int](repeating: 0,  count: 17)
        var maxCode = [Int](repeating: -1, count: 17)
        var valOff  = [Int](repeating: 0,  count: 17)
        var vals    = [Int]()

        mutating func build(counts: [Int], rawVals: Data, base: Int) {
            let total = counts.reduce(0, +)
            guard base + total <= rawVals.count else { return }
            vals = (0..<total).map { Int(rawVals[base + $0]) }
            var code = 0, idx = 0
            for b in 1...16 {
                valOff[b] = idx - code
                if counts[b-1] > 0 {
                    minCode[b] = code
                    maxCode[b] = code + counts[b-1] - 1
                    code       += counts[b-1]
                    idx        += counts[b-1]
                }
                code <<= 1
            }
        }
    }

    static func decode(_ jpeg: Data) -> CGImage? {
        guard jpeg.count > 4, jpeg[0] == 0xFF, jpeg[1] == 0xD8 else { return nil }
        var i = 2
        var P = 8, H = 0, W = 0, Pt = 0, sel = 1
        var htabs  = [Int: HTable]()
        var compTd = [Int: Int]()
        var scanAt = -1

        while i + 1 < jpeg.count {
            guard jpeg[i] == 0xFF else { i += 1; continue }
            let m = Int(jpeg[i+1]); i += 2
            if m == 0xD8 { continue }
            if m == 0xD9 { break }
            if m >= 0xD0, m <= 0xD7 { continue }
            guard i + 2 <= jpeg.count else { break }
            let segLen = Int(jpeg[i]) << 8 | Int(jpeg[i+1])
            let segEnd = i + segLen; i += 2

            switch m {
            case 0xC3:  // SOF3 — lossless frame header
                guard i + 6 <= jpeg.count else { break }
                P = Int(jpeg[i])
                H = Int(jpeg[i+1]) << 8 | Int(jpeg[i+2])
                W = Int(jpeg[i+3]) << 8 | Int(jpeg[i+4])

            case 0xC4:  // DHT — define Huffman table
                var p = i
                while p < segEnd, p < jpeg.count {
                    let th = Int(jpeg[p]) & 0x0F; p += 1
                    guard p + 16 <= jpeg.count else { break }
                    var counts = [Int](repeating: 0, count: 16)
                    for k in 0..<16 { counts[k] = Int(jpeg[p+k]) }; p += 16
                    let total = counts.reduce(0, +)
                    guard p + total <= jpeg.count else { break }
                    var ht = HTable()
                    ht.build(counts: counts, rawVals: jpeg, base: p)
                    p += total
                    htabs[th] = ht
                }

            case 0xDA:  // SOS — start of scan
                guard i < jpeg.count else { break }
                let nc = Int(jpeg[i]); var p = i + 1
                for _ in 0..<nc {
                    guard p + 1 < jpeg.count else { break }
                    compTd[Int(jpeg[p])] = Int(jpeg[p+1]) >> 4; p += 2
                }
                if p + 2 < jpeg.count {
                    sel = Int(jpeg[p])
                    Pt  = Int(jpeg[p+2]) & 0x0F
                }
                scanAt = p + 3

            default: break
            }
            i = segEnd
        }

        guard scanAt > 0, W > 0, H > 0, W <= 16384, H <= 16384,
              P >= 1, P <= 16, P > Pt else { return nil }
        let td = compTd.values.first ?? 0
        guard let ht = htabs[compTd[1] ?? td] ?? htabs[td] else { return nil }

        let (wh, whOvf) = W.multipliedReportingOverflow(by: H)
        guard !whOvf else { return nil }
        let bits   = Bits(jpeg, start: scanAt)
        let maxVal = (1 << P) - 1
        let initPx = 1 << (P - Pt - 1)
        var out    = [UInt8](repeating: 0, count: wh)
        var Ra     = initPx

        for row in 0..<H {
            // JPEG Lossless line boundary: Ra resets to first pixel of previous row.
            if row > 0 { Ra = Int(out[(row - 1) * W]) }
            for col in 0..<W {
                var code = 0, ssss = 0
                for b in 1...16 {
                    code = (code << 1) | bits.read(1)
                    if code <= ht.maxCode[b] {
                        ssss = ht.vals[ht.valOff[b] + code]
                        break
                    }
                }
                let diff: Int
                if ssss == 0 {
                    diff = 0
                } else {
                    let s = min(ssss, 16)   // clamp: prevents bit-shift overflow on malformed input
                    let v = bits.read(s)
                    diff = v >= (1 << (s - 1)) ? v : v - (1 << s) + 1
                }
                let idx  = row * W + col
                let Rb   = row > 0 ? Int(out[idx - W]) : initPx
                let Rc   = (row > 0 && col > 0) ? Int(out[idx - W - 1]) : initPx
                let pred: Int
                if row == 0, col == 0 {
                    pred = initPx
                } else {
                    switch sel {
                    case 1: pred = Ra
                    case 2: pred = Rb
                    case 3: pred = Rc
                    case 4: pred = Ra + Rb - Rc
                    case 5: pred = Ra + (Rb - Rc) / 2
                    case 6: pred = Rb + (Ra - Rc) / 2
                    case 7: pred = (Ra + Rb) / 2
                    default: pred = Ra
                    }
                }
                let px = (pred + diff) & maxVal
                out[idx] = UInt8(clamping: px)
                Ra = px
            }
        }

        let space = CGColorSpaceCreateDeviceGray()
        return out.withUnsafeMutableBytes { ptr -> CGImage? in
            guard let ctx = CGContext(
                data: ptr.baseAddress, width: W, height: H,
                bitsPerComponent: 8, bytesPerRow: W,
                space: space, bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) else { return nil }
            return ctx.makeImage()
        }
    }
}
