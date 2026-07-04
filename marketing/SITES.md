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
| **iMedicalApps** | imedicalapps.com — fysiek-gereviewde medische apps, 400k views/mnd | Contact via About → Contact op imedicalapps.com. Grootste vis hier — physician reviewers, dus benadruk klinisch nut + privacy |
| **RadioGyan** | radiogyan.com/articles/dicom-viewers/ | Contactformulier: radiogyan.com/contact/ (radiologie-blog van Dr. Amar Udare) |
| **MEDevel** | medevel.com (open-source healthcare tools) | Contact: medevel.com/about-contact/ — check ook hun GitHub-issues voor suggesties |
| **IMAIOS blog** | imaios.com/en/resources/blog/mobile-dicom-viewer-apps | Bedrijf achter concurrent IDV, maar publiek roundup-artikel — reactieformulier/contact op de site |
| **Medicai blog** | blog.medicai.io/en/mobile-dicom-viewer/ | Concurrent (cloud PACS), maar blog staat open voor vermeldingen — contact via medicai.io |
| **PostDICOM blog** | postdicom.com/en/blog/top-25-free-dicom-viewers | Concurrent, roundup "Top 25 Free DICOM Viewers" — contactformulier op postdicom.com |
| **Encord blog** | encord.com/blog/best-dicom-viewers/ | ML data-platform, SEO-roundup — contact via encord.com |
| **Folio3 Digital Health** | digitalhealth.folio3.com/blog/the-best-dicom-viewer/ | Contact via folio3.com |
| **WifiTalents** | wifitalents.com/best/dicom-viewing-software/ | Statistieken/rankings-site — contactformulier op de site |

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
| **SourceForge / Slashdot Media** — sourceforge.net/software/dicom-viewers/ | Vendor kan eigen product claimen/toevoegen aan de vergelijkingspagina (los van open-source hosting) |
| **Awesome DICOM** — github.com/open-dicom/awesome-dicom | Curated GitHub-lijst — voeg Dicom Viewer toe via een Pull Request |
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
