# Aanpassingstemplate — DICOM Player

Vul dit bestand in voordat je begint met aanpassen. Alle antwoorden worden gebruikt
in de stappen beschreven in `BOUW_HANDLEIDING.md`. Bewaar dit bestand in je eigen repository.

---

## 1. Organisatie / Zorginstelling

```
Naam organisatie      : [bijv. Academisch Medisch Centrum]
Afkorting             : [bijv. AMC]
Website               : [bijv. https://www.amc.nl]
Contactpersoon        : [naam van de bouwaanvrager]
E-mail contactpersoon : [e-mailadres]
```

---

## 2. App naam en identiteit

```
App naam (thuisscherm)  : [max. ~12 tekens, bijv. DICOM Viewer]
App naam (in titelbalk) : [bijv. DICOM Player]
Versienummer            : [bijv. 1.0.0]
```

---

## 3. Bundle identifier

```
Bundle ID hoofdapp      : [bijv. com.mijninstelling.DICOMPlayer]
Apple Developer Team ID : [te vinden in developer.apple.com → Account, bijv. AB12CD34EF]
```

> Het bundle ID is de unieke naam van jouw app in het Apple ecosysteem.
> Gebruik de omgekeerde domeinnaam van je organisatie als je die hebt.

---

## 4. GitHub repository

```
GitHub gebruikersnaam : [bijv. EdCafferata]
Repository naam       : [bijv. DICOM-player]
Volledige URL         : [bijv. https://github.com/EdCafferata/DICOM-player]
Branch                : [standaard: master-branch]
```

---

## 5. App-icoon

```
Logo bestandsnaam     : [bijv. dicom_icon.png]
Logo locatie          : [pad op je computer, bijv. ~/Downloads/logo.png]
Logo resolutie        : [bijv. 1024x1024 px — minimaal 512x512 aanbevolen]
Achtergrondkleur      : [kleur achter het logo, bijv. donker navy #080E1A of zwart]
```

> Het script in BOUW_HANDLEIDING.md stap 7 genereert alle iOS-maten automatisch.

---

## 6. Kleurenschema (medische UI)

```
Achtergrond (bg)        : [standaard: #080E1A — donker navy]
Surface                 : [standaard: #0F1A2E]
Kaartachtergrond (card) : [standaard: #162035]
Accent kleur (teal)     : [standaard: #00C2CB]
Actie blauw             : [standaard: #2F80ED]
Tekst primair           : [standaard: #E8EEF7]
Tekst secundair         : [standaard: #5A7099]
```

> Laat velden leeg om de standaardkleuren te gebruiken.
> Pas `Models/MedTheme.swift` aan om de kleuren te wijzigen.

---

## 7. Demo DICOM bestanden

```
Demo bestand 1    : [bestandsnaam.dcm — beschrijving, bijv. cag_voor_ingreep.dcm]
Demo bestand 2    : [bestandsnaam.dcm — beschrijving]
Demo bestand 3    : [bestandsnaam.dcm — beschrijving]
Bron bestanden    : [waar vandaan, bijv. DICOM Library https://www.dicomlibrary.com]
```

> Anonimiseer patiëntgegevens (tag 0010,0010 etc.) vóór bundelen in de app.
> Zie BOUW_HANDLEIDING.md stap 4 voor instructies.

---

## 8. DICOM viewer instellingen

```
Standaard window preset : [standaard: autoWindow (min/max scan)]
Max zoom               : [standaard: 8× — range 0.5×–8×]
Min zoom               : [standaard: 0.5×]
Standaard FPS cine     : [standaard: 10 fps — keuze: 5/10/15/24/30]
```

---

## 9. Tip Jar / IAP

```
Tip Jar aanwezig?       : [Ja / Nee]

Indien Ja:
  Product ID klein      : [bijv. com.mijninstelling.dicomplayer.tip.small]
  Naam klein            : [bijv. Koffie]
  Prijs klein           : [bijv. €0,99]

  Product ID middel     : [bijv. com.mijninstelling.dicomplayer.tip.medium]
  Naam middel           : [bijv. Lunch]
  Prijs middel          : [bijv. €2,99]

  Product ID groot      : [bijv. com.mijninstelling.dicomplayer.tip.large]
  Naam groot            : [bijv. Diner]
  Prijs groot           : [bijv. €9,99]
```

> Alle producten zijn Non-Consumable.
> IAP producten moeten aangemaakt worden in App Store Connect vóór indienen.
> Zie BOUW_HANDLEIDING.md stap 6 voor instructies.

---

## 10. Simulator voor testen

```
Simulator naam  : [bijv. iPhone 16]
iOS versie      : [bijv. 18.2]
Simulator UDID  : [bijv. F2532603-D618-4C2D-A0A6-4E6F9A8161F6]
```

> Zoek UDID via: `xcrun simctl list devices | grep "iPhone"`

---

## 11. App Store beschrijving

```
Korte beschrijving (30 tekens)  : [bijv. Bekijk medische DICOM-bestanden]
Lange beschrijving (4000 tekens): [volledige beschrijving voor App Store pagina]

Sleutelwoorden (100 tekens max) : [bijv. DICOM, CT scan, medisch, viewer, radiologie]

Wat is er nieuw (versienotes)   : [beschrijving van de wijzigingen in deze versie]
```

---

## 12. App Store screenshots

```
Taal screenshots        : [bijv. Nederlands]
Achtergrondkleur iPhone : [standaard: #080E1A (donker navy)]

Schermen om te tonen:
  Screenshot 1          : [bijv. bestandslijst met demo CAG bestanden]
  Screenshot 2          : [bijv. CT scan fullscreen viewer, overlay zichtbaar]
  Screenshot 3          : [bijv. cine player met speelbalk actief]
```

> Zie BOUW_HANDLEIDING.md stap 10 voor het Python-script.
> Vereiste formaten: iPhone 6.9" (1320×2868) — minimaal vereist door Apple.

---

## 13. Privacy & medische data

```
Patiëntdata in de app?    : [Ja — wordt lokaal opgeslagen / Nee — alleen demo data]
iCloud backup uitzetten?  : [Ja / Nee — standaard Nee]
Analytics trackers?       : [Nee — standaard geen trackers]
```

> De app slaat alle DICOM-bestanden lokaal op in de app's Documents-map.
> Niets wordt gedeeld met derden.
> Voeg indien nodig een Privacy Policy URL toe in App Store Connect.

---

## Checklist na invullen

Ga door naar `BOUW_HANDLEIDING.md` en verwerk bovenstaande antwoorden stap voor stap:

- [ ] Stap 1 — Repository gekloned
- [ ] Stap 2 — Bundle identifier ingesteld (sectie 3 van dit template)
- [ ] Stap 3 — App naam ingesteld (sectie 2)
- [ ] Stap 4 — Demo DICOM bestanden toegevoegd (sectie 7)
- [ ] Stap 5 — Kleurenschema aangepast indien gewenst (sectie 6)
- [ ] Stap 6 — Tip Jar IAP ingesteld in App Store Connect + code (sectie 9)
- [ ] Stap 7 — App-icoon gegenereerd (sectie 5)
- [ ] Stap 8 — Gebouwd en getest op simulator (sectie 10)
- [ ] Stap 9 — IAP getest met StoreKit configuratiebestand
- [ ] Stap 10 — App Store screenshots gemaakt (sectie 12)
- [ ] Stap 11 — App Store beschrijving ingevuld in App Store Connect (sectie 11)
- [ ] Commit & push naar eigen repository
- [ ] Archive gebouwd en geüpload via Xcode Organizer
- [ ] Versie ingediend bij Apple Review
