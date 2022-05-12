DELTA=0.01;
$fn=100;

PEGH=15;
module peg_minus()
{
     cylinder(d=8-0.2,h=2*PEGH);
}
module peg()
{
     difference() {
          cylinder(d=8,h=PEGH);
          translate([0,0,-DELTA])cylinder(d=4,h=PEGH+2*DELTA);
     }
}

module pegs()
{
     translate([0,(65/2)*0.4,-PEGH/2]) peg();
     translate([0,-(65/2)*0.4,-PEGH/2]) peg();
}
module pegs_minus()
{
     translate([0,(65/2)*0.4,-PEGH]) peg_minus();
     translate([0,-(65/2)*0.4,-PEGH]) peg_minus();
}

module protect(){
difference() {
     scale([1,0.4,0.4])sphere(d=65);
     scale([1,0.4,0.4])sphere(d=58);
     rotate([0,90,0])translate([0,0,-50])cylinder(d=6,h=100);
     pegs_minus();
}
pegs();
}

difference() {
     protect();
     translate([-50,-50,-100])cube([100,100,100]);
}
