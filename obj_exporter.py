vertices=[]
faces=[]
vt=[]
uv=[]
with open("assets/torus3_6.obj") as f:
    while line:=f.readline():
        if line[0:2]=='v ':
            vertex=line.split()
            vertices.append(round(float(vertex[1]),2))
            vertices.append(round(float(vertex[2]),2))
            vertices.append(round(float(vertex[3]),2))
        elif line[0]=='f':
            face=line.split()
            faces.append(int(face[3].split('/')[0])-1)
            uv.append(int(face[3].split('/')[1])-1)
            faces.append(int(face[2].split('/')[0])-1)
            uv.append(int(face[2].split('/')[1])-1)
            faces.append(int(face[1].split('/')[0])-1)
            uv.append(int(face[1].split('/')[1])-1)
        elif line[0:2]=='vt':
            vt.append(round(float(line.split()[1]),2))
            vt.append(round(float(line.split()[2]),2))
print(vertices)
print(len(vertices)//3)
print(faces)
print(len(faces)//3)
print(vt)
print(uv)