// labyrinth maze
// Add divet on outside of case for where the pin is.
// Consider possibility of putting the maze on the inside of the lid.
// Extend interior tube into the handle.

top_thickness = 2;
bottom_thickness = 2;

outside_facets = 8;

C_I = 19.2; // Cylinder maze inside diameter (19.2)
C_O = 25.0; // Cylinder maze outside diameter (25)
C_H = 12.4; // Cylinder maze height (72.4)

H_I = C_I; // Handle inside diameter
H_O = 32;  // Handle outside diameter (32)
H_H = 8; // Handle height (12.4)

P_I = 1; // Pixel inside diameter
P_O = 3.0; // Pixel outside diameter (3.8)
P_H = 1.6; // Pixel height (1.6)
P_S = (1/sqrt(2))*P_I; // pixel tip side length
pin_bump_offset = P_H/2;

M_W = 3.14159*(C_O-2*P_H);
M_H = C_H;
echo("M_W=",M_W);
echo("M_H=",M_H);
M_Wn = floor(M_W/P_S);
M_Hn = floor(M_H/P_S);
echo("M_Wn=",M_Wn);
echo("M_Hn=",M_Hn);

lid_top_gap = 1.0;
base_to_lid_gap = 0.6;
L_I = C_O+base_to_lid_gap; // Lid inside diameter (25.7)
L_O = H_O; // Lid outside diameter
L_H = C_H+top_thickness+lid_top_gap; // lid height (76.3)
L_pin_offset = M_H-(M_Hn-4)*P_S; // how far inside the lid is the pin (4.8)



C_Ic = C_O/2-P_H;  // Cylinder inside radius of channels

channel_scale = 1.0;
pin_scale = 1.0;

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
    cylinder(d1=P_I,d2=sqrt(2)*P_O,h=P_H,$fn=4);
}

module bump()
{
    rotate(a=[0,90,0])
    rotate(a=[0,0,45])
    translate([0,0,P_H/2])
    cylinder(d1=P_I,d2=sqrt(2)*P_O,h=P_H/2,$fn=4);
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
        translate([L_I/2-P_H,0,L_pin_offset])
        pixel();
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
