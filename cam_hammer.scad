$fn=100;
/* OpenSCAD */
DELTA=0.01;

Assembly=1;
Leg=2;
Bar=3;
Cam=4;
ShaftForCam=5;
Shaft2=6;
Hammer=7;
HammerHead=8;
HammerHandle=9;
Clip=10;
Crank=11;
CrankHandle=12;

PRINT=Assembly;
//PRINT=Leg;
//PRINT=HammerHandle;
//PRINT=Hammer;
//PRINT=HammerHead;
//PRINT=ShaftForCam;
//PRINT=Cam;
//PRINT=Shaft2;
//PRINT=Clip;
//PRINT=Crank;
//PRINT=CrankHandle;

CAM_COLOR = [0,1,0];
FRAME_COLOR = [0.6,0.5,1];
HAMMER_COLOR = [1,0,0];
SHAFT_COLOR = [1,1,0];

LEG_LENGTH = 70;
LEG_WIDTH = 8;
LEG_THICK = 3;

LEG_SUPPORT_LENGTH = 45;

LEG_0 = 1/3;

BAR_LENGTH=50;

PIN_W=3;
PIN_L=3;
PIN_H=LEG_THICK;
PIN_MIDDLE = (LEG_WIDTH-PIN_W)/2;

SHAFT_R=2;
SHAFT_L=BAR_LENGTH + LEG_THICK * 4 + DELTA * 2;
SHAFT_X=LEG_LENGTH * LEG_0 + SHAFT_R + (LEG_WIDTH-SHAFT_R*2)/2;
SHAFT_ELEVATION=20;
SHAFT_ELEVATION2=LEG_SUPPORT_LENGTH + LEG_WIDTH - SHAFT_R * 2;

CAM_THICK = LEG_THICK * 2;

CLIP_WIDTH = SHAFT_R * 1.8;
CLIP_OUTER_RADIUS = SHAFT_R + 2;
CLIP_INNER_RADIUS = SHAFT_R + 0.2;

HAMMER_W=16;
HAMMER_L=12;
HAMMER_H=18;

HAMMER_HANDLE_W = 70;
HAMMER_HANDLE_L = CAM_THICK;
HAMMER_HANDLE_H = 3;
HOLE_POS = HAMMER_HANDLE_W * 2.67 / 8; //TODO: DEPENDS ON CAM SMALL RADIUS
HOLE_OUTER_R = SHAFT_R + 2;

CRANK_LENGTH = SHAFT_R * 5;

/* tolerances */
CLIP_HOLE_TOLERANCE=1.1;
LEG_TOLERANCE_FOR_SHAFT=1.1;
HAMMER_HANDLE_L_TOLERANCE=1.1;

function polar_to_xy(v) = [v[1] * cos(v[0]), v[1] * sin(v[0] )];

module polar_profile(control_points,step) {
    for (angle =[0: step: 360 - 1]) {
        ps = [angle,  lookup(angle, control_points)];
        pe = [angle+step,  lookup(angle+step, control_points) ];

        polygon ([ [0,0], polar_to_xy(ps), polar_to_xy(pe)]);
    }
}

snail = [ [0,4], [50, 5], [140,8], [350,14], [359,14], [360,4] ];

module cam()
{
    rotate([0,0,186]) difference()
    {
        translate([0,0,-CAM_THICK/2]) scale([2,2,1]) linear_extrude(height = CAM_THICK) polar_profile(snail,5);
        rotate([90,0,0]) scale([1.2,1.0,1.2]) shaft_for_cam(true);
    }
}

module _angled_bar()
{
    angled_length = LEG_LENGTH * LEG_0 * (1 / sin(45));
    translate([0,-LEG_WIDTH,0]) {
        cube([angled_length, LEG_WIDTH, LEG_THICK], center=false);
    }
}

module down(what)
{
    translate([0,0,-what]) children();
}

module leg()
{
    difference()
    {
        union()
        {
            cube([LEG_LENGTH, LEG_WIDTH, LEG_THICK]);
            translate([LEG_LENGTH * LEG_0, LEG_WIDTH, 0]) cube([LEG_WIDTH, LEG_SUPPORT_LENGTH, LEG_THICK]);

            translate([0, LEG_WIDTH, 0]) rotate([0,0,45]) {
                _angled_bar();
            }
            translate([LEG_WIDTH + LEG_LENGTH * LEG_0, LEG_WIDTH + LEG_LENGTH * LEG_0, 0]) rotate([0,0,360-45])
            {
                _angled_bar();
            }
        }

        //
        translate([PIN_MIDDLE, PIN_MIDDLE, -DELTA]) pin(true);
        translate([LEG_LENGTH - PIN_MIDDLE - PIN_L, PIN_MIDDLE, -DELTA]) pin(true);
        translate([SHAFT_X, SHAFT_ELEVATION,-DELTA]) rotate([90,0,0]) scale([1.1, 1.1, 1.1]) shaft(true);
        translate([SHAFT_X, SHAFT_ELEVATION2,-DELTA]) rotate([90,0,0]) scale([1.1, 1.1, 1.1]) shaft(true);
        //
    }
}

module pin(diff=false)
{
    if(diff)
    {
        scale([1.1,1.1,1.1]) cube([PIN_W, PIN_L, PIN_H]);
    } else {
        cube([PIN_W, PIN_L, PIN_H]);
    }
}

module bar()
{
    cube([BAR_LENGTH, LEG_WIDTH, LEG_THICK]);
    translate([-PIN_W+DELTA,(LEG_WIDTH-PIN_W)/2,0]) pin();
    translate([0,(LEG_WIDTH- PIN_W)/2,0]) translate([BAR_LENGTH - DELTA, 0, 0]) pin();
}

/* SHAFT */
GUARD_WIDTH = SHAFT_R * 2;

SHAFT_CAP_WIDTH = 1.2;

module _clip_space(r, h)
{
    difference()
    {
        cylinder(r=r, h=h, center=false);
        translate([-r,0,-DELTA]) cube([r*2, r*2, CLIP_WIDTH * CLIP_HOLE_TOLERANCE + DELTA * 2], center=false);
    }
}

module _shaft_guard(r, h)
{
    centerxy(r, r) cube([r, r, h], center=false);
}

function _acc(arr, pos, num) = num==0 ? 0 : arr[pos][1] + _acc(arr, pos + 1, num - 1);

module centerxy(w,l)
{
    translate([-w/2,-l/2,0]) children();
}

/*
* |cap|clip hole|shaft-rotating|shaft-guard|shaft|shaft-guard|shaft-rotating|clip-hole|shaft|clip-hole|shaft-rotating|clip-hole|cap|
*/
D_Cap=1;
D_ClipHole=2;
D_ShaftRotating=3;
D_ShaftGuard=4;
D_Shaft=5;
D_CamBar=6;
D_CrankHole=7;
D_CamGuard=8;

module _draw_shaft_part(which, h)
{
    if(which == D_Cap)
    {
        cylinder(r=SHAFT_R, h=h, center=false);
    } else if(which == D_ClipHole) {
        _clip_space(r=SHAFT_R, h=h);
    } else if(which == D_ShaftRotating) {
        cylinder(r=SHAFT_R*0.95, h=h, center=false);
    } else if(which == D_ShaftGuard) {
        _shaft_guard(SHAFT_R * 2, h);
    } else if(which == D_Shaft) {
        cylinder(r=SHAFT_R, h=h, center=false);
    } else if(which == D_CamBar) {
        translate([-SHAFT_R, -SHAFT_R,0]) cube([SHAFT_R * 2+DELTA*2, SHAFT_R * 2+DELTA*2, h], center=false);
    } else if(which == D_CrankHole) {
        translate([-SHAFT_R/2,-SHAFT_R/2,0]) cube([SHAFT_R,SHAFT_R,h]);
    } else if(which == D_CamGuard) {
        translate([-SHAFT_R*2, -SHAFT_R,0]) cube([SHAFT_R * 4, SHAFT_R * 2, h], center=false);
    } else {
        a=1/0;
        cube([a,a,a]);
    }
}

module _shaft_interpreter(z)
{
    for(i = [0:1:len(z)])
    {
        pos_z = _acc(z, 0, i);
        what = z[i][0];
        h = z[i][1];

        translate([0, 0, pos_z]) _draw_shaft_part(what, h);
    }
}

module shaft(hole=false)
{
    rotate([360-90, 180, 0])
    {
        z = [
            [D_Cap,           SHAFT_CAP_WIDTH],                                      // CAP
            [D_ClipHole,      CLIP_WIDTH * CLIP_HOLE_TOLERANCE],                     // CLIP-HOLE
            [D_ShaftRotating, LEG_THICK * LEG_TOLERANCE_FOR_SHAFT],                  // SHAFT-ROTATING for leg
            [D_ShaftGuard,    GUARD_WIDTH],                                          // SHAFT-GUARD
            [D_Shaft,         BAR_LENGTH / 2 - GUARD_WIDTH*2 - (HAMMER_HANDLE_L*HAMMER_HANDLE_L_TOLERANCE) / 2], // SHAFT
            [D_ShaftGuard,    GUARD_WIDTH],                                          // SHAFT-GUARD
            [D_ShaftRotating, HAMMER_HANDLE_L * HAMMER_HANDLE_L_TOLERANCE],          // SHAFT-ROTATING for hammer-handle
            [D_ClipHole,      CLIP_WIDTH * CLIP_HOLE_TOLERANCE],                     // CLIP-HOLE
            [D_Shaft,         BAR_LENGTH / 2 - (HAMMER_HANDLE_L * HAMMER_HANDLE_L_TOLERANCE) /2 - (CLIP_WIDTH*CLIP_HOLE_TOLERANCE)*2],                  // SHAFT
            [D_ClipHole,      CLIP_WIDTH * CLIP_HOLE_TOLERANCE],                     // CLIP-HOLE
            [D_ShaftRotating, LEG_THICK * LEG_TOLERANCE_FOR_SHAFT],                  // SHAFT-ROTATING for leg
            [D_ClipHole,      CLIP_WIDTH * CLIP_HOLE_TOLERANCE],                     // CLIP-HOLE
            [D_Cap,           SHAFT_CAP_WIDTH],                                      // CAP
        ];
        _shaft_interpreter(z);
    }
}

SHAFT_HANDLE_L = 10;
module shaft_for_cam(hole=false)
{
    z=[
        [D_Cap, SHAFT_CAP_WIDTH],
        [D_ClipHole, CLIP_WIDTH * CLIP_HOLE_TOLERANCE],
        [D_ShaftRotating, LEG_THICK * LEG_TOLERANCE_FOR_SHAFT],
        [D_ShaftGuard, GUARD_WIDTH],
        [D_Shaft, BAR_LENGTH / 2 - GUARD_WIDTH*2 - (HAMMER_HANDLE_L * HAMMER_HANDLE_L_TOLERANCE)/2],
        [D_CamGuard, GUARD_WIDTH],
        [D_CamBar, CAM_THICK],
        [D_ClipHole, CLIP_WIDTH*CLIP_HOLE_TOLERANCE],
        [D_Shaft, BAR_LENGTH / 2 - (HAMMER_HANDLE_L * HAMMER_HANDLE_L_TOLERANCE)/2 - CLIP_WIDTH*CLIP_HOLE_TOLERANCE*2],
        [D_ClipHole, CLIP_WIDTH*CLIP_HOLE_TOLERANCE],
        [D_ShaftRotating, LEG_THICK * LEG_TOLERANCE_FOR_SHAFT],
        [D_Shaft, CLIP_WIDTH],
        [D_CrankHole, CRANK_LENGTH / 2],
        //[D_ClipHole, CLIP_WIDTH*CLIP_HOLE_TOLERANCE],
    ];
    rotate([90,0,180]) _shaft_interpreter(z);
}

module hammer_handle()
{    
    translate([-HOLE_POS, 0, 0]) difference()
    {
        union()
        {
            cube([HAMMER_HANDLE_W, HAMMER_HANDLE_L, HAMMER_HANDLE_H], center=true);
            vert_h = LEG_SUPPORT_LENGTH - SHAFT_ELEVATION;
            hor_end = (HAMMER_HANDLE_W - HAMMER_HANDLE_H) / 2;
            translate([hor_end, 0, vert_h/2 + HAMMER_HANDLE_H/2 - DELTA]) cube([HAMMER_HANDLE_H, HAMMER_HANDLE_L, vert_h], center=true);
            translate([HOLE_POS,0,0]) rotate([90,0,0]) cylinder(r=HOLE_OUTER_R, h=HAMMER_HANDLE_L, center=true);
            translate([hor_end,0,vert_h + HAMMER_HANDLE_H/2]) rotate([90,0,0]) cylinder(r=HAMMER_HANDLE_H/2,h=HAMMER_HANDLE_L, center=true);
        }
        translate([HOLE_POS,0,0]) scale([1.2,1.2,1.2]) rotate([90,0,0]) cylinder(r=SHAFT_R, h=HAMMER_HANDLE_L, center=true);
    }
}

module hammer_head()
{
    difference()
    {
        cube([HAMMER_W, HAMMER_L, HAMMER_H], center=true);
        translate([HAMMER_HANDLE_W/2 + HOLE_POS,0,0]) scale([1.1,1.2,1.2]) hammer_handle();
    }
}

module hammer()
{
    translate([-HAMMER_HANDLE_W/2 - HOLE_POS, 0, 0]) translate([0, 0, 0]) rotate([0,0,0])
    {
        hammer_head();
        translate([HAMMER_HANDLE_W / 2 + HOLE_POS, 0, 0]) hammer_handle();
    }
}

hr = SHAFT_R+1.4;
b0 = SHAFT_R * sqrt(2);
br = SHAFT_R + 1;

CRANK_GRIP_HOLE=1.9;

module crank()
{
    bx=SHAFT_R*2+b0;
    rotate([90,0,0]) {
        difference()
        {
            cylinder(r=hr,h=CRANK_LENGTH, center=true);
            translate([0,0,SHAFT_L/2+3]) rotate([270,0,0]) scale(1.2,1.2,1.2) shaft_for_cam();
        }
    }
    translate([bx,(CRANK_LENGTH - b0)/2,0])cube([b0*3,b0,b0], center=true);
    translate([bx + hr + br,(CRANK_LENGTH - b0)/2,0]) rotate([90,0,0]) {
        difference()
        {
            cylinder(r=br, h = b0, center=true);
            cylinder(r=CRANK_GRIP_HOLE, h = b0 + DELTA*2, center=true);
            translate([br,0,0]) scale([1,0.6,1]) rotate([0,0,60]) cylinder(r=4, h = b0 + DELTA*2, center=true, $fn=3);
        }
    }
}

CRANK_HANDLE_H = 8;
module crank_handle()
{
    hch = b0*1.2;
    tiph=2;
    //translate([0,15,0]) crank();
    cylinder(r=hr, h=CRANK_HANDLE_H, center=true);
    translate([0,0,(hch + CRANK_HANDLE_H)/2-DELTA]) cylinder(r=CRANK_GRIP_HOLE, h=hch, center=true);
    translate([0,0,(hch + CRANK_HANDLE_H + 2*tiph+1)/2-DELTA]) cylinder(r1=CRANK_GRIP_HOLE, r2=hr, h= tiph, center=true);
}

module clip()
{

    difference() {
        cylinder(r=CLIP_OUTER_RADIUS, h=CLIP_WIDTH, center=true);
        cylinder(r=CLIP_INNER_RADIUS, h=CLIP_WIDTH + DELTA * 2, center=true);
        translate([SHAFT_R*1.8,0,0]) rotate([0, 0, 60]) cylinder(r=4, h=CLIP_WIDTH + DELTA*2, center=true, $fn=3);
    }
    translate([-CLIP_WIDTH, 0, 0]) difference()
    {
        cylinder(r=CLIP_INNER_RADIUS, h=CLIP_WIDTH, center=true);
        translate([CLIP_INNER_RADIUS / 2 + DELTA * 2, 0, 0]) cube([CLIP_INNER_RADIUS, CLIP_INNER_RADIUS*3, CLIP_WIDTH + DELTA * 2], center=true);
    }
    rotate([0,0,0]) translate([0,CLIP_INNER_RADIUS,0]) cube([CLIP_INNER_RADIUS*2, 1.6, CLIP_WIDTH], center=true);
}

module frame()
{
    translate([0, LEG_THICK, 0]) rotate([90,0,0]) leg();
    translate([0,LEG_THICK *2 + BAR_LENGTH,0]) rotate([90,0,0]) leg();
    translate([PIN_MIDDLE,LEG_THICK + DELTA,0]) rotate([90,0,90]) bar();
    translate([LEG_LENGTH - PIN_L - PIN_MIDDLE, LEG_THICK + DELTA,0]) rotate([90,0,90]) bar();
}

if(PRINT == Assembly)
{
    color(FRAME_COLOR) frame();
    color(SHAFT_COLOR) translate([SHAFT_X, -(SHAFT_CAP_WIDTH + CLIP_WIDTH * CLIP_HOLE_TOLERANCE), SHAFT_ELEVATION]) shaft();
    color(SHAFT_COLOR) translate([SHAFT_X, -(SHAFT_CAP_WIDTH + CLIP_WIDTH * CLIP_HOLE_TOLERANCE), SHAFT_ELEVATION2]) shaft_for_cam();
    color(CAM_COLOR) translate([SHAFT_X, SHAFT_L / 2 - LEG_THICK*2,SHAFT_ELEVATION2]) rotate([90,0,0]) cam();
    px = SHAFT_X;
    color(HAMMER_COLOR) translate([px, (SHAFT_L - LEG_THICK * 2 - HAMMER_L)/2, SHAFT_ELEVATION]) {
        rotate([0,0,180]) hammer();
    }
    translate([LEG_LENGTH*LEG_0 + SHAFT_R*2,SHAFT_L - SHAFT_R, SHAFT_ELEVATION2]) color([0,0,1]) crank();
    translate([LEG_LENGTH*LEG_0 + SHAFT_R*2 + b0*3 + hr + br/2,SHAFT_L - SHAFT_R + CRANK_LENGTH, SHAFT_ELEVATION2]) rotate([90,0,0]) color([0,0,1]) crank_handle();
    translate([LEG_LENGTH*LEG_0 + SHAFT_R*2,-CLIP_WIDTH/2,SHAFT_ELEVATION]) rotate([90,0,0]) clip();
} else if(PRINT==Leg) {
    leg();
} else if(PRINT==Bar) {
    bar();
} else if(PRINT==Cam) {
    rotate([90,0,0]) cam();
} else if(PRINT==ShaftForCam) {
    shaft_for_cam();
} else if(PRINT==Hammer) {
    hammer();
} else if(PRINT==HammerHead) {
    hammer_head();
} else if(PRINT==HammerHandle) {
    hammer_handle();
} else if(PRINT==Clip) {
    clip();
} else if(PRINT==Crank) {
    crank();
} else if(PRINT==CrankHandle) {
    crank_handle();    
} else {
    //leg();
    //bar();
    //cam();
    shaft();
}
