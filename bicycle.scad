$fn=50;


RULD=30;
THICK=10;
RULANGLE=80;

TESTH=60;
HOLDERH=40;

module rul()
{
     cylinder(d=RULD,h=TESTH);
     translate([0,0,TESTH]) {
	  rotate([0,RULANGLE,0])cylinder(d=RULD,h=TESTH);
	  sphere(d=RULD);
     }
}

module holder()
{
     EARD=15;
     EART=5;
     cylinder(d=RULD+THICK,h=HOLDERH);
     difference() {
	  union() {
	       translate([(RULD+THICK)/2+EARD/2,0,HOLDERH/2-2]) {
		    translate([0,EART/2,0])rotate([90,0,0]) {
			 cylinder(d=EARD,h=EART);
		    }
	       }
	       translate([(RULD+THICK)/2-EARD/2,-EART/2,HOLDERH/2-EARD/2-2]) cube([EARD,EART,EARD]);
	       translate([(RULD+THICK)/2,-EART/2,HOLDERH/2-2]) cube([EARD,EART,EARD]);
	  }
	  translate([(RULD+THICK)/2+EARD/2,5,HOLDERH/2-2-5+EART])rotate([90,0,0])cylinder(d=8,h=20);
     }
     translate([0,0,HOLDERH]) {
	  rotate([0,RULANGLE,0]) {
	       cylinder(d=RULD+THICK,h=HOLDERH);
	       translate([-20,0,HOLDERH-22]) difference() {
		    p=2*(RULD+THICK);
		    union(){
		    scale([1,1.2,0.5])sphere(d=p);
		    translate([-2,0,p/2*0.5+EARD/2])rotate([90,0,0]) difference() {
			 union() {
			      translate([0,0,-EART])cylinder(d=EARD,h=2*EART);
			      translate([-EARD/2,-EARD,-EART])cube([EARD,EARD,2*EART]);
			 }
			 translate([0,0,-50]) cylinder(d=8,h=100);
		    }
		    }
		    translate([-110,-50,-80])cube([100,100,100]);
		    translate([0,-(RULD+THICK)+4,0])rotate([0,90,0]) {
			 cylinder(d=25,h=100);
			 translate([0,0,-50])cylinder(d=8,h=100);
		    }
		    translate([0,-1*(-(RULD+THICK)+4),0])rotate([0,90,0]) {
			 cylinder(d=25,h=100);
			 translate([0,0,-50])cylinder(d=8,h=100);
		    }
	       }
	  }
	  difference() {
	       rotate([0,80,0])scale([1.1,1,1.1]) {
		    sphere(d=RULD+2.2*THICK);
	       }
	       X=1;
	       translate([0,-EART,0])translate([-RULD/2-X,0,RULD/2+X])rotate([0,270+RULANGLE/2,0])rotate([90,0,0])cylinder(d=15,h=50);
	       translate([0,EART,0])translate([-RULD/2-X,0,RULD/2+X])rotate([0,270+RULANGLE/2,0])rotate([-90,0,0])cylinder(d=15,h=50);
	       translate([0,-EART*2,0])translate([-RULD/2-X,0,RULD/2+X])rotate([0,270+RULANGLE/2,0])rotate([-90,0,0])cylinder(d=8,h=50);
	  }
     }
}

difference() {
     translate([0,0,TESTH-HOLDERH])holder();
     rul();
     translate([-50,0,0])cube([100,100,100]);
}
