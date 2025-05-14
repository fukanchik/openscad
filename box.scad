$fn = 60;
DELTA=0.01;

WIDTH = 60;
LENGTH = 80;
HEIGHT= 20;
WALL = 1;

PAD=0.3;

HANDLE_D = 8;
HANDLE_L = 30;

MODE_ASSEMBLY = 0;
MODE_BODY = 1;
MODE_CAP = 2;
PRINT_MODE = MODE_CAP;

module box(w,l,h,wall)
{
	real_w = w;
	real_l = l;
	real_h = h;
	inner_w = w - 2*wall;
	inner_l = l - 2*wall;
	inner_h = h;
	difference()
		{
			cube([real_w, real_l, real_h]);
			translate([wall,wall,wall])cube([inner_w, inner_l, inner_h]);
		}
}

NOZZLE_D=0.4;
module body()
{
	mid_l = (LENGTH - HANDLE_L) / 2;
	wall = max(WALL, (HANDLE_D * 0.2)/2 + NOZZLE_D);
	echo("WALL",wall);
	difference()
		{
			box(WIDTH, LENGTH, HEIGHT, wall);
			translate([0, mid_l, HEIGHT/3]) rotate([270,0,0]) scale([0.2,1,1]) cylinder(d=HANDLE_D, h=HANDLE_L);
			translate([WIDTH, mid_l, HEIGHT/3]) rotate([270,0,0]) scale([0.2,1,1]) cylinder(d=HANDLE_D, h=HANDLE_L);
		}
}

module cap()
{
	SCALE=0.3;
	width = WIDTH + 2*(WALL+PAD);
	length = LENGTH+2*(WALL+PAD);
	handle_l = HANDLE_L - 2*WALL;
	mid_l = (length - handle_l) / 2;
	total_z = HEIGHT+WALL+PAD;
	bar_z = total_z + WALL + PAD - (WALL+PAD + HEIGHT/3);

	difference()
		{
			union()
			{
				box(width, length, total_z-2, WALL);
				translate([0+WALL, mid_l, bar_z]) rotate([270,0,0]) scale([SCALE,0.95,1]) cylinder(d=HANDLE_D, h=handle_l);
				translate([WIDTH+WALL+2*PAD, mid_l, bar_z]) rotate([270,0,0]) scale([SCALE,0.95,1]) cylinder(d=HANDLE_D, h=handle_l);
			}

			N=20;
			translate([width/2, -DELTA, 3*HEIGHT/4+N/5]) union() {
				rotate([270,0,0]) cylinder(d=N,h=2*DELTA+length);
				translate([-N/2,0,0]) cube([N,2*DELTA+length, N]);
			}
		}
}

if (PRINT_MODE == MODE_BODY)
	{
		body();
	}
 else if (PRINT_MODE == MODE_CAP)
	 {
		 cap();
	 }
 else if (PRINT_MODE == MODE_ASSEMBLY)
	 {
		 difference()
			 {
				 union()
				 {
					 if(1)color([1,0,0,1])translate([WALL+PAD,WALL+PAD,WALL+PAD-3]) body();
					 if(1)color([0,1,0,1])
							  translate([WIDTH + 2*(WALL + PAD),0,HEIGHT-PAD]) rotate([0,180,0])
							  intersection()
							  {
								  cap();
								  //	translate([0,10,-10])cube([100,20,100]);
							  }
				 }
				 translate([WIDTH/2,15,-10])rotate([0,0,45])cube([100,100,100]);
			 }
	 }
 else
	 {
		 assert(0, "PRINT_MODE is unknown");
	 }
