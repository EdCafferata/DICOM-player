import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var store = FileStore.shared

    @State private var showImporter   = false
    @State private var selectedInfo: DICOMFileInfo?
    @State private var parsedDICOM: ParsedDICOM?
    @State private var parsedImage: UIImage?
    @State private var showViewer     = false
    @State private var isParsing      = false
    @State private var errorMessage: String?
    @State private var shareFile: DICOMFileInfo?

    var body: some View {
        NavigationView {
            Group {
                if store.files.isEmpty {
                    emptyState
                } else {
                    fileList
                }
            }
            .navigationTitle("DICOM Viewer")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showImporter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
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
        .overlay {
            if isParsing {
                loadingOverlay
            }
        }
        .alert("Kan bestand niet openen", isPresented: .init(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    // MARK: File list

    private var fileList: some View {
        List {
            ForEach(store.files) { file in
                FileRow(file: file)
                    .contentShape(Rectangle())
                    .onTapGesture { open(file) }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            store.delete(file)
                        } label: {
                            Label("Verwijder", systemImage: "trash")
                        }
                        Button {
                            shareFile = file
                        } label: {
                            Label("Deel", systemImage: "square.and.arrow.up")
                        }
                        .tint(.blue)
                    }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable { store.reload() }
        .sheet(item: $shareFile) { file in
            ShareSheet(url: file.url)
        }
    }

    // MARK: Empty state

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.and.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Geen bestanden")
                .font(.title2.bold())
            Text("Tik op + om een DICOM of medisch bestand te importeren.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Importeer bestand") { showImporter = true }
                .buttonStyle(.borderedProminent)
        }
    }

    // MARK: Loading overlay

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView().tint(.white).scaleEffect(1.4)
                Text("Bestand laden…")
                    .foregroundColor(.white)
                    .font(.callout)
            }
            .padding(28)
            .background(Color(.systemGray5).opacity(0.95))
            .cornerRadius(16)
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
                // Try as a regular image
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

private struct FileRow: View {
    let file: DICOMFileInfo

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(file.name)
                    .font(.body.bold())
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text(file.sizeHuman)
                    Text("·")
                    Text(file.modifiedAgo)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var iconName: String {
        switch file.ext {
        case "DCM", "DICOM": return "waveform.and.magnifyingglass"
        case "PNG", "JPG", "JPEG": return "photo"
        default: return "doc.fill"
        }
    }
}

// MARK: - Quick image viewer (non-DICOM fallback)

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
                            .font(.title2).foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    Spacer()
                    Text(title).font(.caption).foregroundColor(.white.opacity(0.8)).padding(.trailing)
                }
                Spacer()
            }
        }
    }
}
