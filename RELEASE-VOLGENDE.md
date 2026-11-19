# Dicom Viewer — volgende versie: niet vergeten (pre-release-check 19 nov 2026)

Stand: 2.1 (build 9) live, min iOS 16. Geen fastlane-metadata in deze repo → deze punten handmatig in ASC.

- [ ] **Privacy-URL wijst naar de homepage `cafferata.info`** i.p.v. een privacybeleid (Guideline 5.1.1-risico,
      zeker voor een medische app). Op een live versie niet te wijzigen (API: 409). Bij de volgende versie in
      ASC → App-informatie zetten op `https://cafferata.info/dicom-viewer/privacy.html` (NL) en
      `https://cafferata.info/dicom-viewer/en/privacy.html` (EN).
- [ ] **Support-/marketing-URL** (versie, NL+EN) ook nog `cafferata.info` → `/dicom-viewer/support.html` (`/en/` voor EN)
      en `/dicom-viewer/`.
- [ ] Screenshots alleen in NL; de EN-listing toont NL-beelden.
- [ ] Fooien zijn NON_CONSUMABLE (één keer per persoon) — werkt, maar dan is "Aankopen herstellen" verplicht; controleren.
- [ ] Marketing: altijd zowel App Store- als Google Play-link.
- [ ] Pre-release-check (skill `pre-release-app-review`) vóór indienen.
