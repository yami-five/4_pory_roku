pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
tex='677765677656777677776566665677777777655ee55677777776555ee55567776665555ee55556665555555665555555665555677655556676eee6e77e6eee6776eee6eeee6eee676655556ee655556655555556655555556665555ee55556667776555ee55567777777655ee556777777776566665677776777656776567776'
chicken_tex='4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444'
t=0
-- function _init()
--     -- tex=zoom_rotator_texture()
-- end
function zoom_rotator_texture()
    local texture=""
    for i=0,8192,1 do
        texture=texture..sub(tostr(@i,true),5,6)
    end
    return texture
end
function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,l_int,tex_size,texture)
    if (y<0 or y>127) return
    local q,n
    n=(flr(y)%2+0.5)*0.5
    x0+=n;
    x1+=n;
    if (x1<x0) q=x0 x0=x1 x1=q
    if (x1<0 or x0>127) return
    y=flr(y+0.5);
    if (x0<0) x0=0
    if (x1>127) x1=127
    x0,x1=flr(x0/2+0.5),flr(x1/2+0.5)
    for x = x0, x1, 1 do
        Ba,Bb=((p1[2]-p2[2])*(x*2-p2[1])+(p2[1]-p1[1])*(y-p2[2]))*inv,((p2[2]-p0[2])*(x*2-p2[1])+(p0[1]-p2[1])*(y-p2[2]))*inv
        Bc=1-Ba-Bb
        uv_x,uv_y=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1],Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
        uv_x = max(0, min(1, uv_x))
        uv_x=flr(uv_x*tex_size+0.5)+1
        uv_y = max(0, min(1, uv_y))
        uv_y=flr(uv_y*tex_size+0.5)
        local texture_color1 = texture[max(0, min(tex_size*tex_size, flr(uv_y *tex_size + uv_x+0.5)))]
        local color="0x11"
        if(l_int>0.7)then color="0x"..texture_color1..texture_color1
        elseif(l_int<=0.7 and l_int>0.3)then color="0x1"..texture_color1
        end
        memset(0x6000 + y * 64 + x, color, 2)
    end
end
    
function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,l_int,tex_size,texture)
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,tex_size,texture);
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,tex_size,texture);
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
    
function tric(a,b,c,d,e,f,uv0,uv1,uv2,l_int,tex_size,texture)
    local e1x,e1y,e2x,e2y=c-a,d-b,e-a,f-b;
    if (e1x*e2y-e1y*e2x<0) return;
    return tri(a,b,c,d,e,f,uv0,uv1,uv2,l_int,tex_size,texture);
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

function draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,textures,calc_light,tex_size)
    for i=1,3*faces,3 do
        local a,b,c,xab,yab,zab,xac,yac,zac,nv,l_dir,l_cos,l_int;
        a,b,c,l_int=f[i],f[i+1],f[i+2],1;
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
            {tc[uv[i]*2+1],tc[uv[i]*2+2]},{tc[uv[i+1]*2+1],tc[uv[i+1]*2+2]},{tc[uv[i+2]*2+1],tc[uv[i+2]*2+2]},l_int,tex_size,textures[tex_i])
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
    draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,{tex},true,16)
end

function draw_torus(p)
	local qt,vertices,order,rings,faces,vt,vm=t*0.01,12,{},6,12,{},{}
	local v=split("-0.75,0.0,1.3,-0.62,0.43,1.08,-0.38,0.43,0.65,-0.25,0.0,0.43,-0.38,-0.43,0.65,-0.62,-0.43,1.08,0.75,0.0,1.3,0.62,0.43,1.08,0.38,0.43,0.65,0.25,0.0,0.43,0.38,-0.43,0.65,0.62,-0.43,1.08,0.75,0.0,-1.3,0.62,0.43,-1.08,0.38,0.43,-0.65,0.25,0.0,-0.43,0.38,-0.43,-0.65,0.62,-0.43,-1.08,-0.75,0.0,-1.3,-0.62,0.43,-1.08,-0.38,0.43,-0.65,-0.25,0.0,-0.43,-0.38,-0.43,-0.65,-0.62,-0.43,-1.08,0.75,0.0,1.3,0.62,0.43,1.08,0.38,0.43,0.65,0.25,0.0,0.43,0.38,-0.43,0.65,0.62,-0.43,1.08,1.5,0.0,0.0,1.25,0.43,0.0,0.75,0.43,0.0,0.5,0.0,0.0,0.75,-0.43,0.0,1.25,-0.43,0.0,-0.75,0.0,-1.3,-0.62,0.43,-1.08,-0.38,0.43,-0.65,-0.25,0.0,-0.43,-0.38,-0.43,-0.65,-0.62,-0.43,-1.08,-1.5,0.0,-0.0,-1.25,0.43,-0.0,-0.75,0.43,-0.0,-0.5,0.0,-0.0,-0.75,-0.43,-0.0,-1.25,-0.43,-0.0,1.5,0.0,-0.0,1.25,0.43,-0.0,0.75,0.43,-0.0,0.5,0.0,-0.0,0.75,-0.43,-0.0,1.25,-0.43,-0.0,0.75,0.0,-1.3,0.62,0.43,-1.08,0.38,0.43,-0.65,0.25,0.0,-0.43,0.38,-0.43,-0.65,0.62,-0.43,-1.08,-1.5,0.0,-0.0,-1.25,0.43,-0.0,-0.75,0.43,-0.0,-0.5,0.0,-0.0,-0.75,-0.43,-0.0,-1.25,-0.43,-0.0,-0.75,0.0,1.3,-0.62,0.43,1.08,-0.38,0.43,0.65,-0.25,0.0,0.43,-0.38,-0.43,0.65,-0.62,-0.43,1.08")
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
	local f=split("0,1,6,2,8,1,2,3,8,3,4,9,5,11,4,5,0,11,1,7,6,8,7,1,3,9,8,4,10,9,11,10,4,0,6,11")
    local tc=split("1.0,0.5,0.0,0.67,-0.0,0.5,1.0,0.83,0.0,0.83,0.0,1.0,1.0,-0.0,-0.0,0.17,-0.0,0.0,1.0,0.33,-0.0,0.33,1.0,0.67,1.0,1.0,1.0,0.17")
    local uv=split("2,1,0,4,3,1,4,5,3,8,7,6,10,9,7,10,2,9,1,11,0,3,11,1,5,12,3,7,13,6,9,13,7,2,0,9")
    for i=1,rings*2,2 do
        local v_r={}
        local vm_r={}
        for j=1+vertices*3*(order[i]-1),vertices*3*order[i] do
            add(v_r,vt[j])
            add(vm_r,vm[j])
        end
	    draw_model(p,qt,vertices,v_r,vm_r,faces,f,tc,uv,{tex},true,16)
    end
end

function zoom_rotator(p)
	local qt,vertices,planes,vt,vm,faces=t*0.01,4,25,{},{},2
	local v=split("-5.0,5.0,-0.0,5.0,5.0,-0.0,-5.0,-5.0,0.0,5.0,-5.0,0.0,5.0,5.0,-0.0,15.0,5.0,-0.0,5.0,-5.0,0.0,15.0,-5.0,0.0,-5.0,15.0,-0.0,5.0,15.0,-0.0,-5.0,5.0,-0.0,5.0,5.0,-0.0,5.0,15.0,-0.0,15.0,15.0,-0.0,5.0,5.0,-0.0,15.0,5.0,-0.0,-5.0,-5.0,0.0,5.0,-5.0,0.0,-5.0,-15.0,0.0,5.0,-15.0,0.0,5.0,-5.0,0.0,15.0,-5.0,0.0,5.0,-15.0,0.0,15.0,-15.0,0.0,-15.0,5.0,-0.0,-5.0,5.0,-0.0,-15.0,-5.0,0.0,-5.0,-5.0,0.0,-15.0,15.0,-0.0,-5.0,15.0,-0.0,-15.0,5.0,-0.0,-5.0,5.0,-0.0,-15.0,-5.0,0.0,-5.0,-5.0,0.0,-15.0,-15.0,0.0,-5.0,-15.0,0.0,-25.0,5.0,-0.0,-15.0,5.0,-0.0,-25.0,-5.0,0.0,-15.0,-5.0,0.0,-25.0,15.0,-0.0,-15.0,15.0,-0.0,-25.0,5.0,-0.0,-15.0,5.0,-0.0,-25.0,-5.0,0.0,-15.0,-5.0,0.0,-25.0,-15.0,0.0,-15.0,-15.0,0.0,-25.0,25.0,-0.0,-15.0,25.0,-0.0,-25.0,15.0,-0.0,-15.0,15.0,-0.0,-25.0,-15.0,0.0,-15.0,-15.0,0.0,-25.0,-25.0,0.0,-15.0,-25.0,0.0,15.0,5.0,-0.0,25.0,5.0,-0.0,15.0,-5.0,0.0,25.0,-5.0,0.0,15.0,15.0,-0.0,25.0,15.0,-0.0,15.0,5.0,-0.0,25.0,5.0,-0.0,15.0,-5.0,0.0,25.0,-5.0,0.0,15.0,-15.0,0.0,25.0,-15.0,0.0,15.0,25.0,-0.0,25.0,25.0,-0.0,15.0,15.0,-0.0,25.0,15.0,-0.0,15.0,-15.0,0.0,25.0,-15.0,0.0,15.0,-25.0,0.0,25.0,-25.0,0.0,-5.0,25.0,-0.0,5.0,25.0,-0.0,-5.0,15.0,-0.0,5.0,15.0,-0.0,5.0,25.0,-0.0,15.0,25.0,-0.0,5.0,15.0,-0.0,15.0,15.0,-0.0,-15.0,25.0,-0.0,-5.0,25.0,-0.0,-15.0,15.0,-0.0,-5.0,15.0,-0.0,-5.0,-15.0,0.0,5.0,-15.0,0.0,-5.0,-25.0,0.0,5.0,-25.0,0.0,5.0,-15.0,0.0,15.0,-15.0,0.0,5.0,-25.0,0.0,15.0,-25.0,0.0,-15.0,-15.0,0.0,-5.0,-15.0,0.0,-15.0,-25.0,0.0,-5.0,-25.0,0.0")
    for i=1,planes,1 do
        for j=1+vertices*3*(i-1),vertices*3*i,3 do
            local x,y,z=v[j],v[j+1],v[j+2];
            z-=22-11*sin(t%10*0.1)
            -- z+=sin(t*0.005)
            -- z-=11 -- max zoom
            -- z-=33 -- min zoom
            x,y=rotate(x,y,qt);
            add(vm,x);
            add(vm,y);
            add(vm,z);
            z+=5;
            x=x*96/z+64;
            y=y*96/z+64;
            vt[j],vt[j+1],vt[j+2]=flr(x+0.5),flr(y+0.5),flr(z+0.5);
        end
    end
	local f=split("0,2,1,2,3,1")
    local tc=split("1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0")
    local uv=split("2,1,0,1,3,0")
    for i=1,planes,1 do
        local v_r,vm_r={},{}
        for j=1+vertices*3*(i-1),vertices*3*i do
            add(v_r,vt[j])
            add(vm_r,vm[j])
        end
	    draw_model(p,qt,vertices,v_r,vm_r,faces,f,tc,uv,{tex},false,128)
    end
end

function draw_cube_anim(p)
    local textures,qt,vertices,faces,vt,vm=draw_plasmas(),t*0.01,8,12,{},{}
	local v=split("1.5,1.5,-1.5,1.5,-1.5,-1.5,1.5,1.5,1.5,1.5,-1.5,1.5,-1.5,1.5,-1.5,-1.5,-1.5,-1.5,-1.5,1.5,1.5,-1.5,-1.5,1.5")
	local f=split("0,2,4,3,7,2,7,5,6,5,7,1,1,3,0,5,1,4,2,6,4,7,6,2,5,4,6,7,3,1,3,2,0,1,0,4")
    local tc=split("1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0")
    local uv=split("2,1,0,2,1,0,1,3,2,0,2,3,2,1,0,1,3,2,1,3,0,1,3,0,3,0,2,2,1,3,1,3,0,3,0,2")
    for j=1,vertices*3,3 do
        local x,y,z=v[j],v[j+1],v[j+2];
        y,z=rotate(y,z,qt);
        x,z=rotate(x,z,qt*1.5);
        -- x,y=inf(qt+p,x,y)
        -- y-=1
        add(vm,x);
        add(vm,y);
        add(vm,z);
        z=z+5;
        x=x*96/z+64;
        y=y*96/z+64;
        vt[j],vt[j+1],vt[j+2]=flr(x),flr(y),flr(z);
    end
    draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,textures,false,32)
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
        for j=0,64,2 do
            if(i%2==0)then
                poke(0x7fc0-i*64+j,@(0x6000+i*128+j))
            else 
                poke(0x7fc0-i*64+j-1,@(0x6000+i*128+j-1))
            end
        end
    end
end

-- function _update()
--     t+=1
-- end

-- function _draw()
--     cls()
--     draw_chicken()
-- end

function draw_chicken(p)
	local qt,vertices,faces,vt,vm=t*0.01,82,162,{},{}
	local v=split("-1.12,1.07,0.0,-0.66,0.96,0.71,0.15,0.82,0.99,-0.54,-0.81,0.0,-1.17,0.03,0.0,0.03,-1.0,0.0,-0.59,-0.22,0.8,0.03,-0.5,1.09,-0.38,2.73,0.0,-0.72,2.44,0.0,-0.04,2.82,0.0,0.35,2.57,0.0,-0.42,2.47,0.42,-0.09,2.54,0.51,0.24,2.57,0.29,0.76,1.35,0.0,1.82,1.0,0.0,2.26,0.51,0.0,0.91,0.55,1.01,1.82,0.51,0.57,1.41,-0.65,0.0,1.13,-0.33,0.9,2.23,1.31,0.0,0.46,1.76,0.54,-0.82,1.89,0.0,-0.48,1.86,0.54,0.04,1.84,0.68,0.52,2.08,0.0,1.98,-0.11,0.0,1.59,0.04,0.69,0.77,-1.55,0.56,0.77,-1.55,0.75,0.96,-1.55,0.56,0.96,-1.55,0.75,0.77,-1.99,0.51,0.77,-1.99,0.8,0.96,-1.99,0.56,0.96,-1.99,0.75,0.77,-1.86,0.56,0.96,-1.86,0.56,0.77,-1.86,0.75,0.96,-1.86,0.75,0.77,-1.99,0.66,0.96,-1.86,0.66,0.07,-1.99,0.47,0.07,-1.99,0.84,1.26,-1.99,0.66,-1.18,1.89,0.0,-0.81,2.11,0.0,-0.74,1.89,0.14,-0.66,0.96,-0.71,0.15,0.82,-0.99,-0.59,-0.22,-0.8,0.03,-0.5,-1.09,-0.42,2.47,-0.42,-0.09,2.54,-0.51,0.24,2.57,-0.29,0.91,0.55,-1.01,1.82,0.51,-0.57,1.13,-0.33,-0.9,0.46,1.76,-0.54,-0.48,1.86,-0.54,0.04,1.84,-0.68,1.59,0.04,-0.69,0.77,-1.55,-0.56,0.77,-1.55,-0.75,0.96,-1.55,-0.56,0.96,-1.55,-0.75,0.77,-1.99,-0.51,0.77,-1.99,-0.8,0.96,-1.99,-0.56,0.96,-1.99,-0.75,0.77,-1.86,-0.56,0.96,-1.86,-0.56,0.77,-1.86,-0.75,0.96,-1.86,-0.75,0.77,-1.99,-0.66,0.96,-1.86,-0.66,0.07,-1.99,-0.47,0.07,-1.99,-0.84,1.26,-1.99,-0.66,-0.74,1.89,-0.14")
	local f=split("3,4,6,14,10,11,12,8,13,6,7,3,1,2,6,9,8,12,25,1,49,22,17,19,29,21,18,21,7,18,25,26,1,29,19,28,22,19,16,13,10,14,26,23,2,31,30,5,18,15,19,14,11,27,13,14,26,48,12,49,23,27,15,21,29,20,18,19,29,36,39,38,31,7,21,30,32,20,32,33,21,38,40,42,37,35,40,32,39,43,43,33,32,40,31,33,38,30,31,38,39,32,43,41,33,43,37,41,36,43,39,42,44,38,40,45,42,37,46,36,37,42,35,34,42,36,36,42,37,34,44,42,38,44,34,35,45,40,42,45,35,36,46,43,43,46,37,0,1,4,24,49,0,49,24,48,12,13,25,12,48,9,47,48,49,24,47,49,8,10,13,7,5,3,2,7,6,7,2,18,26,2,1,19,17,28,23,18,2,7,31,5,15,16,19,23,14,27,14,23,26,12,25,49,18,23,15,29,28,20,34,36,38,33,31,21,5,30,20,20,32,21,41,37,40,41,40,33,40,38,31,30,38,32,1,6,4,49,1,0,13,26,25,4,3,52,10,56,11,8,54,55,53,52,3,51,50,52,8,9,54,50,61,81,17,22,58,59,63,57,53,59,57,62,61,50,58,63,28,58,22,16,10,55,56,60,62,51,64,65,5,15,57,58,11,56,27,56,55,62,54,48,81,27,60,15,63,59,20,58,57,63,73,70,72,53,65,59,66,64,20,67,66,59,74,72,76,69,71,74,73,66,77,67,77,66,65,74,67,64,72,65,73,72,66,75,77,67,71,77,75,77,70,73,78,76,72,79,74,76,80,71,70,76,71,69,76,68,70,76,70,71,78,68,76,78,72,68,79,69,74,79,76,69,80,70,77,80,77,71,50,0,4,81,24,0,24,81,48,55,54,61,48,54,9,48,47,81,47,24,81,10,8,55,5,53,3,53,51,52,51,53,57,51,62,50,17,58,28,57,60,51,65,53,5,16,15,58,56,60,27,60,56,62,61,54,81,60,57,15,28,63,20,70,68,72,65,67,59,64,5,20,66,20,59,71,75,74,74,75,67,72,74,65,72,64,66,52,50,4,50,81,0,62,55,61")
    local tc=split("0.2,0.26,-0.0,0.31,0.08,0.1,0.38,0.86,0.29,0.89,0.34,0.82,0.28,0.79,0.22,0.88,0.23,0.78,0.33,0.18,0.36,0.46,0.19,0.49,0.14,0.82,0.12,0.7,0.21,0.67,0.78,0.8,0.93,0.84,0.88,0.99,0.59,0.74,0.7,0.59,0.76,0.69,0.52,0.41,0.57,0.22,0.32,0.67,0.93,0.7,0.79,0.95,0.41,0.67,0.57,0.0,0.63,0.23,0.6,0.22,0.57,1.0,0.46,0.79,0.1,0.76,0.57,0.67,0.89,0.54,0.95,0.24,0.98,0.28,0.95,0.28,0.89,0.24,0.81,0.03,0.83,0.43,0.61,0.33,0.64,0.31,0.64,0.27,0.98,0.38,0.95,0.39,0.95,0.36,0.98,0.32,0.98,0.36,0.95,0.3,0.89,0.28,0.89,0.32,0.89,0.36,0.89,0.39,0.95,0.32,0.92,0.54,0.89,0.54,0.89,0.39,0.93,0.54,0.96,0.55,0.93,0.69,0.91,0.18,0.95,0.18,0.93,0.24,0.96,0.14,0.93,0.14,0.9,0.14,0.89,-0.0,0.95,0.52,0.98,0.56,0.97,-0.0,0.09,0.9,0.11,0.92,0.06,0.96,0.06,0.89,0.02,0.53,0.08,0.71,0.14,0.95,0.11,0.91,0.14,0.89,0.05,0.9,0.0,0.98,0.0,0.89,0.06,0.94,0.16,-0.0,0.98,0.24,0.57,0.54,0.89,0.24")
    local uv=split("2,1,0,5,4,3,8,7,6,0,9,2,11,10,0,12,7,8,14,11,13,17,16,15,20,19,18,22,9,21,14,23,11,20,15,24,17,15,25,6,4,5,23,26,10,29,28,27,18,30,15,3,5,31,6,5,23,32,8,13,31,26,33,19,20,34,18,15,20,37,36,35,39,28,38,42,41,40,43,42,38,46,45,44,48,47,46,37,50,49,51,49,50,52,46,51,53,45,52,37,35,50,54,49,51,47,49,54,49,36,37,57,56,55,60,59,58,63,62,61,65,62,64,65,66,61,65,61,62,67,66,65,57,55,68,60,69,59,70,65,64,73,72,71,73,71,74,75,11,1,76,13,75,79,78,77,8,6,14,8,32,12,82,81,80,81,83,80,7,4,6,9,84,2,10,9,0,9,10,21,23,10,11,15,16,24,26,21,10,28,39,27,30,25,15,5,26,31,5,26,23,8,14,13,26,21,33,20,24,34,36,85,35,28,43,38,41,86,40,42,40,38,47,54,46,46,54,51,45,46,52,35,87,50,11,0,1,13,11,75,6,23,14,1,2,0,4,5,3,7,8,6,9,0,2,10,11,0,7,12,8,11,14,13,16,17,15,19,20,18,9,22,21,23,14,11,15,20,24,15,17,25,4,6,5,26,23,10,28,29,27,30,18,15,5,3,31,5,6,23,8,32,13,26,31,33,20,19,34,15,18,20,36,37,35,28,39,38,41,42,40,42,43,38,45,46,44,47,48,46,50,37,49,49,51,50,46,52,51,45,53,52,35,37,50,49,54,51,49,47,54,36,49,37,56,57,55,59,60,58,62,63,61,62,65,64,66,65,61,61,65,62,66,67,65,55,57,68,69,60,59,65,70,64,72,73,71,71,73,74,11,75,1,13,76,75,78,79,77,6,8,14,32,8,12,81,82,80,83,81,80,4,7,6,84,9,2,9,10,0,10,9,21,10,23,11,16,15,24,21,26,10,39,28,27,25,30,15,26,5,31,26,5,23,14,8,13,21,26,33,24,20,34,85,36,35,43,28,38,86,41,40,40,42,38,54,47,46,54,46,51,46,45,52,87,35,50,0,11,1,11,13,75,23,6,14")
    for j=1,vertices*3,3 do
        local x,y,z=v[j],v[j+1],v[j+2];
        y,z=rotate(y,z,qt);
        x,z=rotate(x,z,qt*1.5);
        -- x,y=inf(qt+p,x,y)
        -- y-=1
        add(vm,x);
        add(vm,y);
        add(vm,z);
        z=z+5;
        x=x*96/z+64;
        y=y*96/z+64;
        vt[j],vt[j+1],vt[j+1]=flr(x),flr(y),flr(z);
    end
    draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,{chicken_tex},true,16)
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000066676677667666600000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000006667777677677777666600000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000666777777776677766667666000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000006677777777667777677766776660000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000067777777766676666667766677760000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006676777777667777776667667767776000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000066767667766677777766777767766777600000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000667767767667677777677777776667777660000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000677776666677767777677777667767777660000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006777776677767766677677766777777777666000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000677666677777667777677d6677777777677766600000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000677667677777777dd765d6dd677777777767776666000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000067777677777776d5555dddded67777777767776776660000000000000000000000000000000000000000000000
0000000000000000000000000000000000000667776677777d5254d4d4dddded6677777777767777760000000000000000000000000000000000000000000000
000000000000000000000000000000000000067777677776d54d5d5d5d4ddddfff66677777667777760000000000000000000000000000000000000000000000
0000000000000000000000000000000000000677766777d52ddd45454d5ddd6e6ff7667766666676760000000000000000000000000000000000000000000000
000000000000000000000000000000000000067766776554dd45dd5d5d4d4dddff77776766677666666000000000000000000000000000000000000000000000
0000000000000000000000000000000000000066777625454ddd54d4d5d5dded6ff7777666766777667660000000000000000000000000000000000000000000
0000000000000000000000000000000000000666667d25d5d5dd4d5d54d4dddedf77777766766677766766000000000000000000000000000000000000000000
000000000000000000000000000000000006667666765d5d4dd4d5d54d55dddd6f777777d6777667776776000000000000000000000000000000000000000000
000000000000000000000000000000000066777677675445d5dd5d4d5d4ddde6ef77777666767766666766000000000000000000000000000000000000000000
00000000000000000000000000000000006777667766d5d45ddd4d54d5ddddde6f77777766666777667760000000000000000000000000000000000000000000
0000000000000000000000000000000000667766676762554d4dd5dd54dddd6dff77777766776667777660000000000000000000000000000000000000000000
0000000000000000000000000000000000066666676665d4d5dd4d454ddddedffff6f6776d676666667760000000000000000000000000000000000000000000
000000000000000000000000000000000000676677766d455ddddd5dddddefddd55555576d776776666660000000000000000000000000000000000000000000
00000000000000000000000000000000000067666666d554ddd4d5454ddddd65555de6f776677767766600000000000000000000000000000000000000000000
00000000000000000000000000000000000067667667d4d525515555d4ddd55105255df777d76666760000000000000000000000000000000000000000000000
00000000000000000000000000000000000066776667655555520105d545410005555d5d777d5d56766000000000000000000000000000000000000000000000
00000000000000000000000000000000000067777767dd55252000004ddd55006fd6fdd667752ddd660000000000000000000000000000000000000000000000
00000000000000000000000000000000000066676677ddd2155550005ddde525f6d55677777d5dd6000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000676676d400e6df7f1005567f500055567f77751766000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000066750dd55d6d55d502d5f77f5525dddf7f775576d000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006d05e5dd5551505ddd26777ddddddde6f776d756000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000d501dd55d555555ddd56777edddd4d6ff7777650000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006d50dd45254554dddd467777ddd5dde6f777f560000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006dd05ddd4d5d4ddddd5d777ffedd5ddef7760600000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000006df54ddddd54dddddd4d777f6fdd4dd6f67d1600000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000d5ddd5dd4d554ddddd5f77f6ddd5dddf7765600000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000d2d5d4d5d4dd545dd25f77d5d545dde7767760000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000005255d5d5d55d55dd05fd5545d55dd6f766760000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000065dd45455545552000d556625d4ddf7766760000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006d75d55455525d55505f7f6d25dde6f766776000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000067755455252555dddd5d7f7f555ddff766776600000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000677d25525555dddd5d5d7777d0dd6f77d6777600000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000667655555255dddd2525555d5056ef7667777760000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006677d2525525dd5000054dddfd56676577777760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000067776525255250002525dff67fdd771d77767760000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006777775255552522525505de6d6f755777777760000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000006777777d552555555525dd6d66d7557677776760000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000677777755552525dddf777f6e6d57f677766760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000006777677d2525555dddd776f66d577f677766760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000006776677d5555525dd5566f66d5f7f7d67766760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000006776677d5dd5155d5525d6dd5f777f676776760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000677676d545d52525500055577f77f677667760000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000067776765d545d5510112d67ff7f76677667760000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000677667755d555545452d7fff6f77e677767760000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000666776545d4545d555df6f6f77fd677776600000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000006776755d55d555452df6f6ff76d567776600000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000667766554d5545d555d7f6f67fd5d77777660000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000067777600555d555452dff6f6ed56777777776000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000667777760045545d555d66ddd5567777777776600000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000066777777771045545d5454d5d25677767777777600000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000067777777777505d545d555522d7776777777777666660000000000000000000000000000000000000000
00000000000000000000000000000000000000000666677777777777d502d555d25dd77777777777777667766000000000000000000000000000000000000000
0000000000000000000000000000000000000000677667777777777777d554d45d67777777777777777767777666600000000000000000000000000000000000
000000000000000000000000000000000000006677767777766777777776d5555777777767777e67777dd7777777766600000000000000000000000000000000
000000000000000000000000000000000006667777667777666777777667762576677777666774d777d116777777777766000000000000000000000000000000
0000000000000000000000000000000066677777776777d66677777766777755677677777766dffd67111d777777777777666000000000000000000000000000
000000000000000000000000000000066777777777d77ddf77777776677777556777677766d6977fd7111d77777777777776d660000000000000000000000000
00000000000000000000000000000667d6677777764d97f6677773377777775d77777677f4777deff77111d777777777777fd2d6000000000000000000000000
0000000000000000000000000006677742d777777dff4ff67d2233367777775d77777767747769ae667111377777777777d64477660000000000000000000000
00000000000000000000000006677777d67677776dde69677222333d777777dd7777777d22df9674fd7111d777777777764de677760000000000000000000000
000000000000000000000000677677767edf777766edef67e9222337777777d677777772222da44f7fe111d6777777777d2e7676760000000000000000000000
00000000000000000000000067676777752677776e79e6d999223336777777d67777767222267f9e7dd1111d777777777e467777776000000000000000000000
000000000000000000000006f66766677ff76776d4df66f99922333d777777d677766722227fe6aed9d631167776777744777777776000000000000000000000
00000000000000000000006677de6f6d67767777666615da99223337766677677767772222aaa966f99961177777777d42677777766600000000000000000000
0000000000000000000666776677d576672f7777777111da9992333777776666767772222faaaf777999111d77677776df67777776f660000000000000000000
00000000000000000667767776f6de677d467777777d111e99923334777777766777222227aaadd6699ed1117777777767777776dd7760000000000000000000
00000000000000006777677777d67777667777777776111f9997d33227777767777222227faaf333599f11114d67777f67777766dde676600000000000000000
00000000000000006777677777766776677777777776111e999ad33322277677662222227aaaf333999911152dd67776777766f7e66777600000000000000000
000000000000000067777777776df76de6777777777d111e999a333322222222222222277aaa733399941115467d677777777f66767777760000000000000000
00000000000000006776777777d7767666777777767d111d999aa3332222222222222277aaaf7333999d11d246774677677766f77d6777760000000000000000
00000000000000006776777777d76f6f7667777767761116999aa3337772222222227777aaaf733d999111524777267777777e677f6677776000000000000000
0000000000000006776777777767776e6d677766777611169999a333777777722777777aaaf733399991111226744f76777766777e6767776000000000000000
0000000000000006776777777677766f6d77776d7776111d9999a333377777777777777aaa7733399995112222de6677776676677766df776000000000000000
00000000000000677767777776776f6d766777dd77761115e99973333777777777777faaaa7733d9999111244e674f7776764d66777667776000000000000000
0000000000000067767777776776767fd67777d477661115999963333777777767777aaaf773336999d111dd66d45767777e77f7677777776000000000000000
000000000000067776777777677f6e77667777e5d7f21112d99976333aa777777777faaa7763339999711d467f227777666767dd667767777600000000000000
000000000000067776777776776d776d776777dd76fd5113e999773333aaf777777faaaf773336999931122ed24777667fde646ff76776777600000000000000
00000000000006776777777777777766776777dd777771127f99f73333aaaa7777aaaaa7733336e99d1115d22477767667667e66777677777600000000000000
00000000000006776777777777777677776776f6664d6111df999773333aaaaaaaaaaaa733333d999611d6ed67776777667767f6677766677600000000000000
00000000000006776777777777776777776777e6642661116f999773333aaaaaaaaa7777333369999d1167777dd7777777677767f77777677600000000000000
000000000000677767777777777767777767777ddfdd2411d7e99773333377aaaa777777333999996111d767de66777777767776677777667600000000000000
00000000000067776777777777776777776777777777d711137999776333377777777733336999967113e766767777777777677f677777777600000000000000
00000000000067767777777777767777776777777777671111f999777333333777773333379999961116d67d6776777777777677777777777600000000000000
000000000000677677777777776777777767777767776761117e99977733333333333333379999711117f66e7767776777777767777777767760000000000000
000000000000677677777777776777777767777777676de111d7999f77773333333333377999997111177de77767767777777776777777777760000000000000
00000000000067767777777777677777776777777d76ed7211d7999e777773333333337799999761116776d77777776777777777677777767776000000000000
000000000006677677777777776777777767777776f6d6661156799997777777337777779999771111766f677677776777777777767777776776000000000000
00000000000677767777767777677777776777777776e667711167999e7777767777777999997611117e66767777776777777777767777767776000000000000
0000000000067767777776777767777777677777767777777111d7e9999e77676777779999776111d776df767677777677777777767777776777600000000000
00000000000677677777767776777777767677777777767676111d779999ff7666776999997711116777dde77777776777777777767777776777760000000000
00000000000677677777767776777777677677777777767767611167f9999999999e9999e7761111677776777677776777777777767777776777760000000000
0000000000067767777777677677777767767777776777777771111d7ff9999999999999776111d6777776776777776777777777767777776777760000000000
0000000000067767777777677677777767776777776666d67776d111d77f99999999999777111177777776776777776777777777766777776777760000000000
000000000006776777777767767777776777677777767e67777771111d67777e9999977761111d7777776f777777766777777777677667777677760000000000
00000000000067677777776776777777677767777776ed6777777dd11117777777777777111167777777d7776777677677777777677767777677760000000000
000000000000676777777767767777777677677777776e7777777771111116777767111111117776777677777777777677777777677767777677760000000000
00000000000066777777776776777777767767777777677777777776d31111111111111111177776777777776777777677777777767767777677760000000000
00000000000006777777776776777777767776777777677777777777771111111111111177777776777777777777776777777777767776777677760000000000
00000000000006777777776776777777767776777777677777777777777dd61111111d1677777767777777767777776777777777767776777677776000000000
000000000000067777777776767777777677777777776777777777777777776d6666777777777767777777767777776777777777767776777677776000000000
