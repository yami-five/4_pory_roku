pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

t=0
texture='677765677656777677776566665677777777655ee55677777776555ee55567776665555ee55556665555555665555555665555677655556676eee6e77e6eee6776eee6eeee6eee676655556ee655556655555556655555556665555ee55556667776555ee55567777777655ee556777777776566665677776777656776567776'
function rasterize(y, x0, x1, uv0, uv1, uv2, inv,p0,p1,p2,l_int)
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
        uv_x=flr(uv_x*16)+1
        uv_y = max(0, min(1, uv_y))
        uv_y=flr(uv_y*16)+1
        texture_index=flr((uv_y-1) *16 + uv_x)
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
    
function tri(x0,y0,x1,y1,x2,y2,uv0,uv1,uv2,l_int)
    local x,xx,y,q,q2,uv;
    if (y0>y1) y=y0;y0=y1;y1=y;x=x0;x0=x1;x1=x;uv=uv0;uv0=uv1;uv1=uv;
    if (y0>y2) y=y0;y0=y2;y2=y;x=x0;x0=x2;x2=x;uv=uv0;uv0=uv2;uv2=uv;
    if (y1>y2) y=y1;y1=y2;y2=y;x=x1;x1=x2;x2=x;uv=uv1;uv1=uv2;uv2=uv;
    local dx01,dy01,dx02,dy02;
    local xd,xxd;
    if (y2<0 or y0>127) return
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int);
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
            rasterize(y,x,xx,uv0,uv1,uv2,inv,{x0,y0},{x1,y1},{x2,y2},l_int);
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
    
function tric(a,b,c,d,e,f,uv0,uv1,uv2,l_int)
    local e1x,e1y,e2x,e2y,xpr;
    e1x=c-a;
    e1y=d-b;
    e2x=e-a;
    e2y=f-b;
    xpr=e1x*e2y-e1y*e2x;
    if (xpr<0) return;
    return tri(a,b,c,d,e,f,uv0,uv1,uv2,l_int);
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

function draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,texture)
    for i=1,3*faces,3 do
        local a,b,c,xab,yab,zab,xac,yac,zac,nv,l_dir,l_cos,l_int;
        a=f[i];
        b=f[i+1];
        c=f[i+2];
        -- flat shading
        -- normal vector
        xab=vm[b*3+1]-vm[a*3+1]
        yab=vm[b*3+2]-vm[a*3+2]
        zab=vm[b*3+3]-vm[a*3+3]
        xac=vm[c*3+1]-vm[a*3+1]
        yac=vm[c*3+2]-vm[a*3+2]
        zac=vm[c*3+3]-vm[a*3+3]
        nv={yab*zac-zab*yac,zab*xac-xab*zac,xab*yac-yab*xac}
        vec_len=v3_len({nv[1],nv[2],nv[3]})
        nv[1]=nv[1]/vec_len
        nv[2]=nv[2]/vec_len
        nv[3]=nv[3]/vec_len
        nv_len=v3_len(nv)
        -- light direction
        tx=(vm[a*3+1]+vm[b*3+1]+vm[c*3+1])/3
        ty=(vm[a*3+2]+vm[b*3+2]+vm[c*3+2])/3
        tz=(vm[a*3+3]+vm[b*3+3]+vm[c*3+3])/3
        l_dir={50-tx,50-ty,50-tz}
        l_len=v3_len(l_dir)
        -- cos
        l_dir_nv=v3_len({l_dir[1]-nv[1],l_dir[2]-nv[2],l_dir[3]-nv[3]})
        x=nv_len*nv_len+l_len*l_len-l_dir_nv*l_dir_nv
        y=l_len*nv_len*2
        l_cos=x/y
        l_int=max(0.1,l_cos)
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
function draw_cube(p)
	local qt,s;
    s=0.35
	qt=t*0.01;
    vertices=8
	v={
        1.0*s, 1.0*s, -1.0*s, 
        1.0*s, -1.0*s, -1.0*s, 
        1.0*s, 1.0*s, 1.0*s, 
        1.0*s, -1.0*s, 1.0*s, 
        -1.0*s, 1.0*s, -1.0*s, 
        -1.0*s, -1.0*s, -1.0*s, 
        -1.0*s, 1.0*s, 1.0*s, 
        -1.0*s, -1.0*s, 1.0*s
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
    local vt={};
    local vm={};
    for j=1,vertices*3,3 do
        local x,y,z;
        x=v[j];
        y=v[j+1];
        z=v[j+2];
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
        vt[j]=flr(x);
        vt[j+1]=flr(y);
        vt[j+2]=flr(z);
    end
	draw_model(p,qt,vertices,vt,vm,faces,f,tc,uv,texture)
end

function draw_torus(p)
	local qt,s;
    s=0.35
	qt=t*0.01;
    vertices=12
    local order={}
    rings=6
	v={
        -0.75, 0.0, 1.3, -0.62, 0.43, 1.08, -0.38, 0.43, 0.65, -0.25, 0.0, 0.43, -0.38, -0.43, 0.65, -0.62, -0.43, 1.08, 0.75, 0.0, 1.3, 0.62, 0.43, 1.08, 0.38, 0.43, 0.65, 0.25, 0.0, 0.43, 0.38, -0.43, 0.65, 0.62, -0.43, 1.08,
        0.75, 0.0, -1.3, 0.62, 0.43, -1.08, 0.38, 0.43, -0.65, 0.25, 0.0, -0.43, 0.38, -0.43, -0.65, 0.62, -0.43, -1.08, -0.75, 0.0, -1.3, -0.62, 0.43, -1.08, -0.38, 0.43, -0.65, -0.25, 0.0, -0.43, -0.38, -0.43, -0.65, -0.62, -0.43, -1.08,
        0.75, 0.0, 1.3, 0.62, 0.43, 1.08, 0.38, 0.43, 0.65, 0.25, 0.0, 0.43, 0.38, -0.43, 0.65, 0.62, -0.43, 1.08, 1.5, 0.0, 0.0, 1.25, 0.43, 0.0, 0.75, 0.43, 0.0, 0.5, 0.0, 0.0, 0.75, -0.43, 0.0, 1.25, -0.43, 0.0,
        -0.75, 0.0, -1.3, -0.62, 0.43, -1.08, -0.38, 0.43, -0.65, -0.25, 0.0, -0.43, -0.38, -0.43, -0.65, -0.62, -0.43, -1.08, -1.5, 0.0, -0.0, -1.25, 0.43, -0.0, -0.75, 0.43, -0.0, -0.5, 0.0, -0.0, -0.75, -0.43, -0.0, -1.25, -0.43, -0.0,
        1.5, 0.0, -0.0, 1.25, 0.43, -0.0, 0.75, 0.43, -0.0, 0.5, 0.0, -0.0, 0.75, -0.43, -0.0, 1.25, -0.43, -0.0, 0.75, 0.0, -1.3, 0.62, 0.43, -1.08, 0.38, 0.43, -0.65, 0.25, 0.0, -0.43, 0.38, -0.43, -0.65, 0.62, -0.43, -1.08,
        -1.5, 0.0, -0.0, -1.25, 0.43, -0.0, -0.75, 0.43, -0.0, -0.5, 0.0, -0.0, -0.75, -0.43, -0.0, -1.25, -0.43, -0.0, -0.75, 0.0, 1.3, -0.62, 0.43, 1.08, -0.38, 0.43, 0.65, -0.25, 0.0, 0.43, -0.38, -0.43, 0.65, -0.62, -0.43, 1.08
    };
    local vt={};
    local vm={};
    for i=1,rings,1 do
        for j=1+vertices*3*(i-1),vertices*3*i,3 do
            local x,y,z;
            x=v[j];
            y=v[j+1];
            z=v[j+2];
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
            vt[j]=flr(x);
            vt[j+1]=flr(y);
            vt[j+2]=flr(z);
        end
    end
    for i=1,rings,1 do
        local x=0
        local y=0
        local z=0
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
    faces=12;
	f={
		0, 1, 6, 2, 8, 1, 2, 3, 8, 3, 4, 9, 5, 11, 4, 5, 0, 11, 1, 7, 6, 8, 7, 1, 3, 9, 8, 4, 10, 9, 11, 10, 4, 0, 6, 11
	}
    tc={
        1.0, 0.5, 0.0, 0.67, -0.0, 0.5, 1.0, 0.83, 0.0, 0.83, 0.0, 1.0, 1.0, -0.0, -0.0, 0.17, -0.0, 0.0, 1.0, 0.33, -0.0, 0.33, 1.0, 0.67, 1.0, 1.0, 1.0, 0.17
    }
    uv={
        2, 1, 0, 4, 3, 1, 4, 5, 3, 8, 7, 6, 10, 9, 7, 10, 2, 9, 1, 11, 0, 3, 11, 1, 5, 12, 3, 7, 13, 6, 9, 13, 7, 2, 0, 9
    }
    for i=1,rings*2,2 do
        local v_r={}
        local vm_r={}
        for j=1+vertices*3*(order[i]-1),vertices*3*order[i] do
            add(v_r,vt[j])
            add(vm_r,vm[j])
        end
	    draw_model(p,qt,vertices,v_r,vm_r,faces,f,tc,uv,texture)
    end
end

-- function _update()
--     t+=1
-- end
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

-- function _draw()
--     cls()
--     background()
--     draw_torus(0)
--     mirror()
-- end

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
ffff8ff7ffff78ed811ca7577042e42207442e7211f7ffcbb999410dcd2aa1a172ff7fac1416162650585898ffef20416921214252484898ffef01268d0298b4
062872ff8f1a1cab0889dd04f4ff5fc1853188b620f7ff29f1ffffc0c9540e984ce480f7ff1960199b45436344f198f4ff9e2cb9020b0b1b107072901dffcfaf
2285096921214222d0313ff3ffd91442a4b54011920540709cf4ff6e8e44c4e60a6223440ccff8ff6e0f442ea10cc924300be772ff3f84f70d4fe13cff8fbe1c
7188c9118388b89f812e73ff1fdc29151a9b4443f34504b0b1ff9f070724a9322841dfae8270ff2f1e020b5898020b78af08fbffac2a846928440b69202c416e
3a8bf7ff022e7104981a4780cae283f486ffefc67341e41219b4a64b82d3f4ff3ec93cb83539b9615c8e40cff4ff4f3c09e75070ff3ff0afc13cb80c131cffef
86c93c692b9214ffcf35ff191080a9f2ef09f75ef37fe93cff5527f19d9cffa955110bb4b1ffd5c916f4cd4effc69383994ca2f7ce232cf11a9cffe9762e84f7
be5264f3ff58224343c4f0df11048eef39ef8b6eca4f8df3ff1d168b119f3cff84591dff6e7501a4ff2feb54ef3dff111cbfadf76e00ffef44138aeef11f80c1
85adf1ff6ce5f0df1386ce30ffff0701548eef4af76e8b2fe8161acf18ca00fff0ff0368985c781f284534cff37f8d3780c97282788e079421f2784e3732ff44
1a9440d361f9981812758ce77474ef59c1f9d855e3581250f20bcff8efb67d50b3b4382f925ce1a504e796ffcfd77007506e440b2f543a2f78ff0f0283a32802
2086f84d34ffaf01cb028e2e0184a9358a6974ff1f9b410e5961e8028acf83a827e541f00cffef53303fe5fcff2f8cafa0f8bc5190b0a2adc7f75f6e019c8a0b
7a0f61115778ff4fe07188f786a239e982e774ff2e15e8f4ed2d30ea02e772ffe5169016e02285a8f30f0d0978ff2f0a3a0836aff4f0ffae8e50d4f0ffde304f
8e24850260084effef4857f00d4f9a4c014e7cae0436ffc6c467c027457a706a706e37740ef70e981d58198d58924c129ca8e73270ff91a5a221c2595a222469
6248930304e39404722df30f540c082101c2126cb08c752e40c3830978ef8cdb4069d109cd08f3581016ada670ef3e5a4485a4000b1480ab74ae020b9ef3ff58
8a1b00174673004e8e8e6bb0e035ff8f780042582e206288786019841864988c194ff35f44091843d8322fc4902208507104929ff12fe0ec19b0cc1070768610
c109c241440482fffd16cc8425721e482ee18814122020278834ff984e21f4a401170d3438e820823700b424723e32ffd0c1c1e9c1227250901a153414ffcfb5
c0e7d980e80a0a14321a113488404984f7afa8f32142c343f58b88026380312f78efa3d2c2f331442ec13cae1a4f13aff19f425580f94e05129cac28d4500211
f393f14f838504f74eaa0901ad39ae48f42d74bf01a4ea21f11a6c0400121dd24098dd749ef0df5784a707892f824e342a419abf34cf88480b7cbf0100080e98
d022840ef1df16161c9cff49985e043e08f9cbf8cf929e12a0358b00012142e34c4644ef42f749360a382947088940e4a6f3014980f9ccf3ad10f332a9f42e72
9ed001f94df80f18704e35a968104081f3e412a0f4eef1aef74878fe318f283adff38d2707a7a443004a4ce78e42f375c7ecbfefddffff59fdffffffffffffff
ef170690ac290efff72718ee94ec4cfffdd0b0ce4e80ffff47034014010ffff7928368f38fff7df0020efff6783280fff7d968f8ffffecfffff2000000000000
