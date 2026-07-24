# Dicom Viewer by The IT Crowd

🔒 Laatste security check: 2026-07-24 23:43 CEST

[![App Store](https://img.shields.io/badge/App_Store-v2.1-blue?logo=apple)](https://apps.apple.com/nl/app/dicom-viewer-by-the-it-crowd/id1483496527)
[![Platform](https://img.shields.io/badge/iOS-16.0%2B-lightgrey?logo=apple)](https://apps.apple.com/nl/app/dicom-viewer-by-the-it-crowd/id1483496527)
[![Licentie](https://img.shields.io/badge/licentie-GPL--3.0-green)](LICENSE)

**Dicom Viewer** is een native iOS-app (SwiftUI) waarmee je DICOM-bestanden — medische beelden van bijvoorbeeld röntgen, CT, MRI en echografie — direct op je iPhone of iPad bekijkt.

📲 **[Download in de App Store (NL)](https://apps.apple.com/nl/app/dicom-viewer-by-the-it-crowd/id1483496527)** · **[US](https://apps.apple.com/us/app/dicom-viewer-by-the-it-crowd/id1483496527)** — versie 2.1 is live sinds 1 juli 2026. 🟢 Beschikbaar in het Nederlands en Engels.

## Functies (v2.1)

- 🩻 **Eigen DICOM-parser** — leest het DICOM-binairformaat zonder externe dependencies
- 🖼️ **Fullscreen viewer** — pinch/zoom, slepen en dubbeltikken om te resetten
- 🎞️ **Cine player** — speel multi-frame bestanden (series) af als video
- 🗂️ **Series navigator** — slices automatisch gegroepeerd per serie ([#2](https://github.com/EdCafferata/DICOM-player/issues/2))
- 🎚️ **Window/Level presets** — Abdomen, Long, Bot, Hersenen ([#3](https://github.com/EdCafferata/DICOM-player/issues/3))
- 💾 **Exporteer frames** als PNG/JPEG ([#5](https://github.com/EdCafferata/DICOM-player/issues/5))
- 🕘 **Recent geopende bestanden** ([#6](https://github.com/EdCafferata/DICOM-player/issues/6))
- 🌙 **Medisch dark theme** — UI ontworpen voor het bekijken van medische beelden
- 📂 **Open-in ondersteuning** — open bestanden vanuit de Bestanden-app, AirDrop of e-mail
- ☕ **Tip Jar** — steun de ontwikkelaar optioneel met een kleine bijdrage

## Binnenkort

Nog open op de backlog:

- 📏 Measurements — afstand meten in mm op het beeld ([#4](https://github.com/EdCafferata/DICOM-player/issues/4))
- 📱 iPad split-view layout — bestandslijst en viewer naast elkaar ([#7](https://github.com/EdCafferata/DICOM-player/issues/7))

## Vereisten

- iOS 16.0 of nieuwer
- iPhone en iPad

## Zelf bouwen

```bash
git clone git@github.com:EdCafferata/DICOM-player.git
cd DICOM-player
open "Dicom Player.xcodeproj"
```

Zie [BOUW_HANDLEIDING.md](BOUW_HANDLEIDING.md) voor uitgebreide bouwinstructies en [CONTRIBUTING.md](CONTRIBUTING.md) als je wilt bijdragen.

## Over DICOM

DICOM (Digital Imaging and Communications in Medicine) is de standaard voor het opslaan, uitwisselen en printen van medische beeldinformatie. De standaard definieert een bestandsformaat en een netwerkprotocol bovenop TCP/IP en wordt beheerd door de Amerikaanse [NEMA](https://www.dicomstandard.org). In de gezondheidszorg — met name op radiologieafdelingen — worden beelden van modaliteiten (röntgen, CT, MRI, echografie) via DICOM uitgewisseld en opgeslagen in PACS-beeldarchieven.

## Licentie

Dit project is beschikbaar onder de [GPL-3.0-licentie](LICENSE).
