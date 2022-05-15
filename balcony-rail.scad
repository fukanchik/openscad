$fn=100;
DELTA=0.01;

module up(x)
{
    translate([0,0,x])children();
}

module down(x)
{
    translate([0,0,-x])children();
}

THICK=20;
module bar()
{
    translate([-51/2,0,0])
    {
        translate([5,0,0]) cube([41,THICK,16]);
        up(16-DELTA) cube([51,THICK,25-16+DELTA]);
    }
    difference()
    {
        translate([0,THICK,25]) scale([1,1,0.4]) rotate([90,0,0]) cylinder(r=25.5,h=THICK);
        translate([-110,-DELTA,-195-DELTA]) cube([220,THICK+2*DELTA,220]);
    }
}

module barclaw(){
    difference()
    {
        difference()
        {
            w=60;
            union()
            {
                translate([-w/2,0,0])  cube([w,THICK-DELTA*2,40]);
                translate([28,THICK,39])rotate([90,0,0]) cylinder(r=10,h=THICK);
            }
            translate([0,-DELTA,-DELTA]) bar();
        }
        translate([28,THICK,39+DELTA])rotate([90,0,0])
        {
            down(DELTA) cylinder(r=5,h=THICK+2*DELTA, $fn=6);
        }
        translate([15,-DELTA,-DELTA]) cube([20,20,10]);
    }
}

module hang()
{
    SIDE=5;
    cylinder(r=10,h=SIDE);
    up(SIDE)cylinder(r=5-0.28,h=THICK);
    difference()
    {
        translate([2,-20,0])
        cube([10,35,THICK+SIDE]);
        up(SIDE)cylinder(r=10.28,h=THICK+DELTA);
    }
    R0=40;
    if(0)
    {translate([R0+5,12,0])difference()
    {
        cylinder(r=R0,h=THICK+SIDE);
        down(DELTA)cylinder(r=R0-7,h=THICK+SIDE+DELTA*2);
        translate([-R0/2,-R0*2,-DELTA])rotate([0,0,15])cube([R0*2+DELTA*2,R0*2,THICK+SIDE+DELTA*2]);
        translate([20,7.4,-(THICK+SIDE)/2])difference()
        {
            cube([THICK+SIDE, THICK+SIDE, (THICK+SIDE)*2]);
            translate([0,(THICK+SIDE)+2,THICK+SIDE])rotate([0,90,0])cylinder(r=2*(THICK+SIDE)/3,h=THICK+SIDE);
        }
    }
    translate([R0*2+3,R0,(THICK+SIDE)/2])rotate([120,90,0])down(4)cylinder(r=3,h=14);
}  {
    up=1.2*360;
    translate([R0+6,16,0])for(x=[0:1:up])
    {
        v=6.4-(x/(up/6));
        dff=x/24;
        rotate([0,0,270-x])translate([0,(R0-(up-x))/9.6,(dff)/2])cylinder(r=v,h=(THICK+SIDE)-dff);
    }
}
}

barclaw();
//translate([28,5+DELTA+THICK,39+DELTA])rotate([90,0,0])
//hang();
