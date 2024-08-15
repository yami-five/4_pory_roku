pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
t=0
len=0x00
function _init()
   pal(0,7,2) 
   pal(5,10,2)
end
function _update()
   t+=1 
end
function _draw()
    cls()
    poke(0x5f5f,0x10)
    local len,mem_sec=(2<<(flr(t*2.8)%8))-1,0x5f70+flr(t*2.8/8)
    poke(mem_sec,len)
    if(len<=3 and mem_sec!=0x5f70)then poke(mem_sec-1,0xff) end
    printh(flr(t*2.8/8).. " "..flr(t*2.8).." "..(flr(t*2.8)%8).." "..len,"loggg.txt")
    if(len>0xff) then len=0x00 end
    rectfill(0,0,127,flr(t*2.8),5)
end

--0b00000000 0
--0b00000001 1
--0b00000011 3
--0b00000111 7 
--0b00001111 15
--0b00011111 31
--0b00111111 
--0b01111111
--0b11111111 