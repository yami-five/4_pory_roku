vertices=[]
faces=[]
vt=[]
uv=[]
with open("assets/chicken6.obj") as f:
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
# text=""
# for x in vertices:
#     text+=str(x)+','
# print(text[:-1])
# print(len(vertices)//3)
# text=""
# for x in faces:
#     text+=str(x)+','
# print(text[:-1])
# print(len(faces)//3)
text=""
for x in vt:
    text+=str(x)+','
print(text[:-1])
# text=""
# for x in uv:
#     text+=str(x)+','
# print(text[:-1])