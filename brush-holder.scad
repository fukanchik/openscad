/**
 * Hand Saw Brush Holder replacement part.
 */
xlength=16;

ywidth=12;
holeyw=4;
holeywsmall=2;
botthick=2;
pinywidth=16.5;
zheight=18.6;

eps=0.01;

difference() {
   union() {
	cube([xlength, ywidth, zheight]);
	translate([0, -(pinywidth-ywidth)/2, 0])
		cube([xlength, pinywidth, 4]);
   }
   translate([2.5, 2.5, 18.6-17])
	cube([10.5, 6.8, 17+eps]);

   translate([-eps,(ywidth-holeyw)/2,botthick])
	cube([3,holeyw,4]);
   translate([-eps,(ywidth-holeywsmall)/2,botthick])
	cube([3,holeywsmall,7]);

   translate([-eps,-sqrt(2)*2,-sqrt(2)*2])
	rotate([45,0,0])
		cube([xlength+eps+eps, 4, 4]);
   translate([-eps,ywidth+sqrt(2)*2,-sqrt(2)*2])
	rotate([45,0,0])
		cube([xlength+eps+eps, 4, 4]);

   translate([-eps,(ywidth-4)/2,zheight-0.7])
	cube([xlength+eps+eps, 4, 1]);
}
