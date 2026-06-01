import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var store = FileStore.shared

    @State private var showImporter  = false
    @State private var selectedInfo: DICOMFileInfo?
    @State private var parsedDICOM: ParsedDICOM?
    @State private var parsedImage: UIImage?
    @State private var showViewer    = false
    @State private var isParsing     = false
    @State private var errorMessage: String?
    @State private var shareFile: DICOMFileInfo?
    @State private var fileToDelete: DICOMFileInfo?
    @State private var showTipJar = false
    @AppStorage("demosHidden") private var demosHidden = false
    @AppStorage("tipJarCoachMarkShown") private var coachMarkShown = false
    @State private var showCoachMark = false

    var body: some View {
        ZStack {
            Med.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                MedDivider()

                if store.files.isEmpty {
                    emptyState
                } else {
                    fileList
                }
            }
        }
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.data, .item],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                store.importFile(from: url)
            }
        }
        .sheet(isPresented: $showViewer, onDismiss: { parsedDICOM = nil; parsedImage = nil }) {
            if let parsed = parsedDICOM {
                ViewerView(parsed: parsed)
            } else if let img = parsedImage, let file = selectedInfo {
                QuickImageView(image: img, title: file.name)
            }
        }
        .sheet(item: $shareFile) { file in
            ShareSheet(url: file.url)
        }
        .sheet(isPresented: $showTipJar) {
            TipJarView()
        }
        .overlay {
            if isParsing { loadingOverlay }
        }
        .overlay {
            if showCoachMark {
                TipJarCoachMark(isShowing: $showCoachMark)
                    .zIndex(100)
            }
        }
        .onAppear {
            if !coachMarkShown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation { showCoachMark = true }
                    coachMarkShown = true
                }
            }
        }
        .alert("Bestand verwijderen?", isPresented: .init(
            get: { fileToDelete != nil },
            set: { if !$0 { fileToDelete = nil } }
        )) {
            Button("Verwijder", role: .destructive) {
                if let f = fileToDelete { store.delete(f) }
                fileToDelete = nil
            }
            Button("Annuleer", role: .cancel) { fileToDelete = nil }
        } message: {
            Text("\(fileToDelete?.name ?? "") wordt permanent verwijderd.")
        }
        .alert("Bestand niet ondersteund", isPresented: .init(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "waveform.and.magnifyingglass")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Med.accent)

            VStack(alignment: .leading, spacing: 1) {
                Text("DICOM VIEWER")
                    .font(.medLabel())
                    .tracking(2.5)
                    .foregroundColor(Med.textSec)
                Text("Medical Imaging")
                    .font(.medTitle())
                    .foregroundColor(Med.textPri)
            }

            Spacer()

            HStack(spacing: 10) {
                Button {
                    showTipJar = true
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                        .frame(width: 36, height: 36)
                        .background(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.12))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.3), lineWidth: 0.5))
                }
                Button {
                    showImporter = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Med.accent)
                        .frame(width: 36, height: 36)
                        .background(Med.accent.opacity(0.12))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Med.accent.opacity(0.3), lineWidth: 0.5))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Med.surface)
    }

    // MARK: File list

    private var fileList: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(Array(store.files.enumerated()), id: \.element.id) { idx, file in
                        VStack(spacing: 0) {
                            MedFileRow(file: file, isDemo: false)
                                .contentShape(Rectangle())
                                .onTapGesture { open(file) }
                                .contextMenu {
                                    Button {
                                        shareFile = file
                                    } label: {
                                        Label("Deel", systemImage: "square.and.arrow.up")
                                    }
                                    Button(role: .destructive) {
                                        fileToDelete = file
                                    } label: {
                                        Label("Verwijder", systemImage: "trash")
                                    }
                                }
                            if idx < store.files.count - 1 {
                                MedDivider().padding(.leading, 64)
                            }
                        }
                        .background(Med.card)
                    }
                } header: {
                    HStack {
                        Text("RECENTE SCANS")
                            .font(.medLabel())
                            .tracking(2)
                            .foregroundColor(Med.textSec)
                        Spacer()
                        Text("\(store.files.count) BESTANDEN")
                            .font(.medLabel())
                            .tracking(1)
                            .foregroundColor(Med.textDim)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Med.bg)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .background(Med.bg)
        .refreshable { store.reload() }
    }

    // MARK: Empty state

    private var emptyState: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Import CTA
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Med.accent.opacity(0.08))
                            .frame(width: 80, height: 80)
                        Circle()
                            .stroke(Med.accent.opacity(0.2), lineWidth: 1)
                            .frame(width: 80, height: 80)
                        Image(systemName: "waveform.and.magnifyingglass")
                            .font(.system(size: 32, weight: .light))
                            .foregroundColor(Med.accent.opacity(0.7))
                    }

                    VStack(spacing: 6) {
                        Text("EIGEN SCAN TOEVOEGEN")
                            .font(.medLabel())
                            .tracking(2)
                            .foregroundColor(Med.textSec)
                        Text("Importeer een DICOM of medisch beeldbestand.")
                            .font(.medCaption())
                            .foregroundColor(Med.textSec)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    Button {
                        showImporter = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("BESTAND IMPORTEREN")
                                .tracking(1.2)
                        }
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(Med.bg)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Med.accent)
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 36)
                .padding(.bottom, 32)

                // Demo files
                if !store.bundledDemos.isEmpty {
                    VStack(spacing: 0) {
                        HStack {
                            Text("VOORBEELDBESTANDEN")
                                .font(.medLabel())
                                .tracking(2)
                                .foregroundColor(Med.textSec)
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    demosHidden.toggle()
                                }
                            } label: {
                                Text(demosHidden ? "TOON" : "VERBERG")
                                    .font(.medLabel())
                                    .tracking(1)
                                    .foregroundColor(Med.accent)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)

                        if !demosHidden {
                            VStack(spacing: 0) {
                                ForEach(Array(store.bundledDemos.enumerated()), id: \.element.id) { idx, file in
                                    VStack(spacing: 0) {
                                        MedFileRow(file: file, isDemo: true)
                                            .contentShape(Rectangle())
                                            .onTapGesture { open(file) }
                                        if idx < store.bundledDemos.count - 1 {
                                            MedDivider().padding(.leading, 64)
                                        }
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
            }
        }
        .background(Med.bg)
    }

    // MARK: Loading overlay

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                ProgressView()
                    .tint(Med.accent)
                    .scaleEffect(1.3)
                Text("LADEN…")
                    .font(.medLabel())
                    .tracking(2)
                    .foregroundColor(Med.textSec)
            }
            .padding(32)
            .background(Med.surface)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Med.border, lineWidth: 0.5))
        }
    }

    // MARK: Open

    private func open(_ file: DICOMFileInfo) {
        selectedInfo = file
        isParsing    = true
        Task.detached(priority: .userInitiated) {
            do {
                let parsed = try DICOMParser.parse(url: file.url)
                await MainActor.run {
                    parsedDICOM = parsed
                    isParsing   = false
                    showViewer  = true
                }
            } catch DICOMError.notDICOM {
                if let img = UIImage(contentsOfFile: file.url.path) {
                    await MainActor.run {
                        parsedImage = img
                        isParsing   = false
                        showViewer  = true
                    }
                } else {
                    await MainActor.run {
                        isParsing    = false
                        errorMessage = "Dit bestandsformaat wordt niet ondersteund."
                    }
                }
            } catch {
                await MainActor.run {
                    isParsing    = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - File row

private struct MedFileRow: View {
    let file: DICOMFileInfo
    var isDemo: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 42, height: 42)
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(file.name)
                    .font(.medBody())
                    .foregroundColor(Med.textPri)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    MedBadge(text: file.ext)
                    if isDemo {
                        MedBadge(text: "DEMO", color: Med.blue.opacity(0.7))
                    } else {
                        Text(file.sizeHuman)
                            .font(.medMono(11))
                            .foregroundColor(Med.textSec)
                        Text("·")
                            .foregroundColor(Med.textDim)
                        Text(file.modifiedAgo)
                            .font(.medCaption())
                            .foregroundColor(Med.textSec)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Med.textDim)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Med.card)
    }

    private var iconName: String {
        switch file.ext {
        case "DCM", "DICOM": return "waveform.and.magnifyingglass"
        case "PNG", "JPG", "JPEG": return "photo"
        default: return "doc.fill"
        }
    }

    private var iconColor: Color {
        switch file.ext {
        case "DCM", "DICOM": return Med.accent
        case "PNG", "JPG", "JPEG": return Med.blue
        default: return Med.textSec
        }
    }
}

// MARK: - Quick image viewer

private struct QuickImageView: View {
    let image: UIImage
    let title: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    Spacer()
                    Text(title)
                        .font(.medCaption())
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.trailing)
                }
                Spacer()
            }
        }
    }
}
