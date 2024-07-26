pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- t=0
thunder,t_x="",0
-- function _update()
--     t+=1 
--     update_thunder()
-- end
function draw_thunder()
    if(#thunder>200)then thunder='' end
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
        pset(pt[i+1],i,7)
    end
end
-- function _draw()
--     cls()
--     draw_thunder()
-- end
__gfx__
