pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function set_screen_pallete(n)
	poke(0x5f5f,0x10)
	for i=5-n,4 do
		poke(0x5f7b+i,0xff)
	end
end

function reset_screen_palette()
	poke(0x5f5f,0x00)
	for i=0,15 do
		poke(0x5f70+i,0x00)
	end
end

function change_palette(palette,pal_n)
	for i=1,16 do
		pal(i-1,palette[i],pal_n)
	end
end

function letter_to_num(char)
    if(char=='g') then return '0'
	elseif(char=='h')then return '1'
	elseif(char=='i')then return '2'
	elseif(char=='j')then return '3'
	elseif(char=='k')then return '4'
	elseif(char=='l')then return '5'
	elseif(char=='m')then return '6'
	elseif(char=='n')then return '7'
	elseif(char=='o')then return '8'
	elseif(char=='p')then return '9'
	else return char
	end
end

function decompress_picture(img)
	local decompressed,cur_char,counter='',img[1],img[2]
	for i=3,#img,1 do
		if(tonum(img[i])!=nil) then counter=counter..img[i]
		else
			cur_char=letter_to_num(cur_char)
			for j=1,counter,1 do
				decompressed=decompressed..cur_char
			end
			cur_char,counter=img[i],''
		end
	end
	cur_char=letter_to_num(cur_char)
	for i=1,counter,1 do
		decompressed=decompressed..cur_char
	end
	return decompressed
end

function load_gfx(img, addr)
	for i=1,16384,2 do
		poke(addr+(i-1)/2,"0x"..img[i]..img[i+1])
	end
end

-- function load_sprites(img)
-- 	for i=1,16384,2 do
-- 		poke((i-1)/2,"0x"..img[i]..img[i+1])
-- 	end
-- end

function fade_out()
	fillp(fade[flr(t*0.1)])
	rectfill(0,0,127,127,0)
end

function fade_in()
	fillp(fade[7-ceil(t*0.1)])
	rectfill(0,0,127,127,0)
end

fade=split("0xffff.8,0xffff.8,0xffff.8,0xa5a5.8,0x0a0a.8,0x2080.8,0x0200.8")

function load_font()
	poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,96,96,48,16,8,0,0,6,0,68,0,0,0,0,0,0,0,72,78,116,36,46,114,18,32,56,84,20,56,80,74,60,0,34,21,21,42,84,84,34,0,24,36,18,78,113,33,94,0,4,8,8,0,0,0,0,0,32,16,16,8,16,16,32,0,2,4,4,8,4,4,2,0,0,0,16,124,56,40,0,0,0,16,16,124,16,16,0,0,0,0,0,0,0,8,4,0,0,0,0,126,0,0,0,0,0,0,0,0,0,8,0,0,8,8,4,4,4,2,2,0,56,68,68,66,66,34,28,0,32,48,40,32,16,16,56,0,60,66,64,32,24,4,126,0,60,66,32,56,64,34,28,0,68,68,34,62,32,16,16,0,126,2,30,32,64,70,56,0,24,100,2,58,70,66,60,0,6,120,48,14,56,4,4,0,60,66,98,28,18,34,28,0,60,66,98,92,64,38,24,0,0,16,0,0,0,16,0,0,0,16,0,0,16,8,0,0,96,24,4,24,96,0,0,0,0,60,0,60,0,0,0,0,6,24,32,24,6,0,0,0,60,66,64,48,8,0,24,28,34,89,101,125,2,28,0,0,0,56,64,120,36,162,92,2,4,8,56,72,68,36,26,0,0,0,24,4,130,98,28,128,64,64,48,44,34,50,76,0,0,24,36,18,142,98,28,32,80,16,30,120,8,10,4,0,96,144,136,72,242,132,120,4,8,8,56,72,68,36,34,0,48,0,48,16,8,4,12,48,0,48,32,64,68,68,56,2,4,8,72,56,12,148,98,16,32,32,32,16,16,40,24,0,0,32,82,156,148,148,66,0,0,0,58,68,68,68,34,0,0,0,56,68,66,34,28,0,0,120,148,144,112,8,6,0,120,36,18,18,28,160,64,0,0,0,100,152,8,8,4,0,0,48,8,72,176,132,120,0,8,208,48,28,16,144,96,0,0,4,34,18,18,146,108,0,0,32,76,80,80,48,16,0,0,0,66,132,148,88,40,0,0,0,198,40,16,42,196,0,32,70,72,80,96,34,28,0,0,50,44,16,8,156,98,0,56,8,8,8,8,8,56,0,0,0,0,16,0,0,0,0,28,16,16,16,16,16,28,0,0,8,20,34,0,0,0,0,0,0,0,0,0,126,0,0,56,48,32,0,0,0,0,64,160,160,160,144,240,136,134,62,66,68,60,68,132,130,126,56,68,4,2,130,130,68,56,62,66,132,132,132,66,50,14,126,2,4,28,4,4,130,126,158,100,8,8,56,4,4,2,56,68,4,194,178,130,68,56,130,68,68,68,124,68,66,130,112,28,16,16,32,32,32,248,24,96,192,64,68,66,34,28,98,148,20,12,28,36,162,66,6,8,8,8,72,136,132,252,130,68,172,172,148,148,132,2,130,68,72,72,88,88,100,134,48,72,132,130,130,130,68,56,60,74,144,144,80,40,8,6,24,36,66,66,66,46,148,104,60,74,144,144,80,40,168,70,112,136,4,8,114,130,132,120,224,24,22,32,32,32,32,32,136,132,130,130,130,130,68,56,70,136,136,144,80,80,48,16,96,146,132,148,184,168,72,68,2,132,104,24,24,20,164,66,132,74,48,32,32,16,18,12,242,76,32,28,40,4,180,78,0,112,124,126,126,124,112,0,24,24,24,0,24,24,24,0,0,14,62,126,126,62,14,0,0,0,14,219,112,0,0,0,28,34,93,69,93,34,28,0"))
end

function load_credits_font()
	poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,48,120,120,120,48,0,48,0,108,108,72,36,0,0,0,0,54,127,54,54,54,127,54,0,8,126,11,62,104,63,8,0,66,101,50,24,44,86,35,0,14,27,14,91,115,99,62,0,0,0,0,0,0,0,0,0,56,12,6,6,6,12,56,0,14,24,48,48,48,24,14,0,108,56,108,0,0,0,0,0,0,0,16,16,124,16,16,0,0,0,0,24,24,16,8,0,0,0,0,0,124,0,0,0,0,0,0,0,0,24,24,0,64,96,48,24,12,6,2,0,124,230,198,198,198,206,124,0,60,48,48,48,48,48,252,0,124,198,96,56,12,6,254,0,124,198,192,120,192,198,124,0,240,216,204,198,254,192,192,0,254,6,126,192,192,198,124,0,124,198,6,126,198,198,124,0,254,198,96,48,24,12,6,0,124,198,198,124,198,198,124,0,124,198,198,252,192,198,124,0,0,48,48,0,48,48,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,124,192,252,198,252,0,6,6,126,198,198,198,126,0,0,0,124,198,6,198,124,0,192,192,252,198,198,198,252,0,0,0,124,198,254,6,124,0,120,24,254,24,24,24,24,0,0,0,252,198,252,192,124,0,6,6,126,198,198,198,198,0,48,0,60,48,48,48,254,0,192,0,192,192,192,198,124,0,6,6,198,102,62,102,198,0,6,6,6,6,6,28,240,0,0,0,126,214,214,214,214,0,0,0,126,198,198,198,198,0,0,0,124,198,198,198,124,0,0,0,126,198,126,6,6,0,0,0,252,198,252,192,192,0,0,0,118,206,6,6,6,0,0,0,252,6,254,192,126,0,24,24,254,24,24,24,248,0,0,0,198,198,198,198,124,0,0,0,198,198,108,56,16,0,0,0,198,214,214,254,108,0,0,0,238,124,56,124,238,0,0,0,198,198,108,56,30,0,0,0,254,112,56,28,254,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,56,108,198,198,254,198,198,0,126,198,198,126,198,198,126,0,124,198,6,6,6,198,124,0,62,102,198,198,198,102,62,0,254,6,6,62,6,6,254,0,254,6,6,62,6,6,6,0,252,6,6,246,198,198,252,0,198,198,198,254,198,198,198,0,252,48,48,48,48,48,252,0,240,192,192,192,198,198,124,0,198,102,54,30,54,102,198,0,6,6,6,6,6,6,254,0,198,238,254,214,198,198,198,0,198,206,222,246,230,198,198,0,124,198,198,198,198,198,124,0,126,198,198,126,6,6,6,0,124,198,198,198,246,102,188,0,126,198,198,126,54,102,198,0,124,198,6,124,192,198,124,0,252,48,48,48,48,48,48,0,198,198,198,198,198,198,124,0,198,198,198,198,108,56,16,0,198,198,214,254,238,198,198,0,198,238,124,56,124,238,198,0,204,204,204,120,48,48,48,0,254,224,112,56,28,14,254,0,0,0,0,0,0,0,0,0,24,24,24,24,24,24,24"))
end
