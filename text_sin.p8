pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
t=0
function _init()
	text_outro=split("T,h,a,n,k,s, ,f,o,r, ,w,a,t,c,h,i,n,g, , , ,I,t, ,w,a,s, ,n,e,w, ,p,r,o,d,u,c,t,i,o,n, ,f,r,o,m, ,A,b,e,r,r,a,t,i,o,n, ,C,r,e,a,t,i,o,n,s, , , ,M,a,d,e, ,b,y, ,Y,a,m,i,F,i,v,e, , , ,F,i,r,s,t, ,p,r,e,s,e,n,t,e,d, ,a,t, ,X,e,n,i,u,m, ,2,0,2,4")
	-- text_outro=split("a,b,c,d,e,f")
end
function _update()
	t+=1
end
function _draw()
	cls()
	for i=1,#text_outro do
		print(text_outro[i],128-t+8*(i-1),sin((t+8*(i-1))*0.025)*4+64,7)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
