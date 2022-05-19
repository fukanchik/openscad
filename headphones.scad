$fn=20;
DELTA=0.01;

PHONE_HOLE_WIDTH = 35;
PHONE_HOLE_THICK = 12;

CORD_HOLE_WIDTH = 23;
CORD_HOLE_THICK = 5;

R_SCREW_BOX = 2.5;
W_SCREW_BOX = 22.8;
SCREW_HOLE_DIST = 20;

module rounded_block(length, thick, height)
{
    hull()
    {
        cylinder(r=thick / 2, h = height);
        translate([length - thick, 0, 0])
        {
            cylinder(r=thick / 2, h = height);
        }
    }
}

module arc_wrap(P)
{
    W = CORD_HOLE_WIDTH;
    THICK = CORD_HOLE_THICK;
    HEIGHT = 23;

    translate([(PHONE_HOLE_WIDTH-CORD_HOLE_WIDTH)/4,0,11]) rounded_block(W+P, THICK+P, HEIGHT);
}

module earphone_wrap(P)
{
    W = PHONE_HOLE_WIDTH;
    THICK = PHONE_HOLE_THICK;
    HEIGHT = 11;

    rounded_block(W+P, THICK+P, HEIGHT+P);
}

module holder()
{
    difference()
    {
        union()
        {
            earphone_wrap(3);
            arc_wrap(3);
        }
        union()
        {
            earphone_wrap(DELTA);
            arc_wrap(DELTA);
        }
    }
}
holder();
if(false)
difference()
//union()
{
    union()
    {
        if(true)difference()
        {
            holder();
            translate([21.9,-15/2,11+3]) cube([20,15,40]);
            translate([28,-15/2,0]) cube([20,15,40]);
            translate([21.9,-4,0]) cube([10,8,11+3]);
        }

        translate([0,4,0])
        difference()
        {
            difference()
            {
                union()
                {
                    hull()
                    {
                        cylinder(r=R_SCREW_BOX, h=12);
                        translate([W_SCREW_BOX,0,0])
                        {
                            cylinder(r=R_SCREW_BOX, h=12);
                        }


                    }
                    translate([-R_SCREW_BOX,0,0]) cube([W_SCREW_BOX+R_SCREW_BOX*2, 2, 12]);
                }
                translate([-R_SCREW_BOX,2,0])
                {
                    cube([W_SCREW_BOX+R_SCREW_BOX*2, R_SCREW_BOX * 2,12]);
                }
            }

            translate([1.8,-6+R_SCREW_BOX*2+0.01,12-5]) rotate([90+30,0,0])
            {
                cylinder(r=1.5,h=R_SCREW_BOX*4, center=true);
                translate([0,0,2.1]) cylinder(r=2.5,h=3, center=true);
            }
            translate([1.8+SCREW_HOLE_DIST,-6+R_SCREW_BOX*2+0.01,12-5]) rotate([90+30,0,0])
            {
                cylinder(r=1.5,h=1+R_SCREW_BOX*4, center=true);
                translate([0,0,2.1]) cylinder(r=2.5,h=3, center=true);
            }
        }
    }
    translate([0,4,0])
    {
        translate([1.8,                -6+R_SCREW_BOX*2+0.01,12-5]) rotate([90+30,0,0])
        {
            cylinder(r=1.5,h=R_SCREW_BOX*4, center=true);
            translate([0,0, -4]) cylinder(r=2.5,h=6, center=true);
        }
        translate([1.8+SCREW_HOLE_DIST,-6+R_SCREW_BOX*2+0.01,12-5]) rotate([90+30,0,0])
        {
            cylinder(r=1.5,h=1+R_SCREW_BOX*4, center=true);
            translate([0, 0, -4]) cylinder(r=2.5,h=6, center=true);
        }
    }
}
