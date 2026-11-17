// =====================================================================
//  Meriva Küchenboxen – Montageschablonen
//  Platten 10 mm Pappel · Leisten 14 × 14 · Vollauszüge 12,7 × 45,5
//
//  Teil auswählen (Customizer oder unten "teil" ändern), F6, als STL
//  exportieren. Jedes Teil liegt schon druckfertig ohne Stützmaterial.
//  Material: PETG oder PLA, 3 Wände, 20 % Infill.
// =====================================================================

/* [Auswahl] */
teil = "alle"; // [alle, eck_seite, eck_boden, kante_10, kante_11, schiene_korpus, schiene_schublade, blende_links, blende_rechts, griff, bohrlehre]

/* [Holz und Beschläge] */
platte        = 10;     // Plattenstärke
leiste        = 14;     // Leistenquerschnitt
schiene_h     = 45.5;   // Höhe Auszug laut Datenblatt
mitte_korpus  = 155;    // Schienenmitte über Unterkante Seitenteil
mitte_schubl  = 110;    // Schienenmitte über Unterkante Schubladenseite
// Höhe der INNENSCHIENE (Schubladenteil) nachmessen und hier eintragen.
// 0 = Anreißlehre: das Ende der Lehre liegt genau auf der Schienenmitte.
schiene_innen_h = 0;

/* [Schablonen] */
steg_h  = 8;    // Höhe der Anschlagstege auf der Platte
lippe   = 3;    // Stärke der Lippe, die über die Plattenkante greift
lippe_t = 8;    // wie weit die Lippe an der Kante nach unten greift (< platte)
arm     = 70;   // Armlänge der Eck- und Kantenschablonen
spiel   = 0.2;  // Druckspiel

$fn = 48;

// ---------------------------------------------------------------------
//  Hilfen
// ---------------------------------------------------------------------
// dreht ein Teil, dessen Oberseite bei z = top liegt, mit dieser Seite aufs Druckbett
module aufs_bett(top) { translate([0,0,top]) rotate([180,0,0]) children(); }

module gravur(txt, size=4.5, depth=1.0, top) {
    translate([0,0,top-depth]) linear_extrude(depth+0.01)
        text(txt, size=size, font="Liberation Sans:style=Bold", halign="center", valign="center");
}

// ---------------------------------------------------------------------
//  1) Eck- und Kantenschablone für Leisten
//  Platte liegt mit der Innenseite nach oben, Ecke im Ursprung,
//  Platte bei x ≥ 0, y ≥ 0. Kante A = Kante entlang x (y = 0),
//  Kante B = Kante entlang y (x = 0). Die Stege sind genau so breit wie
//  der Abstand der Leiste von der Kante – Leiste einfach dagegenlegen.
//  oB = 0 → gerade Kantenschablone ohne zweiten Arm.
// ---------------------------------------------------------------------
module eck(oA, oB, label) {
    difference() {
        union() {
            // Steg an Kante A
            cube([arm, oA, steg_h]);
            translate([0,-lippe,-lippe_t]) cube([arm, lippe, steg_h+lippe_t]);
            if (oB > 0) {
                // Steg an Kante B
                cube([oB, arm, steg_h]);
                translate([-lippe,-lippe,-lippe_t]) cube([lippe, arm+lippe, steg_h+lippe_t]);
            }
        }
        // Beschriftung auf dem breiteren Steg
        translate([arm*0.6, oA/2, 0]) gravur(label, size=min(oA*0.55,5), top=steg_h);
    }
}

// ---------------------------------------------------------------------
//  2) Schienenlehre: hakt an einer Kante ein, die Schiene liegt mit ihrer
//  Unterkante am Ende der Lehre an. Zwei Stück pro Schiene (vorn, hinten).
//   kante_offset: wie weit die Kante, an der die Lippe einhakt, unterhalb
//                 der Bezugskante liegt (Schublade: Boden 10 mm darunter)
//   bruecke:      Kanal unter der Lehre, damit sie über Leiste L1 greift
// ---------------------------------------------------------------------
module schienenlehre(mitte, kante_offset=0, bruecke=false, label="", sh=schiene_h) {
    d = mitte + kante_offset - sh/2;   // Lippenkante → Unterkante Schiene (sh = 0: → Mittellinie)
    b = 24;
    h = bruecke ? leiste + 6 : 6;
    difference() {
        union() {
            cube([b, d, h]);
            translate([0,-lippe,-lippe_t]) cube([b, lippe, h+lippe_t]);
        }
        if (bruecke)   // Kanal für L1 (10 mm von der Kante, 14 × 14) mit 0,5 mm Luft
            translate([-1, platte-0.5, -1]) cube([b+2, leiste+1, leiste+1.5]);
        translate([b/2, (d+ (bruecke ? platte+leiste : 0))/2 + 6, 0]) rotate([0,0,90])
            gravur(label, size=6, top=h);
    }
}

// ---------------------------------------------------------------------
//  3) Blendenlehre: Box steht auf dem Tisch. Die Lehre liegt außen am
//  Seitenteil an; die Blende steht auf dem Fuß (4 mm Fuge unten) und
//  stößt seitlich an die 2-mm-Stufe (2 mm Fuge seitlich).
//  Koordinaten: Seitenteil außen bei x = 0, Korpus-Vorderkante bei y = 0,
//  Blende davor (y < 0), Tisch bei z = 0.
// ---------------------------------------------------------------------
module blendenlehre() {
    H = 40; fuge_s = 2; fuge_u = 4; w = 6;
    union() {
        translate([-w, 0, 0])         cube([w, 30, H]);               // am Seitenteil
        translate([-w, -platte-4, 0]) cube([w+fuge_s, platte+4, H]);  // Stufe neben der Blende
        translate([fuge_s, -platte-4, 0]) cube([35, platte+4, fuge_u]); // Fuß unter der Blende
    }
}

// ---------------------------------------------------------------------
//  4) Griffschablone: liegt vorn auf der Blende, Lippe hakt über die
//  Oberkante. Mitte der Blende anzeichnen (238 mm), Kerbe darauf
//  ausrichten, Ausschnitt mit Bleistift umfahren.
//  Ausschnitt 120 × 25 mm, untere Ecken R 12,5 (Forstner 25 mm).
// ---------------------------------------------------------------------
gb = 120; gt = 25; gr = gt/2;
module griff_kontur() {
    translate([-gb/2, -gr]) square([gb, gr + 20]);
    hull() { for (s=[-1,1]) translate([s*(gb/2-gr), -gr]) circle(r=gr); }
}
module griffschablone() {
    W = 180; Hh = 55; t = 3;
    difference() {
        union() {
            difference() {
                union() {
                    translate([-W/2, -Hh, 0]) cube([W, Hh, t]);                   // Platte auf der Blende
                    translate([-W/2, 0, -platte+2]) cube([W, lippe, platte-2+t]);   // Lippe über die Oberkante
                }
                translate([0,0,-20]) linear_extrude(40) griff_kontur();
            }
            // Naben für die Forstner-Mittelpunkte, mit Steg zur Unterkante des Ausschnitts
            for (s=[-1,1]) translate([s*(gb/2-gr), -gr, 0]) {
                cylinder(d=7, h=t);
                translate([-1.5, -gr-2, 0]) cube([3, gr+2, t]);
            }
        }
        translate([0, -Hh, -1]) linear_extrude(t+2) polygon([[-4,-0.01],[4,-0.01],[0,6]]);   // Mittelkerbe
        for (s=[-1,1]) translate([s*(gb/2-gr), -gr, -1]) cylinder(d=2.4, h=t+2);           // Ankörnpunkte
    }
}

// ---------------------------------------------------------------------
//  5) Bohrlehre für die Schraubenlinien
//  Lippe an die Plattenkante, dann durch die Löcher mit 2 mm vorbohren.
//   17 mm: Seitenteil → Leiste L1/L2, Schubladenseite → L4
//    7 mm: Boden/Deckel → L1, Rückwand → L2/L3, Stirnteil → L4
//    5 mm: Schubladenboden → Kanten von Seiten und Stirnteilen
// ---------------------------------------------------------------------
module bohrlehre() {
    L = 180; B = 26; h = 6; dl = 2 + 2*spiel + 0.2;
    reihen = [[17, [30, 150]], [7, [30, 150]], [5, [90]]];
    difference() {
        union() {
            cube([L, B, h]);
            translate([0,-lippe,-lippe_t]) cube([L, lippe, h+lippe_t]);
        }
        for (r = reihen) for (x = r[1]) translate([x, r[0], -lippe_t-1]) cylinder(d=dl, h=h+lippe_t+2);
        translate([60, 17, 0]) gravur("17", size=4, top=h);
        translate([60, 7.5, 0]) gravur("7", size=4, top=h);
        translate([110, 5, 0]) gravur("5", size=3.5, top=h);
        translate([120, 21.5, 0]) gravur("Kante", size=3.5, top=h);
    }
}

// ---------------------------------------------------------------------
//  Druckfertige Teile
// ---------------------------------------------------------------------
module p_eck_seite()   aufs_bett(steg_h) eck(platte, platte, "10/10");          // Seitenteile hinten: L1 + L2
module p_eck_boden()   aufs_bett(steg_h) eck(platte, leiste, "10/14");          // Boden/Deckel hinten: L3
module p_kante_10()    aufs_bett(steg_h) eck(platte, 0, "10");                  // Seitenteile vorn: L1
module p_kante_11()    aufs_bett(steg_h) eck(platte+1, 0, "11");                // Brett: L5
module p_schiene_k()   aufs_bett(leiste+6) schienenlehre(mitte_korpus, 0, true, "155");
module p_schiene_s()   aufs_bett(6) schienenlehre(mitte_schubl, platte, false,
                           schiene_innen_h > 0 ? "110+10" : "Mitte", schiene_innen_h);
module p_blende_l()    blendenlehre();
module p_blende_r()    mirror([1,0,0]) blendenlehre();
module p_griff()       aufs_bett(3) griffschablone();
module p_bohr()        aufs_bett(6) bohrlehre();

if      (teil == "eck_seite")         p_eck_seite();
else if (teil == "eck_boden")         p_eck_boden();
else if (teil == "kante_10")          p_kante_10();
else if (teil == "kante_11")          p_kante_11();
else if (teil == "schiene_korpus")    p_schiene_k();
else if (teil == "schiene_schublade") p_schiene_s();
else if (teil == "blende_links")      p_blende_l();
else if (teil == "blende_rechts")     p_blende_r();
else if (teil == "griff")             p_griff();
else if (teil == "bohrlehre")         p_bohr();
else if (teil == "keins")             { }
else {
    // Übersicht aller Teile
    translate([0,   0,  0]) p_eck_seite();
    translate([90,  0,  0]) p_eck_boden();
    translate([180, 0,  0]) p_kante_10();
    translate([180, 30, 0]) p_kante_11();
    translate([0,  -40, 0]) p_schiene_k();
    translate([35, -40, 0]) p_schiene_s();
    translate([90, -60, 0]) p_blende_l();
    translate([150,-60, 0]) p_blende_r();
    translate([90, -100,0]) p_griff();
    translate([0,  -260,0]) p_bohr();
}
