pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

t1=0
-- texture='677765677656777677776566665677777777655ee55677777776555ee55567776665555ee55556665555555665555555665555677655556676eee6e77e6eee6776eee6eeee6eee676655556ee655556655555556655555556665555ee55556667776555ee55567777777655ee556777777776566665677776777656776567776'
textures={
    '0000','7777','aaaa','bbbb','cccc','8888','9999'
}
function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,l_int,texture,t_res)
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
        uv_x=flr(uv_x*t_res)+1
        uv_y = max(0, min(1, uv_y))
        uv_y=flr(uv_y*t_res)+1
        texture_index=flr((uv_y-1) *t_res + uv_x)
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
    
function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,l_int,texture,t_res)
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,texture,t_res);
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int,texture,t_res);
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
    
function tric(a,b,c,d,e,f,uv0,uv1,uv2,l_int,texture,t_res)
    local e1x,e1y,e2x,e2y,xpr;
    e1x=c-a;
    e1y=d-b;
    e2x=e-a;
    e2y=f-b;
    xpr=e1x*e2y-e1y*e2x;
    if (xpr<0) return;
    return tri(a,b,c,d,e,f,uv0,uv1,uv2,l_int,texture,t_res);
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

function draw_model()
	cls()
	-- stripes
	    
	local r,qt;
	qt=t1*0.01;
	
	-- model
    vertices=8
	v={
        0.5, 0.5, -0.5, 
        0.5, -0.5, -0.5, 
        0.5, 0.5, 0.5, 
        0.5, -0.5, 0.5, 
        -0.5, 0.5, -0.5, 
        -0.5, -0.5, -0.5, 
        -0.5, 0.5, 0.5, 
        -0.5, -0.5, 0.5
    };
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
    cn=26
    cubes={
        --top
        0,1,0,
        1,1,0,
        -1,1,0,
        0,1,1,
        0,1,-1,
        1,1,-1,
        -1,1,-1,
        1,1,1,
        -1,1,1,
        --mid
        1,0,0,
        -1,0,0,
        0,0,1,
        0,0,-1,
        1,0,-1,
        -1,0,-1,
        1,0,1,
        -1,0,1,
        --bot
        0,-1,0,
        1,-1,0,
        -1,-1,0,
        0,-1,1,
        0,-1,-1,
        1,-1,-1,
        -1,-1,-1,
        1,-1,1,
        -1,-1,1,
    }
    ti={
        7,7,7,7,7,7,
        2,2,2,2,2,2,
        3,3,3,3,3,3,
        4,4,4,4,4,4,
        5,5,5,5,5,5,
        6,6,6,6,6,6,
        7,7,7,7,7,7,
        2,2,2,2,2,2,
        3,3,3,3,3,3,
        4,4,4,4,4,4,
        5,5,5,5,5,5,
        6,6,6,6,6,6,
        7,7,7,7,7,7,
        2,2,2,2,2,2,
        3,3,3,3,3,3,
        4,4,4,4,4,4,
        5,5,5,5,5,5,
        6,6,6,6,6,6,
        7,7,7,7,7,7,
        2,2,2,2,2,2,
        3,3,3,3,3,3,
        4,4,4,4,4,4,
        5,5,5,5,5,5,
        6,6,6,6,6,6,
        7,7,7,7,7,7,
        2,2,2,2,2,2,
    }
    local t_res=2
    local ti_i=1
    for i=1,3*cn,3 do
	-- transform
        local vt={}
        for j=1,3*vertices,3 do
            local x,y,z;
            -- read
            x=v[j];
            y=v[j+1];
            z=v[j+2];
                -- process
            x,y,z=translation(x,y,z,cubes[i],cubes[i+1],cubes[i+2])
            --rotacja
            -- y,z=rotate(y,z,qt*0.9);
            -- x,z=rotate(x,z,qt*0.3);
            -- x,z=rotate2(x,z,qt*0.3)
            x,z=rotate(x,z,qt)
            y,z=rotate(y,z,0.875)
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
        -- printh(vt[4].." "..vt[5].." "..vt[6].." "..t1, "loggg.txt")
        
        -- triangles
        local f_i=1
        for j=1,3*faces,3 do
            local texture = textures[ti[ti_i+flr(f_i)-1]]
            --petla wyciaga kolejne sciany z listy
            local a,b,c,xab,yab,zab,xac,yac,zac,nv,l_dir,l_cos,l_int;
            a=f[j];
            b=f[j+1];
            c=f[j+2];
            l_int=1
            -- printh(nv[1].." "..nv[2].." "..nv[3].." "..vec_len, "loggg.txt")
            -- printh(l_cos.." "..x.." "..y.." "..t1, "loggg.txt")
            -- printh(l_len.." "..nv_len, "loggg.txt")
            printh(ti_i+f_i.." "..texture, "loggg.txt")
            printh(".....................", "loggg.txt")
            -- printh(l_int.." "..t1, "loggg.txt")
            tric(
                vt[a*3+1],
                vt[a*3+2],
                vt[b*3+1],
                vt[b*3+2],
                vt[c*3+1],
                vt[c*3+2],
                {tc[uv[j]*2+1],tc[uv[j]*2+2]},{tc[uv[j+1]*2+1],tc[uv[j+1]*2+2]},{tc[uv[j+2]*2+1],tc[uv[j+2]*2+2]},l_int,texture,t_res)
            f_i+=0.5
        end
        ti_i+=6
    end
end
function _update()
    t1+=1
	
end
function v3_len(vec)
    return sqrt(vec[1]*vec[1]+vec[2]*vec[2]+vec[3]*vec[3])        
end

function _draw()
    draw_model()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
