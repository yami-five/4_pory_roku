pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
max_iter=48
s=2
cx=0
cy=0.75
stage=1
x=0
function julia(z1,z2)
    local z={z1,z2}
    local n=0
    while((z[1]*z[1]+z[2]*z[2])<=4 and n<max_iter) do
        tempZx=z[1]*z[1]-z[2]*z[2]+cx
        z[2]=z[1]*z[2]*2+cy
        z[1]=tempZx
        n+=1
    end
    return n
end

function _update()
    s*=0.9
    x+=0.0005
    -- cx+=0.01
    -- if(flr(stage)==1)then
    --     cy+=0.05
    -- elseif(flr(stage)==2)then
    --     cy-=0.05
    --     cx+=0.05
    -- elseif(flr(stage)==3)then
    --     cx-=0.05
    -- end
    -- stage+=0.025
end

function hex(value)
	result=tostr(value,true)
	result=sub(result,6,6)
    -- printh(result,"loggg.txt")
	return result
end

function _draw()
    cls()
    local rs = -1
    local re = 1
    local is = -1
    local ie = 1
    -- for i=-1,1,0.5 do
    --     for j=-1,1,0.5 do
    for i=1,127,2 do
        for j=1,127,2 do
            local z1=rs + (i*0.0078) * (re - rs)
            local z2=is + (j*0.0078) * (ie - is)
            n=julia(z1*s+x,z2*s)
            -- local color = hex(n%16)
            local color = n%16
            -- poke(0x6000+j*0x40+i,"0x"..color..color)
            -- poke(0x6000+(j+1)*0x40+i,"0x"..color..color)
            pset(i,j,color)
            pset(i+1,j,color)
            pset(i,j+1,color)
            pset(i+1,j+1,color)
            -- pset(i,j,color)
            -- pset(i,128-j,color)
            -- print(j/128)
            -- print(c1.." "..c2.." "..n.." "..color.." "..i.." "..j)
        end
    end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
