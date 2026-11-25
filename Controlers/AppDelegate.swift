import SwiftUI

/// Telt app-starts (voor de periodieke fooienpot, issue #11).
enum AppStart {
    /// Hoeveelste start dit is; één keer gezet bij het opstarten.
    static private(set) var nummer = 0

    static func registreer() {
        let d = UserDefaults.standard
        nummer = d.integer(forKey: "aantalStarts") + 1
        d.set(nummer, forKey: "aantalStarts")
    }

    /// Elke 50e start de fooienpot tonen, maar alleen aan wie nog nooit tipte
    /// en niet "niet meer tonen" koos.
    static var toonFooienpot: Bool {
        let d = UserDefaults.standard
        return nummer > 0 && nummer % 50 == 0
            && !d.bool(forKey: "heeftGetipt")
            && !d.bool(forKey: "fooienpotNietMeerTonen")
    }
}

/// App-start via de SwiftUI-levenscyclus (scenes). Apps die met de iOS 27-SDK
/// zijn gebouwd moeten scenes gebruiken; het oude UIApplicationDelegate-venster
/// liet de app op iOS 27 direct afsluiten.
@main
struct DicomViewerApp: App {
    init() { AppStart.registreer() }

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
