# Sites die over DICOM/scans schrijven — lijst + aanpak

> Onderzoek door Claude, 4 juli 2026. Aanvulling op [PROMOTIE.md](PROMOTIE.md) —
> dit zijn specifiek de websites die al roundups/reviews/nieuws over DICOM-viewers
> en medische beeldvorming publiceren. Bij elke site staat hoe je 'm het beste
> nadert, met een tekst die je direct kunt kopiëren.

## A. Review- en roundup-sites (vragen om toevoeging/update)

Deze sites hebben al een artikel met een lijstje DICOM-viewers. Een mailtje met het
verzoek om Dicom Viewer toe te voegen kost weinig en kan een blijvende vermelding
opleveren (goed voor SEO-verkeer).

| Site | Artikel | Aanpak |
|---|---|---|
| **iMedicalApps** ⚠️ | imedicalapps.com — fysiek-gereviewde medische apps, 400k views/mnd | Contactformulier (imedicalapps.com/contact/) is **kapot** (reCAPTCHA geeft "Invalid site key", 13 juli 2026 geconstateerd) en er staat geen los e-mailadres — alleen redacteursnamen (Iltifat Husain MD, Satish Misra MD). About-pagina lijkt al jaren niet bijgewerkt. **Update 9 augustus 2026:** opnieuw gecontroleerd — nog steeds exact dezelfde "Invalid site key"-fout, dus nog steeds niet bruikbaar. Alternatief blijft Twitter/X (@IltifatMD, hoofdredacteur) — niet geprobeerd deze sessie, kandidaat voor Ed zelf |
| **RadioGyan** ✅ | radiogyan.com/articles/dicom-viewers/ | Contactformulier: radiogyan.com/contact/ (radiologie-blog van Dr. Amar Udare) — **gemaild door Ed, 10 juli 2026** |
| **MEDevel** ✅✅✅ | medevel.com (open-source healthcare tools) | Contact: medevel.com/about-contact/ — check ook hun GitHub-issues voor suggesties — **gemaild door Ed, 10 juli 2026. Reactie ontvangen 10 juli 2026: "We are ready to publish about it, please send us a full features list." Featurelijst-reactie (zie kant-en-klare tekst hieronder) verzonden door Ed, 10 juli 2026 — wacht op publicatie.** |
| **IMAIOS blog** ⚠️ | imaios.com/en/resources/blog/mobile-dicom-viewer-apps | Bedrijf achter concurrent IDV. **Sterke pitch:** hun artikel zegt letterlijk "we did not find any other iOS applications that are free" (alleen Horos $14,99/jr en Osirix $9,99/mnd genoemd) — Dicom Viewer is precies die ontbrekende gratis iOS-app. Contactformulier faalde 2x met HTTP 400 (13 juli 2026, reCAPTCHA gaf 503) — bleek tijdelijk: een bugmelding over dat probleem is bij de 3e poging wél gelukt ("Your message has been sent successfully"). IMAIOS (Hyeyeon Chotard) bevestigde 15 juli 2026 (ticket #291854) dat de bugmelding is doorgezet naar hun devteam. **Update 9 augustus 2026:** artikel opnieuw gecontroleerd — pitch nog steeds geldig (nog steeds geen gratis iOS-viewer genoemd). Contactformulier (imaios.com/en/contact-us, categorie "Partnership") volledig ingevuld met de content-suggestie-tekst (zie hieronder) — **bewust niet verzonden**, form heeft een zichtbare reCAPTCHA-badge en Claude klikt niet op verzendknoppen achter een CAPTCHA. Staat klaar voor Ed om te controleren en te versturen. |
| **Medicai blog** | blog.medicai.io/en/mobile-dicom-viewer/ | Concurrent (cloud PACS), maar blog staat open voor vermeldingen — contact via medicai.io |
| **PostDICOM blog** ✅ | postdicom.com/en/blog/top-25-free-dicom-viewers | Concurrent (NL bedrijf, Utrecht), roundup "Top 25 Free DICOM Viewers" — **gemaild via contactformulier door Ed, 13 juli 2026 ("Your message was sent successfully"), wacht op reactie** |
| **Encord blog** | encord.com/blog/best-dicom-viewers/ | ML data-platform, SEO-roundup — contact via encord.com |
| **Folio3 Digital Health** | digitalhealth.folio3.com/blog/the-best-dicom-viewer/ | Contact via folio3.com |
| **WifiTalents** | wifitalents.com/best/dicom-viewing-software/ | Statistieken/rankings-site — contactformulier op de site |
| **Radiology Cafe** ✅✅ | radiologycafe.com/radiology-trainees/dicom-viewers/ — UK-site van Dr Christopher Clarke (Consultant Radiologist, Nottingham), lijst met gratis DICOM-viewers (Horos, WEASIS, RadiAnt, Pacsbin, Collective Minds) incl. één iOS-app (Horos iOS) — Dicom Viewer stond er nog niet bij. Pagina nodigde expliciet uit: "Please send us your suggestions for other great free DICOM viewers!" | Alleen webformulier (radiologycafe.com/contact-us/), geen los e-mailadres. Tekst door Claude ingevuld en klaargezet (28 juli 2026), **door Ed ingevuld gecontroleerd en verzonden**, wacht op reactie |

## B. Nieuwssites (persbericht-aanpak)

Deze schrijven radiologienieuws en nemen soms productaankondigingen op.

| Site | Notitie |
|---|---|
| **AuntMinnie** (auntminnie.com) | Grootste community medische beeldvorming — al genoemd in PROMOTIE.md, juiste subforum voor aankondiging |
| **Medimaging.net** | Globaal radiologienieuws — MRI/CT/echo/imaging-IT, neemt persberichten op |
| **Imaging Technology News** (itnonline.com) | Radiology Imaging-kanaal, dekt CT/MRI/RX-technologie |
| **Diagnostic Imaging** (diagnosticimaging.com) | MJH Life Sciences-titel, redactioneel — moeilijker zonder relatie, wel proberen |

## C. Open directories (zelf toevoegen, geen contact nodig)

| Site | Aanpak |
|---|---|
| **SourceForge / Slashdot Media** ⏸️ — sourceforge.net/software/vendors/new | Blijkt een zwaarder B2B-leadformulier dan verwacht ("Add Your Business Software or Service", vraagt telefoonnummer/bedrijfsgegevens) — telefoonnummer bewust leeg gelaten. Formulier staat verder klaar (13 juli 2026): categorie "DICOM Viewers", Free Version, iPhone+iPad aangevinkt. **Bewust nog niet verstuurd** — de verplichte akkoord-checkbox bevat ook "I agree to receive communications from SourceForge.net" (marketing-opt-in), Ed wil dat nog even laten hangen voordat we op Submit klikken. |
| **Awesome DICOM** ✅ — github.com/open-dicom/awesome-dicom | Curated GitHub-lijst — **PR geopend 13 juli 2026: [#27](https://github.com/open-dicom/awesome-dicom/pull/27)**, toegevoegd aan de Visualization-sectie onder Other/Combination, wacht op merge |
| **AlternativeTo + SaaSHub** | Al gepland in LAUNCH_KIT.md sectie B |

## D. Nederlandse patiëntencommunity (helpende toon, geen reclame)

| Site | Notitie |
|---|---|
| **kanker.nl** — gespreksgroepen (bv. "beeldvormend onderzoek", oncologie-forums) | Nederlandse patiënten vragen hier naar scans/cd's van het ziekenhuis. Zelfde *helpende* aanpak als Reddit: reageer op een concrete vraag, noem de app als optie, wees open dat je de maker bent |

---

## Kant-en-klare teksten

### 1. Mail aan review-/roundup-sites (categorie A)

Onderwerp: `Suggestion for your DICOM viewer roundup — Dicom Viewer (iOS)`

```
Hi,

I came across your article on DICOM viewers and wanted to suggest an addition:
Dicom Viewer, a native iOS app for viewing DICOM medical images (X-ray, CT, MRI,
ultrasound) on iPhone and iPad.

It's built privacy-first — everything runs on-device, with no account, no cloud
upload and no PACS connection required. Patients can open scans they received on
a hospital CD or USB drive; clinicians and students get a cine player, Window/Level
presets (Abdomen, Lung, Bone, Brain), a series navigator and frame export.

App Store: https://apps.apple.com/app/id1483496527
Site: https://cafferata.info

Happy to answer questions or send screenshots if that's useful. Thanks for
maintaining such a helpful resource!

Best,
Ed — The IT Crowd
```

**Radiology Cafe (radiologycafe.com/contact-us/):** bovenstaande tekst is gebruikt
in het Bericht-veld van het webformulier (Naam: Ed Cafferata, E-mail:
edcafferata@icloud.com) — ingevuld door Claude, verzonden door Ed, 28 juli 2026.

### 2. Persbericht/mail aan nieuwssites (categorie B)

Onderwerp: `New app: Dicom Viewer — native, privacy-first DICOM viewer for iPhone/iPad`

```
The IT Crowd has released Dicom Viewer, a native iOS app that lets patients and
clinicians view DICOM medical images (X-ray, CT, MRI, ultrasound) directly on
iPhone and iPad — without uploading anything to a cloud service or PACS system.

Key features: full-screen viewer with pinch-zoom and pan, a cine player for
multi-frame studies, Window/Level presets (Abdomen, Lung, Bone, Brain), an
automatic series navigator, and frame export to PNG/JPEG. Everything runs
on-device, so no account and no internet connection is needed once installed.

Dicom Viewer is free to download, with an optional tip jar to support
development. Available worldwide in English and Dutch.

App Store: https://apps.apple.com/app/id1483496527
Contact: edcafferata@icloud.com
```

### 3. GitHub PR-tekst voor Awesome DICOM (categorie C)

```
Add Dicom Viewer — a native iOS app (iPhone/iPad) for viewing DICOM medical
images (X-ray, CT, MRI, ultrasound). On-device only: no account, no cloud
upload, no PACS connection. Includes a cine player, Window/Level presets,
series navigator and frame export. Free, App Store: https://apps.apple.com/app/id1483496527
```

### 3b. Featurelijst voor MEDevel (reactie op hun verzoek, 10 juli 2026)

Onderwerp: `Re: Dicom Viewer — full feature list`

```
Hi [naam contactpersoon],

Great to hear you're ready to publish! Here's the full feature list for Dicom
Viewer by The IT Crowd.

One-liner: A native iOS app (SwiftUI) that lets patients and clinicians view
DICOM medical images — X-ray, CT, MRI, ultrasound — directly on iPhone or iPad,
fully on-device.

App Store: https://apps.apple.com/us/app/dicom-viewer-by-the-it-crowd/id1483496527
GitHub (open source, GPL-3.0): https://github.com/EdCafferata/DICOM-player
Platform: iOS 16.0+, iPhone and iPad
Languages: English, Dutch
Price: Free, with an optional tip jar
Current version: 2.1 (live since July 1, 2026)

Why it's different
Everything is processed entirely on-device — no account, no cloud upload, no
PACS connection. The DICOM parser itself is custom-built with zero external
dependencies. That matters for two audiences at once: patients who just want
to open the scan CD/USB their hospital gave them, and clinicians/students who
want a fast, private viewer.

Full feature list (v2.1)
- Custom DICOM parser — reads the DICOM binary format natively, no third-party
  libraries
- Full-screen viewer — pinch-to-zoom, pan, double-tap to reset
- Cine player — plays multi-frame studies (series) back like a video
- Series navigator — slices automatically grouped by series
- Window/Level presets — Abdomen, Lung, Bone, Brain
- Frame export — save frames as PNG/JPEG
- Recently opened files
- Dark medical theme — UI designed specifically for reading medical images
- Open-in support — open files directly from the Files app, AirDrop, or email
- Tip jar — optional way to support development, no paywall on core features

On the roadmap (in progress)
- Measurements — distance measurement in mm directly on the image
- iPad split-view layout — file list and viewer side by side

Screenshots
Happy to send high-res screenshots (or App Store Connect access to the current
set) — just let me know which sizes/format you need.

The project is fully open source under GPL-3.0, so feel free to link the
GitHub repo alongside the App Store listing if that fits your format.

Thanks again for considering it — let me know if you need anything else!

Best,
Ed Cafferata
The IT Crowd
edcafferata@icloud.com
```

### 3c. IMAIOS-contactformulier (categorie Partnership) — klaargezet 9 augustus 2026, niet verzonden

Ingevuld op imaios.com/en/contact-us (Voornaam: Ed, Achternaam: Cafferata, E-mail:
edcafferata@icloud.com, categorie: Partnership). **Niet verzonden** — het formulier
heeft een zichtbare reCAPTCHA-badge, en Claude klikt niet op verzendknoppen achter
een CAPTCHA. Ed kan dit zelf controleren en versturen op de bovenstaande URL.

Onderwerp: `Free native iOS DICOM viewer — for your "Best mobile DICOM viewer" article`

```
Hi IMAIOS team,

I enjoyed your "Best mobile DICOM viewer" article. You note that you didn't
find any free iOS DICOM viewer apps (only Horos Mobile at $14.99/yr and
Osirix HD at $9.99/mo are listed for iOS). I built exactly that: Dicom
Viewer, a free native iOS app for viewing DICOM medical images (X-ray, CT,
MRI, ultrasound) on iPhone and iPad.

It's privacy-first: everything runs on-device, no account, no cloud upload,
no PACS connection required. Features include a cine player for multi-frame
studies, Window/Level presets (Abdomen, Lung, Bone, Brain), an automatic
series navigator, and frame export to PNG/JPEG. Open source under GPL-3.0,
with a custom DICOM parser written from scratch.

App Store: https://apps.apple.com/app/id1483496527
Site: https://cafferata.info

Would be great if it could be added to your comparison table as a free iOS
option. Happy to answer any questions or send screenshots.

Best,
Ed Cafferata — The IT Crowd
```

### 4. Helpende reactie voor kanker.nl / NL-forums (categorie D)

```
De bestanden op een cd of usb-stick van het ziekenhuis zijn meestal DICOM-bestanden
(.dcm). Op je iPhone of iPad kun je die openen met een DICOM-viewer-app — ik gebruik
zelf Dicom Viewer omdat alles op het toestel blijft (geen upload, geen account). Zet
de bestanden op je telefoon (via de Bestanden-app, AirDrop of e-mail) en open ze in
de app. Laat het weten als het niet lukt, dan denk ik mee.

(Volledigheidshalve: ik ben de maker van de app.)
```

**Why:** Bredere vindbaarheid naast de kanalen uit PROMOTIE.md/LAUNCH_KIT.md —
specifiek de sites die al content over DICOM-viewers/scans hebben.
**How to apply:** Begin met categorie A (hoogste kans op een blijvende vermelding),
categorie C kost het minste tijd. Categorie D pas gebruiken bij een concrete vraag,
nooit als losse post.
