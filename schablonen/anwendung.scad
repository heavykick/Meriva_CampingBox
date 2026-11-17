teil = "keins";
include <meriva_schablonen.scad>
szene = "eck_seite";
HOLZ=[0.93,0.84,0.66]; LEISTE=[0.90,0.62,0.36]; SCHAB=[0.20,0.45,0.80]; SCHIENE=[0.65,0.68,0.72]; BRETT=[0.78,0.55,0.35];
module platte_xy(x,y) color(HOLZ) translate([0,0,-platte]) cube([x,y,platte]);

if (szene=="eck_seite") {
  platte_xy(200,170);
  color(LEISTE) { translate([10,10,0]) cube([190,14,14]); translate([10,24,0]) cube([14,146,14]); }
  color(SCHAB) eck(10,10,"10/10");
}
if (szene=="eck_boden") {
  platte_xy(200,170);
  color(LEISTE) translate([14,10,0]) cube([186,14,14]);
  color(SCHAB) eck(10,14,"10/14");
}
if (szene=="kante_10") {
  platte_xy(200,90);
  color(LEISTE) translate([0,10,0]) cube([200,14,14]);
  color(SCHAB) translate([40,0,0]) eck(10,0,"10");
}
if (szene=="kante_11") {
  color(BRETT) translate([0,0,-18]) cube([200,120,18]);
  color(LEISTE) translate([0,11,0]) cube([200,14,14]);
  color(SCHAB) translate([40,0,0]) eck(11,0,"11");
}
if (szene=="schiene_korpus") {
  d = mitte_korpus - schiene_h/2;
  platte_xy(420, mitte_korpus+60);
  color(LEISTE) translate([0,platte,0]) cube([420,leiste,leiste]);
  color(SCHIENE) translate([0,d,0]) cube([420,schiene_h,12.7]);
  color(SCHAB) { translate([30,0,0]) schienenlehre(mitte_korpus,0,true,"155"); translate([330,0,0]) schienenlehre(mitte_korpus,0,true,"155"); }
}
if (szene=="schiene_schublade") {
  d = mitte_schubl - schiene_h/2;
  platte_xy(420, 220);                                         // Schubladenseite, außen oben
  color(HOLZ) translate([0,-platte,-70]) cube([420,platte,70]); // Schubladenboden, bündig darunter
  color(SCHIENE) translate([0,mitte_schubl-15,0]) cube([420,30,12.7]);        // Innenschiene, Mitte auf der Linie
  color([0.2,0.2,0.2]) translate([0,mitte_schubl-0.4,0]) cube([420,0.8,0.3]);   // Bleistiftlinie
  color(SCHAB) { translate([30,-platte,0]) schienenlehre(mitte_schubl,platte,false,"Mitte",0); translate([330,-platte,0]) schienenlehre(mitte_schubl,platte,false,"Mitte",0); }
}
if (szene=="blende") {
  // Korpus-Ecke (Seitenteil + Boden), Blende davor, Lehre
  color(HOLZ) { translate([0,0,0]) cube([10,160,140]); translate([10,0,0]) cube([150,160,10]); }
  color([1,0.86,0.62]) translate([2,-10,4]) cube([158,10,136]);
  color(SCHAB) blendenlehre();
}
if (szene=="griff") {
  color(HOLZ) difference(){ translate([-130,-120,-10]) cube([260,120,10]); }
  color(SCHAB) griffschablone();
}
if (szene=="bohrlehre") {
  platte_xy(240,80);
  color(LEISTE) translate([0,10,-24]) cube([240,14,14]);
  color(SCHAB) translate([30,0,0]) bohrlehre();
}
