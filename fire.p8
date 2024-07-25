pico-8 cartridge // http://www.pico-8.com
version 42
__lua__


w,h,fire=64,64,{}
hh=h*h

function _init()
	for i=1,hh do
		fire[i]=0 
	end
	pal(1,8,1)
	pal(2,137,1)
	pal(3,9,1)
	pal(4,10,1)
	pal(5,135,1)
	pal(6,7,1)
	pal(8,7,1)
end

function _draw()
	cls()
	draw_fire()
end



function draw_fire()
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
