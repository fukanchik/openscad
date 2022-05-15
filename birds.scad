$fn=50;
DELTA=0.01;

N=16;
LEN=220;
//LEN=55;
D=3.4;
NUM=round(LEN/40);
PAD=6;
PADX=3;
LINTERNAL=15-0.4;
THICK=3.4;

module teardrop(r,l)
{
     linear_extrude(height=l)
	  union()
     {
	  circle(r=r);
	  square([r,r]);
     }
}
module teardrop3(radius, length, angle) {
     rotate([0, angle, 0]) union() {
	  linear_extrude(height = length, center = true, convexity = radius, twist = 0)
	       circle(r = radius, $fn = 30);
	  linear_extrude(height = length, center = true, convexity = radius, twist = 0)
	       projection(cut = false) rotate([0, -angle, 0]) translate([0, 0, radius * sin(45) * 1.5]) cylinder(h = radius * sin(45), r1 = radius * sin(45), r2 = 0, center = true, $fn = 30);
     }
}

module teardrop2(r1 = 10, r2 = 5, h=5) {
     slope = -atan((r1 - r2) / h);
     union() {
	  rotate([0, 0, 45])
	       difference() {
               cube([r1, r1, h]);
               translate([r1 * sqrt(2), 0, 0])
		    rotate([0, 0, 45])
		    rotate([0, slope, 0])
		    translate([0, 0, -r1])
		    cube([r1 * 2, r1 * 2, h * r1]);
               translate([r1, r1, 0])
		    rotate([0, 0, 90])
		    rotate([0, slope, 0])
		    translate([0, 0, -r1])
		    cube([r1 * 2, r1 * 2, h * r1]);
               translate([r1, -r1, 0])
		    rotate([0, 0, 0])
		    rotate([0, slope, 0])
		    translate([0, 0, -r1])
		    cube([r1 * 2, r1 * 2, h * r1]);
	  }
	  cylinder(r1 = r1, r2 = r2, h = h, $fn = 32);
     }
}

module roundtop()
{
     intersection()
     {
	  difference()
	  {
	       scale([1,1,0.8])sphere(r=24);
	       translate([-25,-25,-50])cube([50,50,50]);
	       translate([0,0,-DELTA])cylinder(d1=12,d2=30,h=30);
	       for(i=[0:N])
	       {
		    rotate([0,0,i*360/N]) translate([8,0,2]) rotate([0,45,0])cylinder(d=3,h=15);
	       }
	  }
	  cylinder(d1=36,d2=46,h=30);
     }
}

module hole()
{
     cylinder(d=D,h=20);
     //cylinder(d1=4,d2=2,h=3);
}

module myholes()
{
     w=LINTERNAL+2*PADX;
     for(i=[0:NUM])
     {
	  translate([0,PAD+i*(LEN-PAD*2)/NUM,-DELTA]){
	       children();
	  }
     }
     translate([0,LEN+w/2, -DELTA])children();
}

module rail()
{
     difference()
     {
	  w=LINTERNAL+2*PADX;
	  union()
	  {
	       cube([LINTERNAL+2*PADX,LEN,15]);
	       translate([0,LEN,0]) {
		    translate([PADX,0,0])cube([LINTERNAL,w,THICK]);
	       }
	  }
	  translate([w/2,0,0])myholes() hole();
	  translate([PADX,-DELTA,THICK-DELTA])cube([LINTERNAL,LEN+2*DELTA,15+2*DELTA]);
	  translate([-DELTA,(LEN-110)/2,THICK]) cube([LINTERNAL+2*PADX+2*DELTA,110,20]);
     }
}

//rail();
module toprail(nop) {
     hpeg=10;
     wide=10;
     height=(2+D)*(nop==1?2:1);
     difference() {
	  union() {
	       cube([wide,LEN,height]);
	       translate([wide/2,0,height-DELTA])myholes() difference() {
		    cylinder(d1=2*D,d2=D+0.8,h=hpeg);
		    translate([0,0,-DELTA])cylinder(d=D+0.4,h=hpeg+2*DELTA);
	       }
	       translate([0,LEN,0]) {
		    w=wide+2*PADX;
		    translate([0,0,0])cube([wide,w,height]);
	       }
	  }
	  translate([-DELTA,0,0.6+D/2])myholes() rotate([90+45,0,0])rotate([0,90,0])teardrop(D/2,20);
	  translate([PAD,10-DELTA,0.6+D/2])rotate([0,-45,0])rotate([90,0,0])teardrop(D/2,10);
     }
}
//translate([PADX,0,THICK])
//toprail(0);
//#rotate([0,0,90])
toprail(1);

if(0) difference() {
     translate([-DELTA,-DELTA,-DELTA])cube([20,160,20]);
      }

module earphone()
{
     difference()
     {
	  cylinder(d=8,h=20);
	  cylinder(d=1,h=20);
	  translate([0,0,7])cylinder(d=6.5,h=8+DELTA);
	  translate([0,0,7+8])cylinder(d=4,h=5+DELTA);
	  translate([-10,0,0])cube([20,20,20+DELTA]);
     }
}

//earphone();
