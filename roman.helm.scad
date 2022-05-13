//plum
//skull
//nasal
//visor
$fn = 20;
TOLERANCE=0.01;

HEAD_RADIUS = 16;
SHOULDER_RADIUS = 19;
HELM_HEIGHT=26;
HEAD_SCALE=[1,0.8,1];
HELM_THICK = 1.6;

VISOR_WIDTH=9;

generate_plum = false;
generate_skull = false;
print_tube = true;

SR = 4;
TH = 10;
SC=0.4;

module down(how)
{
    translate([0, 0, -how]) children();
}

module hollow_cylinder(r1, r2, h, t)
{
    difference()
    {
	cylinder(r1 = r1, r2 = r2, h = h);
	down(TOLERANCE)
	{
	    cylinder(r1 = r1 - t, r2 = r2 - t, h = h + TOLERANCE * 2);
	}
    }
}

module hollow_half_sphere(r, t)
{
    __wide = r * 2*1.02;
    down(2)difference()
    {
        sphere(r = r*1.01);
	down(TOLERANCE)
	sphere(r=r-t);
        translate([-__wide/2, -__wide/2, -__wide + 2])
	{
	    cube([__wide, __wide, __wide]);
	}
    }
}

module rim(r,t,h)
{
    difference()
    {
	hollow_half_sphere(r,t);
	ZT=2;
	BW=8;
	translate([-r,BW/2,ZT]) cube([r*2.2,r*2.2,r*2]);
	translate([-r,-r*2-BW/2,ZT]) cube([r*2,r*2,r*2]);
    }
}

module plum_holder(R,w,D,add=0)
{
    r = R + 4;

    difference()
    {
	hollow_half_sphere(r,w);
	translate([-r,w/2,0]) cube([r*2,r*2,r]);
	translate([-r,-r*2-w/2,0]) cube([r*2,r*2,r]);
	rotate([0,360-10,0])
	{
	    translate([0,-r,7]) rotate([0,70-D,0]) cube([r*2,r*2,r]);
	    translate([0,-r,0]) rotate([0,180+25+D,0]) cube([r*2,r*2,r]);
	}
    }
}

module plum(R, w, D)
{
    ADD=6;
    r=R+4+ADD;
    difference()
    {
	hollow_half_sphere(r,w+ADD);
	translate([-r,w/2,0]) cube([r*2,r*2,r]);
	translate([-r,-r*2-w/2,0]) cube([r*2,r*2,r]);
	rotate([0,360-10,0])
	{
	    translate([0,-r,7]) rotate([0,70-D,0]) cube([r*2,r*2,r]);
	    translate([0,-r,0]) rotate([0,180+25+D,0]) cube([r*2,r*2,r]);
	}
    }
}

module h_arc(radius, head_scale, t)
{
    scale(head_scale)
    {
	hollow_half_sphere(radius,t);
	rim(radius+0.6, 1, 2);
    }
    difference()
    {
	plum_holder(HEAD_RADIUS,6,0);
	plum_holder(HEAD_RADIUS+2,4,2);
	translate([-HEAD_RADIUS*2, -HEAD_RADIUS*2, -HEAD_RADIUS+TOLERANCE*2]) cube([HEAD_RADIUS*4,HEAD_RADIUS*4,HEAD_RADIUS]);
    }
}

if(generate_plum)
{
    translate([0,0,HELM_HEIGHT])
    {
	if(false)difference()
	{
	    plum_holder(HEAD_RADIUS,6,0);
	    plum_holder(HEAD_RADIUS+2,4,2);
	    //translate([-HEAD_RADIUS*2, -HEAD_RADIUS*2, -HEAD_RADIUS+TOLERANCE*2]) cube([HEAD_RADIUS*4,HEAD_RADIUS*4,HEAD_RADIUS]);
	}
	color([1,0,0]) plum(HEAD_RADIUS+2, 4, 2);
    }
}

module frustrum(w, s, t)
{
    rotate([90, 0, 180])
    {
	uw = (s / 2);
	scale([-w,w,1]) linear_extrude(height = t)
	{
            polygon([[0.5,-0.5], [0,0], [uw,1], [uw,2], [0.5,2]]);
	}
    }
}

module h_tube(head_radius, shoulder_radius, helm_height, thick, head_scale)
{
    scale(head_scale)
    {
	hollow_cylinder(shoulder_radius, head_radius, helm_height, thick);
    }
    visor_rim();
}

module visor_rim()
{
}

module visor(w, h, t)
{
    nose_h = h / 5;
    nose_w = w / 6;

    difference()
    {
	union()
	{
	    XX=w/2;
	    LIST=[[SC*XX,0], [XX, 0], [XX,h], [0,h]];
	    translate([0,t,0]) rotate([90,0,0]) linear_extrude(height=t) polygon(LIST);
	    translate([-2,t,h-2]) rotate([90,0,0])
	    {
		cylinder(r = SR, h = t);
	    }
	}
	union()
	{
	    translate([w/2 - w/4 + TOLERANCE,-TOLERANCE,h-nose_h-w/2+0.8]) frustrum(w/2, 0.4, t+TOLERANCE*2);
	}
	translate([-3,t+1,h-2]) rotate([90,0,0])
	{
	    translate([-SR,3,-TOLERANCE])rotate([0,0,-11]) down(TOLERANCE)cube([SR*3,SR*3,SR*3+TOLERANCE*2]);
	}
    }
}

module full_visor()
{
    visor(VISOR_WIDTH, HELM_HEIGHT, TH);
    translate([VISOR_WIDTH-TOLERANCE, 0, 0]) scale([-1,1,1])visor(VISOR_WIDTH, HELM_HEIGHT, TH+TOLERANCE*2);
}

module bottom_negative()
{
    scale([2,2,1]) difference()
    {
	BH = HELM_HEIGHT / 2;
	cube([SHOULDER_RADIUS,SHOULDER_RADIUS,BH]);
	union()
	{
	    translate([2.5,0,SHOULDER_RADIUS*3.6]) scale([1,1,10]) rotate([-90,0,0]) down(TOLERANCE) cylinder(r=SHOULDER_RADIUS/3,h=SHOULDER_RADIUS + TOLERANCE*2);
	    translate([SHOULDER_RADIUS*1.15,0,SHOULDER_RADIUS*0.8]) rotate([-90,0,0]) down(TOLERANCE) cylinder(r=SHOULDER_RADIUS*0.8,h=SHOULDER_RADIUS + TOLERANCE*2);
	}
    }
}

color([213/256,195/256,171/256])
difference()
{
    union()
    {
	if(generate_skull) translate([0,0,HELM_HEIGHT]) h_arc(HEAD_RADIUS, HEAD_SCALE, HELM_THICK);

	if(print_tube) h_tube(HEAD_RADIUS, SHOULDER_RADIUS,HELM_HEIGHT, HELM_THICK, HEAD_SCALE);
    }

    if(generate_skull||print_tube)
    {
	translate([4+SHOULDER_RADIUS,0-VISOR_WIDTH/2,0]) rotate([-12,0,90]) full_visor();
	translate([-SHOULDER_RADIUS,-SHOULDER_RADIUS,-TOLERANCE]) bottom_negative();
    }
}
