$fn=100;

DELTA=0.01;

TUBE_DIAMETER = 19;

TUBE_LENGTH = 100;
TUBE_HEIGHT = 30;

TUBE_RADIUS = TUBE_DIAMETER / 2;

VERT_HOLE_X = TUBE_DIAMETER/10;
SMALL_HOLE_X = VERT_HOLE_X + TUBE_RADIUS + 58;
SMALL_HOLE_R = 3.5;
SMALL_HOLE_SCREW_R = 11/2;
SCREW_R=7 / 2;
DRIVER_R=11/2;

module base_shape()
{
    difference()
    {
        scale([0.94,TUBE_DIAMETER / TUBE_LENGTH,(TUBE_HEIGHT+15) / TUBE_LENGTH]) sphere(r=TUBE_LENGTH);
        translate([-TUBE_LENGTH,-TUBE_LENGTH/2,-TUBE_LENGTH/2]) cube([TUBE_LENGTH, TUBE_LENGTH, TUBE_LENGTH]);
        translate([-DELTA,-TUBE_LENGTH/2,1]) cube([TUBE_LENGTH, TUBE_LENGTH, TUBE_LENGTH]);
    }
}

module big_bar()
{
    difference()
    {
        rotate([0, 0, 6]) base_shape();
        rotate([0, 0, 6]) translate([-DELTA,0,0]) rotate([0,90,0]) cylinder(r=TUBE_RADIUS, h=TUBE_LENGTH);
        translate([VERT_HOLE_X+-DELTA,0,-TUBE_LENGTH/2]) cylinder(r=TUBE_RADIUS, h=TUBE_LENGTH);
        rotate([0,0,sin(6)*SMALL_HOLE_X]) {
            TRUNK_H = TUBE_LENGTH / 2;
            translate([SMALL_HOLE_X,0,-TRUNK_H/2]) cylinder(r=SMALL_HOLE_R, h = TRUNK_H);
            CAP_HEIGHT=TUBE_LENGTH/3;
            translate([SMALL_HOLE_X, 0, -CAP_HEIGHT-TUBE_DIAMETER/2-2]) cylinder(r=SMALL_HOLE_SCREW_R*3, h=CAP_HEIGHT);
        }
        bar();
        translate([0,0,-18]) scale([1,1.1,1.3]) rotate([0,90,0]) {
            cylinder(r=SCREW_R, h=20);
            translate([0,0,15]) cylinder(r=DRIVER_R, h=90);
        }
    }
}

module bar()
{
    BAR_W=20;
    BAR_THICK=4;

    a=acos(((BAR_W+1)/2)/((TUBE_DIAMETER+BAR_THICK)/2));

    BAR_L=10;

    translate([3,0,-TUBE_LENGTH/2]) difference() {
        cylinder(r = TUBE_RADIUS + BAR_THICK, h = TUBE_LENGTH);
        translate([0,0,-DELTA]) cylinder(r = TUBE_RADIUS + 1, h = TUBE_LENGTH+DELTA*2);

        translate([0,-BAR_W,-DELTA]) rotate([0,0,a]) cube([BAR_L,BAR_W,TUBE_LENGTH+DELTA*2]);
        translate([-BAR_L,0,-DELTA]) rotate([0,0,-a]) cube([BAR_L,BAR_W,TUBE_LENGTH+DELTA*2]);
        translate([-TUBE_DIAMETER-8, -TUBE_RADIUS-4, -DELTA]) cube([TUBE_DIAMETER+8, TUBE_DIAMETER+8, TUBE_LENGTH+DELTA*2]);
    }
    W = SMALL_HOLE_SCREW_R * 1.9;
    translate([TUBE_RADIUS+BAR_THICK,-W/2,5 - TUBE_LENGTH/3]) cube([SMALL_HOLE_SCREW_R*2.8, W,TUBE_LENGTH/2]);
}


module small_bar()
{
    scale([TUBE_HEIGHT / TUBE_LENGTH, TUBE_DIAMETER / TUBE_LENGTH, 1]) cylinder(r=TUBE_LENGTH, h=60);
}

//small_bar();
big_bar();
