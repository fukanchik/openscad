/**
 * Universal Mounting Hub - 5mm Printable
 * 
 * Original aluminum is here: https://www.sparkfun.com/products/10006
 * GPL v3 or later
 */
$fn=50;

function inch(i) = i * 25.4;
function mm(m) = m;

DELTA = 0.01;

HUB_DIAMETER   = inch(0.75);
HUB_HEIGHT     = inch(0.20);
SHAFT_DIAMETER = mm(5);
SCREW_DIAMETER = mm(3);
SCREW_OFFSET   = inch(0.25);
NUT_WIDTH      = mm(5.6);
NUT_WIDTH2     = mm(2.3);

module hub_body()
{
    cylinder(
	r = HUB_DIAMETER / 2,
	h = HUB_HEIGHT
    );
}

module hub_shaft()
{
    cylinder(
	r = SHAFT_DIAMETER / 2,
	h = HUB_HEIGHT + DELTA * 2
    );
}

module hub_peg()
{
    cylinder(
	r = SCREW_DIAMETER / 2,
	h = HUB_HEIGHT + DELTA * 2
    );
}

module nut_block()
{
    translate([-NUT_WIDTH/2, - NUT_WIDTH2/2,0]) cube([
	    NUT_WIDTH,
	    NUT_WIDTH2,
	    HUB_HEIGHT+DELTA*2
	]);
}

module fixing_screw()
{
    cylinder(
	r = SCREW_DIAMETER / 2,
	h = HUB_DIAMETER / 2
    );
}

module four()
{
    for(c = [[-1,0],[1,0],[0,1],[0,-1]])
    {
	translate([SCREW_OFFSET*c[0],SCREW_OFFSET*c[1],0]) children();
    }
}

module hub()
{
    difference()
    {
	hub_body();
	translate([0,0,-DELTA]) {
	    hub_shaft();
	    four() hub_peg();
	    rotate([0,0,45])
	    {
		translate([0,-HUB_DIAMETER/3,0]) nut_block();
	    }
	}

	translate([0,0,HUB_HEIGHT/2]) rotate([90,0,45])
	{
	    fixing_screw();
	}
    }
}

hub();

