$fn=100;

DELTA=0.01;

INNER=8.4;
OUTER=10.3;

SZ=4.4;

module digit(top, digit)
{
    translate([-SZ/2.5, -SZ/2, top])
    color([1,0,0]) linear_extrude(height=1.6)
     text(digit, size = SZ, direction = "ltr", spacing = 1 );
}

module up(z)
{
    translate([0,0,z]) children();
}

module cone(h1)
{
    hcone=8;
    up(-hcone+0.4+h1) difference()
    {
        up(-1)cylinder(r=OUTER/2+2, h=hcone+1);
        up(DELTA)cylinder(r1=0, r2=OUTER/2+h1/1.5, h=hcone);
    }
}

module rivet(num, h1, h2, e1h, e1l, e2h, e2l)
{
    difference()
    {
        union()
        {
    digit(h2-1, num);
    cylinder(r1=OUTER/2 + e1h, r2=OUTER/2 + e1l, h=h1);
    cylinder(r1=INNER/2 + e2h, r2=INNER/2 + e2l, h=h2);
    }
    cone(h1);
}
}

translate([0,0,0]) rivet("1", 2, 6, 0, 0, 0, 0);
translate([14,0,0]) rivet("2", 3, 7, -0.2, 0.2, 0.2, -0.2);
translate([28,0,0]) rivet("3", 2, 5, -0.2, 0.1, 0.1, -0.2);
