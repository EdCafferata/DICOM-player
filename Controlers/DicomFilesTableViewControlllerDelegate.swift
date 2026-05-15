import Foundation
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

            default:
                r.skip(len)
            }
        }

        guard rows > 0, columns > 0 else { throw DICOMError.badDimensions }

        let isJPEG   = transferSyntax.hasPrefix("1.2.840.10008.1.2.4") || encapsulated
        let isSigned = pixelRep == 1
        let invert   = photometric == "MONOCHROME1"

        let frames: [CGImage]
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
        }
        if frames.isEmpty { throw DICOMError.missingPixelData }

        return ParsedDICOM(
            patientName: patientName,
            modality: modality,
            rows: rows, columns: columns,
            frames: frames,
            windowCenter: windowCenter,
            windowWidth: windowWidth
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
        // Try direct decode first (works when blob is exactly one complete frame)
        if let img = cgImage(from: blob) { return [img] }
        // Fall back to marker-based splitting: handles multi-frame and chunked data
        return splitAndDecode(blob)
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
                    if earliest == nil || found.lowerBound < earliest!.lowerBound { earliest = found }
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
        guard let src = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(src, 0, nil)
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
        let frameSize      = rows * columns * samples * bytesPerSample
        guard frameSize > 0, data.count >= frameSize else { return [] }

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
        let pixelCount = rows * columns
        var out        = [UInt8](repeating: 0, count: pixelCount * bpp)
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
