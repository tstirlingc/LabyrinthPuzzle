P_I = .5;
P_O = 2;
P_H = 1;

module pixel()
{
    intersection()
    {
        cylinder(d1=P_I,d2=P_O,h=P_H,$fn=100);
        cylinder(d1=P_I,d2=sqrt(2)*P_O,h=P_H,$fn=4);
    }
}
pixel();