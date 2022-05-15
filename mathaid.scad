$fn = 100;

include <MCAD/involute_gears.scad>

MAKE_BASE = true;
MAKE_GEARS = false;
MAKE = [true, false, true];

GEARS = [
     [10,  5.55556, [1,1,0]],
     [15,  8.33333, [1,0,1]],
     [20, 11.11111, [0,1,1]]
     ];

COLOR_OF_BASE = [0.5, 0.5, 0.5];

function mygear_nteeth(gear) = gear[0];
function mygear_radius(gear) = gear[1];
function mygear_color(gear) = gear[2];

function mygear_max_radius(idx, val) = (idx >= len(GEARS)) ? val : ( !MAKE[idx] ? mygear_max_radius(idx+1, val) : (val < GEARS[idx][1] ? mygear_max_radius(idx + 1, GEARS[idx][1]) : mygear_max_radius(idx+1, val) ) );

function _mygear_0(idx, add) = (idx >= len(GEARS)) ? [] : MAKE[idx] ? concat([[idx, add + GEARS[idx][1]]], _mygear_0(idx + 1, add + 2 * GEARS[idx][1])) : _mygear_0(idx + 1, add);

function mygear_accumulate_radius() = _mygear_0(0, 0);

function sum_printable(idx) = (idx >= len(MAKE)) ? 0 : ( ((MAKE[idx]) ? 2*GEARS[idx][1] : 0) + sum_printable(idx + 1));

module up()
{
     translate([0, 0, 2])
     {
          children();
     }
}

module make_gear(teeth)
{
     difference()
     {
          linear_extrude(5)
          {
               gear(number_of_teeth = teeth, circular_pitch = 200, flat=true, bore_diameter = 5 / 2);
          }
          if(teeth / 5 >= 3)
          {
               nsteps = 6;
               for(i = [0:1:nsteps])
               {
                    rotate([0, 0, 360 / nsteps * i])
                    {
                         translate([teeth/3.2,0,-1])
                         {
                              cylinder(r=teeth / 10, h = 10);
                         }
                    }
               }
          }
     }
     rotate([0,0,360/12])
     {
          translate([teeth/2.9,0,0])
          {
               cylinder(r=10 / 12, h=10);
          }
     }
}

module mygear_spread_children(domake)
{
     radii = mygear_accumulate_radius();
     if(MAKE[domake])
     {
          move = lookup(domake, radii);
          translate([move, 0, 0])
          {
               rotate([0, 0, 360 / 10 * 0.5])
               {
                    children();
               }
          }
     }
}

if(MAKE_GEARS) scale([2,2,1]) up(2)
               {
                    for(domake = [0 : 1 : len(MAKE) - 1])
                    {
                         if(MAKE[domake])
                         {
                              mygear_spread_children(domake) color(mygear_color(GEARS[domake]))
                              {
                                   make_gear(mygear_nteeth(GEARS[domake]));
                              }
                         }
                    }
               }

HOLE_RADIUS = (2.5 - 0.2) / 2;

if(MAKE_BASE)
{
     BASE_LEN = sum_printable(0);
     BASE_WID = mygear_max_radius(0, 0);
     color(COLOR_OF_BASE)
     {
          scale([2,2,1]) union() {
               translate([BASE_LEN/2,0,0])
               {
                    cube([BASE_LEN,BASE_WID*2,2], center=true);
               }
               for(domake = [0 : 1 : len(MAKE) - 1])
               {
                    if(MAKE[domake])
                    {
                         mygear_spread_children(domake) cylinder(r = HOLE_RADIUS, h=8);
                    }
               }
          }
     }
}
