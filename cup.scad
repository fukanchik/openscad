DELTA=0.01;
D_DOWN=50;
D_UP=70;
TALL=90;

WALL=1;

difference()
{
	cylinder(d1=D_DOWN,d2=D_UP,h=TALL);
	difference()
		{
			cylinder(d1=D_DOWN-2*WALL,d2=D_UP-2*WALL,h=TALL+2*DELTA);
			translate([-50,-50,0])cube([100,100,7]);
		}
}
