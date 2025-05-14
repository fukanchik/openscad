$fn=60;
DELTA=0.01;
H=4;

DIN=17.4;
INNER=11.8;
D=DIN+2;

if(1)difference()
{
	cylinder(d=D,h=H+1);
	translate([0,0,1-DELTA]) cylinder(d=INNER,h=H+1+2*DELTA,$fn=6);
}

translate([0,0,2]) difference()
{
	cylinder(d=DIN+2,h=H);
	translate([0,0,-DELTA])cylinder(d=DIN,h=H+2*DELTA);
}
