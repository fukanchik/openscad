use <threads.scad>

$fn=60;

DELTA=0.01;
module up(x)
{
     translate([0,0,x-DELTA])children();
}

H1=6.8;
H2=8;
H3=8;
H4=7;

module adapter()
{
		 base=20.2;
     intersection() {
					metric_thread(diameter=base+.6,pitch=2,length=H3);
					cylinder(d=base+.4,h=H3);
     }
}

module adapter2()
{
     intersection() {
					metric_thread(diameter=25.5,pitch=2,length=H1);
					cylinder(d=25.2,h=H1);
     }
}

module adapter3()
{
     difference()
     {
					cylinder(d=34,h=H4+2.4-DELTA,$fn=12);
					metric_thread(diameter=28.8,pitch=1.7+0*1.4,length=H4+DELTA);
					up(H4+DELTA)cylinder(d=28,h=2.45);
     }
}

module adapter_12(){
    
		 difference()
		 {
					union()
					{
							 //adapter2();
							 //up(H1) cylinder(d=27,h=H2);
							 //up(H1+H2)adapter();
							 adapter2();
							 up(H1) cylinder(d1=27,d2=34,h=H2,$fn=12);
							 up(H1+H2)
										adapter3();
					}
					up(-1)cylinder(d=8,h=H1+H2+H3+2);
		 }
}

module adapter0()
{
		 base=22; 
		 intersection() {
					metric_thread(diameter=base+.6,pitch=2,length=H3);
					cylinder(d=base+.4,h=H3);
     }
}

module test0(){
		 difference()
		 {
					cylinder(d=24,h=H3+1-DELTA*2);
					up(1)adapter0();
		 }
}

module adapter_X()
{
		 difference()
		 {
					union()
					{
							 difference(){
										adapter2();
										up(-DELTA)cylinder(d1=19.6,d2=8,h=5);
							 }
							 up(H1) union() {
										//cylinder(d1=27,d2=24,h=H2);
										cylinder(d1=28,d2=25,h=H2,$fn=12);
							 }
							 up(H1+H2)
										adapter();
					}
					up(-1)cylinder(d=8,h=H1+H2+H3+2);
					//up(H1+H2+H3-0.2)cylinder(d=18,h=2);
		 }
}

adapter_X();
