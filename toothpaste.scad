$fn=60;
THICK=1;
DELTA=0.01;

module wall()
{
     cube([30+8+8,1,23]);
}

module bottom()
{
     cube([30+8+8,11,1]);
}

module back()
{
     cube([30+8+8,1,10]);
}
module hook()
{
     translate([0,-6.5,0])rotate([0,90,0])difference() {
	  cylinder(r=6.5,h=8+30+8);
	  translate([0,0,-DELTA])cylinder(r=6.5-1,h=30+8+8+2*DELTA);
	  translate([0,-10,-DELTA])cube([20,20,30+8+8+DELTA*2]);
	  translate([-20,-9,(8+8+30)/2])rotate([0,90,0])cylinder(d=30,h=100);
     }
}

wall();
translate([0,1,0])bottom();
translate([0,10+2-0.4,0])rotate([2,0,0])back();
translate([0,1,23])hook();
