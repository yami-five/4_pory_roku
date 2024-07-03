import math
vx=1
vy=-1
vz=-1
def rotate(x,y,a):
    c=math.cos(math.radians(a*360)) 
    s=math.sin(math.radians(a*360))
    return c*x-s*y, s*x+c*y
for t in range(1,3):
    qt=t*0.01
    x=vx
    y=vy
    z=vz
    y,z=rotate(y,z,qt*0.9);
    x,z=rotate(x,z,qt*0.3);
    z=z+5;
    x=x*96/z+64;
    y=y*96/z+64;
    print("x="+str(x)+" y="+str(y)+" z="+str(z))