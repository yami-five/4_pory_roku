pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function autumn()
    if(mp<124)then
        memcpy(0x6000,0x8000,0x2000)
    end
    if(mp<118)then
        inverted_leaves()
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