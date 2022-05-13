use </home/fuxx/tmp/pi/t.scad>;

$fn = 100;
DELTA = 0.001;

PRINT_STAND = true;
PRINT_HOLDER = true;
PRINT_PI = true;

SHOW_PLATE = false;

CLOCK_HEIGHT = 38;
CLOCK_DIAMETER_BIG = 160;
CLOCK_DIAMETER_SMALL = 150;

HOLDER_COLOR = [1, 0, 0];

module clock()
{
    cylinder(r1 = CLOCK_DIAMETER_BIG / 2, r2 = CLOCK_DIAMETER_SMALL / 2, h = CLOCK_HEIGHT);
}

THICK_FRONT = 4;
THICK_BACK = 3;

STAND_WIDTH=CLOCK_HEIGHT + THICK_FRONT + THICK_BACK;

module stand()
{
    translate([0,-100,0])
    {
	difference()
	{
	    translate([0,150,0])
	    {
		rotate([0,0,90])
		{
		    cylinder(r=95/2, h=STAND_WIDTH, $fn=3);
		}
	    }
	    translate([-100,150,-1]) cube([400,400,70]);
	}
    }

    translate([-(HOLDER_WIDTH-5)/2,26.25,-2.5+DELTA])
    {
	cube([HOLDER_WIDTH-5,23.75,10]);
    }
}

module _clock_hole()
{
    translate([0,106,-THICK_BACK])
    {
	rotate([-5,0,0]) clock();
    }
}

module arc_hole()
{
    rotate([90,0,0])
    {
	translate([0,-25,-5])
	{
	    scale([1,2,1])
	    {
		cylinder(r=35,h = 3 * CLOCK_HEIGHT);
	    }
	}
    }
}

module full_stand()
{
    difference()
    {
	rotate([90,0,0])
	{
	    difference()
	    {
		stand();
		_clock_hole();
	    }
	}
	arc_hole();
	translate([-HOLDER_WIDTH/2,2.5,34]) color([1,0,0]) rotate([90,0,0])
	{
	    holder();
	}
    }
}

PI_WIDTH=2;
module my_pi()
{
    translate([0, -STAND_WIDTH+PI_WIDTH+3, 60])
    {
	color([0,1,0])
	rotate([83,0,0]) 
	{
	    scale([2,2,2]) PI();
	}
    }
}

if(PRINT_PI)
{
    my_pi();
}

if(PRINT_STAND)
{
    difference()
    {
	full_stand();
	scale([1.001, 1.001, 1.001]) my_pi();
    }
}

if(SHOW_PLATE) translate([-50,0,-20]) color([1,0.5,0.5]) cube([100,100,10]);

HOLDER_WIDTH=60;
HOLDER_HEIGHT=60;
HOLDER_THICK=8;

HOLDER_WIDTH_HOLE=55;
BAR_THICK=4;
DEPTH=16+4;
EAR_HEIGHT=15;
BH=16;

module holder()
{
    difference()
    {
	difference()
	{
	    cube([HOLDER_WIDTH, HOLDER_HEIGHT, HOLDER_THICK]);
	    translate([-DELTA,-DELTA,(HOLDER_THICK-BAR_THICK)/2-DELTA])
	    {
		cube([HOLDER_WIDTH+DELTA*2, BH+DELTA*2, BAR_THICK + DELTA]);
	    }
	    translate([(HOLDER_WIDTH-HOLDER_WIDTH_HOLE)/2,BH+BAR_THICK,-1])
	    {
		cube([HOLDER_WIDTH_HOLE, HOLDER_HEIGHT-BH-BAR_THICK+DELTA, DEPTH+DELTA*2]);
	    }
	}
	translate([0,HOLDER_HEIGHT-EAR_HEIGHT,0])
	{
	    difference()
	    {
		union()
		{
		    cube([HOLDER_WIDTH, EAR_HEIGHT, DEPTH]);
		    RR=3;
		    translate([0,(EAR_HEIGHT)/2,0])
		    {
			cylinder(r=RR,h=DEPTH);
		    }
		    translate([HOLDER_WIDTH,(EAR_HEIGHT)/2,0])
		    {
			cylinder(r=RR,h=DEPTH);
		    }
		}
		translate([(HOLDER_WIDTH-HOLDER_WIDTH_HOLE)/2,-DEPTH,-DELTA])
		{
		    cube([HOLDER_WIDTH_HOLE, EAR_HEIGHT+2*DEPTH, DEPTH+DELTA*2]);
		}
	    }

	}

	HOLE = HOLDER_WIDTH / 2;
	BLEG_WIDTH = (HOLDER_WIDTH-HOLE)/2;
	translate([BLEG_WIDTH,-DELTA,-DELTA]) 
	{
	    cube([HOLE, BH + DELTA * 2, HOLDER_THICK + DELTA * 2]);
	}

	translate([BLEG_WIDTH, -10, -DELTA]) 
	cube([HOLE,BH+DELTA*2,HOLDER_THICK+DELTA*2]);
	translate([-HOLDER_THICK, -DELTA, -DELTA]) cube([BLEG_WIDTH,BH + DELTA * 2, HOLDER_THICK + DELTA * 4]);
	translate([HOLDER_WIDTH-HOLDER_THICK, -DELTA, -DELTA]) cube([BLEG_WIDTH,BH + DELTA * 2, HOLDER_THICK + DELTA * 4]);

    }
}

module complete_holder()
{
    difference()
    {
	color(HOLDER_COLOR)
	{
	    translate([-HOLDER_WIDTH / 2, 2.5, 34])
	    {
		rotate([90,0,0])
		{
		    holder();
		}
	    }
	}
	arc_hole();
    }
}

if(PRINT_HOLDER)
{
    complete_holder();
}
