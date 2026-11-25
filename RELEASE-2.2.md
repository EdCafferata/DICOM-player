# Dicom Viewer 2.2 (build 10) — pre-release-check en indieningsstatus

Gemaakt op 26 november 2026 (nacht) door Claude. **Advies: GO**, na de drie handmatige punten hieronder.
Er is niets ingediend; dat doet Ed.

## Richtlijnen
App Review Guidelines "Last Updated: October 16, 2026", gelijk aan de baseline. Niets nieuws dat deze app raakt.

## Automatisch gecontroleerd (App Store Connect API)
| Punt | Status |
|---|---|
| Versie 2.2 aangemaakt (PREPARE_FOR_SUBMISSION, release na goedkeuring) | ✅ |
| Build 10 geüpload, VALID, gekoppeld aan 2.2 (hoger dan live 2.1 / build 9) | ✅ |
| 12 talen met beschrijving, zoekwoorden, promotietekst en "Wat is er nieuw" (nl, en, de, fr, es, it, pt-BR, ja, ko, zh-Hans, ru, hi) | ✅ |
| Nieuwe screenshots iPhone 6,9" (4) en iPad 13" (3); nl = Nederlands, alle andere talen = Engels; oude 2.1-sets verwijderd | ✅ |
| Privacy-URL per taal → `cafferata.info/dicom-viewer/privacy.html` (nl) of `/en/privacy.html` (200) | ✅ (was de homepage) |
| Support- en marketing-URL → `/dicom-viewer/support.html` en `/dicom-viewer/` (en: `/en/…`) | ✅ (was de homepage) |
| Export compliance: `ITSAppUsesNonExemptEncryption = NO` | ✅ |
| Categorie Medisch, leeftijdsclassificatie aanwezig | ✅ |
| Review-notitie voor Apple (geen login, voorbeeldscans, meten, fooien, niet-diagnostisch) | ✅ (was "..") |
| IAP's (3 fooien) zijn APPROVED, niets nieuws dat mee moet | ✅ |

## Opgelost tijdens de check
- **Koffie-fooi was niet te koop** in de live-versie: het product heet in App Store Connect `tip.smal`, de app zocht `tip.small`. De app gebruikt nu `tip.smal`.
- **Privacy-manifest:** reden CA92.1 voor UserDefaults toegevoegd.
- **Foto-toestemming:** `NSPhotoLibraryAddUsageDescription` toegevoegd ("Bewaar afbeelding" vanuit het deelvenster).
- **Crash op iOS 27** bij het starten (geen scene-levenscyclus): opgelost met de SwiftUI App-levenscyclus. Getest op Eds iPhone 13 Pro Max (iOS 27.2.1).

## Handmatig door Ed (vóór "Voeg toe voor review")
1. **App Privacy ("nutrition label")**: controleer dat er "Data Not Collected" staat. Dat klopt met de app (geen tracking, alles lokaal).
2. **Leeftijdsclassificatie**: als App Store Connect om nieuwe vragen vraagt (zoals bij RNH/BVK), beantwoord ze (medisch/educatief, geen gebruikersinhoud).
3. **Indienen**: versie 2.2 openen en "Voeg toe voor review", daarna "Verstuur voor review".

## Getest
- Echte iPhone (iOS 27.2.1): starten, tabs, viewer, meten, talen (door Ed getest).
- Simulator iPhone 17 Pro Max en iPad Pro 13" (iOS 26.5): alle schermen, iPad naast elkaar, Engels/Japans/Duits/Hindi.
- Release-build compileert.

## Android (Dicom Viewer 1.1.0, versionCode 5)
- Zelfde nieuwe look en functies als iOS 2.2, 12 talen, tablets naast elkaar.
- Getest op een emulator (Pixel 8, Android 16): scans met miniaturen, viewer, meten (85,1 mm klopt met de rekensom), Leren, Over, fooien-hulpje.
- AAB: `/Volumes/Backup-Ed/AI/android-release-aab/dicom-viewer-1.1.0-vc5.aab`. **Ed sleept het zelf in Play Console**; releasenotes staan in `dicom-viewer-android/fastlane/metadata/android/*/changelogs/5.txt`.
- Nog niet gedaan: Play-winkelvermelding in de 10 nieuwe talen en nieuwe Play-screenshots.
- Handmatig vóór Play-productie: **test op een echt Android-toestel** (alleen de emulator is getest), en laat het
  data-safety-formulier op "geen gegevens verzameld" staan (de app verzamelt nog steeds niets). Target SDK 36.
- Debug-testhulp (`-demoOpen`, `-meetTest`, `-startTab`, `-aantalStarts`) zit alleen in DEBUG-builds, niet in de
  release (geen verborgen functies, 2.5.19).
