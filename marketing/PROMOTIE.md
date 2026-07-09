# Promotieplan — Dicom Viewer

> Onderzoek door Claude op 13 juni 2026, autonoom uitgevoerd terwijl Ed weg was.
> Doel: concrete plekken om Dicom Viewer (medische DICOM-viewer, live in NL + VS)
> te promoten, geprioriteerd, met de spelregels per platform en kant-en-klare teksten.

## De twee doelgroepen (belangrijk voor de toon)

Dicom Viewer heeft twee heel verschillende publieken — richt je per kanaal op één:

1. **Patiënten** — mensen die van het ziekenhuis een cd/usb met hun MRI/CT/röntgen
   meekregen en die thuis willen bekijken. Dit is de **sterkste, minst competitieve
   hoek**: uit reviews van concurrenten blijkt "useful for viewing tests from the
   hospital, especially when you can't use a laptop to access a CD". Geen jargon,
   nadruk op: privacy (blijft op je toestel), geen account, opent cd/usb/e-mail.
2. **Professionals** — radiologen, laboranten, geneeskundestudenten, dierenartsen.
   Hier nadruk op cine-loop, W/L-presets, series, snelheid. Wees voorzichtig: deze
   groep prikt door marketing heen en de subreddits zijn streng op zelfpromotie.

---

## PRIORITEIT 1 — gratis, hoge waarde, nu doen

### 1. Apple App Store — Featuring Nomination (gratis, via App Store Connect)
Apple's eigen kanaal om geredigeerd te worden ("Featured"). Sinds nov 2024 kun je
je app zelf nomineren via **App Store Connect → Featuring nominations form**.
- **Waarom nu:** je VS-lancering (12 juni) is precies het type "moment" waar Apple
  op selecteert. Dien in als **nieuwe regio / major update**.
- **Timing:** minimaal 2 weken vooraf, idealiter 4–6 weken voor een moment; tot 3
  maanden vooruit mag.
- **Apple scoort op 7 criteria:** UX, UI-design, innovatie, uniekheid,
  toegankelijkheid, lokalisatie, kwaliteit van de productpagina. → de en-US
  store-pagina (issue #8) is inmiddels af (NL+EN ingevuld, ingediend met v2.1).
- Link: https://developer.apple.com/help/app-store-connect/manage-featuring-nominations/nominate-your-app-for-featuring/

### 2. AlternativeTo + SaaSHub (gratis listing als alternatief)
Mensen zoeken hier actief naar "DICOM viewer voor iPhone". Voeg Dicom Viewer toe als
alternatief voor de bekende namen, dan lift je mee op hun zoekverkeer:
- Concurrenten om je als alternatief bij te plaatsen: **RadiAnt, MicroDicom, Horos,
  IDV (IMAIOS DICOM Viewer), Medicai, MedFilm, OsiriX, xMedCon**.
- AlternativeTo: https://alternativeto.net (maak account → "Add to alternatives")
- SaaSHub: https://www.saashub.com

### 3. 9to5Mac — Indie App Spotlight (gratis redactionele rubriek)
Wekelijkse rubriek voor indie-apps. Indienen kan simpel per e-mail.
- **Mail:** michaelb@9to5mac.com — korte pitch + App Store-link + 2–3 screenshots.
- Hoek: "native, privacy-first DICOM viewer, geen cloud, nu ook in de VS".

### 4. Indie App Catalog / IndieAppsCatalog (gratis directory)
- https://indieappcatalog.com en https://indiecatalog.app/news/submit
- Plaats de app + een "NewsFromDevs"-update voor de VS-lancering.

---

## PRIORITEIT 2 — developer- & Apple-community (gratis, makkelijk)

| Plek | URL | Notitie |
|---|---|---|
| MacRumors iOS Apps-forum | forums.macrumors.com/forums/ios-apps-and-apple-arcade.133/ | Eigen thread per app, updates blijven bumpen; afbeeldingen mogen direct geüpload |
| HackingWithSwift — App Announcements | hackingwithswift.com/forums/app-announcements | TestFlight én App Store; afbeeldingen elders hosten en linken |
| r/IndieAppNews | reddit.com/r/IndieAppNews | Subreddit speciaal vóór zelfpromotie van indie-apps |
| Product Hunt | producthunt.com/protips | Gratis launch; ranking via upvotes. Goede SEO-waarde ook zonder #1. Plan een launchdag, mobiliseer contacten |
| Indie Dev Monday — "Look at me" | indiedevmonday.com/look-at-me | Nieuwsbrief-spotlight via formulier |

---

## PRIORITEIT 3 — medische communities (hoge relevantie, let op regels)

> **Gouden regel:** op deze plekken werkt *helpen* beter dan *adverteren*. Beantwoord
> vragen als "hoe bekijk ik mijn MRI-cd op mijn telefoon?" en noem de app als één van
> de opties. Lees altijd eerst de subreddit-/forumregels over zelfpromotie.

- **r/radiology** — actief, veel artsen (41%), laboranten (18%), studenten (12%).
  Strikt op promo. Beste: nuttige post of reactie, geen harde reclame.
- **r/medicine** — alleen geverifieerde professionals; zeer streng. Eerder
  reputatie opbouwen dan posten-en-wegwezen.
- **Patiënt-subreddits** (hier is de echte kans, vragen over "scans bekijken"):
  r/AskDocs, r/MRI, r/CTscan, r/cancer, r/braintumor — beantwoord concrete
  "hoe-bekijk-ik-mijn-cd"-vragen.
- **AuntMinnie** (auntminnie.com) — grootste community voor medische beeldvorming;
  nieuws + forums. Goede plek voor een aankondiging in de juiste subforum.
- **Figure 1** ("Instagram voor artsen", HIPAA-compliant) en **Radiology Rounds** —
  case-sharing netwerken; geschikt om zichtbaar te zijn tussen radiologen.
- **LinkedIn** — post vanuit The IT Crowd + deel in radiologie-/health-IT-groepen.
- **Dierenartsen** niet vergeten: DICOM wordt ook veterinair gebruikt; minder
  concurrentie. Zoek veterinaire imaging-groepen op FB/LinkedIn.

---

## PRIORITEIT 4 — bredere directories & verbreders

- **Mastodon iosdev.space** — tag @indieappcatalog; actieve indie-iOS-community.
- **AltStore PAL** (EU, gratis listing, 0% commissie op gratis apps) — extra
  vindbaarheid binnen de EU.
- App-reviewsites benaderen voor een review (medevel.com schrijft over DICOM-apps;
  zij maakten al lijstjes "Top free iPhone DICOM apps" — vraag om opname).
- **radiologybusiness.com / radiologytoday.net** — schrijven "essential apps"-stukken;
  een mailtje met de app kan tot vermelding leiden.

---

## Kant-en-klare teksten

### Korte pitch (9to5Mac / directories / Product Hunt tagline)
> **Dicom Viewer** — view your MRI, CT and X-ray scans right on your iPhone or iPad.
> Open DICOM files straight from a hospital CD, USB drive or email. No account, no
> cloud, no PACS — your medical images never leave your device. Native, fast, with a
> cine player and a dark theme built for medical images.

### Reddit/forum-reactie op "hoe bekijk ik mijn scan-cd?" (patiënt-hoek)
> If you've got a CD or USB from the hospital, the files on it are usually DICOM
> (.dcm). On iPhone/iPad you can open them with a DICOM viewer app — I use Dicom
> Viewer because everything stays on the device (no upload, no account). Copy the
> files to your phone (Files app / AirDrop / email) and open them in the app. Happy
> to help if you get stuck.

### LinkedIn-post (professioneel, vanuit The IT Crowd)
> Trots: Dicom Viewer is nu ook live in de Amerikaanse App Store 🇺🇸. Een native iOS-
> viewer voor DICOM-beelden (röntgen, CT, MRI, echo) — privacy-by-design: alles blijft
> op het toestel, geen cloud, geen account. Met cine-loop, window/level-presets en een
> donker thema voor medische beelden. [link] #radiology #medicalimaging #iOS #DICOM

---

## Volgorde van aanpak (wat eerst)
1. ✅ **en-US store-pagina af** (issue #8) — NL+EN teksten, keywords, subtitle en
   privacy-URL ingevuld; meegestuurd met de v2.1-indiening (30 juni 2026).
2. ✅ Featuring Nomination ingediend (de VS-lancering + de v2.1-update zijn het "moment").
3. ✅ AlternativeTo + SaaSHub-listings — beide live (7-8 juli 2026), zie LAUNCH_KIT.md.
4. ✅ 9to5Mac gemaild (4 juli 2026); Indie App Catalog nog te doen.
5. MacRumors- en HackingWithSwift-thread aanmaken — nog open.
6. Pas daarna de medische communities, met de *helpende* toon — NL-outreach loopt al
   gedoseerd via NEDERLANDSE_BRONNEN.md.
7. Vraag de eerste tevreden gebruikers om een **review** — een pagina zonder ratings
   converteert slecht (geldt extra voor medische apps).

## Bronnen
- https://nemecek.be/blog/129/places-you-can-promote-your-app-for-free
- https://developer.apple.com/help/app-store-connect/manage-featuring-nominations/nominate-your-app-for-featuring/
- https://9to5mac.com/guides/indie-app-spotlight/
- https://indieappcatalog.com/
- https://medevel.com/top-free-iphone-dicom-radiology-applications-for-doctors-radiologists/
- https://www.imaios.com/en/resources/blog/mobile-dicom-viewer-apps
- https://radiologybusiness.com/topics/healthcare-management/leadership/reddit-radiologists-engage-peer-learning-patients
