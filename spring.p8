pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function spring()
    if(mp<26)then
        sky()
        scroller()
        spr(0,0,0,16,16)
    elseif(mp<34)then
        memcpy(0x6000,0x8000,0x2000)
        if(mp>27)then
            leaves()
        end
    elseif(mp<52)then
        if(t>200 and rings>=0)then rings-=1 
        elseif(rings<30 and t>10)then rings+=1 end
        if(rings>=30 or t>200)then cls(flr(t*0.5)%7+8)
        else cls()
        end
        if(t>200 and rings<1)then draw_plasma() end
        for i=rings,1,-1 do
            local sx = cos(7+t*0.01)
            local sy = sin(7+t*0.01)*cos(7+t*0.01)
            poke(0x5f34,0x2)
            circfill(64+sx*i,64+sy*i,200/i,flr(t*0.33+i)%7+8 | 0x1800)
        end
    end
end

function draw_plasma()
	for y=16,111,1 do
		for x=16,111,1 do
			c=(
				16+(16*sin(x*0.016-t))+
				16+(16*sin(y*0.008-t))+
				16+(16*sin((x%2+y%2)*0.016-t))+
				16+(16*sin(sqrt(x*x+y*y-t)*0.008))
			)*0.25
			pset(x,y,(c+t)%6+8)
		end
	end
end

function scroller()
    for i=1,128,1 do
        memcpy(0x0000+(0x40*(i-1+1)),img1+t+(0x40*(i-1+1)),0x40-t)
        memcpy(0x0040-t+(0x40*(i-1+1)),img2+(0x40*(i-1+1)),t)
    end
end

function sky()
    fillp(-24416)
    rectfill(0,0,128,4,7+12*16)
    fillp(-23391)
    rectfill(0,4,128,9,7+12*16)
    fillp(-23131)
    rectfill(0,9,128,14,7+12*16)
    fillp(21080)
    rectfill(0,14,128,19,12+7*16)
    fillp(20560)
    rectfill(0,19,128,24,12+7*16)
    fillp(4160)
    rectfill(0,24,128,29,12+7*16)
    fillp()
    rectfill(0,29,128,50,12)
    fillp(4160)
    rectfill(0,50,128,55,12+13*16)
    fillp(20560)
    rectfill(0,55,128,60,12+13*16)
    fillp(21080)
    rectfill(0,60,128,65,12+13*16)
    fillp(-23131)
    rectfill(0,65,128,70,12+13*16)
end
function leaves()
    
    spr(0+(32*(flr(t*0.02)%3)),8,40,2,2)
    spr(2+(32*(flr(t*0.02)%3)),22,4,2,2)
    spr(4+(32*(flr(t*0.02)%3)),38,6,2,2)
    spr(6+(32*(flr(t*0.02)%3)),49,39,2,2)
    spr(8+(32*(flr(t*0.02)%3)),68,18,2,2)
    spr(10+(32*(flr(t*0.02)%3)),84,21,2,2)
    spr(12+(32*(flr(t*0.02)%3)),89,39,2,2)
end