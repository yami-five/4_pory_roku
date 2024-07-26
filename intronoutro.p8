pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

function melting()
	if (melted>=60) then memcpy(0x8080,0x8000,0x1f7f)
	else
		for i = 0, 63, 1 do
			if delays[i+1]==0 then
				for j = 128, 0, -1 do
					poke(0x8000+i+(j-1)*64, @(0x8000+i+(j-2)*64))
					poke(0x8000+(i+1+(j-1)*64), @(0x8000+(i+1+(j-2)*64)))
				end
			else
				delays[i+1]+=1
				if(delays[i+1]==0) then melted+=1 end
			end
		end
	end
	memcpy(0x6000,0x8000,0x2000)
end

function gen_delays()
	delays={}
	for i = 1, 65, 1 do
		delay=flr(rnd(30)) - 29
		if(delay==0)then melted+=1 end
		add(delays, delay)
	end
end

function intro()
	if(mp>=4 and mp<6)then
		load_gfx(logo,24576)
		if(mp==4) then
			fade_in()
		else fillp()
		end
	elseif(mp>=6 and mp<10)then
		melting()

	elseif(mp>=10 and mp<12)then
        spr(0,0,0,16,16)
		if(mp==10) then
			fade_in()
		else fillp()
		end
	elseif(mp>=12 and mp<16)then
		if(t==0) then 
			memcpy(0x8000,0x0000,0x2000)
		end
		melting()
	
	elseif(mp>=16 and mp<20)then
        memcpy(0x6000,0x8000,0x2000)
		print("CODE",48,15,7)
		print("MUSIC",64,25,7)
		print("GFX",86,35,7)
		spr(4*(ceil(t*0.25)%3),20,47,4,4)
		poke(0x5f34,0x2)
		circfill(36,72,t*2,0 | 0x1800)
	end
end

function outro()
	draw_chicken()
	for i=1,#text_outro do
		print(text_outro[i],128-t*2+8*(i-1),sin((t*2+8*(i-1))*0.025)*4+64,7)
	end
end