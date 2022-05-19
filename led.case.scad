DELTA=0.01;

BLUE=[0.3, 0.3, 1];
WHITE=[1, 1, 1];

DIMW=84.2-1.2;
DIMH=55.2-0.4;
DIMZ=6.8;
THICK=1.4;
MAGIC1 = 3.7;

SWH=10;
SWW=22;
SWZ=5;

SWPOSLEFT=2.6;
SWOUT=0.2;

PINW=1;
PINH=1.4;
PINZ=1.2;
PINNUM=10;

module switches()
{
    module _pin()
    {
        color(WHITE) cube([PINW, PINH, PINZ]);
    }

    color(BLUE) cube([SWW, SWH, SWZ]);
    pad = SWW / (PINNUM + 1);
    for(i=[0:1:(PINNUM-1)])
    {
        translate([PINW + i * pad, (SWH - PINH)/2 - PINH * (i%2), SWZ - PINZ / 2]) _pin();
    }
}

WIREW = 4;
WIREH = 4;
WIREPADW = 3 + THICK;
WIREPADH = 3 + THICK;
WIREZ = DIMZ + THICK + DELTA * 2;

SHORTER = 14;
BIGHOLEW = 47 - SHORTER;

module case()
{
    difference()
    {
        cube([DIMW + THICK * 2, DIMH + THICK * 2, DIMZ + THICK]);
        translate([THICK, THICK, -DELTA]) cube([DIMW, DIMH, DIMZ - MAGIC1 + DELTA * 2]);
        translate([THICK + 1, THICK + 1, -DELTA]) cube([DIMW - 2, DIMH - 2, DIMZ + DELTA * 2]);
        HOLEW = SWW + SWOUT * 2;
        HOLEH = SWH + SWOUT * 2;
        translate([SWPOSLEFT - SWOUT + THICK, (DIMH + THICK * 2 - HOLEH)/2]) cube([HOLEW, HOLEH, DIMZ + THICK + DELTA * 2]);

        translate([DIMW - WIREPADW - THICK - 1, DIMH - WIREPADH - THICK - 1, -DELTA]) cube([WIREW,WIREH,WIREZ]);
        translate([DIMW - WIREPADW - THICK - 1, 3+THICK, -DELTA]) cube([WIREW,WIREH,WIREZ]);
        translate([DIMW - BIGHOLEW - THICK - 1 - SHORTER, WIREPADH, -DELTA]) cube([BIGHOLEW, 12, DIMZ + THICK + DELTA * 2]);
    }
}

//color(WHITE) case();
//translate([SWPOSLEFT + THICK, ( DIMH - SWH + THICK*2 ) / 2, 0]) switches();

module cap()
{
    difference()
    {
        cube([BIGHOLEW-0.6, 12-0.6, 12]);
        translate([0.7, 0.7, -DELTA]) cube([BIGHOLEW-2, 12-2, 12 - 3.4 + DELTA * 2]);
        for(i=[0:1:7])
        {
            translate([3 + i*3.8,(12-0.6)/2,0]) cylinder(h=12-0.4, r=3.5/2,$fn=50);
        }
    }
}

//translate([DIMW - BIGHOLEW - THICK - 1 - SHORTER, WIREPADH, DIMZ + THICK -DELTA]) cap();

L=2.8;
W=7.6;
H=8;
D=1.8;
P=2.8;
BT=0.8;

difference()
{
    cube([P + (L+D)*8+D, W+2, H+BT-DELTA]);
    for(i=[0:1:7])
    {
        translate([P*(i>3?1:0) + D + (L+D)*i, 1, BT]) cube([L, W, H]);
    }
}
