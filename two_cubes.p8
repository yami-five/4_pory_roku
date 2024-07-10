pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

t=0
textures={'999999999','bbbbbbbbb'}
function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,l_int,texture)
    -- cieniowanie: zliczaj piksele i rysuj co ktれはryわい tylko
    if (y<0 or y>127) return
    local q,n
    n=(flr(y)%2)*0.5
    x0+=n;
    x1+=n;
    if (x1<x0) q=x0 x0=x1 x1=q
    if (x1<0 or x0>127) return
    y=flr(y);
    if (x0<0) x0=0
    if (x1>127) x1=127
    x0=flr(x0/2);
    x1=flr(x1/2);
    for x = x0, x1, 1 do
        Ba=((p1[2]-p2[2])*(x*2-p2[1])+(p2[1]-p1[1])*(y-p2[2]))*inv
        Bb=((p2[2]-p0[2])*(x*2-p2[1])+(p0[1]-p2[1])*(y-p2[2]))*inv
        Bc=1-Ba-Bb
        uv_x=Ba*uv0[1]+Bb*uv1[1]+Bc*uv2[1]
        uv_y=Ba*uv0[2]+Bb*uv1[2]+Bc*uv2[2]
        uv_x = max(0, min(1, uv_x))
        uv_x=flr(uv_x*3)+1
        uv_y = max(0, min(1, uv_y))
        uv_y=flr(uv_y*3)+1
        texture_index=flr((uv_y-1) *3 + uv_x)
        texture_index = max(0, min(256, texture_index))
        local texture_color1 = sub(texture,texture_index,texture_index)
        local color
        if(l_int>0.7)then color="0x"..texture_color1..texture_color1
        elseif(l_int<=0.7 and l_int>0.3)then color="0x1"..texture_color1
        else color="0x11"
        end
        memset(0x6000 + y * 64 + x, color, 2)
    end
end
    
function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,l_int,texture)
    local x,xx,y,q,q2,uv;
    if (y0>y1) y=y0;y0=y1;y1=y;x=x0;x0=x1;x1=x;uv=uv0;uv0=uv1;uv1=uv;
    if (y0>y2) y=y0;y0=y2;y2=y;x=x0;x0=x2;x2=x;uv=uv0;uv0=uv2;uv2=uv;
    if (y1>y2) y=y1;y1=y2;y2=y;x=x1;x1=x2;x2=x;uv=uv1;uv1=uv2;uv2=uv;
    local dx01,dy01,dx02,dy02;
    local xd,xxd;
    if (y2<0 or y0>127) return --clip
    y=y0;
    x=x0;
    xx=x0;
    dx01=x1-x0;
    dy01=y1-y0;
    dy02=y2-y0;
    dx02=x2-x0;
    dx12=x2-x1;
    dy12=y2-y1;
    q2=0;
    xxd=1; if(x2<x0) xxd=-1
    inv=1/((y1-y2)*(x0-x2)+(x2-x1)*(y0-y2))
    if flr(y0)<flr(y1) then
        q=0;
        xd=1; if(x1<x0) xd=-1
        while y<=y1 do
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,texture);
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
        q=0;
        x=x1
        xd=1; if (x2<x1) xd=-1
        while y<=y2 and y<128 do
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,texture);
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
    
function tric(a,b,c,d,e,f,uv0,uv1,uv2,l_int,texture)
    local e1x,e1y,e2x,e2y,xpr;
    e1x=c-a;
    e1y=d-b;
    e2x=e-a;
    e2y=f-b;
    xpr=e1x*e2y-e1y*e2x;
    if (xpr<0) return;
    return tri(a,b,c,d,e,f,uv0,uv1,uv2,l_int,texture);
end
    
    
function rotate(x,y,a)
    local c=cos(a) s=sin(a)
    return c*x-s*y, s*x+c*y
end

function rotate2(x,y,a)
    local xP=2 yP=1 
    local c=cos(a) s=sin(a)
    return c*(x-xP)-s*(y-yP)+xP, s*(x-xP)+c*(y-yP)+yP
end

function translation(x,y,z,xT,yT,zT)
    return x+xT,y+yT,z+zT
end

function draw_model(p,qt,vertices,vt,faces,f,tc,uv,texture)
    local r
-- transform
    -- vt={};
    -- for i=1,3*vertices,3 do
    --     local x,y,z;
    --     -- read
    --     x=v[i];
    --     y=v[i+1];
    --     z=v[i+2];
    --         -- process
    --     -- x,y,z=translation(x,y,z,1,0,0)
    --     --rotacja
    --     y,z=rotate(y,z,qt*0.9);
    --     x,z=rotate(x,z,qt*0.3);
    --     -- x,z=rotate(x,z,qt*0.3)
    --     -- x,y=rotate(x,y,qt*0.3)
    --     -- y,z=rotate(y,z,0.125)
    --     x,y=inf(qt+p,x,y)
    --     y-=1
    --     -- x+=2*(cos(qt))+1+px
    --     -- y+=sin(qt)*cos(qt)*2+py
    --     --przesuwanie gora dol i na boki
    --     -- x+=sin(t*0.007); 	
    --     -- y+=sin(t*0.005);
    --     --ustawianie wspolrzednych
    --     z=z+5;
    --     x=x*96/z+64;
    --     y=y*96/z+64;
    --         -- write
    --     vt[i]=flr(x);
    --     vt[i+1]=flr(y);
    --     vt[i+2]=flr(z);
    -- end
    -- printh(vt[4].." "..vt[5].." "..vt[6].." "..t, "loggg.txt")

    -- material
    colors={
        0xbbbb,
        0x8888,
        0xaaaa,
        0xeeee,
        0xdddd,
        0xcccc,
    }
        -- triangles
    for i=1,3*faces,3 do
        --petla wyciaga kolejne sciany z listy
        local a,b,c,xab,yab,zab,xac,yac,zac,nv,l_dir,l_cos,l_int;
        a=f[i];
        b=f[i+1];
        c=f[i+2];
        -- flat shading
        -- normal vector
        xab=vt[b*3+1]-vt[a*3+1]
        yab=vt[b*3+2]-vt[a*3+2]
        zab=vt[b*3+3]-vt[a*3+3]
        xac=vt[c*3+1]-vt[a*3+1]
        yac=vt[c*3+2]-vt[a*3+2]
        zac=vt[c*3+3]-vt[a*3+3]
        nv={yab*zac-zab*yac,zab*xac-xab*zac,xab*yac-yab*xac}
        vec_len=v3_len({nv[1]*0.001,nv[2]*0.001,nv[3]*0.001})*1000
        -- printh(nv[1].." "..nv[2].." "..nv[3].." ", "loggg.txt")
        nv[1]=nv[1]/vec_len
        nv[2]=nv[2]/vec_len
        nv[3]=nv[3]/vec_len
        nv_len=v3_len(nv)
        -- light direction
        tx=(vt[a*3+1]+vt[b*3+1]+vt[c*3+1])/3
        ty=(vt[a*3+2]+vt[b*3+2]+vt[c*3+2])/3
        tz=(vt[a*3+3]+vt[b*3+3]+vt[c*3+3])/3
        l_dir={50-tx,50-ty,50-tz}
        l_len=v3_len(l_dir)
        -- cos
        l_dir_nv=v3_len({l_dir[1]-nv[1],l_dir[2]-nv[2],l_dir[3]-nv[3]})
        x=nv_len*nv_len+l_len*l_len-l_dir_nv*l_dir_nv
        y=l_len*nv_len*2
        l_cos=x/y
        l_int=max(0.1,l_cos)
        -- printh(nv[1].." "..nv[2].." "..nv[3].." "..vec_len, "loggg.txt")
        -- printh(l_cos.." "..x.." "..y.." "..t, "loggg.txt")
        -- printh(l_len.." "..nv_len, "loggg.txt")
        -- printh(l_int, "loggg.txt")
        -- printh(".....................", "loggg.txt")
        -- printh(l_int.." "..t, "loggg.txt")
        tric(
            vt[a*3+1],
            vt[a*3+2],
            vt[b*3+1],
            vt[b*3+2],
            vt[c*3+1],
            vt[c*3+2],
            {tc[uv[i]*2+1],tc[uv[i]*2+2]},{tc[uv[i+1]*2+1],tc[uv[i+1]*2+2]},{tc[uv[i+2]*2+1],tc[uv[i+2]*2+2]},l_int,texture)
    end
end
function draw_cubes(p)
	-- cls()
	-- stripes
	    
	local qt,s;
    s=0.35
	qt=t*0.01;
	
	-- model
    vertices=8
    local order={}
    cubes=2
	v={
        1.0*s+1, 1.0*s, -1.0*s, 
        1.0*s+1, -1.0*s, -1.0*s, 
        1.0*s+1, 1.0*s, 1.0*s, 
        1.0*s+1, -1.0*s, 1.0*s, 
        -1.0*s+1, 1.0*s, -1.0*s, 
        -1.0*s+1, -1.0*s, -1.0*s, 
        -1.0*s+1, 1.0*s, 1.0*s, 
        -1.0*s+1, -1.0*s, 1.0*s,
        1.0*s-1, 1.0*s, -1.0*s, 
        1.0*s-1, -1.0*s, -1.0*s, 
        1.0*s-1, 1.0*s, 1.0*s, 
        1.0*s-1, -1.0*s, 1.0*s, 
        -1.0*s-1, 1.0*s, -1.0*s, 
        -1.0*s-1, -1.0*s, -1.0*s, 
        -1.0*s-1, 1.0*s, 1.0*s, 
        -1.0*s-1, -1.0*s, 1.0*s
    };
    local vt={};
    local vm={};
    for i=1,2,1 do
        for j=1+vertices*3*(i-1),vertices*3*i,3 do
            local x,y,z;
            -- read
            x=v[j];
            y=v[j+1];
            z=v[j+2];
                -- process
            -- x,y,z=translation(x,y,z,1,0,0)
            --rotacja
            y,z=rotate(y,z,qt*0.9);
            x,z=rotate(x,z,qt*0.3);
            add(vm,x);
            add(vm,y);
            add(vm,z);
            -- x,z=rotate(x,z,qt*0.3)
            -- x,y=rotate(x,y,qt*0.3)
            -- y,z=rotate(y,z,0.125)
            -- x,y=inf(qt+p,x,y)
            -- y-=1
            -- x+=2*(cos(qt))+1+px
            -- y+=sin(qt)*cos(qt)*2+py
            --przesuwanie gora dol i na boki
            -- x+=sin(t*0.007); 	
            -- y+=sin(t*0.005);
            --ustawianie wspolrzednych
            z=z+5;
            x=x*96/z+64;
            y=y*96/z+64;
                -- write
            vt[j]=flr(x);
            vt[j+1]=flr(y);
            vt[j+2]=flr(z);
        end
    end
    clear={}
    for i=1,cubes,1 do
        local x=0
        local y=0
        local z=0
        for j=1,vertices*3,3 do
            x+=vm[j*i]
            y+=vm[(j+1)*i]
            z+=vm[(j+2)*i]
            -- printh(vt[j*i].." "..vt[(j+1)*i].." "..vt[(j+2)*i],"loggg.txt")
        end
        x/=vertices
        y/=vertices
        z/=vertices
        -- printh(x.." "..y.." "..z,"loggg.txt")
        -- printh("end","loggg.txt")
        add(order,i)
        add(order,flr(sqrt((0-x)*(0-x)+(0-y)*(0-y)+(-10-z)*(-10-z))*10))
    end
    order=order_seq(order,cubes)
    printh(order[1].." "..order[2].." "..order[3].." "..order[4],"loggg.txt")
	faces=12;
	f={
		0, 2, 4,
        3, 7, 2,
        7, 5, 6,
        5, 7, 1,
        1, 3, 0,
        5, 1, 4, 
        2, 6, 4, 
        7, 6, 2, 
        5, 4, 6, 
        7, 3, 1, 
        3, 2, 0, 
        1, 0, 4
	}
    tc={
        1.0, 0.0, 
        0.0, 1.0, 
        0.0, 0.0, 
        1.0, 1.0,
    }
    uv={
        2, 1, 0, 
        2, 1, 0, 
        1, 3, 2, 
        0, 2, 3, 
        2, 1, 0, 
        1, 3, 2, 
        1, 3, 0, 
        1, 3, 0, 
        3, 0, 2, 
        2, 1, 3, 
        1, 3, 0, 
        3, 0, 2
    }
    for i=1,cubes*2,2 do
        local v_r={}
        for j=1+vertices*3*(order[i]-1),vertices*3*order[i] do
            add(v_r,vt[j])
            -- printh(i.." "..j.." "..order[1].." "..order[2].." "..order[3].." "..order[4],"loggg.txt")
        end
	    draw_model(p,qt,vertices,v_r,faces,f,tc,uv,textures[order[i]])
        -- print(order[1].." "..order[2].." "..order[3].." "..order[4],0)
        -- print(order[1].." "..order[2],0)
    end
    -- printh("end","loggg.txt")
end

function draw_torus(p)
    local qt,s;
    s=0.35
	qt=t*0.01;
	
	-- model
    vertices=36
	v={
        1.5, 0.0, 0.0, 1.25, 0.43, 0.0, 0.75, 0.43, 0.0, 0.5, 0.0, 0.0, 0.75, -0.43, 0.0, 1.25, -0.43, 0.0, 0.75, 0.0, -1.3, 0.62, 0.43, -1.08, 0.38, 0.43, -0.65, 0.25, 0.0, -0.43, 0.38, -0.43, -0.65, 0.62, -0.43, -1.08, -0.75, 0.0, -1.3, -0.62, 0.43, -1.08, -0.38, 0.43, -0.65, -0.25, 0.0, -0.43, -0.38, -0.43, -0.65, -0.62, -0.43, -1.08, -1.5, 0.0, -0.0, -1.25, 0.43, -0.0, -0.75, 0.43, -0.0, -0.5, 0.0, -0.0, -0.75, -0.43, -0.0, -1.25, -0.43, -0.0, -0.75, 0.0, 1.3, -0.62, 0.43, 1.08, -0.38, 0.43, 0.65, -0.25, 0.0, 0.43, -0.38, -0.43, 0.65, -0.62, -0.43, 1.08, 0.75, 0.0, 1.3, 0.62, 0.43, 1.08, 0.38, 0.43, 0.65, 0.25, 0.0, 0.43, 0.38, -0.43, 0.65, 0.62, -0.43, 1.08
    };
	faces=72;
	f={
		0, 1, 6, 1, 2, 7, 2, 3, 8, 3, 4, 9, 4, 5, 10, 5, 0, 11, 6, 7, 12, 7, 8, 13, 8, 9, 14, 9, 10, 15, 10, 11, 16, 11, 6, 17, 13, 19, 12, 13, 14, 19, 14, 15, 20, 15, 16, 21, 16, 17, 22, 17, 12, 23, 18, 19, 24, 19, 20, 25, 20, 21, 26, 21, 22, 27, 22, 23, 28, 23, 18, 29, 24, 25, 30, 26, 32, 25, 26, 27, 32, 27, 28, 33, 29, 35, 28, 29, 24, 35, 31, 1, 30, 31, 32, 1, 32, 33, 2, 33, 34, 3, 34, 35, 4, 35, 30, 5, 1, 7, 6, 2, 8, 7, 3, 9, 8, 4, 10, 9, 5, 11, 10, 0, 6, 11, 7, 13, 12, 8, 14, 13, 9, 15, 14, 10, 16, 15, 11, 17, 16, 6, 12, 17, 19, 18, 12, 14, 20, 19, 15, 21, 20, 16, 22, 21, 17, 23, 22, 12, 18, 23, 19, 25, 24, 20, 26, 25, 21, 27, 26, 22, 28, 27, 23, 29, 28, 18, 24, 29, 25, 31, 30, 32, 31, 25, 27, 33, 32, 28, 34, 33, 35, 34, 28, 24, 30, 35, 1, 0, 30, 32, 2, 1, 33, 3, 2, 34, 4, 3, 35, 5, 4, 30, 0, 5
	}
    tc={
        1.0, 0.5, 0.0, 0.67, 0.0, 0.5, 1.0, 0.67, 0.0, 0.83, 1.0, 0.83, 0.0, 1.0, 1.0, -0.0, 0.0, 0.17, -0.0, 0.0, 1.0, 0.17, 0.0, 0.33, 1.0, 0.33, 1.0, 0.5, 0.0, 0.67, -0.0, 0.5, 1.0, 0.67, 0.0, 0.83, 1.0, 0.83, 0.0, 1.0, 1.0, -0.0, -0.0, 0.17, -0.0, 0.0, 1.0, 0.17, -0.0, 0.33, 1.0, 0.33, 1.0, 1.0, 1.0, 1.0
    }
    uv={
        2, 1, 0, 1, 4, 3, 4, 6, 5, 9, 8, 7, 8, 11, 10, 11, 2, 12, 15, 14, 13, 14, 17, 16, 17, 19, 18, 22, 21, 20, 21, 24, 23, 24, 15, 25, 14, 16, 15, 14, 17, 16, 17, 19, 18, 22, 21, 20, 21, 24, 23, 24, 15, 25, 15, 14, 13, 14, 17, 16, 17, 19, 18, 22, 21, 20, 21, 24, 23, 24, 15, 25, 15, 14, 13, 17, 18, 14, 17, 19, 18, 22, 21, 20, 24, 25, 21, 24, 15, 25, 14, 16, 15, 14, 17, 16, 17, 19, 18, 22, 21, 20, 21, 24, 23, 24, 15, 25, 1, 3, 0, 4, 5, 3, 6, 26, 5, 8, 10, 7, 11, 12, 10, 2, 0, 12, 14, 16, 13, 17, 18, 16, 19, 27, 18, 21, 23, 20, 24, 25, 23, 15, 13, 25, 16, 13, 15, 17, 18, 16, 19, 27, 18, 21, 23, 20, 24, 25, 23, 15, 13, 25, 14, 16, 13, 17, 18, 16, 19, 27, 18, 21, 23, 20, 24, 25, 23, 15, 13, 25, 14, 16, 13, 18, 16, 14, 19, 27, 18, 21, 23, 20, 25, 23, 21, 15, 13, 25, 16, 13, 15, 17, 18, 16, 19, 27, 18, 21, 23, 20, 24, 25, 23, 15, 13, 25
    }
	draw_model(p,qt,vertices,v,faces,f,tc,uv)
end

function _update()
    t+=1
	
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
    for i=0,3,1 do
        rectfill(0+i*32,0,15+i*32,86,10)
        rectfill(16+i*32,0,31+i*32,86,14)    
    end
end

function mirror()
    for i=0,40,1 do
        for j=0,64,2 do
            if(i%2==0)then
                poke(0x7fc0-i*64+j,@(0x6000+i*128+j))
                -- poke(0x7fc0-i*64+j-1,0x11)
            else 
                poke(0x7fc0-i*64+j-1,@(0x6000+i*128+j-1))
            --     poke(0x7fc0-i*64+j,0x11)
            end
        end
    end
end

function _draw()
    cls()
    background()
    draw_cubes(0)
    mirror()
end

function order_seq(seq,len)
    for i=1,len*2,2 do
        local max=i+1
        for j=1+i*2,len*2,2 do
            if(seq[max]<seq[j+1]) then
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
-- function bridge1()
--     background()
--     draw_torus(0)
--     mirror()    
-- end

-- function bridge2()
--     background()
--     draw_cube(0)
--     draw_cube(0.1)
--     draw_cube(0.2)
--     draw_cube(0.3)
--     draw_cube(0.4)
--     draw_cube(0.5)
--     mirror()      
-- end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
