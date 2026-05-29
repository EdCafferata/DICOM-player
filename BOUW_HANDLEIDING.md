# Bouwhandleiding: DICOM Player iOS app

Dit document beschrijft **alle stappen** om de DICOM Player te bouwen, aan te passen en in de App Store te plaatsen.
De app is volledig herschreven van UIKit naar SwiftUI (versie 2.0).

---

## Vereisten

| Tool | Versie | Opmerking |
|------|--------|-----------|
| macOS | 13+ | |
| Xcode | 15+ | Download via App Store |
| Git | meegeleverd | `xcode-select --install` indien nodig |
| Apple Developer account | betaald ($99/jaar) | Vereist voor App Store distributie |
| App Store Connect account | gratis | Aanmaken op appstoreconnect.apple.com |

---

## Stap 1 — Repository klonen

```bash
git clone https://github.com/EdCafferata/DICOM-player.git
cd DICOM-player
git checkout master-branch
```

Open het project in Xcode:
```bash
open "Dicom Player.xcodeproj"
```

Selecteer een simulator en druk op ▶ (Cmd+R). De app moet starten met de bestandslijst.

---

## Stap 2 — Bundle identifier controleren

In Xcode → Project Navigator → selecteer `Dicom Player` → Target `Dicom Player`:
- **Bundle Identifier:** `info.cafferata.dicomplayer`
- **Team:** `9J2S23WJH3` (Ed Cafferata)
- **Deployment Target:** iOS 15.0+

Om aan te passen voor eigen gebruik:

| Oud | Nieuw |
|-----|-------|
| `info.cafferata.dicomplayer` | `com.jouwbedrijf.DICOMViewer` |

Zoek en vervang in `project.pbxproj`:
```bash
sed -i '' 's/info.cafferata.dicomplayer/com.jouwbedrijf.DICOMViewer/g' \
  "Dicom Player.xcodeproj/project.pbxproj"
```

---

## Stap 3 — App naam instellen

In `Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>DICOM Player</string>

<key>CFBundleName</key>
<string>DICOM Player</string>
```

---

## Stap 4 — Demo DICOM bestanden toevoegen

De app bevat drie bundeled demo-bestanden voor eerste gebruik:
- `cag_voor_ingreep.dcm`
- `cag_tijdens_ingreep.dcm`
- `cag_na_ingreep.dcm`

Om eigen demo-bestanden toe te voegen:
1. Sleep `.dcm` bestanden naar `Dicom Player/` in Xcode's Project Navigator
2. Vink "Copy items if needed" aan
3. Vink "Add to targets: Dicom Player" aan

In `DicomFileManager.swift` worden bundled bestanden geladen via:
```swift
let demoFiles = ["cag_voor_ingreep", "cag_tijdens_ingreep", "cag_na_ingreep"]
```
Pas deze array aan als je andere demo-bestanden toevoegt.

---

## Stap 5 — Medische UI kleuren aanpassen (MedTheme.swift)

De design tokens staan in `Models/MedTheme.swift`:

```swift
struct Med {
    static let bg      = Color(hex: "#080E1A")  // achtergrond
    static let surface = Color(hex: "#0F1A2E")  // kaartachtergrond
    static let card    = Color(hex: "#162035")  // bestandskaart
    static let accent  = Color(hex: "#00C2CB")  // teal accent
    static let blue    = Color(hex: "#2F80ED")  // actie blauw
    static let textPrimary   = Color(hex: "#E8EEF7")
    static let textSecondary = Color(hex: "#5A7099")
}
```

Verander de hex-waarden voor een ander kleurenschema.

---

## Stap 6 — Tip Jar IAP instellen (StoreKit 2)

### 6a. In App Store Connect

Ga naar App Store Connect → Jouw app → In-App Purchases:
1. Klik `+` → Non-Consumable
2. Product ID: `info.cafferata.dicomplayer.tip.small`
3. Naam: `Koffie`
4. Prijs: €0,99
5. Voeg localisatie toe: `nl_NL` + `en-US`
6. Voeg IAP screenshot toe (verplicht)
7. Herhaal voor `tip.medium` (Pizza €2,99) en `tip.large` (Diner €9,99)

### 6b. In de app (TipJarView.swift)

De product IDs staan bovenaan `Views/TipJarView.swift`:
```swift
class TipStore: ObservableObject {
    let productIDs = [
        "info.cafferata.dicomplayer.tip.small",
        "info.cafferata.dicomplayer.tip.medium",
        "info.cafferata.dicomplayer.tip.large"
    ]
}
```
Vervang de IDs als je een andere bundle ID gebruikt.

### 6c. StoreKit configuratiebestand (voor simulator testen)

Xcode heeft een `.storekit` bestand nodig om IAP in de simulator te testen:
1. File → New File → StoreKit Configuration File → `Configuration.storekit`
2. Voeg de drie Non-Consumable producten toe met dezelfde IDs
3. Product → Scheme → Edit Scheme → Run → Options → StoreKit Configuration: `Configuration.storekit`

---

## Stap 7 — App-icoon instellen

Zorg voor een **PNG van 1024×1024 px**.

Genereer alle iOS-maten met `sips`:
```bash
SRC="pad/naar/jouw_logo.png"
DST="Dicom Player/Images.xcassets/AppIcon.appiconset"

for size in 20 29 40 60 76 83; do
  sips -z $size $size "$SRC" --out "$DST/icon_${size}pt.png"
done
for size in 40 58 80 87 120 152 167 180; do
  sips -z $size $size "$SRC" --out "$DST/icon_${size}.png"
done
sips -z 1024 1024 "$SRC" --out "$DST/Icon-1024.png"
```

Of gebruik het Python-script uit `BOUW_HANDLEIDING.md` van BVK/RHN voor alle maten tegelijk.

---

## Stap 8 — Bouwen voor simulator

```bash
cd /Volumes/Backup-Ed/AI/DICOM-player

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project "Dicom Player.xcodeproj" \
  -scheme "Dicom Player" \
  -destination "id=F2532603-D618-4C2D-A0A6-4E6F9A8161F6" \
  -configuration Debug build
```

### Installeren + starten
```bash
xcrun simctl install F2532603-D618-4C2D-A0A6-4E6F9A8161F6 \
  "/Users/edcafferata/Library/Developer/Xcode/DerivedData/Dicom_Player-dnpskgwspfvinfestohjmivukfmu/Build/Products/Debug-iphonesimulator/Dicom Player.app"

xcrun simctl launch F2532603-D618-4C2D-A0A6-4E6F9A8161F6 info.cafferata.dicomplayer
```

> **Tip:** Als de DerivedData-map een andere naam heeft:
> ```bash
> find ~/Library/Developer/Xcode/DerivedData -name "Dicom Player.app" -path "*/Debug-iphonesimulator/*" 2>/dev/null
> ```

---

## Stap 9 — Bouwen voor App Store (TestFlight / Release)

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project "Dicom Player.xcodeproj" \
  -scheme "Dicom Player" \
  -configuration Release \
  -archivePath /tmp/DicomPlayer.xcarchive \
  archive
```

Daarna in Xcode:
1. **Window → Organizer** → selecteer het archive
2. **Distribute App** → App Store Connect → Upload
3. Wacht op verwerkingsmail van Apple (~10 min)
4. Ga naar App Store Connect → TestFlight → selecteer de build → Indienen voor review

---

## Stap 10 — App Store screenshots maken

### iPhone screenshots (simulator)

```bash
# Simulator opstarten en app openen
xcrun simctl boot F2532603-D618-4C2D-A0A6-4E6F9A8161F6
open -a Simulator

# Screenshot nemen
xcrun simctl io F2532603-D618-4C2D-A0A6-4E6F9A8161F6 screenshot /tmp/dicom_screen.png
```

Screenshot afmeting iPhone 16 simulator: **1320×2868 px** (6.9")

Schaal naar App Store formaten:
```python
from PIL import Image
import os

src = "/tmp/dicom_screen.png"
out = "AppStore/Screenshots"
os.makedirs(out, exist_ok=True)

img = Image.open(src).convert("RGB")

sizes = [
    ("iphone_6.9inch_1320x2868.png",  1320, 2868),
    ("iphone_6.7inch_1290x2796.png",  1290, 2796),
    ("iphone_6.5inch_1242x2688.png",  1242, 2688),
]

for name, w, h in sizes:
    canvas = Image.new("RGB", (w, h), (8, 14, 26))  # #080E1A background
    ratio = h / img.height
    nw = int(img.width * ratio)
    scaled = img.resize((nw, h), Image.LANCZOS)
    canvas.paste(scaled, ((w - nw) // 2, 0))
    canvas.save(f"{out}/{name}")
    print(f"  {name}")
```

### App Store icoon (1024×1024)
Het icoon wordt automatisch meegenomen vanuit `AppIcon.appiconset/Icon-1024.png`.

---

## Stap 11 — DICOM testbestanden toevoegen aan simulator

```bash
# Kopieer .dcm bestand naar simulator Documents map
UDID="F2532603-D618-4C2D-A0A6-4E6F9A8161F6"
DOCS=$(xcrun simctl get_app_container "$UDID" info.cafferata.dicomplayer data)/Documents
cp /pad/naar/bestand.dcm "$DOCS/"

# Of via simctl file push (nieuwere Xcode)
xcrun simctl file push "$UDID" /pad/naar/bestand.dcm \
  "app/info.cafferata.dicomplayer/Documents/"
```

---

## Stap 12 — Testen van IAP in simulator

1. Zorg dat het `.storekit` configuratiebestand is ingesteld (zie Stap 6c)
2. Bouw en start de app
3. Open Tip Jar via het icoon rechtsboven in de bestandslijst
4. Klik een tip aan — de sandbox koopflow start (geen echte afrekening)
5. Controleer in Xcode Console of `TipStore` de purchase bevestigt

---

## Bekende valkuilen

| Probleem | Oorzaak | Oplossing |
|----------|---------|-----------|
| "No module found: StoreKit" | StoreKit framework ontbreekt | In Xcode: Target → Frameworks → `+` → StoreKit.framework |
| IAP werkt niet in simulator | Geen StoreKit Config | Voeg `.storekit` bestand toe, stel in via Scheme (zie Stap 6c) |
| DICOM parse error | Implicit VR bestand | Parser detecteert automatisch; controleer transfer syntax tag `(0002,0010)` |
| Cine niet zichtbaar | Bestand bevat maar 1 frame | Cine-controls verschijnen alleen bij ≥2 frames |
| App crasht bij open | Demo DCM beschadigd | Vervang bundled .dcm bestanden via Stap 4 |
| Build faalt "Signing" | Team ID mismatch | Xcode → Signing & Capabilities → selecteer juist team |
| DerivedData pad veranderd | Xcode heeft nieuwe hash | Gebruik `find` commando uit Stap 8 om het juiste pad te vinden |

---

## Bronvermelding

Gebaseerd op DICOM standaard: [NEMA DICOM PS3](https://www.dicomstandard.org/current)
JPEG 2000: Transfer Syntax UID `1.2.840.10008.1.2.4.90`
StoreKit 2: [Apple Developer Documentation](https://developer.apple.com/documentation/storekit)
