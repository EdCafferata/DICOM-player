# Dicom Viewer — volgende versie: niet vergeten (pre-release-check 19 nov 2026)

Stand: 2.1 (build 9) live, min iOS 16. Geen fastlane-metadata in deze repo → deze punten handmatig in ASC.

- [ ] **Privacy-URL wijst naar de homepage `cafferata.info`** i.p.v. een privacybeleid (Guideline 5.1.1-risico,
      zeker voor een medische app). Op een live versie niet te wijzigen (API: 409). Bij de volgende versie in
      ASC → App-informatie zetten op `https://cafferata.info/dicom-viewer/privacy.html` (NL) en
      `https://cafferata.info/dicom-viewer/en/privacy.html` (EN).
- [ ] **Support-/marketing-URL** (versie, NL+EN) ook nog `cafferata.info` → `/dicom-viewer/support.html` (`/en/` voor EN)
      en `/dicom-viewer/`.
- [x] **iOS 27 vereist scenes:** builds met de iOS 27-SDK crashten bij de start (`UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption`). Opgelost in 2.2: SwiftUI `App`-levenscyclus + `UIApplicationSceneManifest`. Geldt ook voor Eds andere oudere apps met `@UIApplicationMain`!
- [ ] **2.2 heeft een nieuwe look** → alle App Store-screenshots (iPhone én iPad) opnieuw maken; de oude tonen de oude UI.
- [ ] 2.2: op een echt toestel testen (iPhone 13 Pro Max = iOS < 26? dan de materiaal-fallback) en iPad split-view.
- [ ] Openen van een scan en het eerste maken van miniaturen is traag (bestaande parser, alle frames worden gedecodeerd); in een Release-build nameten.
- [ ] 2.2 is in 12 talen (#12): App Store-beschrijving en -screenshots per taal toevoegen in ASC (geen fastlane-metadata in deze repo). Vertalingen zijn door Claude gemaakt; laat de medische teksten (Leren) bij voorkeur nalezen.
- [ ] Screenshots alleen in NL; de EN-listing toont NL-beelden.
- [ ] Fooien zijn NON_CONSUMABLE (één keer per persoon) — werkt, maar dan is "Aankopen herstellen" verplicht; controleren.
- [ ] Marketing: altijd zowel App Store- als Google Play-link.
- [ ] Pre-release-check (skill `pre-release-app-review`) vóór indienen.
