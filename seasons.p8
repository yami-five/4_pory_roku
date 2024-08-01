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
    elseif(mp<44)then
        if(t>200 and rings>=0)then rings-=1 
        elseif(rings<30 and t>10)then rings+=1 end
        if(rings>=30 or t>200)then cls(flr(t*0.5)%7+8)
        else cls()
        end
        for i=rings,1,-1 do
            local sx = cos(7+t*0.01)
            local sy = sin(7+t*0.01)*cos(7+t*0.01)
            poke(0x5f34,0x2)
            circfill(64+sx*i,64+sy*i,200/i,flr(t*0.33+i)%7+8 | 0x1800)
        end
    elseif(mp>=44) then draw_plasma()
        if(mp<46)then 
            circfill(64,64,t*3,0 | 0x1800) 
        end
    end
end

function draw_plasma()
	for x=0,63,1 do
		for y=0,63,1 do
			c=(
				16+(16*sin(x*0.016+sin(t*0.0)))+
				16+(16*sin(y*0.008+sin(t*0.01)))+
				16+(16*sin(sqrt((x-63)%2*(x-63)%2+(y-63)%2*(y-63)%2)*0.016+sin(t*0.01)))+
				16+(16*sin(sqrt(x*x+y*y)*0.004+sin(t*0.01)))
			)*0.25
            
			pset(x*2,y*2,(c+t)%6+8)
            pset(x*2+1,y*2,(c+t)%6+8)
			pset(x*2,y*2+1,(c+t)%6+8)
            pset(x*2+1,y*2+1,(c+t)%6+8)
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

function summer()
    if(mp<76)then
        memcpy(0x6000,0x8000,0x2000)
        spr(0+64,8,40,2,2)
        spr(2+64,22,4,2,2)
        spr(4+64,38,6,2,2)
        spr(6+64,49,39,2,2)
        spr(8+64,68,18,2,2)
        spr(10+64,84,21,2,2)
        spr(12+64,89,39,2,2)
        flowers()
        birds()
		for i=1,80,2 do
			spr(112,bees[i+1]+t*3,bees[i],2,2)
		end
    elseif(mp<86)then
        fractal1()
    elseif(mp<96)then
        fractal2()
    end
end

function flowers()
    if(mp>=67)then
        pset(66,107,2)
        pset(121,101,5)
        pset(127,99,2)
        pset(79,102,5)
        pset(27,100,5)
        pset(81,111,4)
        pset(58,115,1)
        pset(50,104,2)
        pset(79,108,8)
        pset(75,110,8)
    end  
    if(mp>=70)then  
        pset(118,100,8)
        pset(109,84,8)
        pset(48,116,1)
        pset(120,82,8)
        pset(112,89,2)
        pset(58,73,1)
        pset(27,114,5)
        pset(81,109,8)
        pset(126,91,4)
        pset(70,106,8)
    end  
    if(mp>=73)then 
        pset(91,99,8)
        pset(126,84,2)
        pset(25,102,4)
        pset(88,110,4)
        pset(41,113,5)
        pset(96,103,1)
        pset(47,105,1)
        pset(60,111,4)
        pset(108,102,1)
        pset(35,106,2) 
    end
end

function birds()
    spr((flr(t*0.1)%2)%10+96,flr(t*0.1)-5,110)
    spr((flr(t*0.1)%2)%10+106,70-flr(t*0.1),96,1,1,-1) 
    spr(flr(t*0.1)%3+108,48,21)   
end

function autumn()
    local texture
    if(mp<118)then
        memcpy(0x6000,0x8000,0x2000)
        inverted_leaves()
    elseif(mp<119)then
        spr(0,0,-128+t*4,16,16)
    elseif(mp<132)then
        spr(0,0,0,16,16)
        if(mp>=122)then
            update_lens()
	        draw_lens(lens_x,lens_y)
        end
    elseif(mp==132 and t<5)then
        memset(0x6000,0x77,0x2000)
    elseif(mp>=132 and t>=5)then
        zoom_rotator(0,texture)
    end
end

function inverted_leaves()
    
    spr(0+(32*(2-flr(t*0.02)%3)),8,40,2,2)
    spr(2+(32*(2-flr(t*0.02)%3)),22,4,2,2)
    spr(4+(32*(2-flr(t*0.02)%3)),38,6,2,2)
    spr(6+(32*(2-flr(t*0.02)%3)),49,39,2,2)
    spr(8+(32*(2-flr(t*0.02)%3)),68,18,2,2)
    spr(10+(32*(2-flr(t*0.02)%3)),84,21,2,2)
    spr(12+(32*(2-flr(t*0.02)%3)),89,39,2,2)
end

function winter()
    if(mp<176)then
        memcpy(0x6000,0x8000,0x2000)
        if(mp>174)then
            draw_thunder(11,200)
        else
            draw_thunder(4,100)
        end
        if(#snow==0 or t%3==0)then
            snow=""
            for i=0,4096 do
                    snow=snow..flr(rnd(40))..","
            end
        end
        local s=split(snow)
        for i=0,63 do
            for j=1,64 do
                local c=s[i*64+j]
                if(c<=3)then
                    pset(i,j-1,c+8) 
                    pset(i+64,j-1,c+8) 
                    pset(i+64,j+63,c+8) 
                    pset(i,j+63,c+8) 
                end
            end
        end 
    elseif(mp<193)then
        draw_fire()
    end
end
function draw_thunder(c,l)
    if(#thunder>l)then thunder='' end
    if(#thunder==0)then
        t_x=flr(rnd(64))+32
        thunder=thunder..tostr(t_x)..","
    else
        for i=1,5 do
            if(flr(rnd(2))==0)then
                t_x+=1
            else
                t_x-=1
            end
            thunder=thunder..tostr(t_x).."," 
        end
    end
    local pt=split(thunder)
    for i=1,#pt-2 do
        pset(pt[i+1],i,c)
    end
end
function draw_fire()
	local w,h,hh=64,64,4096
	for x=1,w do
		fire[h*(h-1)+x]=rnd(128)%16
	end
	for y=0,h-1 do
		for x=1,w do
			local yh1=(y*h+1)
			local yhmodhh,hmodw=(yh1+h)%hh,x%w
			fire[yh1+x]=
				((fire[yhmodhh+(x+w)%w]
				+fire[((yh1+h*2)%hh)+hmodw]
				+fire[yhmodhh+(x+1)%w]
				+fire[((yh1+h*3)%hh)+hmodw])/4.2)%8
		end
	end
	for y=1,h do
		for x=1,w*2,2 do
		local yhx=y*h+x
			pset(x,y,fire[yhx])
			pset(x+1,y,fire[yhx])
			if(y%4==0)then
				pset(x,96-(y/2),fire[yhx])
			end
		end
	end
end