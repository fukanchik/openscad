/*
 * Fix for broken stand lamp base.
 *
 * The base is a thin aluminum bowl which by itself is too light to hold the
 * lamp standing straight.
 *
 * I filled it with concrete. 
 *
 * Bottom part of this holder is completely sunk inside of concrete. It creates
 * a hole for the lamp's rod.
 *
 * Top part is screwed in with M8 bolts and prevents the rod from wobbling.
 *
 * This was my early design, which has it's drawbacks. Today i would have
 * designed it a bit differently.
 *
 * Unfortunately, because of concrete it's impossible to rebuild.
 */
//Print either top or bottom part?
printTop = 0; //[0=Top,1=Bottom]

$fn=100;

delta02=0.2;
delta01=0.1;
big_radius = 80 / 2;
small_radius = 75 / 2;
small_radius2 = 63 / 2;
rod_radius = 16 / 2 + delta02;
m8 = 8 / 2;
m15 = 15 / 2;

height0=1;
height1=5;
height2=5;

height_bot=28;
height_top=30;

washer_height=2;

module holes() {
	//Subtracted
	translate([0,0,height1+height2-height_bot-delta01]) cylinder(r=rod_radius,h=height0+height1+height2+50+height_bot+delta02);
	for(z=[0,1,2,3]) {
		translate([sin(90*z)*(small_radius2-m8*1.5), cos(90*z)*(small_radius2-m8*1.5),-height_bot-delta01]) cylinder(h=height_bot+height0+height1+height2+delta02,r=m8);
		translate([sin(90*z)*(small_radius2-m8*1.5), cos(90*z)*(small_radius2-m8*1.5),-height_bot]) cylinder(h=height_bot-height0-height1-delta01,r=m15);

	}
	translate([0,0,-washer_height-delta02]) cylinder(h=washer_height+delta02,r=21);
}

module top() {
	difference() {
		union() {
			cylinder(r=big_radius, h=height0);
			translate([0,0,height0])
				cylinder(r1=big_radius,r2=small_radius, h=5);
			translate([0,0,height0+height1])
				cylinder(r1=small_radius,r2=small_radius2, h=height2);
			translate([0,0,height0+height1+height2])
				cylinder(r1=rod_radius*1.9,r2=rod_radius*1.5,h=height_top);

			for(z=[0,1,2,3]) {
				translate([sin(45+90*z)*(rod_radius*1.5), cos(45+90*z)*(rod_radius*1.5),0]) cylinder(h=height0+height1+height2+height_top,r1=m8*2,r2=m8/2);
			}
		}
		holes();
	}
}

module bottom() {
	difference() {
		union() {
			translate([0,0,-height0-height1])
				cylinder(r=big_radius, h=height0+height1-0.01);

			translate([0,0,-height_bot])
				cylinder(r1=rod_radius*2,r2=rod_radius*2.2, h=height_bot-height0-height1);

			for(z=[0,1,2,3]) {
				translate([sin(45+90*z)*(small_radius-m8), cos(45+90*z)*(small_radius-m8),-height_bot])
					cylinder(h=height_bot,r1=m8,r2=m8*1.6);
			}
		}
		holes();
	}
}

if(printTop==0)
{
	top();
} else {
	bottom();
}
