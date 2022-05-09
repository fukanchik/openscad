$fn=120;

DELTA=0.01;

module down(x)
{
     translate([0,0,-x])children();
}

module pedestal()
{
     R=125;
     PED_HEIGHT_HOLE=10;
     PED_THICK=40;
     PED_HEIGHT=40;
     PED_WIDTH = 2*R*0.7;
     difference() {
          translate([-PED_WIDTH/2,0,0])cube([PED_WIDTH,PED_HEIGHT,PED_THICK]);
          translate([0,R+PED_HEIGHT_HOLE,-DELTA]) cylinder(r=R,h=PED_THICK+2*DELTA);
     }
}

pedestal();
