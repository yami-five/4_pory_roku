pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
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
