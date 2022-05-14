$fn=50;

DELTA=0.01;

PRINT_HOOK=1;
PRINT_BODY=0;
PRINT_BODY1=1;

WIRED=5.4;
HOOKH=20;

BARD=15;
BARLEN=30;

BLOCKH=8;

BARR=BARD/2;
WIRER=WIRED/2;
THICK=2;

BOLTSPACE=8;

module down(x)
{
    translate([0,0,-x]) children();
}

BLOCKTHICK=7;

M3nutDia=6.5;
M3boltDia=3.3;
M3nutHeight=2;

module bolt_hole()
{
    XXX=30;
    cylinder(d=M3nutDia,h=M3nutHeight,center=false, $fn=6);
    translate([0,0,M3nutHeight-DELTA]) cylinder(d=M3boltDia,h=XXX,center=false);
}

module hook2()
{
    rotate([0,90,0]) translate([0,0,-BARLEN/2]) difference()
    {
        cylinder(r=BARR+THICK*2, h=BARLEN);
        down(DELTA) cylinder(r=BARR, h=BARLEN+DELTA*2);
        translate([-3,0,0]) down(DELTA) cube([BARD, BARD, BARLEN+DELTA*2]);
    }
    translate([-BARLEN/2,-THICK*2,-(BARR+THICK*2+BLOCKH)]) difference()
    {
        cube([BARLEN,BLOCKTHICK/2,BLOCKH+THICK*2]);
        translate([(BARLEN-WIRED*2)/2,-DELTA,-DELTA]) cube([WIRED*2,DELTA*2+BLOCKTHICK/2,BLOCKH]);
    }
}

BOLTSPREAD=2;
module hook()
{
    outer = WIRER+THICK*2;
    blockx=outer*2+BOLTSPACE*2;
    difference()
    {
        union()
        {
            cylinder(r=outer,h=HOOKH);
            translate([-blockx/2, -BLOCKTHICK/2,0]) cube([blockx,BLOCKTHICK,HOOKH]);
            translate([-blockx/2, -BLOCKTHICK/2,0])cube([BOLTSPACE,BLOCKTHICK/2,HOOKH+8]);
            translate([+blockx/2-BOLTSPACE, -BLOCKTHICK/2,0])cube([BOLTSPACE,BLOCKTHICK/2,HOOKH+8]);
        }
        down(DELTA)cylinder(r=WIRER,h=HOOKH+DELTA*2);
        translate([-blockx/2+M3nutDia/2+1,BLOCKTHICK/2+DELTA,M3nutDia/2+BOLTSPREAD]) rotate([90,0,0])bolt_hole();
        translate([-blockx/2+M3nutDia/2+1,BLOCKTHICK/2+DELTA,HOOKH-(M3nutDia/2+BOLTSPREAD)]) rotate([90,0,0])bolt_hole();
        translate([blockx/2-M3nutDia/2-1,BLOCKTHICK/2+DELTA,M3nutDia/2+BOLTSPREAD]) rotate([90,0,0])bolt_hole();
        translate([blockx/2-M3nutDia/2-1,BLOCKTHICK/2+DELTA,HOOKH-(M3nutDia/2+BOLTSPREAD)]) rotate([90,0,0])bolt_hole();

        if(PRINT_BODY1)
        {
            translate([-blockx/2-DELTA,0,-DELTA]) cube([blockx+DELTA*2, BLOCKTHICK, HOOKH+DELTA*2]);
        } else {
            translate([-blockx/2-DELTA,DELTA-BLOCKTHICK,-DELTA]) cube([blockx+DELTA*2, BLOCKTHICK, HOOKH+DELTA*2+10]);
        }
    }
}

difference()
{
    union()
    {
        if(PRINT_BODY)
        {
            hook();
        }
        if(PRINT_HOOK)
        {
            translate([0,4,4.6+HOOKH+BARD]) hook2();
        }
    }
    translate([-BARLEN/2+M3nutDia/2+1,BLOCKTHICK/2+DELTA,HOOKH+(M3nutDia/2+1)]) rotate([90,0,0])bolt_hole();
    translate([BARLEN/2-M3nutDia/2-1,BLOCKTHICK/2+DELTA,HOOKH+(M3nutDia/2+1)]) rotate([90,0,0])bolt_hole();
}
