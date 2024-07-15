pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
t=0

function _update()
	t+=1
	if t==1280 then t=0 end
end

function _draw()
	cls()
	for i=0,30,2 do
		if i/2%2==0 then
			spr((flr(t*0.1)%2+i)%10,flr(t*0.1),4*i)
		else
			spr((flr(t*0.1)%2+i)%10,127-flr(t*0.1),4*i,1,1,-1)
		end
	end
end
__gfx__
00000800000000000000080000000000000008000000000000000800000000000000080000000000000000000000000000000000000000000000000000000000
00000440400008000000066060000800000001101000080000000990900008000000055050000800000000000000000000000000000000000000000000000000
4000044a444404406000066a666606601000011a111101109000099a999909905000055a55550550000000000000000000000000000000000000000000000000
444444804444444a666666806666666a111111801111111a999999809999999a555555805555555a000000000000000000000000000000000000000000000000
44444400444440806666660066666080111111001111108099999900999990805555550055555080000000000000000000000000000000000000000000000000
04444000044a000006666000066a000001111000011a000009999000099a000005555000055a0000000000000000000000000000000000000000000000000000
00a0a00000a0a00000a0a00000a0a00000a0a00000a0a00000a0a00000a0a00000a0a00000a0a000000000000000000000000000000000000000000000000000
00a00a000a00000000a00a000a00000000a00a000a00000000a00a000a00000000a00a000a000000000000000000000000000000000000000000000000000000
