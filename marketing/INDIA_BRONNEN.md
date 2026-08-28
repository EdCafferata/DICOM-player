# Indiase promotiebronnen — gedoseerde aanpak

> Onderzoek door Claude, 13 juli 2026 (autonoom, terwijl Ed sliep). Aanvulling op
> [PROMOTIE.md](PROMOTIE.md), [LAUNCH_KIT.md](LAUNCH_KIT.md), [SITES.md](SITES.md)
> en [NEDERLANDSE_BRONNEN.md](NEDERLANDSE_BRONNEN.md) — dit zijn specifiek Indiase
> bronnen om Dicom Viewer te promoten. De app staat al live op de India-storefront
> (bevestigd 13 juli 2026: `apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527`
> → HTTP 200).
>
> **Waarom India:** groot Engelstalig publiek, veel privéklinieken/diagnostische
> centra, en een acuut tekort aan radiologen (~20.500 voor 1,4 miljard inwoners —
> bron: [DICOMDrive/digitalhealthnews.com](https://www.digitalhealthnews.com/ai-powered-radiology-pathology-in-india-transforming-medical-imaging-diagnostics)),
> wat teleradiologie en mobiele viewers extra relevant maakt.
>
> Zelfde spelregels als bij de VS-sessie (13 juli 2026, zie geheugen
> `feedback_marketing_channels`): **geen betaalde kanalen, geen kanalen die
> zelfpromotie/AI-content verbieden.** Bij een aantal bronnen hieronder is dat nog
> niet volledig geverifieerd — expliciet gemarkeerd als "nog te checken" vóór
> gebruik, niet zomaar aannemen dat het gratis/toegestaan is.

## ASO-check (geen outreach nodig, puur onderzoek — 13 juli 2026)

Gratis App Store-zoek-API gebruikt (itunes.apple.com/search, geen account
nodig) om te zien waar Dicom Viewer nu al staat in India:
- Zoekterm **"dicom viewer"**: rank **23 van 44** resultaten (vrijwel
  identiek aan de VS: rank 24 van 46 — geen India-specifiek nadeel, maar ook
  geen voordeel)
- Zoekterm **"dicom"** (kaal): **niet gevonden** in de top 48 — sterke
  aanwijzing dat "dicom" als los keyword niet (goed) in de India-locale
  keywords staat
- Zoekterm **"free dicom viewer"**: ook rank 23

**Kans:** het India-specifieke keywordveld in App Store Connect nakijken en
evt. aanvullen (bijv. los "dicom" toevoegen, of Hindi-transliteraties
overwegen) kan de vindbaarheid verbeteren zonder dat daar outreach voor
nodig is. **Blocker:** de App Store Connect API gaf bij deze sessie een
403-fout — bleek de **al bekende, nog openstaande D&B/DUNS-accountblokkade**
(zie geheugen `project_apple_developer_account.md`, opnieuw bevestigd 13 juli
2026) — dus de keywords zelf nakijken/aanpassen kan pas zodra Ed die
Apple-verificatie heeft afgerond.

## Aanbevolen volgorde (golven, ~3-4 dagen ertussen)

### 🏆 De grootste kans — Apple App Store Featuring Nomination voor India
Groter dan elke individuele pers-/community-vermelding hieronder: een Apple-
editorial-plek op de India-storefront kan in één klap veel meer bereik geven
dan alle onderstaande golven samen, en het is een **bewezen, gratis, eigen
kanaal** — geen afhankelijkheid van een journalist die wel of niet reageert.
Ed heeft dit proces al eerder succesvol doorlopen voor de VS-lancering (zie
LAUNCH_KIT.md sectie A).
- **Pad:** App Store Connect → Dicom Viewer → Featuring → Nominations → "+"
- **Type:** *App Launch* (nieuwe regio = India), of *In-App Event/Update* als
  een App Launch-nominatie niet meer past qua timing
- **Lead time:** minimaal 2 weken vooraf, idealiter 4-6 weken; tot 3 maanden
  vooruit mag — dus zo snel mogelijk indienen
- **Supplemental materials:** App Store India-link + cafferata.info
- **Beschrijving:** kan grotendeels de bestaande VS-tekst uit LAUNCH_KIT.md
  hergebruiken, met een kleine India-specifieke toevoeging over het
  radiologentekort/teleradiologie (zie bron hierboven) als motivatie voor de
  regionale relevantie.
- **Nog te doen:** Ed moet dit zelf indienen in App Store Connect (buiten
  bereik van deze browsersessie) — geen contactformulier of e-mail, dus geen
  actie die Claude kan voorbereiden buiten deze tekst.

### 🥇 Golf 1 — IRIA (Indian Radiological & Imaging Association)
Grootste vakvereniging voor radiologie in India (opgericht 1931), met een
nationaal hoofdkantoor plus staatsafdelingen (Delhi, Kerala, West-Bengalen, e.a.).
Zelfde *helpende, niet-adverterende* toon als de NVvR-aanpak in
NEDERLANDSE_BRONNEN.md.
- Hoofdkantoor: iria37@gmail.com (Tel +91-11-41688846, WhatsApp +91 9318435313 /
  +91 9810488954) — https://iria.org.in/contact/
- Regionale chapters (latere golf, als hoofdkantoor niet reageert):
  IRIA Delhi (iriadelhi.org), IRIA Kerala (iriakerala.org), IRIA West-Bengalen
  (iriawb.org)
- **Nog te checken:** geen expliciete "geen reclame"-regel gevonden zoals bij
  NVvR, maar niet actief opgezocht — begin met een informele, niet-wervende toon.

### 🥈 Golf 2 — YourStory (editorial, e-mail)
India's grootste startup-/tech-mediaplatform. Concreet, geverifieerd
indieningsproces (13 juli 2026): naam, mobiel nummer, e-mail, website en korte
uitleg mailen naar **editorial@yourstory.com**, onderwerp
`Story Request Dicom Viewer – Healthcare/MedTech`. Expliciet vermeld: het
redactieteam vraagt nooit om betaling voor coverage — dus een veilig gratis
kanaal.
- Bron: https://support.yourstory.com/article/17-how-do-i-get-my-startup-story-covered
- Alternatief: coverage-aanvraagformulier op
  https://www.contacts.yourstory.com/editorial-coverage-request

### 🥉 Golf 3 — Analytics India Magazine ⚠️ waarschijnlijk zwakke match
Heeft een radiologie-tag (https://analyticsindiamag.com/news/radiology/),
maar bij nader onderzoek (13 juli 2026) blijkt de redactionele focus vooral
op **AI/data-science/enterprise-IT-nieuws** te liggen (datacenters, AI-
investeringen, grote IT-dienstverleners) — niet op consumenten-apps. Geen
duidelijk contactformulier gevonden (contact-us-pagina bestaat niet, redirect
naar een artikel); wel een "Got a tip?"-optie maar zonder duidelijke
mail/formulier-link. Lagere prioriteit — waarschijnlijk geen sterke match
voor Dicom Viewer.
- **ETHealthworld** (health.economictimes.indiatimes.com) — het grootste
  Indiase gezondheidszorg-vakmedium (Economic Times-vertical), maar geen
  duidelijke gratis persbericht-route gevonden bij dit onderzoek; sommige
  zoekresultaten wijzen richting betaalde "artikel plaatsen op Economic
  Times"-PR-diensten. **Niet gebruiken zonder eerst een échte gratis
  redactie-ingang te vinden** (bijv. via een individuele journalist op
  LinkedIn) — past anders mogelijk niet bij de "geen betaalde kanalen"-regel.
  **Update 18 juli 2026:** opnieuw gezocht — de site zelf blokkeert directe
  toegang (403), en er is geen "write for us"/contact-e-mailadres gevonden.
  Wel een naam: Shahid Akhter is redacteur bij ETHealthworld, maar zonder
  geverifieerd e-mailadres is een gok te riskant (bounce-risico zoals eerder
  bij MediaNama). Nog steeds "on hold" tot een echt adres gevonden is.
  **Update 24 juli 2026:** opnieuw gezocht — WebFetch van de contactpagina
  (health.economictimes.indiatimes.com/contact-us) faalde net als eerder
  (site blijft ontoegankelijk voor geautomatiseerde toegang). Geen nieuw
  e-mailadres gevonden. Blijft "on hold".

### Golf 3b — MediaNama ⚠️ gepubliceerd adres blijkt niet actief
Bekroonde publicatie over techbeleid in India (privacy, data, digitale
ecosystemen) — gezaghebbend bij beleidsmakers en bedrijven, minder puur
consument-gericht maar met veel gezag. **Update 13 juli 2026:** de mail naar
**releases@medianama.com** (het adres van hun eigen contactpagina) is
**gebounced** — "550-5.1.1 The email account that you tried to reach does not
exist". Het adres zelf was correct overgenomen, maar blijkt niet (meer)
actief op hun mailserver, ondanks dat het nog op hun site staat. **Niet
opnieuw proberen zonder eerst een ander contact te vinden** (bijv. rechtstreeks
naar een van de journalisten op de contactpagina — aakriti.bansal@medianama.com,
azdhan@medianama.com, prabhanu@medianama.com, amit@medianama.com — of via
Nikhil Pahwa, nikhil@medianama.com).
- Contact: https://www.medianama.com/contact-us/

### Golf 4 — developersIndia (community + Reddit)
India's grootste ontwikkelaarscommunity (1M+ leden). **Regels gecontroleerd
(13 juli 2026):** geen verbod op het delen/showcasen van je eigen app (in
tegenstelling tot de Amerikaanse medische subreddits die deze sessie zijn
tegengekomen) — wel gelden algemene regels: gebruik de juiste post-flair
("Showcase" oid.), geen lage-kwaliteit-post, wees inhoudelijk.
- Community: https://developersindia.in/
- Subreddit: https://reddit.com/r/developersIndia (regels:
  https://old.reddit.com/r/developersIndia/about/rules — geverifieerd, geen
  anti-zelfpromotie-regel)
- **r/india** ⛔ **ongeschikt** (regels gecontroleerd, 13 juli 2026): regel 9
  verbiedt zelfpromotie grotendeels (slechts 1 op de 10 reacties mag
  zelfpromotie zijn — vereist eerst een lange periode actief/oprecht
  meedoen), én regel 10 verbiedt expliciet generatieve AI-content ("We do not
  allow AI-generated content... ChatGPT, Copilot, Gemini..."). Zelfde valkuil
  als HackingWithSwift eerder deze sessie — overslaan.

### Golf 5 — Inc42 ⛔ ongeschikt (India-vestigingseis), niet ingediend
Startup-mediaplatform, groot bereik (25M+/maand). **Update 15 juli 2026:**
nader onderzocht — de "Startup Booster Package" is een apart, duidelijk als
betaald gemarkeerd add-on-product; de gewone submissie via het Tally-form
(https://tally.so/r/w2poXD) is de reguliere, kosteloze coverage-aanvraag
zonder betaalverplichting. Voldoet dus aan de "geen betaalde kanalen"-regel.
**Update 16 juli 2026:** bij het daadwerkelijk openen van het formulier bleek
shortlisting-criterium 1 te eisen dat het bedrijf **in India gevestigd is, of
bij bedrijven buiten India minstens 60-70% van het personeel in India heeft**.
The IT Crowd is een Nederlandse eenmanszaak — voldoet hier niet aan, ongeacht
dat het kanaal verder gratis is. Formulier niet ingevuld/verzonden, geen
vervolgstap voor dit kanaal.

### Golf 6 — Patiëntkant (lagere prioriteit, nog te verifiëren)
Zelfde *helpende, niet-wervende* toon als kanker.nl (NL) — pas reageren bij een
concrete vraag over het bekijken van scanbeelden, geen koude post.
- **India Medical Hub** ☠️ **NIET GEBRUIKEN** (gecheckt 13 juli 2026): het
  domein indiamedicalhub.com blijkt gekaapt — geen medisch forum meer, maar
  een Indonesische gokspam-pagina ("RATU11 BANDAR SLOT GACOR"). Waarschijnlijk
  een verlopen domein dat is overgenomen. Verwijderd uit de aanbevelingen;
  meld dit niet als bron in toekomstige sessies.
- **PharmD Info — Indian Patient Forum** (pharmdinfo.com/indian-patient-forum-f246.html)
  ✅ **lijkt legitiem** (gecheckt 13 juli 2026): actief forum voor Indiase
  apothekers/patiënten, recente posts (juli 2026), subforums incl. Cancer
  Patients Forum, Telepharmacy. Geen expliciet zelfpromotie- of AI-verbod
  gevonden (alleen een algemene medische-disclaimer), maar de aparte
  "algemene regels"-link opende geen leesbare pagina in deze sessie — dus
  niet 100% zeker. **Zelfde voorzichtige aanpak:** alleen reageren op een
  concrete vraag over het bekijken van scanbeelden, geen losse aankondiging.

### Golf 7 — Grote diagnostische ketens (laagste prioriteit, onzeker)
Analoog aan de NL "particuliere scancentra"-golf, maar dan India's grootste
ketens: **Apollo Diagnostics** (apollodiagnostics.in/contact-us) en
**Metropolis Healthcare** (metropolisindia.com/contactus) — beide hebben
alleen een generiek klantenservice-contactformulier gevonden, geen
marketing/redactie-ingang. Bij zulke grote corporates komt een outreach-mail
via het klantformulier waarschijnlijk in een support-wachtrij terecht in
plaats van bij iemand die de app kan aanbevelen — **lagere prioriteit dan de
Nederlandse scancentra-golf**, alleen oppakken als de eerdere golven weinig
opleveren. Geen aparte India-veterinaire radiologie-vereniging gevonden (wel
de internationale IVRA en een lokale hardware-speler Prognosys/ProRad in
Bengaluru, geen duidelijk promotiekanaal).

---

### Nieuwe vondst (21 juli 2026) — Medical Dialogues
Grote Indiase medische-journalistiek-nieuwssite (Minerva Medical Treatment Pvt
Ltd, Delhi) gericht op zorgprofessionals en het publiek. Duidelijke gratis
persbericht-ingang: info@medicaldialogues.in. Gemaild in de Engelstalige
persbericht-stijl (zelfde toon als YourStory/MediaNama-tekst).

### Nieuwe vondst (20 juli 2026) — ISRT (Indian Society of Radiographers and Technologists)
Beroepsvereniging van radiodiagnostisch laboranten/technologen in India (gevestigd
in Thiruvananthapuram, Kerala) — de professionals die dagelijks DICOM-beelden maken
en bekijken, zelfde doelgroep-logica als NVMBR in NEDERLANDSE_BRONNEN.md. Geen
zelfpromotie- of AI-verbod gevonden bij onderzoek van de site. Contact:
info@isrt.org.in. **Gemaild 20 juli 2026.**

### Nieuwe vondst (22 juli 2026) — AMPI (Association of Medical Physicists of India)
Beroepsvereniging van medisch fysici in India (~800 leden: fysici, radiotherapeuten,
radiologen, engineers) — aanpalende doelgroep bij IRIA/ISRT: medisch fysici werken
dagelijks met beeldvormingsdata en QA van imaging-apparatuur, dus generieke
DICOM-viewing is relevant. Geen zelfpromotie- of AI-verbod gevonden. Contact:
**secretary@ampi.org.in** (via ampi.org.in/contact-us). **Gemaild 22 juli 2026.**

### Nieuwe vondst (23 juli 2026) — IRIA-nieuwsbrief (apart van het al gemailde hoofdadres)
Los van het algemene IRIA-hoofdkantooradres (iria37@gmail.com, golf 1, 13 juli
2026, nog geen reactie), bleek er een apart, specifiek nieuwsbrief-inzendadres
te bestaan: **irianewsletter@gmail.com** (voor aankondigingen, verslagen en
foto's voor de IRIA Insights-nieuwsbrief). Andere ingang dan de golf 1-mail,
dus een legitieme aanvullende poging in plaats van een dubbele. **Gemaild
23 juli 2026** via iCloud Mail.

### Nieuwe zoektocht (28 juli 2026) — geen nieuwe onafhankelijke kanalen gevonden
Gezocht naar Indiase radiologie-studentenverenigingen/newsletter-contacten
(RSSDI-achtige student-organisaties, staats-chapters) en een lijst van
radiologieverenigingen (rtstudents.com) doorzocht op nog niet benaderde Indiase
namen. Enige Indiase vermelding daar was de Radiology Education Foundation
(refindia.net) — geen contactadres gevonden bij dit onderzoek, kandidaat voor
een volgende run als er tijd is om dieper te zoeken. Verder alleen al bekende
namen (IRIA, ISRT) teruggevonden. Geen nieuw kanaal deze ronde.

### Nieuwe zoektocht (25 juli 2026) — geen nieuwe onafhankelijke kanalen gevonden
Gezocht naar aanvullende India-specifieke kanalen (studentenorganisaties,
teleradiologie-nieuwssites, colleges). Enige serieuze kandidaat was **ICRI
(Indian College of Radiology & Imaging)** — bleek bij nader onderzoek de
academische tak van IRIA zelf te zijn, met hetzelfde hoofdkantoor-telefoonnummer
(+91 9318435313) als het al gemailde IRIA-hoofdkantoor (golf 1, 13 juli 2026).
Geen apart e-mailadres gevonden en te weinig onderscheid van het al benaderde
contact om als een echt nieuw kanaal te tellen — niet gemaild. Geen andere
kansrijke vondsten deze ronde; bestaande India-aanpak dekt de kansrijke
kanalen nog steeds goed.

### Nieuwe zoektocht (26 juli 2026) — opnieuw geen nieuwe onafhankelijke kanalen
Nogmaals gezocht (studentenverenigingen radiologie, teleradiologie-startupnieuws).
Resultaten wezen vooral naar al bekende namen (IRIA, YourStory) of naar teleradiologie-
bedrijven zelf (5C Network, DeepTek, Qure.ai — dit zijn commerciële concurrenten/
partijen, geen promotiekanaal). Geen nieuwe geschikte vondst deze ronde.

### Nieuwe vondst (26 juli 2026, op verzoek van Ed: universiteiten/medical students) — AIIMS Radiodiagnosis
AIIMS New Delhi (All India Institute of Medical Sciences) is India's meest
prestigieuze medische universiteit/ziekenhuis. Het Department of Radiodiagnosis &
Interventional Radiology heeft een eigen contact: **radiodiagnosis@aiims.edu**.
Geen zelfpromotie- of AI-verbod gevonden (het is een ziekenhuisafdeling, geen
forum). Zelfde *helpende, niet-adverterende* toon als bij IRIA/NVvR. **Gemaild
26 juli 2026.** Twee andere top-instituten (PGIMER Chandigarh, CMC Vellore)
onderzocht maar nog geen bruikbaar departement-e-mailadres gevonden — alleen
algemene instituutstelefoonnummers resp. individuele-faculteitsadressen; niet
gebruikt (bounce-/te-persoonlijk-risico), kandidaat voor een volgende run als
een beter contact opduikt.

### Nieuwe vondst (4 augustus 2026) — SNMI (Society of Nuclear Medicine, India)
Beroepsvereniging van nucleair geneeskundigen in India (gevestigd bij Tata Memorial
Hospital, Mumbai) — aanpalende doelgroep bij IRIA/ISRT/AMPI: nucleaire scans (SPECT,
PET) zijn ook DICOM-bestanden, dus generieke DICOM-viewing is relevant voor deze
beroepsgroep. Geen zelfpromotie- of AI-verbod gevonden. Contact:
**snmindiasecretary@gmail.com**. **Gemaild 4 augustus 2026.**

### Nieuwe zoektocht (10 augustus 2026) — IAOMR gevonden, geen betrouwbaar contact
Gezocht naar Indiase studentenorganisaties/nieuwsbrief-contacten en naar een India-specifieke
dental/maxillofacial-radiologiehoek. **IAOMR (Indian Academy of Oral Medicine and Radiology)**
gevonden (iaomr.org) — relevant omdat Dicom Viewer ook dental/CBCT-DICOM opent, maar alleen
een gedeeltelijk gemaskeerd Honorary Secretary-adres en een curriculum-specifiek adres
(omrcurriculum@gmail.com) gevonden — geen betrouwbaar algemeen contact, dus niet gemaild
(bounce-risico zoals eerder bij ETHealthworld/MediaNama). Kandidaat voor een volgende run
als een beter contact opduikt. Verder geen nieuwe onafhankelijke kanalen gevonden.

### Nieuwe zoektocht (9 augustus 2026) — geen nieuwe onafhankelijke kanalen gevonden
Gezocht naar Indiase radiologie-studentenverenigingen/teleradiologie-nieuws en
naar een India-specifieke veterinaire-radiologie-vereniging. Resultaten wezen
vooral naar al bekende namen (IRIA, ISRT, IVRA). Wel een aangrenzende vondst:
**AAVDI (Australasian Association of Veterinary Diagnostic Imaging,
aavdi.org)** — internationale (niet India-specifieke) Engelstalige
veterinaire-radiologie-vereniging, aanpalend aan de al gemailde ACVR (VS) en
de nog te verzenden IVRA (internationaal). Alleen een webformulier
(aavdi.org/contact-us/), geen los e-mailadres gevonden. Lagere prioriteit
(niet India-specifiek, kleine vereniging) — niet benaderd deze sessie, staat
hier als kandidaat voor een latere ronde als de VS/India-veterinaire hoek
verder wordt uitgebreid.

### Nieuwe zoektocht (28 augustus 2026) — geen nieuwe onafhankelijke kanalen gevonden
Gezocht naar een India-specifieke dental/maxillofacial-radiologiehoek (CBCT-DICOM
is ook relevant voor Dicom Viewer) en naar teleradiologie-nieuwsportals. IAOMR
(al eerder gevonden, 10 augustus) opnieuw bekeken: nog steeds geen betrouwbaar
e-mailadres. **Indian Academy of Dental & Maxillofacial Radiology** (dmfrindia.org)
gevonden maar het domein was deze sessie niet bereikbaar (DNS-fout) en er is geen
e-mailadres gevonden via websearch — niet gebruikt (bounce-risico), kandidaat voor
een volgende run. Teleradiologie-zoekresultaten wezen alleen naar commerciële
teleradiologie-aanbieders (5C Network, Teleradio, Global TeleRadiology e.d.) —
geen persplek. Geen nieuw geschikt kanaal deze ronde.

### Nieuwe zoektocht (13 augustus 2026) — geen nieuwe onafhankelijke kanalen gevonden
Gezocht naar een Indiase radiologie-residenten-nieuwsbrief en departement-contacten bij
grote ziekenhuizen (Tata Memorial Hospital Mumbai, NIMHANS Bangalore) — geen van beide
had een vindbaar afdelings-e-mailadres (alleen algemene telefoonnummers). IRIA-staatschapters
(Karnataka, Kerala, Tamil Nadu) opnieuw bekeken — nog steeds alleen postadressen, geen
e-mail. Geen nieuw geschikt kanaal deze ronde; de bestaande India-checklist staat vrijwel
volledig op afgerond of "on hold" in afwachting van een betere contactroute.

## Android-heruitnodiging (17 augustus 2026) — alle eerder gemailde India-contacten

Op verzoek van Ed: Dicom Viewer is sinds 9 augustus 2026 ook gratis beschikbaar op
Google Play (`info.cafferata.dicomviewer`, live geverifieerd) — extra relevant voor
India gezien het grote Android-marktaandeel daar. Alle eerder gemailde India-contacten
krijgen een korte update-mail — geen nieuwe pitch, alleen het Android-nieuws. Gedoseerd
verstuurd, voortgezet in volgende dagelijkse runs.

**Kant-en-klare tekst (EN):**

**Onderwerp:** Dicom Viewer — now also available on Android

```
Hi [team],

I previously reached out about Dicom Viewer, my free privacy-first DICOM
viewer for iPhone and iPad. It's now also available as a free Android app,
so it's accessible regardless of which device someone uses.

Same principles as the iOS version: everything stays on-device, no account,
no cloud upload, no PACS connection required.

Android (Google Play): https://play.google.com/store/apps/details?id=info.cafferata.dicomviewer
iOS (App Store): https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

**Voortgang:**
- [x] IRIA — iria37@gmail.com — 17 augustus 2026, verzonden via iCloud Mail
- [x] YourStory — editorial@yourstory.com — 17 augustus 2026, verzonden via iCloud Mail
- [x] MSAI — vpi@msaindia.org — 17 augustus 2026, verzonden via iCloud Mail
- [x] ISVIR — info.isvir@gmail.com — 18 augustus 2026, verzonden via iCloud Mail
- [x] RadioGyan — admin@radiogyan.com — 18 augustus 2026, verzonden via iCloud Mail
- [x] ISRT — info@isrt.org.in — 17 augustus 2026, verzonden via iCloud Mail
- [x] Medical Dialogues — info@medicaldialogues.in — 17 augustus 2026, verzonden via iCloud Mail
- [x] AMPI — secretary@ampi.org.in — 18 augustus 2026, verzonden via iCloud Mail
- [x] The Better India — editorial@thebetterindia.com — 17 augustus 2026, verzonden via iCloud Mail
- [x] IRIA-nieuwsbrief — irianewsletter@gmail.com — 20 augustus 2026, verzonden via iCloud Mail
- [x] AIIMS Radiodiagnosis — radiodiagnosis@aiims.edu — 20 augustus 2026, verzonden via iCloud Mail
- [x] CMC Vellore Radiology — radio@cmcvellore.ac.in — 20 augustus 2026, verzonden via iCloud Mail
- [x] SNMI — snmindiasecretary@gmail.com — 20 augustus 2026, verzonden via iCloud Mail
- [x] SIR (Society of Indian Radiographers) — info@radiographers.org — 20 augustus 2026, verzonden via iCloud Mail
- [x] PGIMER Chandigarh — pgimer@chd.nic.in — 20 augustus 2026, verzonden via iCloud Mail (met verzoek om doorsturen naar Radiodiagnosis-afdeling)

---

## Checklist

- [ ] 🏆 Apple Featuring Nomination voor India ingediend in App Store Connect (Ed zelf, buiten browserbereik)
- [x] Golf 1 — IRIA gemaild (iria37@gmail.com) — 13 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Golf 2 — YourStory gemaild (editorial@yourstory.com) — 13 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Golf 3 — Analytics India Magazine onderzocht → ⚠️ waarschijnlijk zwakke match (focus op AI/enterprise-IT, geen contactformulier gevonden), lagere prioriteit
- [ ] Golf 3 — ETHealthworld: eerst een echte gratis redactie-ingang vinden
- [ ] Golf 3b — MediaNama: eerste poging (releases@medianama.com, 13 juli 2026) gebounced — "account does not exist". Retry-pogingen naar nikhil@medianama.com op zowel 15 als 18 juli 2026 werden allebei door de automatische veiligheidscontrole van de sessie geblokkeerd (herkent het als een "on-hold, niet zomaar opnieuw proberen"-contact, ondanks dat de sectie hierboven een individuele-journalist-retry expliciet toestaat). Blijkbaar blokkeert de check dit consequent — geen automatische retry meer proberen. Ed moet dit zelf versturen, of in een interactieve sessie expliciet bevestigen dat de retry door mag
- [x] Golf 4 — developersIndia-post gepost door Ed (18 juli 2026, "I Made This"-flair, u/kaffer1986) — ⚠️ **binnen enkele minuten automatisch verwijderd door de moderators/automod** ("Sorry, this post has been removed by the moderators of r/developersIndia"), vermoedelijk een account-leeftijd/karma-drempel of linkregel, geen inhoudelijke afkeuring gezien. Niet opnieuw proberen zonder eerst de exacte reden te achterhalen (bv. via modmail)
- [x] Golf 4 — r/india regels gecheckt → ⛔ ongeschikt (zelfpromotie-limiet + AI-verbod), overgeslagen
- [x] Golf 5 — Inc42 onderzocht → ⛔ ongeschikt: eist India-vestiging of 60-70% India-personeel, The IT Crowd voldoet niet. Niet ingediend.
- [x] Golf 6 — patiëntforums gecheckt: India Medical Hub ☠️ gekaapt door gokspam (niet gebruiken), PharmD Info lijkt legitiem (wacht op concrete vraag om op te reageren)
- [x] Golf 7 — diagnostische ketens onderzocht (Apollo, Metropolis) → alleen generieke contactformulieren gevonden, laagste prioriteit
- [x] Nieuwe vondst — MSAI (Medical Students' Association of India, 20.000+ leden) gemaild (vpi@msaindia.org) — 19/20 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — ISVIR (Indian Society for Vascular and Interventional Radiology) gemaild (info.isvir@gmail.com) — 19/20 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — RadioGyan.com (Indiase radiologie-onderwijs-nieuwsbrief, 15.000+ abonnees, Dr. Amar Udare) gemaild (admin@radiogyan.com) — 19/20 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — ISRT (Indian Society of Radiographers and Technologists) gemaild (info@isrt.org.in) — 20 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — Medical Dialogues gemaild (info@medicaldialogues.in) — 21 juli 2026, persbericht-stijl (Engelstalig), verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — AMPI (Association of Medical Physicists of India) gemaild (secretary@ampi.org.in) — 22 juli 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — The Better India (250M+ lezers/maand, "world's largest impact-driven positive stories platform") gemaild (editorial@thebetterindia.com) — 20 juli 2026, tekst door Claude klaargezet, screenshot (eigen app-screenshot van Ed, angiografie-beeld met WC/WW/frame-teller) toegevoegd en verzonden door Ed, bevestigd in Verstuurd-map met bijlage
- [x] Onderzocht, niet gebruikt — Startup India Showcase (overheidsplatform) ⛔ alleen voor DPIIT-erkende Indiase bedrijven, The IT Crowd voldoet niet (zelfde blokkade als Inc42/Swadeshi Apps eerder)
- [x] Onderzocht, niet gebruikt — IRIA state-chapters (Karnataka/Kerala/Maharashtra) alleen postadressen gevonden, geen e-mail; bovendien nog te vroeg om te escaleren zolang IRIA-hoofdkantoor (gemaild 13 juli) nog niet gereageerd heeft
- [x] Nieuwe vondst — IRIA-nieuwsbrief gemaild (irianewsletter@gmail.com) — 23 juli 2026, verzonden via iCloud Mail (na akkoord van Ed — de eerdere "lege Verstuurd-map" bleek geen storing maar Eds eigen opschoon-workflow naar de Coding-map, zie geheugen `feedback_mail_coding_folder`), wacht op reactie
- [x] Nieuwe vondst (26 juli 2026, universiteiten) — AIIMS Radiodiagnosis gemaild (radiodiagnosis@aiims.edu), verzonden via iCloud Mail, wacht op reactie
- [ ] Onderzocht, nog geen bruikbaar contact — PGIMER Chandigarh (alleen algemeen instituuttelefoonnummer) en CMC Vellore (alleen individuele-faculteitsadressen, geen departement-e-mail) — kandidaten voor een volgende run als een beter contact opduikt
- [ ] Nieuwe zoektocht (27 juli 2026) — opnieuw gezocht naar contact voor PGIMER Chandigarh en CMC Vellore: CMC Vellore heeft een eigen radiologie-site (cmcvelloreradiology.org/contact-us.php) maar ook die toont alleen telefoonnummers, geen e-mail. PGIMER: alleen het algemene instituutadres (pgimer@chd.nic.in). ETHealthworld opnieuw gecheckt: nog steeds geen gratis redactie-ingang gevonden. Alle drie blijven "on hold"
- [x] PGIMER Chandigarh gemaild (4 augustus 2026, op tip van Ed: bij geen departement-e-mail het algemene instituutadres proberen) — pgimer@chd.nic.in, verzonden via iCloud Mail, met verzoek om doorsturen naar Radiodiagnosis-afdeling, bevestigd in Verstuurd-map, (nog) geen bounce ontvangen, wacht op reactie
- [x] CMC Vellore Radiology — eerste poging info@cmcvelloreradiology.org (4 augustus 2026) **gebounced**: "550 No Such User Here" — dat adres bestaat niet. Ed vond zelf twee echte adressen op cmcvelloreradiology.org/interventional-radiology.php: **radio@cmcvellore.ac.in** (algemeen, Division of Clinical Radiology) en **interventionalradiology@cmcvellore.ac.in** (specifiek IR). Opnieuw gemaild naar radio@cmcvellore.ac.in (4 augustus 2026), verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — SNMI (Society of Nuclear Medicine, India) gemaild (snmindiasecretary@gmail.com) — 4 augustus 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe vondst — SIR (Society of Indian Radiographers) gemaild (info@radiographers.org) — 5 augustus 2026, verzonden via iCloud Mail, bevestigd in Verstuurd-map, wacht op reactie
- [x] Nieuwe zoektocht (5 augustus 2026) — gezocht naar aanvullende India-kanalen (teleradiologie-nieuwssites, startup-persplatforms, app-directories). IJRI (Indian Journal of Radiology and Imaging, IRIA's eigen wetenschappelijke tijdschrift) gevonden maar **niet gebruikt**: is een peer-reviewed vaktijdschrift voor artikel-inzendingen, geen persbericht-/app-tip-kanaal, en IRIA zelf is al gemaild (13 juli 2026). Entrackr/TechCircle (startup-nieuws) en IndianAIapps opnieuw bekeken, geen bruikbare gratis-en-passende ingang gevonden (IndianAIapps al eerder afgewezen wegens AI-focus). Geen nieuw geschikt kanaal deze ronde

---

## Kant-en-klare tekst — Golf 1 (IRIA, e-mail naar iria37@gmail.com)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear IRIA team,

My name is Ed Cafferata, founder of The IT Crowd. I've built Dicom Viewer, a
free native iOS app that lets patients and clinicians view DICOM medical
images (X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no account,
no cloud upload, no PACS connection required. Everything is processed
on-device.

Given the growing role of teleradiology and mobile access to imaging in India,
I thought this might be useful to share with your members, or as a resource
for patients who want to view scans they've been given on a CD or USB drive.

Not a paid promotion request — just thought it might be a genuinely useful
tool for the community you represent.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527
More info: https://cafferata.info

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

---

## Kant-en-klare tekst — IRIA-nieuwsbrief (e-mail naar irianewsletter@gmail.com, gemaild 23 juli 2026)

**Onderwerp:** Suggestion for the IRIA newsletter — free iOS DICOM viewer

```
Hi IRIA Newsletter team,

I'm Ed Cafferata, an independent iOS developer (previously reached out to
iria37@gmail.com). I built Dicom Viewer, a free native iOS app that lets
patients and clinicians view DICOM medical images (X-ray, CT, MRI,
ultrasound) directly on iPhone or iPad — no account, no cloud upload, no
PACS connection required. Everything is processed on-device.

I thought it might be a useful resource to mention in the newsletter for
members and residents, e.g. as a way to quickly review teaching cases or a
patient's own scans on the go.

Not a paid promotion request — just thought it might be genuinely useful for
the community IRIA represents.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527
More info: https://cafferata.info

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

---

## Kant-en-klare tekst — Golf 2 (YourStory, e-mail naar editorial@yourstory.com)

**Onderwerp:** Story Request Dicom Viewer – Healthcare/MedTech

```
Hi YourStory team,

Name: Ed Cafferata
Mobile: [Ed vult zelf in indien gewenst]
Email: edcafferata@icloud.com
Website: https://cafferata.info

I'd like to share Dicom Viewer, a free native iOS app for viewing DICOM
medical images (X-ray, CT, MRI, ultrasound) on iPhone and iPad. It's built
privacy-first: everything runs on-device, with no account, no cloud upload
and no PACS connection required. It serves two audiences — patients who want
to view scans from a hospital CD/USB, and clinicians, students and
veterinarians who get a cine player, Window/Level presets, a series
navigator and frame export.

Given India's radiologist shortage and the growing role of teleradiology, I
thought this might be a relevant story for your healthcare/medtech coverage.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Happy to answer any questions or send screenshots.

Best,
Ed Cafferata — The IT Crowd
```

---

## Kant-en-klare tekst — Golf 3b (MediaNama, e-mail naar releases@medianama.com)

**Onderwerp:** Company update: Dicom Viewer — privacy-first DICOM viewer for iPhone/iPad, now live in India

```
Hi MediaNama team,

I'm Ed Cafferata, founder of The IT Crowd. I wanted to share a company
update that might fit your coverage of India's digital ecosystem and data
policy: Dicom Viewer, a native iOS app for viewing DICOM medical images
(X-ray, CT, MRI, ultrasound), is now available on the India App Store.

The app is built privacy-first: every file is processed entirely on-device,
with no account, no cloud upload and no PACS connection — given India's
ongoing conversations around health data and digital privacy, I thought this
architectural choice might be relevant to your readers.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527
Site: https://cafferata.info

Happy to answer questions or provide more detail on how the on-device
processing works.

Best,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

---

## Kant-en-klare tekst — Golf 4 (developersIndia / r/developersIndia showcase-post)

**Titel:** Built a native iOS DICOM viewer with zero external dependencies —
custom binary parser in Swift

```
I built Dicom Viewer, a native iOS app (SwiftUI) for viewing DICOM medical
images — X-ray, CT, MRI, ultrasound — on iPhone and iPad. Wrote the DICOM
parser myself from scratch, no external dependencies.

It's privacy-first: everything runs on-device, no account, no cloud upload,
no PACS connection. Features: cine player for multi-frame studies,
Window/Level presets, an automatic series navigator, and frame export.
Open source under GPL-3.0.

Repo: https://github.com/EdCafferata/DICOM-player
App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Happy to talk through the DICOM parsing approach or answer anything about
building it — feedback welcome.
```

**Why:** Ed wilde, na de VS-promotiesessie (13 juli 2026), ook India oppakken —
groot potentieel publiek, weinig concurrentie van de bekende namen daar.
**How to apply:** volg de golf-volgorde, zelfde gedoseerde aanpak als NL —
niet alles tegelijk versturen. Check bij golf 3, 5 en 6 eerst de regels/het
prijsmodel voordat je iets verstuurt (les uit de VS-sessie: Product Hunt en
enkele subreddits bleken achteraf niet gratis of niet toegestaan).

## Kant-en-klare tekst — MSAI (e-mail naar vpi@msaindia.org)

**Onderwerp:** Free tool for medical students — Dicom Viewer, native iOS DICOM viewer

```
Hi MSAI team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app for viewing DICOM medical images (X-ray, CT, MRI, ultrasound)
directly on iPhone and iPad — no account, no cloud upload, no PACS connection
required. Everything is processed entirely on-device.

I thought it might be a useful resource for medical students exploring
radiology or reviewing teaching cases on the go — features include a cine
player for multi-frame studies, Window/Level presets, an automatic series
navigator and frame export.

Not a paid promotion request — just thought it might be genuinely useful for
the students MSAI represents.

App Store: apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Happy to answer any questions. Thanks for considering it!

Best,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — ISVIR (e-mail naar info.isvir@gmail.com)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear ISVIR team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians and patients view DICOM medical images
(X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no account, no
cloud upload, no PACS connection required. Everything is processed
on-device.

Given the growing role of mobile access to imaging, I thought this might be
useful to share with your members, or as a resource for patients who want to
view scans they've been given on a CD or USB drive.

Not a paid promotion request — just thought it might be a genuinely useful
tool for the community you represent.

App Store: apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Best regards,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — RadioGyan (e-mail naar admin@radiogyan.com)

**Onderwerp:** Suggestion for RadioGyan — free iOS DICOM viewer

```
Hi,

I'm Ed Cafferata, an independent iOS developer. I wanted to suggest a
resource for RadioGyan: Dicom Viewer, a free native iOS app that lets medical
students and residents view DICOM medical images (X-ray, CT, MRI, ultrasound)
directly on their iPhone or iPad — useful for quick review of teaching cases
on the go. Everything runs on-device, no account or cloud upload needed.

App Store: apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Thought this might be a useful addition for your residents and students.
Thanks for maintaining such a helpful resource!

Best,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — The Better India (klaar, nog niet verzonden — beeld verplicht)

**Onderwerp:** Positive story idea: privacy-first DICOM viewer built by an indie developer

```
Hi team,

I'm Ed Cafferata, an independent iOS developer based in the Netherlands. I
built Dicom Viewer, a free native app that lets anyone view DICOM medical
images (X-ray, CT, MRI, ultrasound) directly on their iPhone or iPad — no
account, no cloud upload, no PACS connection required. Everything is
processed entirely on-device.

The app is aimed at patients who are handed a CD or USB after a scan and have
no easy way to open it, as well as clinicians and students who need a quick
way to review studies on the go. It's also open source (GPL-3.0), built with
a DICOM parser written from scratch.

Given India's growing focus on accessible diagnostics and digital health, I
thought this might fit your healthtech coverage.

App Store: apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Happy to answer any questions or send more screenshots.

Best,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — ISRT (e-mail naar info@isrt.org.in)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear ISRT team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians and patients view DICOM medical images
(X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no account, no
cloud upload, no PACS connection required. Everything is processed
on-device.

Given the growing role of mobile access to imaging, I thought this might be
useful to share with your members, or as a resource for patients who want to
view scans they've been given on a CD or USB drive.

Not a paid promotion request — just thought it might be a genuinely useful
tool for the community you represent.

App Store: apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Best regards,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — AMPI (e-mail naar secretary@ampi.org.in)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear AMPI team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians, physicists and patients view DICOM medical
images (X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no account,
no cloud upload, no PACS connection required. Everything is processed
on-device.

Given AMPI's work at the intersection of physics, imaging technology and
medicine, I thought this might be a useful resource to share with your
members, or as a tool for reviewing teaching cases and QA reference images
on the go.

Not a paid promotion request — just thought it might be genuinely useful for
the community you represent.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

## Kant-en-klare tekst — AIIMS Radiodiagnosis (e-mail naar radiodiagnosis@aiims.edu, gemaild 26 juli 2026)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear AIIMS Radiodiagnosis team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians, residents and patients view DICOM medical
images (X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no account,
no cloud upload, no PACS connection required. Everything is processed
on-device.

Given the growing role of mobile access to imaging in teaching and patient
care, I thought this might be a useful resource to share with your residents
and students, e.g. as a quick way to review teaching cases or a patient's own
scans on the go.

Not a paid promotion request — just thought it might be a genuinely useful
free tool for the department.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527
More info: https://cafferata.info

Best regards,
Ed Cafferata — The IT Crowd
```

## Kant-en-klare tekst — SNMI (e-mail naar snmindiasecretary@gmail.com, gemaild 4 augustus 2026)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear SNMI team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians and patients view DICOM medical images
(X-ray, CT, MRI, ultrasound, nuclear medicine studies) directly on iPhone or
iPad — no account, no cloud upload, no PACS connection required. Everything
is processed on-device.

Given the growing role of mobile access to imaging, I thought this might be
useful to share with your members, or as a resource for patients who want to
view scans they've been given on a CD or USB drive.

Not a paid promotion request — just thought it might be a genuinely useful
tool for the community you represent.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527
More info: https://cafferata.info

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```

## Kant-en-klare tekst — SIR (e-mail naar info@radiographers.org, gemaild 5 augustus 2026)

**Onderwerp:** Dicom Viewer — free iOS app for viewing DICOM images

```
Dear SIR team,

I'm Ed Cafferata, an independent iOS developer. I built Dicom Viewer, a free
native app that lets clinicians, radiographers and patients view DICOM
medical images (X-ray, CT, MRI, ultrasound) directly on iPhone or iPad — no
account, no cloud upload, no PACS connection required. Everything is
processed on-device.

Given the growing role of mobile access to imaging, I thought this might be
useful to share with your members, or as a resource for patients who want to
view scans they've been given on a CD or USB drive.

Not a paid promotion request — just thought it might be a genuinely useful
tool for the community you represent.

App Store: https://apps.apple.com/in/app/dicom-viewer-by-the-it-crowd/id1483496527

Best regards,
Ed Cafferata — The IT Crowd
edcafferata@icloud.com
```
