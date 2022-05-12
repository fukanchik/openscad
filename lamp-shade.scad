$fn=60;
DELTA=0.01;

INNER_D=20.5;//base
OUTER_D=52.5;//base

D=125;

module shade0()
{
     H=114;
     difference() {
          scale([1,1,2]) difference() {
               sphere(d=D);
               scale([1,1.001,1]) sphere(d=D-2);
          }
          translate([0,0,H])cylinder(d=OUTER_D,h=D);
          if(0) {
               N=20;
               K=5;
               D=INNER_D/2;
               for(z=[0:K]) {
                    for(i=[0:N]) {
                         rotate([0,0,z*7])rotate([0,0,(360/N*i)])translate([0,0,(z+1)*D*2])scale([1,0.5,1])rotate([0,90,0])translate([0,0,0])cylinder(d=D,h=300);
                    }
               }
          }
          if(0) {
               N=10;
               for(i=[0:N]) {
                    rotate([15,0,360/N*i])translate([0,0,50])scale([1,0.5,4.5])rotate([0,90,0])translate([0,0,0])cylinder(d=INNER_D,h=300);
               }

               for(i=[0:N]) {
                    rotate([-15,0,360/N*(i+0.5)])translate([0,0,-60])scale([1,0.5,4.5])rotate([0,90,0])translate([0,0,0])cylinder(d=INNER_D,h=300);
               }
          }
     }
     TH=4;
     translate([0,0,H-TH]) difference()
     {
          cylinder(d=OUTER_D, h=TH);
          translate([0,0,-DELTA])cylinder(d=INNER_D, h=TH+2*DELTA);
     }

}

module shade()
{
     DR0=120;
     DR=4;
     translate([0,0,-40])difference() {
          cylinder(d=DR0,h=DR);
          translate([0,0,-DELTA])cylinder(d=DR0-2*DR,h=DR+2*DELTA);
     }
     difference() {
          translate([0,0,-80*0])shade0();
          translate([-150,-150,-340])cube([300,300,300]);
     }
          
}

rotate([0,180,0])shade();
