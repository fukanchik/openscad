$fn=60;

DELTA=0.01;

W=50;
H=40;
D=35;

PADX=7;

THICK=8.6;

module horn()
{
     intersection() {
     difference()
     {
	  cube([H,W,THICK]);
	  translate([D/2+PADX,W/2,-DELTA])cylinder(d=D,h=100);
	  translate([D/2+PADX,(W-D)/2,-DELTA])cube([100,D,100]);
     }
     translate([D/2+PADX-4,W/2,-DELTA]) union()
	  {
	       translate([0,-W/2,0])cube([W,W,100]);
	       cylinder(d=W,h=100);
	  }
     }
}

CT=3;
CW=3;
HL=12;

module handle()
{
     intersection() {
     horn();
     translate([0,25,THICK/2])rotate([0,90,0])cylinder(d=50,h=200);
     }
     translate([H-CT,W-2,0])cube([CT,CW+3,THICK]);
     translate([H-HL,W+CW-DELTA,0])intersection(){
	  cube([HL,CW,THICK]);
	  translate([9.8,1.6,4.5])scale([1,0.5,1])sphere(d=20);
     }
}

handle();

