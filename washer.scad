$fn=100;

NUTR=10.2;
THICK=1.2;
BOLTR_INNER = 4.7/2;

module nut()
{
    difference()
    {
        cylinder(r = NUTR / 1.3,h = THICK);
        translate([0,0,0-0.01]) {
            cylinder(r=NUTR/2,h=THICK + 0.02,$fn=6);
        }
    }
}

module washer()
{
    difference()
    {
        difference()
        {
            translate([0,0,-3]) {
                scale([1.5,1.5,1]) sphere(r=6,h=THICK*2);
            }
            translate([0,0,-12]) cylinder(r=12,h=12);
            translate([0,0,THICK*2])cylinder(r=12,h=6);
        }
        translate([0,0,THICK]) {
            cylinder(r=4.1,h=THICK+0.01);
        }
        translate([0,0,-0.01]) {
            cylinder(r=BOLTR_INNER,h=THICK*2, $fn=100);
        }
    }
}

washer();
