pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function spring()
    if(mp<26)then
        sky()
        if(t<64)then scroller() end
        spr(0,0,0,16,16)
    elseif(mp<34)then
        memcpy(0x6000,0x8000,0x2000)
        if(mp>27)then
            leaves()
        end
    elseif(mp<44)then
        if(t>200 and rings>=0)then rings-=2 
        elseif(rings<45 and t>10)then rings+=1 end
        for i=rings,1,-1 do
            local sx = cos(7+t*0.01)
            local sy = sin(7+t*0.01)*cos(7+t*0.01)
            poke(0x5f34,0x2)
            circfill(64+sx*i,64+sy*i,200/i,flr(t*0.33+i)%7+8 | 0x1800)
        end
    elseif(mp>=44) then draw_plasma()
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
    n=split("8,40,22,4,38,6,49,39,68,18,84,21,89,39")
    for i=1,14,2 do
        spr((i-1)+(32*(flr(t*0.02)%3)),n[i],n[i+1],2,2)
    end
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
    fl=split("66,107,2,121,101,5,127,99,2,79,102,5,27,100,5,81,111,4,58,115,1,50,104,2,79,108,8,75,110,8,118,100,8,109,84,8,48,116,1,120,82,8,112,89,2,58,73,1,27,114,5,81,109,8,126,91,4,70,106,8,91,99,8,126,84,2,25,102,4,88,110,4,41,113,5,96,103,1,47,105,1,60,111,4,108,102,1,35,106,2")
    if(mp>=67)then
        for i=1,30,3 do
            pset(fl[i],fl[i+1],fl[i+2])
        end
    end  
    if(mp>=70)then  
        for i=31,60,3 do
            pset(fl[i],fl[i+1],fl[i+2])
        end
    end  
    if(mp>=73)then 
        for i=61,90,3 do
            pset(fl[i],fl[i+1],fl[i+2])
        end
    end
end

function birds()
    spr((flr(t*0.1)%2)%10+96,flr(t*0.1)-5,110)
    spr((flr(t*0.1)%2)%10+106,70-flr(t*0.1),96,1,1,-1) 
    spr(flr(t*0.1)%3+108,48,21)   
end

function autumn()
    local texture
    if(mp<117)then
        memcpy(0x6000,0x8000,0x2000)
        inverted_leaves()
    elseif(mp<120)then
        memcpy(0x6000,0x8000,0x2000)
        local len,mem_sec=(2<<(flr(t*2.8)%8))-1,0x5f70+flr(t*2.8/8)
        poke(mem_sec,len)
        if(len<=3 and mem_sec!=0x5f70)then poke(mem_sec-1,0xff) end
        if(len>0xff) then len=0x00 end
        spr(0,0,-128+flr(t*2.8),16,16,true,false)
    elseif(mp<132)then
        spr(0,0,0,16,16,true,false)
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
    local n=split("8,40,22,4,38,6,49,39,68,18,84,21,89,39")
    for i=1,14,2 do
        spr((i-1)+(32*(2-flr(t*0.02)%3)),n[i],n[i+1],2,2)
    end
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
	for y=1,h do
		for x=0,w-1 do
			local yh1=(y*h+1)
			local yhmodhh,hmodw=(yh1+h)%hh,x%w
			fire[yh1+x]=
				((fire[yhmodhh+(x+w)%w]
				+fire[((yh1+h*2)%hh)+hmodw]
				+fire[yhmodhh+(x+1)%w]
				+fire[((yh1+h*3)%hh)+hmodw])/4.2)%8
		end
	end
	for y=0,63 do
		for x=0,63 do
		    local yhx=(y+1)*h+x+1
            c=fire[yhx]
			pset(x*2,y*2-12,c)
			pset(x*2+1,y*2-12,c)
			pset(x*2,y*2-11,fire[yhx])
			pset(x*2+1,y*2-11,fire[yhx])
		end
	end
    for i=0,20,1 do
        memcpy(0x7fc0-64*i,0x6000+256*i+2048,0x40)
    end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ee000000000000000ee330000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ee00000000000ee00ee300000000000000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000eee0000000000ee00e30000000000000000000000000000000000000000000000ee0ee00000000ee0000eee0000000000000000000000000000000000000
0000ee30000000000e30030000000000000000000e30000000000000eee000000000eeeeeee0000000ee300eee30000000000eee300000000000000000000000
0000333000000000003e0000000000000000000003300000000000eeee3000000000eee03300000000e3300e33000000000000ee300000000000000000000000
00000ee00000000000e33000000000000000000000000000000000ee333000000000e33000000e00000000ee000000000000e0e3300000000000000000000000
0000033e000e300000003000000000000000000ee0000000000000ee3000000000000000000eeee000000000ee000000000ee033000000000000000000000000
00000000000e300000000e00000000e03000000eee00000000000000000000000000ee00000eee000e0000003000000000000000000000000000000000000000
000000000003000000e0ee0000000ee0300000000e0e00000000ee000000000000000000000ee3000ee000e000000000000ee000000000000000000000000000
000000000000000000e000000000000e00000000003e00000000e30000000000000000e00000e0000e3000000000000000003000000000000000000000000000
0000000000000000000000000000000300000000000000000000000000000000000000000000e00000e0000e0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000eeee000000000000000eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ee00000000000eeeeee30000000000000003eeeee30000000000000000000000000eee00000000ee0000eee0000000000000000000000000000000000000
000eeeeee0000000eeeeeee00000000000000000ee3ee300000000000000000000000eeeee00000000ee300eee30000000000000000000000000000000000000
000eeeeee0000000eeeeee3000000000e000000eee3ee30000000000eee000000000eeeeeee0000000e3300eee30000000000eee300000000000000000000000
0000eeeeee000000eeeee33000000000ee00000e333e3300000000eeee3000000000eeee3300000000e300eeee3000000000eeee300000000000000000000000
0000eeee3e000000ee3333e300000eeeee30000eeee330000000eeeee33000000000ee3330000ee000e3000ee30000000000eeee300000000000000000000000
0000eee33e0e3000eeeeeee3000eeeeeee30000eee3000000000eeeeee0000000000ee33000eeee00ee3000e33000000000eeee3000000000000000000000000
0000000eeeee3000eeeeee33000eeeee333000eeee3000000000eee3e30000000000e333000eee300e3000ee30000000000eee30000000000000000000000000
0000000eeee30000eeeee33000eeeeee333000eeee3300000000eee333000000000000e3000eee300e3000e330000000000e3300000000000000000000000000
0000000eee330000e333330000ee3eee000000eee33300000000e333e0000000000000330000e33000e000e30000000000003000000000000000000000000000
00000003333000000000000000eee3330000000e3330000000000000000000000000000000003330000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000eeeeee000000000eee00000000000000000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0eeeeeeeeeee0000000eeeeeee0000000000000eeeeee000000000ee000000000000000000000000000000000000000000000000000000000000000000000000
0eeeeeeeeeee00000eeeeeeeeeeee000eee00003eeeeeee00000eeeeeee00000000000000000000000ee0000eee0000000000000000000000000000000000000
0eeeeeeeeeee0000eeeeeeeeeeeeeee0eee0000eee3ee3e0000eeeeeeeee000000000e0eee000000eeeeee0eee30000000000eeee00000000000000000000000
0eeeeeee3eeee000eeeeee3eee33eeeeeee3eeeeee3ee3e000eeeeeeeeeee000000eeeeeeeee0000eeeeeeeee330000000000eeeee0000000000000000000000
0eeeeeee3eee3000eeeee3eeeee3eeeeee33eeee333e3e3000eeeeeee3ee300000eeeeeeeeeee0003eee3eeee33000000000eeeeee0000000000000000000000
00eeeeee3eee3000ee3333eeee33eeeeee3ee3eeeee33e3000eeeeeee3ee300000eeeeee3eeeee0e3eee3eeee3ee00000000eeeeeee000000000000000000000
000ee333eeee3000eeeeeee3eeeee3eeee3ee3eeee3eee3000eeeee3e3e33000000eee33eeeee3eeeeee3ee333eeee00000eeee3e33000000000000000000000
000eeeeeeeee3000eeeeee3eeeeee3ee333eeeeeee3ee33000eeeee3333300000000eeeeeeee33eeeeeeeee3eeeee300000eeeee33e000000000000000000000
000eeeeeeee33000eeeee33eeeeee3ee3eeeeeeeee3e3300000ee3eee33300000000e33eee333eee0e3eeeeeeeeee300000e3303330000000000000000000000
00000eeeee330000e33333eeeeee33ee00eeeeee333e3000000eeeee33300000000000e3eeeeeeee0033eee33333330000003000000000000000000000000000
00000003333000000000000333e33333000333333ee30000000e333330000000000000330eeeeee3000033e00000000000000000000000000000000000000000
00000000000000000000000003330000000000000000000000000000000000000000000000003333000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000800000000000000080000000000000008000000000000000800000000000000080000000000000000000000000000aa000000000000000aa00000000000
000004404000080000000660600008000000011010000800000009909000080000000550500008000000000000000000008a0000000aa000000a888000000000
4000044f444404406000066f666606601000011f111101109000099f999909905000055f555505500000000000000000080a0000000a8000000aa00000000000
444444804444444f666666806666666f111111801111111f999999809999999f555555805555555f0000000000000000000a1000000a1800000a100000000000
444444004444408066666600666660801111110011111080999999009999908055555500555550800080000000000000000a1100000a1100000a110000000000
04444000044f000006666000066f000001111000011f000009999000099f000005555000055f0000005f000000800000000aa100000aa100000aa10000000000
00f0f00000f0f00000f0f00000f0f00000f0f00000f0f00000f0f00000f0f00000f0f00000f0f00055000000555f000000008000000080000000800000000000
00f00f000f00000000f00f000f00000000f00f000f00000000f00f000f00000000f00f000f0000000f0000000f00000000008000000080000000800000000000
01111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00110010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001001100000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005f5000ff0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f5f550ffff055500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5f55f5ffffff51150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55f5f5ffffff51150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55f55f5ffff551150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
055f5f50ff0055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000100101005100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001000100100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000100100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
