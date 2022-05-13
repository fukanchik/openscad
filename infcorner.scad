DELTA=0.01;

WIDTH = 15;
LED=12;
GLASS_THICK=4.5;
ACRYLIC_THICK=2.6;

BOTTOM = 1.2;
TOP = 1.2;
WALL = 1.2;

HEIGHT = BOTTOM + GLASS_THICK + LED + ACRYLIC_THICK + TOP;

module mirror()
{
    cube([304,304,GLASS_THICK]);
}

module acrylic()
{
    cube([304,304,ACRYLIC_THICK]);
}

module corner()
{
    difference()
    {
        cube([WIDTH, WIDTH, HEIGHT]);
        translate([WIDTH, 0, -DELTA]) rotate([0,0,45]) cube([WIDTH*sqrt(2), WIDTH*sqrt(2), HEIGHT + DELTA*2]);
    }
}

difference()
{
    corner();
    translate([WALL, WALL, BOTTOM]) mirror();
    translate([WALL, WALL, BOTTOM + GLASS_THICK + LED]) scale([1,1,2]) acrylic();
}

