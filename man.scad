module up(z)
{
translate([0,0,z]) child(0);
}

module down(z)
{
translate([0,0,-z]) child(0);
}

module right(x)
{
translate([x,0,0])child(0);
}

module left(x)
{
translate([-x,0,0])child(0);
}

module forward(y)
{
    translate([0,y,0])child(0);
}


up (10) sphere(r=10,h=6);

down (22) cylinder (r=10,h=23);

left(8) down (35) cylinder (r=4, h=14);

right(8) down (35) cylinder (r=4, h=14);

right (12) down (18) cylinder (r=3,h=17);

down(18) left (12) cylinder (r=3,h=17);
forward(10) left (12) down (14) rotate([90,0,0]) cylinder(r=3,h=12);
down(14) left(12) forward(12) rotate([90,0,0]) cylinder(r=10, h=1.2);

down (36) cylinder(r=20,h=1.2);
