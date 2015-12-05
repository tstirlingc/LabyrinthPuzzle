// labyrinth maze
// Add divet on outside of case for where the pin is.
// Consider possibility of putting the maze on the inside of the lid.
// Extend interior tube into the handle.

top_thickness = 2;
bottom_thickness = 2;

outside_facets = 8;

C_I = 19.2; // Cylinder maze inside diameter
C_O = 25.5; // Cylinder maze outside diameter
C_H = 12.4; // Cylinder maze height (72.4)

H_I = C_I; // Handle inside diameter
H_O = 32;  // Handle outside diameter
H_H = 12.4; // Handle height

L_I = 25.7; // Lid inside diameter
L_O = H_O; // Lid outside diameter
L_H = C_H+top_thickness; // lid height (76.3)
L_pin_offset = 4.8; // how far inside the lid is the pin

P_I = .8; // Pixel inside diameter
P_O = 3.6; // Pixel outside diameter
P_H = 1.2; // Pixel height
P_S = (1/sqrt(2))*P_I; // pixel tip side length

M_W = 3.14159*(C_O-2*P_H);
M_H = C_H;
M_Wn = M_W/P_S;
M_Hn = M_H/P_S;

C_Ic = C_O/2-P_H;  // Cylinder inside radius of channels

channel_scale = 1.05;
pin_scale = 1.0;

//pixel();
handle();
//maze();
//lid();
//generate_maze_mask();
generate_maze();

module pixel()
{
    rotate(a=[0,90,0])
    rotate(a=[0,0,45])
    cylinder(d1=P_I,d2=sqrt(2)*P_O,h=P_H,$fn=4);
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
matrix = [ 
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
[1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] ];
// each sub-list is a slice in the M_W direction of M_Wn points
// matrix[0] is at the top of the cylinder
module generate_maze_mask()
{
    Hn = len(matrix);
    for (i = [0:Hn-1]) 
    {
        Wn = len(matrix[i]);
        for (j = [0:Wn-1]) 
        {
            if (matrix[i][j] != 0)
            {
                rotate(a=[0,0,j*360/M_Wn])
                translate([C_Ic,0,H_H+M_H-i*P_S])
                scale(channel_scale)
                pixel();
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
