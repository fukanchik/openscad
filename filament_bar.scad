$fn = 100;

DELTA = 0.001;

H_EIGHT = 5;
W_IDTH = 20;
D_EPTH = 15;
BACK_THICK = 5;
HOLE_THICK = 1.7;

HOOK_ENTRANCE_RADIUS = 25;

module _outline(height)
{
    rotate([0, 0, 0])
    {
	rotate_extrude(convexity = 10)
	{
	    translate([height * 1.75, 0, 0])
	    {
		circle(r = height / 4);
	    }
	}
    }
}

module _hook(height, width, depth)
{
    rotate([90, 360 - HOOK_ENTRANCE_RADIUS, 90])
    {
	difference()
	{
	    union()
	    {
		cylinder(r=width / 2, h=depth - DELTA);
		_outline(height);
		translate([0, 0, depth]) _outline(height);
	    }
	    translate([0, 0, -DELTA]) cylinder(r = width / 2 - height / 2, h = depth + DELTA * 2);
	    translate([-width / 2, -width, -depth / 2])
	    {
		cube([width, width, depth * 2]);
	    }
	}
    }
}

module filament_bar(height, width, depth)
{
    difference()
    {
	union()
	{
	    cube([depth, width, height]);
	    translate([0 + DELTA, width/2,height])
	    {
		_hook(height, width, depth);
	    }
	    translate([depth, 0, 0])
	    {
		rotate([0,-9,0])
		{
		    translate([-depth*2,0,0])
		    {
			cube([depth*2, width, height]);
		    }
		}
	    }
	}
	translate([-depth*2,-DELTA,-height])
	{
	    cube([depth * 2, width + DELTA * 2, height*2]);
	}
	translate([0, -DELTA, (height - HOLE_THICK) / 2])
	{
	    cube([depth - BACK_THICK, width + DELTA * 2, HOLE_THICK - DELTA]);
	}
	translate([3 * (-sqrt(2) * height) / 4, -DELTA, height / 2])
	{
	    rotate([0, 45, 0])
	    {
		cube([height, width + DELTA * 2, height]);
	    }
	}
    }
    translate([depth,0,height/2])
    {
	rotate([-90,0,0])
	{
	    cylinder(r = height / 2, h = width);
	}
    }
}

module body()
{
    cube([50 - D_EPTH + BACK_THICK + 5, W_IDTH, (H_EIGHT - HOLE_THICK) / 2]);
}

module side_bar()
{
    hull()
    {
	EXTRA = 2;
	translate([0, 0, -EXTRA]) cylinder(r = HOLE_THICK / 2, h = H_EIGHT + EXTRA);
	translate([0, W_IDTH - HOLE_THICK, -EXTRA]) cylinder(r = HOLE_THICK / 2, h = H_EIGHT + EXTRA);
    }
}

translate([51 - D_EPTH + BACK_THICK, 0, 0])
{
    filament_bar(H_EIGHT, W_IDTH, D_EPTH);
}

translate([-HOLE_THICK / 2, 0, H_EIGHT - (H_EIGHT - HOLE_THICK) / 2])
{
    body();
}

translate([-HOLE_THICK / 2, 1*HOLE_THICK / 2, 0])
{
    side_bar();
}
