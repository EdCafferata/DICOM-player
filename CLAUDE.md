# DICOM Player — Claude instructies

## Projectoverzicht
iOS DICOM viewer app voor het bekijken van medische beeldbestanden (.dcm).
Toont CT-scans, röntgenfoto's en cine-series met medische dark-mode UI.
Inclusief Tip Jar (StoreKit 2 IAP) voor ondersteuning van de ontwikkelaar.

## Eigenaar
- **Ed Cafferata** (edcafferata@icloud.com) — developer
- **Team ID:** `9J2S23WJH3`

## Locatie & build
- **Project:** `/Volumes/Backup-Ed/AI/DICOM-player/`
- **Xcode project:** `Dicom Player.xcodeproj`
- **Bundle ID:** `info.cafferata.dicomplayer`
- **GitHub:** https://github.com/EdCafferata/DICOM-player — branch: `master-branch`
- **Versie:** `2.0`
- **Simulator ID:** `F2532603-D618-4C2D-A0A6-4E6F9A8161F6` (iPhone 16, iOS 18.2)

### Build commando's
```bash
# Simulator (Debug)
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project "Dicom Player.xcodeproj" \
  -scheme "Dicom Player" \
  -destination "id=F2532603-D618-4C2D-A0A6-4E6F9A8161F6" \
  -configuration Debug build

# TestFlight archive
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project "Dicom Player.xcodeproj" \
  -scheme "Dicom Player" \
  -configuration Release \
  -archivePath /tmp/DicomPlayer.xcarchive archive
# → daarna Xcode Organizer → Distribute App → App Store Connect
```

### Installeren + starten op simulator
```bash
xcrun simctl install F2532603-D618-4C2D-A0A6-4E6F9A8161F6 \
  "/Users/edcafferata/Library/Developer/Xcode/DerivedData/Dicom_Player-dnpskgwspfvinfestohjmivukfmu/Build/Products/Debug-iphonesimulator/Dicom Player.app"

xcrun simctl launch F2532603-D618-4C2D-A0A6-4E6F9A8161F6 info.cafferata.dicomplayer
```

## Sessie start (ALTIJD uitvoeren)
1. `git -C /Volumes/Backup-Ed/AI/DICOM-player fetch origin && git -C /Volumes/Backup-Ed/AI/DICOM-player pull origin master-branch`
2. Lees dit bestand + `README.md`
3. Meld wat er nieuw is t.o.v. vorige sessie

## App Store Connect
- **App ID:** (zie App Store Connect → Dicom Player)
- **Status:** Versie 2.0 ingediend voor review (2026-05-22), wacht op goedkeuring
- **Tip Jar IAP producten:**
  - `info.cafferata.dicomplayer.tip.small` — Koffie €0,99 (Non-Consumable)
  - `info.cafferata.dicomplayer.tip.medium` — Pizza €2,99 (Non-Consumable)
  - `info.cafferata.dicomplayer.tip.large` — Diner €9,99 (Non-Consumable)

## Sessie einde (ALTIJD uitvoeren)
1. `git add -A && git commit && git push`
2. Werk `CLAUDE.md` bij
3. Update memory: `/Users/edcafferata/.claude/projects/-Volumes-Backup-Ed-AI-Tattoe-tattoe/memory/project_dicom_player.md`

---

## Stack
- **Taal:** Swift, SwiftUI + UIKit bridge
- **Main view:** `Views/ViewController.swift` — `ContentView` (bestandslijst, dark medical theme)
- **Viewer:** `Controlers/DicomFilesTableViewController.swift` — `ViewerView` (SwiftUI fullscreen viewer)
- **Parser:** `Controlers/DicomFilesTableViewControlllerDelegate.swift` — `DICOMParser`
- **Bestanden:** `Controlers/DicomFileManager.swift` — `FileStore: ObservableObject`
- **IAP:** `Views/TipJarView.swift` — `TipJarView` + `TipStore` (StoreKit 2)
- **Theme:** `Models/MedTheme.swift` — `Med` design tokens

## Bestandsstructuur
```
Dicom Player/
  Controlers/
    AppDelegate.swift                         ← UIHostingController(ContentView), open-in handler
    DicomFileManager.swift                    ← FileStore ObservableObject: scan, import, delete
    DicomFilesTableViewController.swift       ← ViewerView: zoom, drag, cine player
    DicomFilesTableViewControlllerDelegate.swift ← DICOMParser: binary DICOM parser
    UploadControler.swift                     ← ShareSheet wrapper voor UIActivityViewController
  Views/
    ViewController.swift                      ← ContentView: bestandslijst, dark UI
    TipJarView.swift                          ← TipJarView + TipStore (StoreKit 2)
  Models/
    Date+timeAgo.swift                        ← Nederlandse tijdstempels
    DicomFileInfo.swift                       ← DICOMFileInfo: Identifiable struct
    Int+asFilesize.swift                      ← Bestandsgrootte formattering
    MedTheme.swift                            ← Design tokens, kleuren, fonts, badges
```

## Architectuur — DICOMParser
- Explicit VR Little Endian (default) + Implicit VR (`1.2.840.10008.1.2`)
- Transfer syntax `1.2.840.10008.1.2.4.90` = JPEG 2000 (encapsulated)
- `extractEncapsulated` — concateneert alle items na de Basic Offset Table
- `splitAndDecode` — zoekt FF D8 (JPEG SOI) / FF 4F (JPEG2000 SOC) markers
- `autoWindow` — scant 16-bit pixels voor min/max → windowCenter/Width
- `skipToDelimiter` — correct voor explicit én implicit VR sequences

## Architectuur — ViewerView
- Pinch-to-zoom: `0.5×`–`8×` via `MagnificationGesture`
- Drag via `DragGesture`; dubbel-tap reset naar origineel
- Overlay aan/uit via enkele tap: WC/WW linksboven, patiëntnaam + modality badge rechtsboven
- Cine player: play/pause, stap voor/achteruit, frame slider, FPS-menu (5/10/15/24/30)

## Medische UI (MedTheme.swift)
```swift
Med.bg       = #080E1A   // donker navy achtergrond
Med.surface  = #0F1A2E   // kaartachtergrond
Med.card     = #162035   // bestandskaart
Med.accent   = #00C2CB   // teal accent
Med.blue     = #2F80ED   // actieblauw
Med.textPrimary   = #E8EEF7
Med.textSecondary = #5A7099
```

## Demo DICOM bestanden (gebundeld in app)
- `cag_voor_ingreep.dcm` — coronaire angiografie voor ingreep
- `cag_tijdens_ingreep.dcm` — coronaire angiografie tijdens ingreep
- `cag_na_ingreep.dcm` — coronaire angiografie na ingreep

## Feature status
- [x] DICOM parser (Explicit + Implicit VR, JPEG + JPEG2000, raw 16-bit)
- [x] Fullscreen viewer met pinch-zoom (0.5×–8×), drag, dubbel-tap reset
- [x] Medische overlay (WC/WW, patiëntnaam, modality badge)
- [x] Cine player met FPS-keuze (5/10/15/24/30 fps)
- [x] Bestandsbeheer: importeren, verwijderen, delen
- [x] Tip Jar (StoreKit 2, 3 Non-Consumable IAP producten)
- [x] Medische dark-mode UI (MedTheme design tokens)
- [x] Demo DICOM bestanden gebundeld
- [x] Open-in handler (andere apps kunnen .dcm naar DICOM Player sturen)
- [x] Versie 2.0 ingediend bij Apple Review (2026-05-22)

## Open issues (backlog)
- [ ] App Store review afwachten en eventuele opmerkingen afhandelen
- [ ] Window-level aanpassen via swipe/slider (WC/WW interactief)
- [ ] Multi-series ondersteuning (DICOM Study met meerdere series)
- [ ] iPad-optimalisatie (split view / grote schermen)
- [ ] Export naar PNG/JPEG vanuit viewer
