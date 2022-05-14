$fn=100;

DELTA=0.01;


RKNOB=33/2;

RSHAFT=6.2/2;
HSHAFT=11.5;

RPIMP=15/2;
HPIMP=5;

//RKNOB=25/2;
HPIMP=0;

module down(x)
{
    translate([0,0,-x]) children();
}

module _shaft()
{
    cylinder(r1=RSHAFT+0.2,r2=RSHAFT-0.1, h=HSHAFT+DELTA*2);
    cylinder(r1=RSHAFT+1,r2=RSHAFT-1,h=2);
}

XXX=RKNOB/4;

module lamp_knob()
{
    difference()
    {
        union(){
            translate([0,0,XXX-DELTA])
            {
                difference()
                {
                    sphere(r=RKNOB);
                    translate([-RKNOB-DELTA,-RKNOB-DELTA,-RKNOB]) cube([RKNOB*2+DELTA*2, RKNOB*2+DELTA*2, RKNOB+DELTA*2]);
                }
            }
            cylinder(r=RKNOB,h=XXX+DELTA);
        }
        translate([0,0,HPIMP-DELTA*2]) _shaft();
    }
    difference()
    {
        translate([-RSHAFT*1.5,4/2,0]) cube(RSHAFT*3, RSHAFT*2, HSHAFT);
        down(DELTA)cylinder(r1=RSHAFT+1,r2=RSHAFT-1,h=2);
    }
}

difference()
{
    lamp_knob();
    difference()
    {
        down(DELTA) cylinder(r=RKNOB*2, h=RKNOB*3, $fn=6);
        down(DELTA) cylinder(r=RKNOB, h=RKNOB*3, $fn=6);
    }
    YYY=12;
    translate([-RKNOB,-RKNOB,RKNOB-YYY]) cube([RKNOB*2,RKNOB*2,RKNOB*2]);
    down(DELTA)cylinder(r=RPIMP,h=HPIMP);
}
