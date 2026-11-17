# Meriva CampingBox

Zwei Schubladenboxen aus 10 mm Pappelsperrholz für den Kofferraum eines Opel Meriva A.
Box 1 nutzt die volle Tiefe, Box 2 ist kürzer, damit die Kühlbox dahinter an der Rücklehne Platz hat.
Beide Boxen sind 48 cm breit und lassen sich stapeln.

**→ [Zur Bauanleitung](anleitung/README.md)**

| | Box 1 | Box 2 |
|---|---|---|
| Außenmaß (T × B × H) | 750 × 480 × 300 mm | 420 × 480 × 300 mm |
| Vollauszug (45 kg, 12,7 mm, Selbsteinzug) | 700 mm | 350 mm |
| Schublade innen | 414 × 690 × 200 mm | 414 × 340 × 200 mm |

## Inhalt

| Pfad | Was |
|---|---|
| [`anleitung/README.md`](anleitung/README.md) | **Bauanleitung:** Einkaufsliste, Zuschnitt, Querschnitt, Schablonen, Bauschritte mit Zeichnungen, Einbau im Auto |
| [`anleitung/index.html`](anleitung/index.html) | Dieselbe Anleitung als Webseite (lokal im Browser öffnen) |
| [`zuschnitt.csv`](zuschnitt.csv) | Zuschnittliste aller Plattenteile (22 × Pappel 10 mm, 1 × Buche 18 mm) |
| [`schablonen/meriva_schablonen.scad`](schablonen/meriva_schablonen.scad) | OpenSCAD-Datei aller Montageschablonen, parametrisch |
| [`schablonen/stl/`](schablonen/stl) | Druckfertige STLs, ohne Stützmaterial druckbar |
| [`schablonen/anwendung.scad`](schablonen/anwendung.scad) | Szenen für die Bilder „Schablone im Einsatz“ in der Anleitung |

## Schablonen

| Nr. | Datei | Wofür | Schritt |
|---|---|---|---|
| 1 | `eck_seite` | Leisten L1/L2 an den hinteren Ecken der Seitenteile (10/10 mm) | 1 |
| 2 | `kante_10` | Vorderes Ende von L1 (10 mm) | 1 |
| 3 | `bohrlehre` | Vorbohren mit 2 mm: Reihen 17 / 7 / 5 mm | 1, 3–6 |
| 4 | `schiene_korpus` | Korpusschiene, Mitte 155 mm, greift über L1 (2 Stück) | 2 |
| 5 | `eck_boden` | Leiste L3 an Boden und Deckel (10/14 mm) | 3 |
| 6 | `schiene_schublade` | Anreißlehre für die Mittellinie der Innenschiene, 110 mm (2 Stück) | 7 |
| 7 | `griff` | Griffausschnitt 120 × 25 mm mit Ankörnpunkten für den 25-mm-Forstner | 9 |
| 8 | `blende_links`, `blende_rechts` | Fugen der Blende: 2 mm seitlich, 4 mm unten | 9 |
| 9 | `kante_11` | Führungsleisten L5 unter dem Brett (11 mm) | 10 |

Einzelnes Teil exportieren:

```sh
openscad -o eck_seite.stl -D 'teil="eck_seite"' schablonen/meriva_schablonen.scad
```

Hast du die Höhe der Innenschiene deiner Auszüge gemessen, trag sie als `schiene_innen_h` ein.
Dann wird `schiene_schublade` von einer Anreißlehre zu einer Anlegelehre wie `schiene_korpus`.

Druck: PETG oder PLA, 3 Wände, 20 % Infill. Die Bohrlehre besser in PETG.
