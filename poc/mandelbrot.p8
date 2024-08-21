pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
max_iter=32
s=1.05
cx=-1.9
cy=0
function mandelbrot(c)
    local z={0,0}
    local n=0
    while((z[1]*z[1]+z[2]*z[2])<=4 and n<max_iter) do
        z[1]=z[1]*z[1]-z[2]*z[2]+c[1]
        z[2]=z[1]*z[2]*2+c[2]
        n+=1
    end
    return n
end

function _update()
    s*=0.925
end

function hex(value)
	result=tostr(value,true)
	result=sub(result,6,6)
    -- printh(result,"loggg.txt")
	return result
end

function _draw()
    cls()
    local rs = -2
    local re = 2
    local is = -1
    local ie = 1
    -- for i=-1,1,0.5 do
    --     for j=-1,1,0.5 do
    for i=0,63,1 do
        for j=0,63,2 do
            local c1=rs + ((i+65)*0.008) * (re - rs)
            local c2=is + (j*0.008) * (ie - is)
            n=mandelbrot({c1*s+cx,c2*s+cy})
            local color1 = hex(n%16)
            -- local c1=rs + ((i+1)*0.0078) * (re - rs)
            -- n=mandelbrot({c1*s+cx,c2*s+cy})
            -- local color2 = hex(16-n)
            poke(0x6000+j*0x40+i,"0x"..color1..color1)
            poke(0x6000+(j+1)*0x40+i,"0x"..color1..color1)
            poke(0x7fc0-j*0x40+i,"0x"..color1..color1)
            poke(0x7fc0-(j+1)*0x40+i,"0x"..color1..color1)
            -- pset(i,j,color)
            -- pset(i,128-j,color)
            -- print(j/128)
            -- print(c1.." "..c2.." "..n.." "..color.." "..i.." "..j)
        end
        -- printh(i,"loggg.txt")
    end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
