# Concurrentie & positionering — Dicom Viewer

> Onderzoek door Claude, 13 juni 2026 (autonoom). App Store-landschap voor iOS
> DICOM-viewers, en waar Dicom Viewer zich het beste kan positioneren.

## De concurrenten (App Store, US)

| App | Model | Hoek | Opmerking |
|---|---|---|---|
| **IDV — IMAIOS DICOM Viewer** | gratis (niet-commercieel) | professionals | 4,69★, sterk gewaardeerd, dé grote naam |
| **DICOM Viewer: MRI CT XRAY & +** | gratis | on-device, patiënt/pro | nieuw, **zeer vergelijkbaar** met Dicom Viewer; folders/ZIP, window level |
| **Medicai DICOM Viewer & PACS** | cloud/subscription | cloud + sharing | leunt op cloud-PACS — ander model |
| **3DICOM Mobile** | gratis app, **login vereist abo** | 3D/pro | drempel: je moet een licentie hebben |
| **OsiriX** | Lite gratis / MD betaald | klinisch (FDA/CE) | desktop-erfenis, zwaar |
| **Falcon Mx / MedFilm / Bee DICOM** | gratis | mobiele viewer | kleinere spelers |

## De rode draad — waar zit het gat?

De markt valt uiteen in twee kampen:
1. **Pro-tools** (IDV, OsiriX, 3DICOM) — gericht op radiologen, soms met
   licentie/abonnement of "niet voor commercieel gebruik".
2. **Cloud-/PACS-apps** (Medicai) — vereisen account, upload naar de cloud.

**Niemand bezet sterk de hoek "patiënt + volledig op het toestel + gratis + privacy".**
Dat is precies waar Dicom Viewer zit. Dát is de wig:

- **Patiënt-vriendelijk** — opent de cd/usb van het ziekenhuis zonder medische kennis.
- **Privacy-by-design** — geen account, geen cloud-upload, alles blijft lokaal. (Medicai
  uploadt; IDV/3DICOM mikken op pro's.)
- **Echt gratis** — met optionele tip jar (geen "niet-commercieel"-clausule zoals IDV,
  geen verplicht abo zoals 3DICOM).
- **Native & snel** — SwiftUI, cine player, eigen parser zonder dependencies.

> Kernboodschap in één zin: *"De enige privacy-first DICOM-viewer die je eigen scans
> meteen op je iPhone opent — geen account, geen cloud, gratis."*

## ASO-les van de concurrentie

De concurrent **"DICOM Viewer : MRI CT XRAY & +"** propt modaliteiten in de app-naam.
Dat is een bewuste vindbaarheids-truc: mensen zoeken op "MRI viewer", "CT scan viewer",
"x-ray app" — niet op "Dicom Viewer". Lessen:

1. **De naam "Dicom Viewer by The IT Crowd" mist de modaliteit-zoekwoorden** die mensen
   intikken (MRI/CT/X-ray). Compenseer in de **ondertitel** en het **keyword-veld**
   (100 tekens) — die wegen mee voor ranking.
   - Gekozen ondertitel (en-US): `Medical image & DICOM viewer` (28/30 tekens). ✅
   - Alternatief met meer modaliteiten als je later wilt bijsturen: `MRI, CT & X-ray DICOM viewer`.
   - Keyword-veld uit `AppStore/STORE_BESCHRIJVING.md`
     (`mri,ct,scan,xray,x-ray,radiology,...`) staat goed. ✅
2. **Voeg de patiënt-zoektermen toe** die de pro-apps negeren: `hospital, cd, scan,
   patient` — daar is minder concurrentie en het sluit aan op jouw unieke hoek.
3. **Reviews zijn de hefboom** — IDV heeft 4,69★. Een nieuwe pagina zonder ratings
   verliest het, hoe goed de app ook is. Vraag je eerste gebruikers actief om een
   review (zie LAUNCH_KIT.md).

## Concreet positioneringsadvies
- Houd de **patiënt-hoek** vooraan in beschrijving + screenshots (de pro's doen dit
  niet → onderscheidend).
- Benoem expliciet **"no account · no cloud · on your device"** — dat is je sterkste,
  meetbare differentiator t.o.v. Medicai/3DICOM.
- Gebruik de modaliteit-zoekwoorden (MRI/CT/X-ray/echo) in ondertitel + keywords, niet
  in de merknaam.
- Mik met content-promotie (Reddit/AuntMinnie) op de twee plekken waar de concurrentie
  zwak is: **patiënten** en **dierenartsen**.

## Bronnen
- https://apps.apple.com/us/app/idv-imaios-dicom-viewer/id1444841062
- https://apps.apple.com/us/app/dicom-viewer-mri-ct-xray/id6760692025
- https://apps.apple.com/us/app/medicai-dicom-viewer-pacs/id6443777852
- https://3dicomviewer.com/3dicom-mobile-and-xr/
- https://sourceforge.net/software/dicom-viewers/iphone/
