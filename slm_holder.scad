$fn = 120;
DELTA=0.01;

WIDTH = 53;
THICK = 27.2;
HEIGHT= 28;

ANGLE = 15;

EXTRA=10;
OUTER_WIDTH = WIDTH + EXTRA+3;
OUTER_THICK = THICK + EXTRA+2;
OUTER_HEIGHT= HEIGHT + EXTRA;

OUTER = [OUTER_WIDTH, OUTER_THICK, OUTER_HEIGHT];
INNER = [WIDTH, THICK, OUTER_HEIGHT];

use <myutils.scad>

module outer_cube(size)
{
    rotate([ANGLE, 0, 0]) down(10) rounded_cube(size, 8, 1);
}

module body()
{
    difference()
    {
	outer_cube(OUTER);
	rotate([ANGLE, 0, 0]) down(1) center_at(OUTER, INNER) rounded_cube(INNER, 3, 2);
    }
}

module erase()
{
    cube([OUTER_WIDTH+DELTA*2,2*OUTER_THICK, OUTER_HEIGHT]);
}

module leg()
{
    LEG_ANGLE=-40;
    rotate([LEG_ANGLE,0,0]) rounded_cube([10,THICK,OUTER_HEIGHT], 1);
}

module slm_holder()
{
    difference()
    {
	union()
	{
	    body();
	    translate([0, 3, 0]) difference()
	    {
		union()
		{
		    translate([(OUTER_WIDTH-10)/5,-23,-2]) leg();
		    translate([(OUTER_WIDTH-10)/5*4,-23,-2]) leg();
		}
		outer_cube([OUTER_WIDTH, OUTER_THICK, OUTER_WIDTH]);
	    }
	}
	translate([-DELTA,-OUTER_THICK/2-10,0,]) down(OUTER_HEIGHT) erase();
	translate([-DELTA,-OUTER_THICK/2,0,]) up(22) erase();
    }
}

slm_holder();

