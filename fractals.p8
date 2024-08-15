pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
max_iter,s,cx,cy,stage=32,1.05,-1.9,0,1
function mandelbrot(c)
    local z,n={0,0},0
    while((z[1]*z[1]+z[2]*z[2])<=4 and n<max_iter) do
        z[1]=z[1]*z[1]-z[2]*z[2]+c[1]
        z[2]=z[1]*z[2]*2+c[2]
        n+=1
    end
    return n
end

function fractal1()
    s*=.8
    local rs,re,is,ie = -2,2,-1,1
    for i=0,63,1 do
        for j=0,63,2 do
            local c1=rs + ((i+65)*0.008) * (re - rs)
            local c2=is + (j*0.008) * (ie - is)
            n=mandelbrot({c1*s+cx,c2*s+cy})
            local color1 = tostr(n%16,true)[6]
            poke(0x6000+j*0x40+i,"0x"..color1..color1)
            poke(0x6000+(j+1)*0x40+i,"0x"..color1..color1)
            poke(0x7fc0-j*0x40+i,"0x"..color1..color1)
            poke(0x7fc0-(j+1)*0x40+i,"0x"..color1..color1)
        end
    end
end
function julia(z1,z2)
    local z,n={z1,z2},0
    while((z[1]*z[1]+z[2]*z[2])<=4 and n<max_iter) do
        tempZx=z[1]*z[1]-z[2]*z[2]+cx
        z[2]=z[1]*z[2]*2+cy
        z[1]=tempZx
        n+=1
    end
    return n
end

function fractal2()
    x+=0.0005
    s*=0.9
    -- local rs,re,is,ie = -1,1,-1,1
    -- local rers,ieis=2,2
    for i=33,97,2 do
        for j=1,127,2 do
            -- local z1,z2=rs + (i*0.0078) * (re - rs),is + (j*0.0078) * (ie - is)
            local z1,z2=(i*0.0078)*2-1,(j*0.0078)*2-1
            n=julia(z1*s+x,z2*s)
            local color = n%16
            pset(i,j,color)
        end
    end
end


-- t,cx,cy,s,x=0,0,0.75,2,0
-- function _update()
--     t+=1
-- end
-- function _draw()
--     cls()
--     fractal2()
-- end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
