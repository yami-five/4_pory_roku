pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
tex='677765677656777677776566665677777777655ee55677777776555ee55567776665555ee55556665555555665555555665555677655556676eee6e77e6eee6776eee6eeee6eee676655556ee655556655555556655555556665555ee55556667776555ee55567777777655ee556777777776566665677776777656776567776'
chicken_tex='5555555555555555555555555555555555555555555555545555335555555b5555554455555544545533b5555555545555555455555554445353b5555545595555555333333b554533b5555555555a55555535b55555b553555b55b5555454555553b5b5555b5b3bb5b55555555454555535b55b5bb5bb5b5bb5b55555554555553555555b55555555555555555545555355555555555b555555b555559544555355555555bbb55555bbb555554554553555555b55555bb5555553b5554454553b555b55555555b555b3533b554455553bbb555b5bbbb3555555b353b5445555b555b55555555bbb55bbb5b3b5444555b55555355b5555bb55535b5b33555555bb555555b5b555b5555b5353b3b55555355555d55555555555bbb53533554a55355555555555555555b33bb53bb544553555b555555555555b335b3535555b5535555b5bb55555555bb5b3533bb545553555b55555b5555555b553b5bbb545553355555555555555555b555bbb5555555222555555555555b555555555555555544455555555555555555555555555555555555555555b55555555555b5b5555555b4e55565d555555555555555555555555bb55d55d65d5555444445555555555552b5dd56ddd55555444444454555555552255655d6d5555554444545455555555524225ddd555555555555555555555555555555555555555555555555555'
-- t=0
-- function _init()
--     -- pal(2,8,1)
--     -- pal(3,5,1)
--     -- pal(4,9,1)
--     -- pal(5,6,1)
--     -- pal(11,134,1)
--     -- pal(14,130,1)
--     -- pal(split("0,129,128,132,132,128,5,129,136,137,137,11,1,137,4,132"),2)
--     -- poke(0x5f5f,0x10)
-- 	-- for i=0,4 do
-- 	-- 	poke(0x5f7b+i,0xff)
-- 	-- end
--     tex=zoom_rotator_texture()
-- end
function zoom_rotator_texture()
    local texture=""
    for i=0,0x2000,1 do
        texture=texture..sub(tostr(@i,true),5,6)
    end
    return texture
end

function texturing(x,yp2y,inv,p0,p1,p2,uv0,uv1,uv2,tex_size,texture,fac,tsts)
    local Ba,Bb=((p1[2]-p2[2])*(x*2+fac-p2[1])+(p2[1]-p1[1])*yp2y)*inv,((p2[2]-p0[2])*(x*2+fac-p2[1])+(p0[1]-p2[1])*yp2y)*inv
    local Bc=1-Ba-Bb
    local uv_x,uv_y=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1],Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
    uv_x = max(0, min(1, uv_x))
    uv_x=flr(uv_x*tex_size+0.5)+1
    uv_y = max(0, min(1, uv_y))
    uv_y=flr(uv_y*tex_size+0.5)+1
    return texture[max(0, min(tsts, flr(uv_y *tex_size + uv_x+0.5)))]
end

function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,l_int,tex_size,texture,fast,tsts)
    if (y<0 or y>127) return
    local q,n
    local yp2y=y-p2[2]
    n=(flr(y)%2+0.5)*0.5
    x0+=n;
    x1+=n;
    if (x1<x0) q=x0 x0=x1 x1=q
    if (x1<0 or x0>127) return
    y=flr(y+0.5);
    if (x0<0) x0=0
    if (x1>123) x1=123
    x0,x1=flr(x0/2+0.5),flr(x1/2+0.5)
    for x = x0, x1, 1 do
        local color="0x11"
        if(l_int>0.3)then
            local texture_color1 = texturing(x,yp2y,inv,p0,p1,p2,uv0,uv1,uv2,tex_size,texture,0,tsts)
            if(l_int>0.97)then color="0xa"..texture_color1
            elseif(l_int<=0.97 and l_int>0.5)then
                if (fast!=true) then color="0x"..texture_color1..texturing(x,y,inv,p0,p1,p2,uv0,uv1,uv2,tex_size,texture,-2,tsts) end
                color="0x"..texture_color1..texture_color1
            elseif(l_int<=0.5)then color="0x1"..texture_color1
            end
        end
        poke(0x6000 + y * 0x40 + x, color)
    end
end
    
function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,l_int,tex_size,texture,fast,tsts)
    local x,xx,y,q,q2,uv;
    if (y0>y1) y=y0;y0=y1;y1=y;x=x0;x0=x1;x1=x;uv=uv0;uv0=uv1;uv1=uv;
    if (y0>y2) y=y0;y0=y2;y2=y;x=x0;x0=x2;x2=x;uv=uv0;uv0=uv2;uv2=uv;
    if (y1>y2) y=y1;y1=y2;y2=y;x=x1;x1=x2;x2=x;uv=uv1;uv1=uv2;uv2=uv;
    local dx01,dy01,dx02,dy02;
    local xd,xxd;
    if (y2<0 or y0>127) return
    y,x,xx=y0,x0,x0;
    dx01,dy01,dy02,dx02,dx12,dy12,q2,xxd=x1-x0,y1-y0,y2-y0,x2-x0,x2-x1,y2-y1,0,1;
    if(x2<x0) xxd=-1
    inv=1/((y1-y2)*(x0-x2)+(x2-x1)*(y0-y2))
    if flr(y0)<flr(y1) then
        q,xd=0,1;
        if(x1<x0) xd=-1
        while y<=y1 do
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,tex_size,texture,fast,tsts);
            y+=1;
            q+=dx01;
            q2+=dx02;
            while xd*q>=dy01 do
                q-=xd*dy01
                x+=xd
            end
            while xxd*q2>=dy02 do
                q2-=xxd*dy02
                xx+=xxd
            end
        end
    end
    
    if flr(y1)<flr(y2) then
        q,x,xd=0,x1,1;
        if (x2<x1) xd=-1
        while y<=y2 and y<128 do
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,tex_size,texture,fast,tsts);
            y+=1;
            q+=dx12;
            q2+=dx02;
            while xd*q>dy12 do
                q-=xd*dy12
                x+=xd
            end
            while xxd*q2>dy02 do
                q2-=xxd*dy02
                xx+=xxd
            end
        end
    end
end
    
function tric(a,b,c,d,e,f,uv0,uv1,uv2,l_int,tex_size,texture,fast,tsts)
    local e1x,e1y,e2x,e2y=c-a,d-b,e-a,f-b;
    if (e1x*e2y-e1y*e2x<0) return;
    return tri(a,b,c,d,e,f,uv0,uv1,uv2,l_int,tex_size,texture,fast,tsts);
end
    
    
function rotate(x,y,a)
    local c,s=cos(a),sin(a)
    return c*x-s*y, s*x+c*y
end

-- function rotate2(x,y,a)
--     local xP=2 yP=1 
--     local c=cos(a) s=sin(a)
--     return c*(x-xP)-s*(y-yP)+xP, s*(x-xP)+c*(y-yP)+yP
-- end

-- function translation(x,y,z,xT,yT,zT)
--     return x+xT,y+yT,z+zT
-- end

function draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,textures,calc_light,tex_size,fast,tsts)
    for i=1,3*faces,3 do
        local a,b,c,xab,yab,zab,xac,yac,zac,nv,l_dir,l_cos,l_int;
        a,b,c,l_int=f[i],f[i+1],f[i+2],0.9;
        if(calc_light==true) then
            -- flat shading
            -- normal vector
            xab,yab,zab,xac,yac,zac=vm[b*3+1]-vm[a*3+1],vm[b*3+2]-vm[a*3+2],vm[b*3+3]-vm[a*3+3],vm[c*3+1]-vm[a*3+1],vm[c*3+2]-vm[a*3+2],vm[c*3+3]-vm[a*3+3]
            nv={yab*zac-zab*yac,zab*xac-xab*zac,xab*yac-yab*xac}
            vec_len=v3_len({nv[1],nv[2],nv[3]})
            nv[1],nv[2],nv[3]=nv[1]/vec_len,nv[2]/vec_len,nv[3]/vec_len
            nv_len=v3_len(nv)
            -- light direction
            local tx,ty,tz=(vm[a*3+1]+vm[b*3+1]+vm[c*3+1])/3,(vm[a*3+2]+vm[b*3+2]+vm[c*3+2])/3,(vm[a*3+3]+vm[b*3+3]+vm[c*3+3])/3
            l_dir={50-tx,50-ty,50-tz}
            l_len=v3_len(l_dir)
            -- cos
            l_dir_nv=v3_len({l_dir[1]-nv[1],l_dir[2]-nv[2],l_dir[3]-nv[3]})
            x=nv_len*nv_len+l_len*l_len-l_dir_nv*l_dir_nv
            y=l_len*nv_len*2
            l_cos=x/y
            l_int=max(0.1,l_cos)
        end
        local tex_i=1
        if #textures==6 then tex_i=flr(i/3)%6+1 end
        tric(
            vt[a*3+1],
            vt[a*3+2],
            vt[b*3+1],
            vt[b*3+2],
            vt[c*3+1],
            vt[c*3+2],
            {tc[uv[i]*2+1],tc[uv[i]*2+2]},{tc[uv[i+1]*2+1],tc[uv[i+1]*2+2]},{tc[uv[i+2]*2+1],tc[uv[i+2]*2+2]},l_int,tex_size,textures[tex_i],fast,tsts)
    end
end
function draw_cube(p)
	local qt,vertices,faces,vt,vm=t*0.01,8,12,{},{}
	local v=split("0.35,0.35,-0.35,0.35,-0.35,-0.35,0.35,0.35,0.35,0.35,-0.35,0.35,-0.35,0.35,-0.35,-0.35,-0.35,-0.35,-0.35,0.35,0.35,-0.35,-0.35,0.35")
	local f=split("0,2,4,3,7,2,7,5,6,5,7,1,1,3,0,5,1,4,2,6,4,7,6,2,5,4,6,7,3,1,3,2,0,1,0,4")
    local tc=split("1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0")
    local uv=split("2,1,0,2,1,0,1,3,2,0,2,3,2,1,0,1,3,2,1,3,0,1,3,0,3,0,2,2,1,3,1,3,0,3,0,2")
    for j=1,vertices*3,3 do
        local x,y,z=v[j],v[j+1],v[j+2];
        y,z=rotate(y,z,qt);
        x,z=rotate(x,z,qt*1.5);
        x,y=inf(qt+p,x,y)
        y-=1
        add(vm,x);
        add(vm,y);
        add(vm,z);
        z=z+5;
        x=x*96/z+64;
        y=y*96/z+64;
        vt[j],vt[j+1],vt[j+1]=flr(x),flr(y),flr(z);
    end
    draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,{tex},true,16,false,256)
end

function draw_torus(p)
	local qt,vertices,order,rings,faces,vt,vm=t*0.01,12,{},8,12,{},{}
	local v=split("-0.0,0.0,1.02,-0.0,0.24,0.88,-0.0,0.24,0.61,-0.0,0.0,0.47,-0.0,-0.24,0.61,-0.0,-0.24,0.88,0.72,0.0,0.72,0.62,0.24,0.62,0.43,0.24,0.43,0.33,0.0,0.33,0.43,-0.24,0.43,0.62,-0.24,0.62,-0.72,0.0,0.72,-0.62,0.24,0.62,-0.43,0.24,0.43,-0.33,0.0,0.33,-0.43,-0.24,0.43,-0.62,-0.24,0.62,-0.0,0.0,1.02,-0.0,0.24,0.88,-0.0,0.24,0.61,-0.0,0.0,0.47,-0.0,-0.24,0.61,-0.0,-0.24,0.88,-1.02,0.0,-0.0,-0.88,0.24,-0.0,-0.61,0.24,-0.0,-0.47,0.0,-0.0,-0.61,-0.24,-0.0,-0.88,-0.24,-0.0,-0.72,0.0,0.72,-0.62,0.24,0.62,-0.43,0.24,0.43,-0.33,0.0,0.33,-0.43,-0.24,0.43,-0.62,-0.24,0.62,-0.72,0.0,-0.72,-0.62,0.24,-0.62,-0.43,0.24,-0.43,-0.33,0.0,-0.33,-0.43,-0.24,-0.43,-0.62,-0.24,-0.62,-1.02,0.0,-0.0,-0.88,0.24,-0.0,-0.61,0.24,-0.0,-0.47,0.0,-0.0,-0.61,-0.24,-0.0,-0.88,-0.24,-0.0,0.0,0.0,-1.02,0.0,0.24,-0.88,0.0,0.24,-0.61,0.0,0.0,-0.47,0.0,-0.24,-0.61,0.0,-0.24,-0.88,-0.72,0.0,-0.72,-0.62,0.24,-0.62,-0.43,0.24,-0.43,-0.33,0.0,-0.33,-0.43,-0.24,-0.43,-0.62,-0.24,-0.62,0.72,0.0,-0.72,0.62,0.24,-0.62,0.43,0.24,-0.43,0.33,0.0,-0.33,0.43,-0.24,-0.43,0.62,-0.24,-0.62,0.0,0.0,-1.02,0.0,0.24,-0.88,0.0,0.24,-0.61,0.0,0.0,-0.47,0.0,-0.24,-0.61,0.0,-0.24,-0.88,1.02,0.0,0.0,0.88,0.24,0.0,0.61,0.24,0.0,0.47,0.0,0.0,0.61,-0.24,0.0,0.88,-0.24,0.0,0.72,0.0,-0.72,0.62,0.24,-0.62,0.43,0.24,-0.43,0.33,0.0,-0.33,0.43,-0.24,-0.43,0.62,-0.24,-0.62,0.72,0.0,0.72,0.62,0.24,0.62,0.43,0.24,0.43,0.33,0.0,0.33,0.43,-0.24,0.43,0.62,-0.24,0.62,1.02,0.0,0.0,0.88,0.24,0.0,0.61,0.24,0.0,0.47,0.0,0.0,0.61,-0.24,0.0,0.88,-0.24,0.0")
    for i=1,rings,1 do
        for j=1+vertices*3*(i-1),vertices*3*i,3 do
            local x,y,z=v[j],v[j+1],v[j+2];
            y,z=rotate(y,z,qt*0.9);
            x,z=rotate(x,z,qt*0.3);
            x,y=inf(qt+p,x,y)
            y-=1
            add(vm,x);
            add(vm,y);
            add(vm,z);
            z=z+5;
            x=x*96/z+64;
            y=y*96/z+64;
            vt[j],vt[j+1],vt[j+2]=flr(x),flr(y),flr(z);
        end
    end
    for i=1,rings,1 do
        local x,y,z=0,0,0
        for j=1,vertices*3,3 do
            x+=vm[j*i]
            y+=vm[(j+1)*i]
            z+=vm[(j+2)*i]
        end
        x/=vertices
        y/=vertices
        z/=vertices
        add(order,i)
        add(order,flr(sqrt((0-x)*(0-x)+(0-y)*(0-y)+(-10-z)*(-10-z))*1000))
    end
    order=sort(order)
	local f=split("0,1,6,1,2,7,2,3,8,4,10,3,4,5,10,0,6,5,1,7,6,2,8,7,3,9,8,10,9,3,5,11,10,6,11,5")
    local tc=split("0.0,0.5,1.0,0.33,1.0,0.5,-0.0,0.33,1.0,0.17,-0.0,0.17,1.0,0.0,1.0,1.0,0.0,0.83,1.0,0.83,1.0,0.67,-0.0,0.0,0.0,1.0,0.0,0.67")
    local uv=split("2,1,0,1,4,3,4,6,5,9,8,7,9,10,8,2,0,10,1,3,0,4,5,3,6,11,5,8,12,7,10,13,8,0,13,10")
    for i=1,rings*2,2 do
        local v_r={}
        local vm_r={}
        for j=1+vertices*3*(order[i]-1),vertices*3*order[i] do
            add(v_r,vt[j])
            add(vm_r,vm[j])
        end
	    draw_model(p,qt,vertices,v_r,vm_r,faces,f,tc,uv,{tex},true,16,false,256)
    end
end

function zoom_rotator(p)
	local qt,vertices,planes,faces,zm=t*0.01,4,25,2,22-11*sin(t%10*0.1)
	local v=split("-5.0,5.0,-0.0,5.0,5.0,-0.0,-5.0,-5.0,0.0,5.0,-5.0,0.0,5.0,5.0,-0.0,15.0,5.0,-0.0,5.0,-5.0,0.0,15.0,-5.0,0.0,-5.0,15.0,-0.0,5.0,15.0,-0.0,-5.0,5.0,-0.0,5.0,5.0,-0.0,5.0,15.0,-0.0,15.0,15.0,-0.0,5.0,5.0,-0.0,15.0,5.0,-0.0,-5.0,-5.0,0.0,5.0,-5.0,0.0,-5.0,-15.0,0.0,5.0,-15.0,0.0,5.0,-5.0,0.0,15.0,-5.0,0.0,5.0,-15.0,0.0,15.0,-15.0,0.0,-15.0,5.0,-0.0,-5.0,5.0,-0.0,-15.0,-5.0,0.0,-5.0,-5.0,0.0,-15.0,15.0,-0.0,-5.0,15.0,-0.0,-15.0,5.0,-0.0,-5.0,5.0,-0.0,-15.0,-5.0,0.0,-5.0,-5.0,0.0,-15.0,-15.0,0.0,-5.0,-15.0,0.0,-25.0,5.0,-0.0,-15.0,5.0,-0.0,-25.0,-5.0,0.0,-15.0,-5.0,0.0,-25.0,15.0,-0.0,-15.0,15.0,-0.0,-25.0,5.0,-0.0,-15.0,5.0,-0.0,-25.0,-5.0,0.0,-15.0,-5.0,0.0,-25.0,-15.0,0.0,-15.0,-15.0,0.0,-25.0,25.0,-0.0,-15.0,25.0,-0.0,-25.0,15.0,-0.0,-15.0,15.0,-0.0,-25.0,-15.0,0.0,-15.0,-15.0,0.0,-25.0,-25.0,0.0,-15.0,-25.0,0.0,15.0,5.0,-0.0,25.0,5.0,-0.0,15.0,-5.0,0.0,25.0,-5.0,0.0,15.0,15.0,-0.0,25.0,15.0,-0.0,15.0,5.0,-0.0,25.0,5.0,-0.0,15.0,-5.0,0.0,25.0,-5.0,0.0,15.0,-15.0,0.0,25.0,-15.0,0.0,15.0,25.0,-0.0,25.0,25.0,-0.0,15.0,15.0,-0.0,25.0,15.0,-0.0,15.0,-15.0,0.0,25.0,-15.0,0.0,15.0,-25.0,0.0,25.0,-25.0,0.0,-5.0,25.0,-0.0,5.0,25.0,-0.0,-5.0,15.0,-0.0,5.0,15.0,-0.0,5.0,25.0,-0.0,15.0,25.0,-0.0,5.0,15.0,-0.0,15.0,15.0,-0.0,-15.0,25.0,-0.0,-5.0,25.0,-0.0,-15.0,15.0,-0.0,-5.0,15.0,-0.0,-5.0,-15.0,0.0,5.0,-15.0,0.0,-5.0,-25.0,0.0,5.0,-25.0,0.0,5.0,-15.0,0.0,15.0,-15.0,0.0,5.0,-25.0,0.0,15.0,-25.0,0.0,-15.0,-15.0,0.0,-5.0,-15.0,0.0,-15.0,-25.0,0.0,-5.0,-25.0,0.0")
    local f,tc,uv=split("0,2,1,2,3,1"),split("1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0"),split("2,1,0,1,3,0")
    for i=1,planes,1 do
        -- printh("-----"..i.."------","loggg.txt")
        local v_r=""
        for j=1+vertices*3*(i-1),vertices*3*i,3 do
            local x,y,z=v[j],v[j+1],v[j+2];
            z-=zm
            -- z+=sin(t*0.005)
            -- z-=11 -- max zoom
            -- z-=33 -- min zoom
            x,y=rotate(x,y,qt);
            z+=5;
            x=x*96/z+64;
            y=y*96/z+64;
            v_r=v_r..flr(x+0.5)..","..flr(y+0.5)..","..flr(z+0.5)..","
            -- printh(x.." "..y.." "..z,"loggg.txt")
        end
        v_r=split(sub(v_r,1,-2))
        local xc,yc=64-(v_r[1]+v_r[4]+v_r[7]+v_r[10])/4,64-(v_r[2]+v_r[5]+v_r[8]+v_r[11])/4
        -- printh("dis="..flr(sqrt(xc*xc+yc*yc)),"loggg.txt")
        if((xc*xc+yc*yc)<22000)then
    	    draw_model(p,qt,vertices,v_r,v_r,faces,f,tc,uv,{tex},false,128,true,16384) 
        end
    end
end

function draw_cube_anim(p)
    local textures,qt,vertices,faces,vt,vm=draw_plasmas(),t*0.01,8,12,"",""
	local v=split("1.3,1.3,-1.3,1.3,-1.3,-1.3,1.3,1.3,1.3,1.3,-1.3,1.3,-1.3,1.3,-1.3,-1.3,-1.3,-1.3,-1.3,1.3,1.3,-1.3,-1.3,1.3")
	local f=split("0,2,4,3,7,2,7,5,6,5,7,1,1,3,0,5,1,4,2,6,4,7,6,2,5,4,6,7,3,1,3,2,0,1,0,4")
    local tc=split("1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0")
    local uv=split("2,1,0,2,1,0,1,3,2,0,2,3,2,1,0,1,3,2,1,3,0,1,3,0,3,0,2,2,1,3,1,3,0,3,0,2")
    for j=1,vertices*3,3 do
        local x,y,z=v[j],v[j+1],v[j+2];
        y,z=rotate(y,z,qt);
        x,z=rotate(x,z,qt*1.5);
        -- x,y=inf(qt+p,x,y)
        -- y-=1
        vm=vm..x..","..y..","..z..","
        z=z+5;
        x=x*96/z+64;
        y=y*96/z+64;
        vt=vt..x..","..y..","..z..","
    end
    vm,vt=split(sub(vm,1,-2)),split(sub(vt,1,-2))
    draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,textures,true,32,false,1024)
end

function v3_len(vec)
    return sqrt(vec[1]*vec[1]+vec[2]*vec[2]+vec[3]*vec[3])        
end

function inf(t,x,y)
	x+=2*(cos(t))
	y+=2*cos(t)*sin(t)
    return x,y
end

function background()
    spr(0,0,0,16,16)
end

function mirror()
    for i=0,40,1 do
        for j=0,64,1 do
            poke(0x7fc0-i*64+j,@(0x6000+i*128+j+448))
        end
    end
end

-- t=0
-- function _update()
--     t+=1
-- end

-- function _draw()
--     cls()
--     -- bridge2()
--     -- spr(0,0,0,16,16)
--     zoom_rotator(0)
--     -- draw_cube_anim()
--     -- draw_chicken()
--     -- mirror()
--     -- print(stat(9))
-- end

function draw_chicken(p)
	local qt,vertices,faces,vt,vm,order=t*0.01,split("5,20,27,14,21,21"),split("4,28,36,20,36,36"),{},{},""
	local v={split("-0.82,1.89,0.0,-1.18,1.89,0.0,-0.81,2.11,0.0,-0.74,1.89,0.14,-0.74,1.89,-0.14")
            ,split("-0.38,2.73,0.0,-0.72,2.44,0.0,-0.04,2.82,0.0,0.35,2.57,0.0,-0.42,2.47,0.42,-0.09,2.54,0.51,0.24,2.57,0.29,0.46,1.76,0.54,-0.48,1.86,0.54,0.04,1.84,0.68,0.52,2.08,0.0,-0.81,2.11,0.0,-0.74,1.89,0.14,-0.42,2.47,-0.42,-0.09,2.54,-0.51,0.24,2.57,-0.29,0.46,1.76,-0.54,-0.48,1.86,-0.54,0.04,1.84,-0.68,-0.74,1.89,-0.14")
            ,split("-1.12,1.07,0.0,-0.66,0.96,0.71,0.15,0.82,0.99,-0.54,-0.81,0.0,-1.17,0.03,0.0,0.03,-1.0,0.0,-0.59,-0.22,0.8,0.03,-0.5,1.09,0.76,1.35,0.0,0.91,0.55,1.01,1.13,-0.33,0.9,0.46,1.76,0.54,-0.82,1.89,0.0,-0.48,1.86,0.54,0.04,1.84,0.68,0.52,2.08,0.0,-0.74,1.89,0.14,-0.66,0.96,-0.71,0.15,0.82,-0.99,-0.59,-0.22,-0.8,0.03,-0.5,-1.09,0.91,0.55,-1.01,1.13,-0.33,-0.9,0.46,1.76,-0.54,-0.48,1.86,-0.54,0.04,1.84,-0.68,-0.74,1.89,-0.14")
            ,split("0.76,1.35,0.0,1.82,1.0,0.0,2.26,0.51,0.0,0.91,0.55,1.01,1.82,0.51,0.57,1.41,-0.65,0.0,1.13,-0.33,0.9,2.23,1.31,0.0,1.98,-0.11,0.0,1.59,0.04,0.69,0.91,0.55,-1.01,1.82,0.51,-0.57,1.13,-0.33,-0.9,1.59,0.04,-0.69")
            ,split("0.03,-1.0,0.0,1.41,-0.65,0.0,0.03,-0.5,-1.09,1.13,-0.33,-0.9,0.77,-1.55,-0.56,0.77,-1.55,-0.75,0.96,-1.55,-0.56,0.96,-1.55,-0.75,0.77,-1.99,-0.51,0.77,-1.99,-0.8,0.96,-1.99,-0.56,0.96,-1.99,-0.75,0.77,-1.86,-0.56,0.96,-1.86,-0.56,0.77,-1.86,-0.75,0.96,-1.86,-0.75,0.77,-1.99,-0.66,0.96,-1.86,-0.66,0.07,-1.99,-0.47,0.07,-1.99,-0.84,1.26,-1.99,-0.66")
            ,split("0.03,-1.0,0.0,0.03,-0.5,1.09,1.41,-0.65,0.0,1.13,-0.33,0.9,0.77,-1.55,0.56,0.77,-1.55,0.75,0.96,-1.55,0.56,0.96,-1.55,0.75,0.77,-1.99,0.51,0.77,-1.99,0.8,0.96,-1.99,0.56,0.96,-1.99,0.75,0.77,-1.86,0.56,0.96,-1.86,0.56,0.77,-1.86,0.75,0.96,-1.86,0.75,0.77,-1.99,0.66,0.96,-1.86,0.66,0.07,-1.99,0.47,0.07,-1.99,0.84,1.26,-1.99,0.66")}
	local f={split("1,2,3,0,1,3,2,1,4,1,0,4")
            ,split("6,2,3,4,0,5,1,0,4,5,2,6,6,3,10,5,6,9,11,4,12,4,5,8,4,11,1,0,2,5,7,6,10,6,7,9,4,8,12,5,9,8,2,15,3,0,13,14,0,1,13,2,14,15,3,15,10,15,14,18,13,11,19,14,13,17,11,13,1,2,0,14,15,16,10,16,15,18,17,13,19,18,14,17")
            ,split("3,4,6,6,7,3,1,2,6,13,1,16,10,7,9,13,14,1,14,11,2,11,15,8,0,1,4,12,16,0,7,5,3,2,7,6,7,2,9,14,2,1,11,9,2,9,11,8,1,6,4,16,1,0,4,3,19,20,19,3,18,17,19,17,24,26,20,22,21,25,24,17,23,25,18,15,23,8,17,0,4,26,12,0,5,20,3,20,18,19,18,20,21,18,25,17,21,23,18,23,21,8,19,17,4,17,26,0")
            ,split("7,2,4,9,6,3,9,4,8,7,4,1,3,0,4,6,9,5,3,4,9,4,2,8,0,1,4,9,8,5,2,7,11,12,13,10,11,13,8,11,7,1,0,10,11,13,12,5,11,10,13,2,11,8,1,0,11,8,13,5")
            ,split("4,5,0,13,10,12,2,5,3,6,4,1,7,6,3,14,12,16,9,11,14,13,6,17,7,17,6,5,14,7,4,12,5,13,12,6,15,17,7,11,17,15,17,10,13,18,16,12,19,14,16,20,11,10,16,11,9,16,8,10,16,10,11,18,8,16,18,12,8,19,9,14,19,16,9,20,10,17,20,17,11,5,2,0,10,8,12,5,7,3,4,0,1,6,1,3,11,15,14,14,15,7,12,14,5,12,4,6")
            ,split("5,4,0,10,13,12,5,1,3,4,6,2,6,7,3,12,14,16,11,9,14,6,13,17,17,7,6,14,5,7,12,4,5,12,13,6,17,15,7,17,11,15,10,17,13,16,18,12,14,19,16,11,20,10,11,16,9,8,16,10,10,16,11,8,18,16,12,18,8,9,19,14,16,19,9,10,20,17,17,20,11,1,5,0,8,10,12,7,5,3,0,4,2,2,6,3,15,11,14,15,14,7,14,12,5,4,12,6")}
    local tc={split("0.5,0.11,0.49,0.07,0.39,0.08,0.46,0.13")
            ,split("0.36,0.95,0.28,0.96,0.32,0.91,0.27,0.88,0.21,0.95,0.23,0.88,0.15,0.9,0.43,0.89,0.31,0.77,0.12,0.8,0.12,0.85,0.21,0.78,0.39,0.78")
            ,split("0.2,0.4,0.02,0.45,0.09,0.25,0.32,0.33,0.34,0.58,0.19,0.61,0.12,0.8,0.21,0.78,0.49,0.54,0.53,0.37,0.31,0.77,0.39,0.78,0.53,0.78,0.43,0.89,0.03,0.65,0.09,0.81,0.16,0.17")
            ,split("0.67,0.54,0.8,0.54,0.8,0.67,0.49,0.54,0.53,0.37,0.62,0.44,0.76,0.4,0.7,0.66,0.52,0.76,0.69,0.27")
            ,split("0.16,0.17,0.4,0.2,0.37,0.16,0.86,0.88,0.81,0.93,0.81,0.88,0.53,0.37,0.32,0.34,0.69,0.27,0.56,0.11,0.56,0.15,0.5,0.2,0.65,0.92,0.62,0.89,0.67,0.89,0.73,0.92,0.67,0.93,0.78,0.89,0.81,0.79,0.74,0.79,0.67,0.79,0.62,0.79,0.73,0.87,0.86,0.46,0.82,0.45,0.82,0.3,0.88,0.54,0.91,0.54,0.88,0.66,0.9,0.3,0.93,0.3,0.93,0.37,0.93,0.25,0.89,0.26,0.88,0.25,0.85,0.17,0.89,0.46,0.93,0.57,0.92,0.19,0.19,0.08,0.17,0.11,0.13,0.06,0.18,0.04,0.86,0.93,0.73,0.03,0.86,0.79")
            ,split("0.16,0.17,0.37,0.16,0.4,0.2,0.86,0.88,0.81,0.88,0.81,0.93,0.53,0.37,0.32,0.34,0.69,0.27,0.56,0.15,0.56,0.11,0.5,0.2,0.65,0.92,0.67,0.89,0.62,0.89,0.67,0.93,0.73,0.92,0.78,0.89,0.81,0.79,0.74,0.79,0.68,0.79,0.62,0.79,0.73,0.87,0.86,0.46,0.82,0.3,0.82,0.45,0.88,0.54,0.88,0.66,0.91,0.54,0.9,0.3,0.93,0.37,0.93,0.3,0.93,0.25,0.89,0.26,0.88,0.25,0.85,0.17,0.89,0.46,0.93,0.57,0.92,0.19,0.19,0.08,0.13,0.06,0.17,0.11,0.18,0.04,0.86,0.93,0.73,0.03,0.86,0.79")}
    local uv={split("2,1,0,3,2,0,1,2,0,2,3,0")
            ,split("2,1,0,5,4,3,6,4,5,3,1,2,2,0,7,3,2,8,10,5,9,5,3,11,5,10,6,4,1,3,12,2,7,2,12,8,5,11,9,3,8,11,1,2,0,4,5,3,4,6,5,1,3,2,0,2,7,2,3,8,5,10,9,3,5,11,10,5,6,1,4,3,2,12,7,12,2,8,11,5,9,8,3,11")
            ,split("2,1,0,0,3,2,5,4,0,7,5,6,9,3,8,7,10,5,10,11,4,11,13,12,14,5,1,15,6,14,3,16,2,4,3,0,3,4,8,10,4,5,11,8,4,8,11,12,5,0,1,6,5,14,1,2,0,3,0,2,4,5,0,5,7,6,3,9,8,10,7,5,11,10,4,13,11,12,5,14,1,6,15,14,16,3,2,3,4,0,4,3,8,4,10,5,8,11,4,11,8,12,0,5,1,5,6,14")
            ,split("2,1,0,5,4,3,5,0,6,2,0,7,3,8,0,4,5,9,3,0,5,0,1,6,8,7,0,5,6,9,1,2,0,4,5,3,0,5,6,0,2,7,8,3,0,5,4,9,0,3,5,1,0,6,7,8,0,6,5,9")
            ,split("2,1,0,5,4,3,7,1,6,10,9,8,11,10,6,14,13,12,16,15,14,5,18,17,19,17,18,20,14,19,21,13,20,5,3,18,22,17,19,15,17,22,17,4,5,25,24,23,28,27,26,31,30,29,33,30,32,33,34,29,33,29,30,35,34,33,25,23,36,28,37,27,38,33,32,41,40,39,41,39,42,1,7,0,4,43,3,1,11,6,9,44,8,10,8,6,15,22,14,14,22,19,13,14,20,3,45,18")
            ,split("2,1,0,5,4,3,2,7,6,10,9,8,9,11,6,14,13,12,16,15,13,18,4,17,17,19,18,13,20,19,14,21,20,3,4,18,17,22,19,17,16,22,5,17,4,25,24,23,28,27,26,31,30,29,31,33,32,34,33,29,29,33,31,34,35,33,23,24,36,37,27,28,33,38,32,41,40,39,39,40,42,7,2,0,43,5,3,11,2,6,44,10,8,8,9,6,22,16,13,22,13,19,13,14,20,45,3,18")}
    for i=1,#vertices do
        vt[i],vm[i]="",""
        for j=1,vertices[i]*3,3 do
            local x,y,z=v[i][j],v[i][j+1],v[i][j+2];
            y,z=rotate(y,z,qt);
            x,z=rotate(x,z,qt*1.5);
            vm[i]=vm[i]..x..","..y..","..z..","
            z=z+5;
            x=x*96/z+64;
            y=y*96/z+64;
            vt[i]=vt[i]..flr(x)..","..flr(y)..","..flr(z)..","
        end
        vt[i],vm[i]=split(vt[i]),split(vm[i])
    end
    for i=1,#vertices do
        local x,y,z=0,0,0
        for j=1,vertices[i]*3,3 do
            x+=vm[i][j]
            y+=vm[i][(j+1)]
            z+=vm[i][(j+2)]
        end
        x/=vertices[i]
        y/=vertices[i]
        z/=vertices[i]
        order=order..i..","..flr(sqrt((0-x)*(0-x)+(0-y)*(0-y)+(-10-z)*(-10-z))*1000)..","
    end
    order=sort(split(sub(order,1,-2)))
    for i=1,#vertices*2,2 do
        draw_model(p,qt,vertices[order[i]],vt[order[i]],vm[order[i]],faces[order[i]],f[order[i]],tc[order[i]],uv[order[i]],{chicken_tex},true,32,false,1024)
    end
end

function sort(seq)
    for i=1,#seq,2 do
        local max=i+1
        for j=i,#seq,2 do
            if(seq[max]<=seq[j+1]) then
                max=j+1
            end
        end
        tmp=seq[i+1]
        seq[i+1]=seq[max]
        seq[max]=tmp
        tmp=seq[i]
        seq[i]=seq[max-1]
        seq[max-1]=tmp
    end
    return seq
end

function draw_plasmas()
    local plasmas={"","","","","",""}
	for x=0,31,1 do
		for y=0,31,1 do
			c=tostr(((
				16+(16*sin(x*0.016+sin(t*0.001)))+
				16+(16*sin(y*0.008+sin(t*0.001)))+
				16+(16*sin(sqrt((x-63)%2*(x-63)%2+(y-63)%2*(y-63)%2)*0.016+sin(t*0.01)))+
				16+(16*sin(sqrt(x*x+y*y)*0.004+sin(t*0.01)))
			)*0.25+t)%6,true)[6]
            for i=1,6,1 do
                plasmas[i]=plasmas[i]..tostr(c+((i-1)*2),true)[6]  
            end
		end
	end
    return plasmas
end

function bridge2()
    background()
    draw_torus(0)
    mirror()    
end

function bridge1()
    background()
    for i=0,5 do
        draw_cube(i*0.1)
    end
    mirror()      
end
__gfx__
eeee6e6eeeeeeeeeede6edd6eeeeeedeeedd66eeeeeeeeedee6ee666eeeeeee6edeeee6d6dddee6e66e6e666eee6d6eeeeeeded6eeeeeeee6eed6deeeed6dee6
d6ee6deeeeee66eeeddeee66ee6eee666de66eeedeeeeeddee6eee66eeeeeeeeee6deee6eeeeee6666eeeeee6ee66e666ee6e66de6deee66eee6d6eeeee666ee
deeeeeee66ee6eeee6deeee6ede66eedeeee6e66eeeeeedeeeee66e6eeee6edeeeee6edee6e66e66ee6eeeee6eeed6eeeeeed6edeeedeed6ee6ee6eee6d6e6ee
6dedeee6e66edeeeeee6eedeeee6e6ee66de6eedeeeee6eee6e6eee66edde6e6e66deeee6e6ee66e6eeeeedeeeeee6eeeeeeeed6e666eeeedeeeeeee66eeeede
eeee6eee66edeeeeeeeee66eded6deeeed6eeeeeee6ee6eeeeeeeeee6eeeeeeedde6edeeee6ee6eeeee6e66ee6e6edeeedeeeeee666eeeedee66e66ee6edde6e
eeede66ee6deeeeeeeeeededeeeeeeeeee6ee6dedeeeed6d6eeeeeeeeee66eeeeee6eeeee666eeee66eeede66eeee6d6eeddede6eeed6e66de6dee6e6eeeeeee
6de66deee6e6eee666d6edeeeeedeeeeeeededede6eeddeededdedeee6e6eeeeedde6dededd6edeeeeeee6deeeee6eee66dde6e6edeeeee6deeed6deee6edeee
ed6ddeeeded6e6eedeeee6eedee6edde6eeee6deeedeedeeeedeeeeeedeee6d6edeeeeeeedee6dd6eedeeeeedd6eeeede6d6edeeeeeeeed6eeddeeeeedee6ede
de6eeeee666e66eeededeed6eeee6edeeeededeeedded6ee6e6deeeedeee6ee6edeee6eee6eeedee6e6ee6dee66eddeede6e6edd6e6eeeeedd6d6dededeee6ed
e66eeeedeeeeee6edeeeee6eeeedeed6ee66deeede666eeeddee6eeee6eddde6ee66e6eedede66e6eeeeeeeedeed66edeeeeeeedeeee66eeeed6de6eeee6eede
6edeeeeeee6edeee6eedeee66eee66edeeeddeeee666de6e6666dee6eeeeeee6e6ee6deeeeed6edeee6ee6dedeeeedee6eee6eeee66ee66e6e6eed6ddee6edee
666e6eee6ee666e6eedee6eee6eeeee6dedeee6edde6e6e6eeee6ee6eede6eddde6eeeee6e6edeeeedddd66eeeeee6eeed6eede6ddeee6e66eeee6ddded6ee6d
ee6eeeeee6eee66ee6edeede6d6dded66dedd66666eedeed6eee6deeee6e66ee6ede6deeeeeeeeeedeeeee6eeeeedeeeee6d66eeeeeeeeeeeed666e6deeee6ee
e6eeee66eed6eeeeeeeeeeeee66deeee66eee66eee66eeeeeee6eeeeeee6e6edddee6eee66ededee6eeded6eeeeee6eeee6ee66eedeeeeeeeee66de6d6e6eed6
6eeeeeedeee66ede6666ddeedeeeeeeeeeeededeeeeeedee6eeed6e6eedeede66eeeeedddde66eeedeeee6e6eeeee6deeeeedeeeeeeede6ee6eeee6eeee6ee6e
eeee6d6de6eee6e6e6eee6e6e6e6ee6d6deee6edeee6edeedeeded1111115eeeeede6d6deeee6ee6dee6eee6eee6ed66ee6eeeede6deee6eee6ee66eeeeeeee6
dddeeee66ddeeeeedeeedeeee6eeeedeeeeeeede6ee6ee6deeed11551200d555dee6deeeeee66e6eeeeeeeeddeeee666d6eeeeeee6eeed6deee6eeeeeeeeeeee
6eeeee6e6d6eed6eeeeedeee6ee666eedeeeeeeeeeeeeeeeee11133d525515555d5dee6edeedeeeeeeede6d6eeeeeeeee6eeded6eee66eeee6ee6e6ded6e6ede
eee6ee6eedde6eee6eeeeee666eee66eedeedee6eee6eeee1111151111553535245dddeeeeee6eeeddeedeee6666eeeddeede6eedeee6eeeeeeeeee6eeedd6e6
ee6eeedeee6e6eeeeeee6eeeeee6eeeee6ee66eeeedeee511131111113151d552445dd6de666ee6eeed6eeeeeeeeee6d6ede6deee6deeee6eeeede66eee6eee6
eeeeedee6eededed6ededeeeedeeeeeeddeed6ededeee13515111115451054500050235dd6eeeeed6e6eeeedde6ed6d6eee6de6ddeeee6eedde6e66e6edeeee6
ee6eeeeded6ddeeeee66eeddedeeede6ede66eeeee6d11035311150545455505250000533dee6eeed6e6eedd6ee6e66e6eeeededee6ee6eeedeeeee6e6edeeee
eeee6deeeeedeeeeeeeeeeeeedeeeeeeeeedddeddee1100053115444444559a4942002053dd6eeeeeee6ee6d6eeee6deedddee6ee6e6eeeeee6eee6ed66eeee6
e6eeeeeeeeeddeeee6d6e66eeeddeeeeeeeedee6de10110000004444a4444a445502001156d6eeeeee66ee6eeee6e6eee66eeede6eeeeeeeedeed6eee6eeee66
e6e6e6ee6deede6e6edede6d6deeedeed6eeeedde011010014244444da454a455544450113ee6e66edeee6dedddeeeeeeeee6eddeeeed6eeeedeeeeeeeeeedee
6d6eeedeeee6eeeeee6ede6e66eeee6edeee6eee11100015552044454440445444444440115d6ee6eedeeee6e6d6ee6eedeeeee6ee6eee666dede6eddd6de6ee
eeeeeeee6ede66e6eeeeeeedeeeedeee6eee66601031005545240444554555545a44fa40113d666eeeee6de6eeeeeededeee6eeee6deeedeedeeeeedddedde66
eeed666eeeee6eeddee66eee66e66ddeeee66e1001220500542550550545ad554444f4920053314eeeedeeeeedeededeee6eedeee6eeeeeeeedeed6eeeeeeede
edeeeddeeeeedee6eedeeee6eedddeeeee6dee00110225552440544444d4df450554af4440014e9e46e6deeeeddeeeee6edeedeedeeeeedeeee6eedeeee66de6
eeeeeedeeeeee6edee666e66deeddeeeeeee6e001015505545444444444dda4f65054aaf4401444ef46eede6eeeeee6eeeee66dde6deeeee6edede66eeee6eee
eee6eeeeeee6eeedddeeddeed6eed6eee6ee6600100055555dd4454544d44d4f6ff4555544242444f6d6ee66eeeedee66edeee66dede6eee6e6e6666ddedeeee
eeedeeeeedeeeee6dd6eedeeeeeeeeeeee6ed5001005554dd444454555dd44fddff777244e44224d6deeee6eeeeddeeee6eeee6eeee6edeeee6e6eeeedee6ee6
6eeeedeeee6eeeeeeeedeeeeee6ee6eee6eee500002455454d54545455dddddfff7777545424444ee66eeed6e6eddededeee6d6e6eedee66d66eeed66eeeeee6
6ee6eeee6e6eede666eeeedeeeeedeed6eeedd1100025444dddd4555554dd4d6d677777744244044f77d4eeeee6eeededeeeee6eede6eedddeee6e66eee6e6de
eeed6ee6dd6ee6edeeeeeeeedeeeee6eeeee6d22012044444dddd5554554d44ddff77777a42490049f7f74e6d6eedeedeeedee6eee6ede6eed6ee6ee6ee6de6e
deedee6edeee6e66eeeded6e6eeeeee6de6e22202000d4554dd45d4555ddd4dfdff77777444492224ffffdeeede6ee6ede6eeeeedeeee6d6eeeee6edeedeeee6
6edeeee6eeeee66de666ee6e6eedde6eeee2202400254544ddd554d55d544d4ddff777774492eaf444eefe6e6deeeeeee6eeedee6ede6e66ee6e66eedddd66ee
66eeed6eeeedee66eeee6eeeddeeeedee6d22240020255454dddd4d454544ffff677777754445e7f699f4deeededed6eeeeee6ee6eeeeeeeeeede6ede6e66ee6
ed6eedd6eeeeeeee6eddeeeeedeeedee6dd020000045045d44444dd5444ddeddff77777754444eeff4efee6ee6eeeeeedee6eeeeede6edee6d6ee6eee6eeee6e
e6eeeddddde6eeeee6ee6ee6e66eeded6ee4000022050455ddddd4d55d4d4dfdfff777775449444d44ffe6ee6eed6de6edeeedd6deeeeeeee6ddde66edede6de
eeeeede6ee6eeedeee6ee6eee6deddededed0200000024d5dddd4dd55dd44efdf540525774e99444fad7dedee66eed6dee6e6deedeeee66e6eeeed6eeeeeedde
e6eeedee6ddee6edeeeeeeee6ee66eededee02202000245554444ddddd4fdf000256fd6774e94459ade6ed6e6eeeeeee6ee6edeeeeed66dee66dd6e6dde6edee
eeee6deeeee6deee6e6deee6dedeeeeeee6e04202002044440505004454dd52200554d67776949549feeeeeeeedeeedeedeeede6eeeeedeeeddeed6ddeee6ed6
deeededeeeeeeeee6deee6ee6eedeeeeeeee452000240d4245520004dd4d55522000501677f02744eaedeeedeeee6eeeeeeddeeee6d6ee6ee6eeeeeeee6eeed6
eeeeeeeeeed6eeee6edee6e6eee6ed6ee66d4440550054452252000544dd5500d551561777745646de66e6eeeeeee6e6eeeeede6ed666eee6eeeeeeedeee6e6e
eeee6deededeeeeeeddeee6eed6eeeede6de6e4402005d55050000005d44dd20d6117577777f2d4e66eeeeeee6edeee6ee6eeeeeeeddededddeedeeeeeee6eee
edeede6e6deeedee6eee6eeeeeee66e66deeee4402504d55d4d00d5554467f400454df67f7750776dedeed66eee6e6eeeee66dd6eed6edde6eed6ee6dedeeeee
6eeeee6eeeee66deeeeee6eeee6eeeedede6d6e422054550d651d5055d5677fd525ddffff775077ede66666d6eeee6eeeed6e6eeee6eddee66eede6e6ee6eeee
6e6e6ee6eed6e66eeee66e6e6edd6e6eeeeedde64400444dd505555df45d777dd4d6ddd6f77f67deeeeee6edd6eeeeee6deeeeeeee6ede6ee6eeee6eee6eedee
eeeeee6e6eeede66ed6eeeeeeeeee66e6eeded6ee450d4454555255dd444777d44d44d66f77777dd6eede66ee66eeeedeee666deeee6eeedeeee6ee6de6eddee
eeeeeeee6dedd6eeddeedeedeeee6eeee6eee6eee6526a4455445ddd444577fffd4d4ff66777fded66eededeeeedeeddee6eeeeeeede6eedeeeee6ee6e66eeee
ee6eeeeded6eeeeeededdeeeee6ed6eee6d6e6eeefd0dd454d444ddd464d777f6f44ddfef7770ede6ee6ee6edeee6e6dded6eeede6ddeee6eeeeddee66e6ede6
eeee6eedeede6eeedd66ded6dde6eeeeede6ddeee64d464d4444544d4dd4777ffff44ddf6f7755eee6eee6deeedd666eeeeeee6e6edeed6eeeeddee6ee6eeeed
6e6eee6eddeeedeeddeedee6e6edede6ee66e6eeedfddd444d4d444d444ddfffdd4d44def77715eeeeeeee6edeedde6e6deeeee6eeeeed6eeed6e6eee6eee6e6
e6eeeeeee6e6ede6deeeeeee6eeeeeee6eedeeddee544444dddd444d55524ff6fd4d556df77751eeeded66dedeeeeeeeee6ee6eee66eeed6e6eeeee6e6eed6e6
eed6deeddeeeeeeee6ee666e666eede6ee6dee6ee6d5d54d44d4d4550550542555dd5d46d777d11eeeee6eeeee6eeeeeeedd6eed6ee6ee6ddede6eee6dedee6d
deeedee6eeeee66edeeeeeeeedee6dee66eed6eee6665144d44d5554520202dfd64d444fef77d15ee6e6ee66eeeeeee6eeeeeee6eede6e6ee6deee6e6e6eedee
eeeeeeeeeeeeeee6deeeee6deeee6eeeeeee6eeee6ee015d4544455455d550d6f6d55dddff7751dd6eedeeedeee6de6eee6ede6eeeede6eedede66ede6eeeeed
e66d6ee6edeeeee6edeeeeeeee66eeeeeeeee6eeeeee11154555555dd44542ff67f4dd4ff77655ddeeed666e6dee6ee6deeeeedd66eeeeee6ee6eeeede6eee6e
deeeed66ee6eeeeeede6deeee6e6eeedeeeeeeeeee6e5115554552554dd4456f76745d6fff7115dd5dd6e6e6ee6eeee6eeeee6d6ede6e6e6eee6ddedeee6edee
6eeede6dd6dee66edeeed66ee6ee66eeee6ee6e6eeed51055555525d4d45050220d05ddff77531dd1566ee6edee6e66e6e6deeee66e6e6de6eeeeee6d6eedeee
ddeeeeeeeee6edeeeeeeeded6ed6ee6eeddeeeeeeedd531155545554d0002002444fdd6fff11155d11ee6e6eeeeeedededeede6ede6deeeeeeed66eeeeeeeeee
ee6edee6edeedeeede6eeedeedeee6d6ee6edeeeed653531155555502022202444ffedd77d11351d51edeedeeeeee6eeee6eeee6deeddeee6e6e666eeeeeede6
edeeeeedeeed666eeeeeeeeee6de6eeeee6d6eeeeee31115104555254520000226d6f6f6ff13551d31eeddedeeed6eeee6eedede66dedee6eeddeedeee6eeeed
dedee6deed66e6eeeeeddedee66ee6eeee6eeeeeeee51115550545552542555f6fff6666f711551d51666d6eedede6eeeeeedded666ededeeee66ee6e66deee6
ddeeeeeeeeeeeed6e6eee6e6e6eedeeeeeedee6e6ee35131511555224555456f77f66fff77115d35d16eeeeede6d666e6eeeeeded66eeeeeeeeeeee66edddede
eee6e6dedeeeed6eedde6ee66eee6e66eedeedd6ddd55011111040552555554ffff6fd47f7035d13556deee6d666eee6deeeee6e6eeeeeeededdeede6edee6d6
eeeeeeeeee6deeed6deee6e6eeeeeeeeeede6eded6e55010111055555255454d66f6f6ff771113055eeeeeeeddedeed666e66e6eee66edeedd6deede66eeeede
6edee6ee66deeeeedeedeeddeeeee6deeeeeeeeeeee110115111d55555255555dddfd77f77d6611d5deeddeedeeee6eed66eeeeeeeeeeeee6ee6eeeeeeeedede
eeeedddeeddee6eeeeeeddeeeeeeeedde66e6e6eeee15000111d545d5455555555d66f77ffd6651d5deee6eedeee6deed6deeeeeed66de6ee666eeeeeeeeeeee
edd6eeeeeee66eeee6eeeeeee6edeeeeedee6d6ddee3300111d5dd5d554050054d67fff776d6665dddedded6eeede66ed666eee66eeeedededed6dedeeeeeede
e6eeeeeeede6eeeededeee6dee6ee6edeeeeedee66e55011155544dd5d5555545ff66fff766766f131eeeeeee6eee6eeeeeed6eeeee666ee6d66eeedddeedeed
edeeeeede6eeeeede66eeeeeeeedeee6e6edee6eed6530015515444455554d55466f67fffe66666050d6e66d6deeeee6eeee6ededdeededeee6ee66ed6ee6dde
ee66eeeeeede6d6eedeeeeeeeeeeedded6ee6edeeee1501155512555d5545454fff666f66d6d7777016eee6eeeeeeeee666e6eee66eeed6ee6deeeeeeee6ee6e
ee6deee6eeeeed66e6ee6eeeeee6eede6deeedde6ee530055555255555545454df6fff6fded6777771eee6deed6eeeeeeede6dee6eeee6e6eeed66eeddeede66
eeeeeeeeeeee6e6e6eeeeede66eeeeee6edee6eee661111555550544444d54454ff6f666d6d66777776deede6ee6e6eeeeed6eededde6eeedeeeeeeeeee6e6ee
6d6eeeed6ee6e6deeeeeeeeeedeeee6e6eeeeeeeeed11155d55dd5255455445d56fff4d4dd6d7777777dedddeedeedeee6ee6deeeeed6e6eee6eeee6ed6dee6e
eedeeed66de6eee66ee6eeeeeeeee6deeeeeeeeeeeee355dddddd6505555d554544dd44666d7677777766eeeedee66ede66eeee6d6e6dedeede66e6e66d666e6
e6eeeeeddeeee66eeeee6e66ee6eeedeeeeeddeeeeed1dd5ddd66d6505555545d555dd6664677777777715eeeeded6eeedeee6e66eee6e6dddeeeeee6e6ee6ee
6dee6ee6eeedeedeeededeeeeeeee6ee66eeedeeed01ddddddd6666770555d4554d56d666667777777771000dee6deee6e66eeeeede6d66eedee6666ee6eed66
6eeedeee6eded6e6e6eee6e6eee6eeeedeeeeeee05006dddd6d6666777754444dd66d666666777777777000105555d6eeeeeeeed6eedee6eeeeede6eedeeeeee
ddede6eee6eeeeeee6eeeeedeeee6eede6eedd51051566d6d666667777655455556d6666667777777777551100155155ded6e666edeeeeeeeeed6d6ede6eeeed
eeeee66eededdde66edeeeeeeeedeeeede6d2505010dddd6d66666777dd6664d6d466666d6677ef7777751110115115515eeeee6ede6dde6eeeeed6eeee6e6dd
e6eeedeeeeeeeee6e6edeeee6e6e6eedd151501150d66d6b6666666715d666d46d6ddd6666666eef77771d10011515115555eeeee6eeed6deeeeded6eeeee6e6
6e6eede66eedee66ee6ede6eeeeeee111150110000666e9666666670556d66556f66dd666be994eee7771151011010555555555deeeeeeedeeeeee6e6eee6eee
de6eee6dee6e666eeee6ee66d6eee6555350050011fefee6666667115d5d665d67766d6666fee99ee777d6d151150551101515d5eee6ddedeeeee6ddee6ee6e6
d66de66e6eeeeeeeed6edeeeedde6d511150500006feaffd667673355dd6665d677ddd6666eea4e9e776d1e1011515501555555556ee66ee66eee6e6de6e6eee
d6eeee6deeeeeee6deee6eee6dd5d5501155150016eea9e66667030155d667d6676dddd666fe949eee771d1010015551151335555deee6ee6eee6dee6eeeeede
e6eeee6e6eed6e6de6ee6ee6d53555510110110056eeeee667543331d5d66657776dd6d4666e9eeeee75dd600001150515351666d1eededdeeedeee6eee6eeee
eed6eee66ee6eed6eeeeee6ed5544551015110116e9999e7602453b555d7666667dd6108866f99e9e460d1620010105011356dd6d6dedeee66ee6dee6eedee6e
eee6eeedeedeeeeeeeeeeee6d4422255110110006ef7667020245350ddd7666676d6008884f6e99777d01d1000010010101dddd6d66ed666eede6eeeee6edeee
e6eed6ddeeeee6eeeeeee66d94454405011111010d6666050044303010666667775000448456669e672e0dd0110001100115ddd6667fedeedee66eeddeeee6e6
ededeeee6ed6eeededed667454454525510001010001d1194504335000110566600008484055f7667409dd6100001100005dddddeef7deeee6eeede6ee6eee6e
eeed6e6d6ede6ed66d666ddd555445555100010100012d154224d5580000055010000989015556766000dd1210000100105dd5ddefff7eeeeeedd6eeeeeeedee
eeeed6dee66dee66e6666dd555555252111101010000dd10505003344400000500004444055a536744f921210000000005d5dd49e9ff77ed6eeeeedeeeee6ede
eedeede666ee6eeeed666d5553d5511555100100000ddd24445513508940050150048e00055b00310449dd62002000010ddd5d4999f777dedee6eeeeeeeedeee
e66eee6ee6dee6eed666dd555bd515dd550000100000d11425005d534848848818888800155505b05440dde0002020000dddddd69477777eee66deeeeede6ee6
eedde66ded6dd6eed6ddd555bd555554450000100100dd20200550338448848e88e2440055a505dd5590dd10002020005ddd4d6dd667767eee6dededdd6ee6ed
deeeedd66d66eed6ddd6ddd56d155544450010100000d112442553360008484e484811105550000042e2d16000000000dddd66d6666667676e6e6eee6eee6dee
66e6e66eeeede666ddd6d5d6665d54444400000000002d1045045b030001014400010005a40033605901ddd0000000016ddd44666d666777e6e6eeeeee6e6de6
eedeee6ee6dedeeddd5dd55775555444540000000200dd110445451330100505500000145a10d36559402d000000000ddddd4e46db676777dee6eeee6e6e66de
6ee666ee6ee666dd646dd5677555554545000000000211114420035361100010101005b555011304294dd6102022010ddd9994e9676677766edeededdeedd6ee
eeeee6ede6eedd6dd566dd77d555554550000010000001d042000553100005155001055a5015dd14442ddd102000011d699f9444466776767e6e6e66e66eede6
e66eeeededeeeeddddd6dd7715355544550000122020de1d054200335300050000005400501b3d45990211002000001ddda999f49d7777767ededeedddeddd6e
edeeeddeee66e555566dd67655553555510101000000111109550013d355011100055a50005300259416120000000015dd949e94ddd777777eed6eeee66deded
deeeddeeedd6ed555d6dd66d1555356d51000102020002d1225000033055a055055554500316315942dd6000000101555dd94feedd6d77777eeeeededeeeee6e
eee6eedee6de6555166d66655555556dd500000000220dd2145541155305955905aa500013510449e1d1110000000555555d6d6666ddd7777eee6e6eeeeeeeee
de6ee6eeee6ee551566d6661555556d55500010000200d11d442201333b55455055500005d33105491dd000000111155255dd6b66d66d6777d6ee6ee6edeeeee
eeeeee66ed6de555dd666665555556ddd5100000000000d1102020013335000500500013d3b049450d160010000055555555ddddd6dddd677dee6ede6ee6dede
6edeeedeed6ed5056666d6d1555566ddd55001000000202dd1044200003531001010003b600442e00d1610111101115555555dddd6ddddd677edeeeeeeeedee6
d6eeeeeeeeee50556666665555556dddd5100000001000dd1d54250005533330000151d5b1242250ddd0001000001555555555ddd66dddd677eede6eedee6e6d
6ed6eeed6edd55056dd666515156dddd51500000000000012104552000333530051336030194f002dd601010000101555555555ddd66ddd677d6deeeddede6e6
eede6ee6eee6115d666666115556dddd1550000000000001dd1042f500013b36336d3b000242900ddd60000100010555d55d5555ddd66ddd776ee6eeeeeddeee
e6ee6e6deed655566d666d5155d66dd6510001000010101dddd0940100000330d060310004f4000dd110001000155505155d5555dddddddd777ee6ede66edeee
666deeded6ee10067dd666551166d6dd5510100000100011d1d505452000011100000000449e01dd6d0010100055555155155d5555dd6666777feeeeeeed6ee6
edeed6de6eed01066dd66d11557ddddd55111000100110100ddd10449000111500000002450000dded11000000555555555d5d5555dd6d667777eedeedee6e6e
ee6eeee6666e05166dd66d555166d5dd55100000000000000d11204054400000000000592e000dde100010010055555155dd5d55555dd6667777deeeeeeeeeed
edeeeeeee6ee015665d66651516dd5d655510000000010000dd1d60094995500000154f049000dd6100011000015555d5555ddd55056666d77777edee6eee6ee
6eee6eddeeee15566ddd660155ddd5dd0155000000001000000dd100059024055044949e20005dd60000010001515555ddddd55d555666667777766ee6e6eeee
6eeeee6eeeee50666d55665515ddd5dd1155000000100000100dd1dd00094f04e444a4900011d6201101000005111555d66dddd5d015d6d667777dedeedeeeee
eee6eeed6ee605666d556655156ddddd1115000000111001001011d620040525e594900000dd160000100010005501555dd66dddd505666d67777de66ede6e6e
ed6eeeeee6dd01666d556605156ddddd515500000001010000000ddd12000012505200000d1d1d0000001000015551155d666dddd1556666d77776de6edeee6e
eee66edded6615dd6d556601556dd5dd505550000001100000010012dd10000000000100d1600000000000001155550555666d6dd1056666677777eeeeed6dde
eeddeeeeee6d5066dd55d651556ddd55505550000100000000000001ddddd10100000112d1710100000000100115555555d66d66651056666777776ee6eeee6e
eeeee66eddee00d66d55566505dddd5dd51150000000000000000010d11d6dddd2d6ddd611d00000000000001515511555ddd6dd65515666677777e6eeeddedd
eeeeeeeeeede516666151d6001dd55dd555150000010010000010000001dd1d16dddedd600010000000000005155511155d6dd6dd1515666667777e66eeeeeee
ee66e6ee6eeed16666555dd0116d5555505155000000000100000000000110d2e1d2112100000000000000005015510555dd66dd65555666677777ede6e6ee6e
6eeeedeeee6dd566d6d51dd1016dddd55100550001000000000000000000000101100000000001000001000001515555d55d6d6d61155576677777eee66eeeee
