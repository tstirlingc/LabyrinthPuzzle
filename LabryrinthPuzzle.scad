// labyrinth maze
// Add divet on outside of case for where the pin is.
// Consider possibility of putting the maze on the inside of the lid.
// Extend interior tube into the handle.

// DONE:  raise bump up by the amount the pin is scaled back
// DONE:  Add divet on outside of lid where pin is.
// TODO:  Compute apothem of octogon to determine the correct distance to move the pin outward to make a divet
// TODO:  Make the top have more space before the maze starts
// TODO:  Make the bottom have more space (move the pin further into the lid)

pi = 3.14159;

top_thickness = 2;
bottom_thickness = 2;
cylinder_thickness = 1.2;
lid_thickness = 3;

lid_top_gap = 1.0;

outside_facets = 8; // octogon

P_I = 3; // Pixel inside diameter
P_OS = 6; // Pixel outside square side length
P_O = sqrt(2)*P_OS; // Pixel outside diameter (3.8)
P_H = 2; // Pixel height (1.6)
P_S = (1/sqrt(2))*P_I; // pixel tip side length

M_Wn = 40;
// P_I=1 => 118 - 12 at top, 6 at bottom = 100 maze
// P_I=2 => 59 - 6 at top, 3 at bottom = 50 maze
rows_at_top = 5;
rows_at_bottom = 1;
M_Hn = rows_at_top + rows_at_bottom + 6; 

M_W = P_S*M_Wn;
M_H = P_S*M_Hn;
echo("M_W=",M_W);
echo("M_H=",M_H);

C_O = M_W/pi+2*P_H; // Cylinder maze outside diameter (25)
C_H = M_H; // Cylinder maze height (72.4)
C_I = C_O-2*P_H-2*cylinder_thickness; // Cylinder maze inside diameter (19.2)
echo("cylinder inside diameter ",C_I);

// layer height = 0.2mm => base_to_lid_gap = 0.6 is about right
// layer height = 0.1mm => base_to_lid_gap = 0.5 ???
base_to_lid_gap = 0.65;  

H_I = C_I; // Handle inside diameter
H_O = C_O+2*lid_thickness + base_to_lid_gap;  // Handle outside diameter (32)
H_H = 13; // Handle height (12.4)
echo("cylinder inside height ",H_H-bottom_thickness+C_H);
echo("handle outside diameter ",H_O);
echo("total outside height ",H_H+L_H);

L_I = C_O+base_to_lid_gap; // Lid inside diameter (25.7)
L_O = H_O; // Lid outside diameter
L_H = C_H+top_thickness+lid_top_gap; // lid height (76.3)
num_rows_pin_is_above_handle = rows_at_bottom;
L_pin_offset = M_H-(M_Hn-1-num_rows_pin_is_above_handle)*P_S; // how far inside the lid is the pin (4.8)

C_Ic = C_O/2-P_H;  // Cylinder inside radius of channels

channel_scale = 1.0;
pin_scale = 1.0;
pin_height_scale = 0.9;
pin_height = P_H*pin_height_scale;
echo("pin height",pin_height);
//bump_height_scale = 0.5/pin_height_scale;
//bump_height = P_H*bump_height_scale;
//echo("bump height ",bump_height);
//echo("bump_gap",pin_height-bump_height);
bump_delta = -0.20;
bump_height = pin_height + bump_delta - base_to_lid_gap;
echo("bump_delta",bump_delta);
echo("bump_height",bump_height);

//lid();
base();


//pixel();
//handle();
//maze();
//lid();
//generate_maze_mask();
//generate_maze();

module base()
{
    handle();
    generate_maze();
}

module pixel()
{
    rotate(a=[0,90,0])
    rotate(a=[0,0,45])
    cylinder(d1=P_I,d2=P_O,h=P_H,$fn=4);
}

module bump()
{
    rotate(a=[0,90,0])
    rotate(a=[0,0,45])
    translate([0,0,P_H-bump_height])
    cylinder(d1=P_I,d2=P_O,h=bump_height,$fn=4);
}

module pin()
{
    translate([L_I/2-pin_height,0,L_pin_offset])
    rotate(a=[0,90,0])
    rotate(a=[0,0,45])
    cylinder(d1=P_I,d2=P_O,h=pin_height,$fn=4);
}

module divet()
{
    alpha = 360/(2*outside_facets);
    apothem = (L_O/2)*cos(alpha)*1.01;
    translate([apothem-L_I/2,0,0])
    pin();
}

module handle()
{
    rotate(a=[0,0,360/(outside_facets*2)])
    difference()
    {
        cylinder(d=H_O,h=H_H,$fn=outside_facets);
        translate([0,0,bottom_thickness]) 
        {
            cylinder(d=H_I,h=H_H,$fn=100);
    
        }
    }
}

module lid()
{
    translate([0,0,H_H+L_H])
    rotate(a=[180,0,0])
    translate([0,0,H_H])
    {
        difference() 
        {
            union()
            {
                rotate(a=[0,0,360/(outside_facets*2)])
                {
                    difference()
                    {
                        cylinder(d=L_O,h=L_H,$fn=outside_facets);
                        translate([0,0,-top_thickness])
                        {
                            cylinder(d=L_I,h=L_H,$fn=100);
                        }
                    }
                }
                pin();
            }
            divet();
        }
    }
}

module maze()
{
    translate([0,0,H_H])
    difference()
    {
        cylinder(d=C_O,h=C_H,$fn=100);
        cylinder(d=C_I,h=C_H,$fn=100);
    }
}
// 5x 0s in horizontal direction to space out channels
// 6x 0s in vertical direciton to space out channels
// leave the bottom 3 rows empty
// leave the top 7 rows empty except for the exit
include <Labyrinth_maze.scad>

// each sub-list is a slice in the M_W direction of M_Wn points
// matrix[0] is at the top of the cylinder
module generate_maze_mask()
{
    Hn = min(len(matrix),M_Hn);
    for (i = [0:Hn-1]) 
    {
        Wn = min(len(matrix[i]),M_Wn);
        for (j = [0:Wn-1]) 
        {
            if (matrix[i][j] == 1)
            {
                rotate(a=[0,0,j*360/M_Wn])
                translate([C_Ic,0,H_H+M_H-i*P_S])
                scale(channel_scale)
                pixel();
            }
            else if (matrix[i][j] == 2)
            {
                rotate(a=[0,0,j*360/M_Wn])
                translate([C_Ic,0,H_H+M_H-i*P_S])
                scale(channel_scale)
                bump();                
            }
        }
    }
}

module generate_maze()
{
    difference()
    {
        maze();
        generate_maze_mask();
    }
}
