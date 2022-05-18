$fn=100;

DELTA=0.01;
RLEG=19/2;
THICK=5;
HHOLDER=58;

module down(x)
{
    translate([0,0,-x]) children();
}

module up(x)
{
    translate([0,0,x]) children();
}

module screw_hole(bar_width)
{
    SCREW=4.2;

    translate([bar_width/2,THICK+DELTA, 0]) rotate([90,0,0]) cylinder(r1=SCREW/2,r2=(SCREW+2)/2,h=THICK+DELTA*2);
    translate([bar_width/2,THICK+DELTA+3,0]) rotate([90,0,0]) cylinder(r=SCREW/2,h=THICK+3+DELTA*2);
}

module hinge()
{
    difference()
    {
        cube([14,THICK+3,HHOLDER]);
        MUL=4;
        up(1*HHOLDER/MUL) screw_hole(14);
        //up(2*HHOLDER/MUL) screw_hole(14);
        up(3*HHOLDER/MUL) screw_hole(14);
        //translate([14/2,THICK+DELTA,3/4*HHOLDER]) rotate([90,0,0]) cylinder(r1=4/2,r2=6/2,h=THICK+DELTA*2);
    }
}

module leg_holder()
{
    difference()
    {
        cylinder(r=RLEG+THICK,h=HHOLDER);
        down(DELTA) cylinder(r=RLEG,h=HHOLDER+DELTA*2);
        translate([-RLEG-THICK,-DELTA,-DELTA]) cube([2*(RLEG+THICK),1*(RLEG+THICK+DELTA), HHOLDER+DELTA*2]);
    }
    translate([-RLEG-THICK, 0,-DELTA]) difference()
    {
        cube([2*(RLEG+THICK),1*(RLEG)+3, HHOLDER]);
        translate([THICK,-DELTA,-DELTA]) cube([2*RLEG, RLEG+3+DELTA*2, HHOLDER+DELTA*2]);
    }
    //hinges
    translate([RLEG+THICK,RLEG-THICK,0]) hinge();
    translate([-RLEG-THICK-14,RLEG-THICK,0]) hinge();
}

leg_holder();
//hinge();
