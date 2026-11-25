import SwiftUI

/// App-start via de SwiftUI-levenscyclus (scenes). Apps die met de iOS 27-SDK
/// zijn gebouwd moeten scenes gebruiken; het oude UIApplicationDelegate-venster
/// liet de app op iOS 27 direct afsluiten.
@main
struct DicomViewerApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                // "Open in…" vanuit Bestanden, Mail of andere apps.
                .onOpenURL { url in
                    FileStore.shared.importFile(from: url)
                }
        }
    }
}
