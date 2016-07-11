DELTA=0.01;

function bit_get(num, bitpos) = floor(num / pow(2, bitpos)) % 2;

module rounded_cube(dim, r, r2=undef)
{
    hull() for(i = [0 : 3])
    {
	X_bit = bit_get(i, 0);
	Y = bit_get(i, 1);
	OFF = r2==undef ? r : max(r, r2);

	translate([dim[0] * X_bit + pow(-1, X_bit) * OFF, dim[1] * Y + pow(-1, Y) * OFF, -DELTA])
	{
	    if(r2==undef)
	    {
		cylinder(r=r, h=dim[2] + DELTA * 2);
	    } else {
		cylinder(r1=r, r2 = r2, h=dim[2] + DELTA * 2);
	    }
	}
    }
}

module center_at(outer, inner)
{
    translate([(outer[0] - inner[0]) / 2, (outer[1] - inner[1]) / 2, 0])
    {
	children();
    }
}

module up(what)
{
    translate([0, 0, what])
    {
	children();
    }
}

module down(what)
{
    translate([0, 0, -what])
    {
	children();
    }
}
