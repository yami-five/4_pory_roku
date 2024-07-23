pico-8 cartridge // http://www.pico-8.com
version 42
__lua__


w=64
h=48
t=0
fire={}
p="0,0,8,9,10,7,7,7,7,7,7,7,7,7,7,7"
r="0,0,2,8,9,6,6,6,6,6,6,6,6,6,6,6"


function _init()
	for x=1,w,1 do
		add(fire,{})
		for y=1,h,1 do
			add(fire[x],0)
		end
	end
	p=split(p)
	r=split(r)
end

function _update()
 //t+=1
end

function _draw()
	cls()
	draw_fire()
end

function draw_fire()
	for x=1,w,1 do 
		fire[x][h] = abs(32768+rnd(128))%16
	end
	for x=1,w,1 do	
		for y=1,h,1 do
			fire[x][y]=
				(fire[(x+w)%w+1][(y+1)%h+1]
				+fire[x%w+1][(y+1)%h+1]
				+fire[(x+1)%w+1][(y+1)%h+1]
				+fire[x%w+1][(y+2)%h+1])/4.2
		end
	end
	for x=1,w,1 do
		for y=1,h,1 do
			pset(2*x-1,2*y-1,p[flr(fire[x][y]+.5)])
			pset(2*x-1,2*y,p[flr(fire[x][y]+.5)])
			pset(2*x,2*y-1,p[flr(fire[x][y]+.5)])
			pset(2*x,2*y,p[flr(fire[x][y]+1.5)])
		end
	end
	-- for y=20,h,1 do
	-- 	for x=1,w,1 do
	-- 		pset(2*x-1,140-y,r[flr(fire[x][y]+1.5)])
	-- 		pset(2*x,140-y,r[flr(fire[x][y]+1.5)])
	-- 	end
	-- end
	line(0,127,127,127,0)
end