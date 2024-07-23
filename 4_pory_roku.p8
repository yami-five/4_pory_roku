pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include utils.p8
#include px9_dec.p8
#include intro.p8
#include seasons.p8
#include rasterizer.p8
#include fractals.p8

t,delays,melted,mp,p_elapsed,rings,bees=0,{},0,0,0,0,{}
function _init()
	music(0)
	load_font()
	poke(24408,129)
	logo=decompress_picture("g5411m1g22m1g101m1g2m1g22m1g2m1g98m1g2m1g6m1g1m6g1m1g6m1g2m1g98m2g1m1g4m14g4m1g1m2g98m4g2m1g1m2g1m1g6m1g1m2g1m1g2m4g96m1g2m4g1m2g14m2g1m4g2m1g94m1g2m5g1m1g14m1g1m5g2m1g94m1g2m2g2m1g18m1g2m2g2m1g94m1g2m1g26m1g2m1g94m1g2m1g26m1g2m1g94m1g2m1g26m1g2m1g96m2g26m2g98m2g26m2g98m1g28m1g206m3g1m8g8m10g1m1g6m1g1m10g1m2g2m1g2m8g2m1g1m14g18m2g10m2g10m1g1m2g2m10g4m14g1m1g2m1g1m12g2m2g1m2g1m6g1m1g2m18g14m1g1m2g8m1g2m1g10m1g1m2g10m2g1m2g1m2g10m1g1m2g2m2g1m1g12m2g1m1g4m2g6m2g14m2g1m1g12m1g1m2g8m1g2m1g10m4g10m1g2m2g2m1g12m2g2m2g12m1g1m2g1m1g4m2g6m2g2m1g11m1g1m2g12m4g8m2g10m1g2m3g10m1g2m2g2m1g6c1g4c1m2g2m2c1g4c1g6m3g2m1g4m2g7m1g2m2g4m1g1m2g1m1g2m2g1m1g8m2g1m3g6m1g2m1g10m2g2m2g10m1g2m2g2m1g6c1g4c1m2g2m2c1g4c1g4m1g2m2g2m1g4m2g10m2g4m6g2m1g2m1g8m2g2m2g6m2g12m2g2m2g10m2g1m2g1m2g8c2m1g1m2g2m2g1m1c2g6m1g2m2g2m1g4m2g10m2g2m1g2m1g2m1g2m1g2m2g8m2g2m2g6m2g10m1g2m1g2m2g10m2g4m2g10m1g2m1g2m1g2m1g8m2g2m1g2m1g4m2g6m1g3m2g2m2g6m2g2m2g6m1g2m1g2m2g4m1g2m1g10m2g4m2g6m4g1m1g4m1g1m2g1m2g1m6g6m6g1m2g2m1g2m1g2m1g4m2g6m2g2m2g2m2g6m2g2m2g6m2g4m2g4m2g12m2g4m2g6m1g1m2g1m1g4m1g1m4g2m6g6m6g2m1g2m1g2m1g2m1g4m2g6m2g2m2g2m2g6m2g2m2g6m2g4m2g4m2g10m1g2m1g4m2g10m2g4m2g6m1g2m1g10m1g2m1g2m2g4m1g2m1g4m2g6m2g2m2g2m2g6m2g2m2g4m1g2m1g4m2g2m1g2m1g10m2g6m2g10m2g1m2g1m2g6m1g2m1g10m1g2m2g2m1g4m1g2m1g4m2g6m2g2m2g2m1g2m1g2m1g2m1g2m2g4m2g6m2g2m2g12m2g6m2g10m1g2m2g2m1g8m2g10m2g2m1g2m1g4m1g2m1g4m2g6m2g2m1g2m1g2m6g4m2g4m2g6m2g2m2g10m1g2m1g6m2g10m1g2m2g2m1g8m1g2m1g6m1g2m1g2m2g6m1g2m1g4m2g6m2g2m1g1m2g2m1g1m2g1m1g4m2g2m1g2m1g6m3g2m1g10m2g8m2g10m1g2m2g2m1g11m1g6m1g3m1g2m1g6m1g2m1g4m2g6m2g4m2g1m1g11m1g2m2g8m4g10m1g2m1g8m2g10m2g1m2g1m2g10m2g6m2g2m2g8m1g2m1g4m2g6m2g4m1g1m2g12m1g2m1g8m2g1m1g10m1g2m1g8m14g4m10g1m2g2m1g2m1g2m1g2m2g8m1g2m1g4m2g6m2g6m16g1m1g8m2g1m1g10m2g10m12g8m10g3m1g2m1g3m1g2m1g8m1g2m1g4m2g6m2g8m14g10m2g56m2g2m2g122m1g1m2g1m1g16c1g1c8g1c2g1c2g1c1g4c3g1c3g3c1g1c2g1c1g2c2g2c1g3c2g58m2g18c2g8c3g9c2g3c2g3c2g2c2g2c2g2c1g1c1g4c1g74c1g2c1g8c1g1c1g7c1g1c1g4c2g1c1g2c1g2c1g2c1g1c1g1c2g1c1g79c1g11c3g1c2g1c1g3c2g4c2g1c1g8c1g1c1g1c2g1c1g2c1g76c1g9c2g1c2g8c2g4c2g1c1g8c1g1c2g1c1g3c1g2c1g74c1g2c1g6c1g3c1g5c1g3c1g4c2g1c1g2c1g2c1g2c1g1c2g1c1g6c1g76c2g2c2g5c2g6c1g2c1g4c2g3c2g2c2g3c1g2c3g4c1g76c1g1c2g1c1g4c1g1c1g1c2g1c1g1c1g2c1g4c2g3c1g1c2g1c1g3c1g2c2g2c2g5644")
	load_gfx(logo,32768)
	gen_delays()
	reload(0xc000,0x0000,0x2000,"intro_gfx.p8") 
	reload(0xe000,0x0000,0x2000,"background_gfx.p8") 
end

function _update()
	t=t+1
	local elapsed=flr(stat(56)/12)%8
	if(elapsed<p_elapsed)then 
		mp+=1 
		if(mp==4 or mp==12)then t=0 end
		if(mp==10)then
			gen_delays() 
			melted,t=0,0
			px9_decomp(0,0,0xc000,sget,sset)
		end
		if(mp==16)then
			t=0
			px9_decomp(0,0,0xca00,sget,sset)
			memcpy(0x8000,0x0000,0x2000)
			px9_decomp(0,0,0xcf00,sget,sset)
		end
		if(mp==20)then
			for i=1,40 do
				add(bees,rnd(64)+32)
				add(bees,rnd(128)-560)
			end
			t=0
			pal(2,132,1)
			pal(7,140,1)
			pal(8,128,1)
			pal(11,138,1)
			pal(13,14,1)
			pal(14,139,1)
			pal(15,134,1)
			px9_decomp(0,0,0xe600,sget,sset) 
			memcpy(0xa000,0x0000,0x2000)
			px9_decomp(0,0,0xeb00,sget,sset) 
			memcpy(0xc000,0x0000,0x2000)
			px9_decomp(0,0,0xe000,sget,sset) 
			memcpy(0x8000,0x0000,0x2000)
			img1,img2=0x8000,0xa000
		end
		if(mp==26)then
			t=0
			memcpy(0x8000,0x6000,0x2000)
			px9_decomp(0,0,0xf000,sget,sset) 
		end
		--0x8000 - wioska 
		--0xe000 - 1 grafika
		--0xe600 - 2 grafika
		--0xeb00 - 3 grafika
		--0xf000 - sprity
		--0xf500 - tlo do 3d 

		if(mp==28)then
			t=0
		end
		if(mp==34)then
			t=0
			pal()
			fillp()
		end
		if(mp==52)then
			t=0
			memcpy(0xa000,0x0000,0x2000)
			px9_decomp(0,0,0xf500,sget,sset) 
			pal(8,139,1)
			pal(15,141,1)
			pal(6,139,1)
			pal(5,2,1)
			pal(7,11,1)
		end
		if(mp==64)then
			t=0
			pal()
			memcpy(0x0000,0xa000,0x2000)
			pal(2,132,1)
			pal(7,140,1)
			pal(10,7,1)
			pal(11,138,1)
			pal(13,12,1)
			pal(14,11,1)
			pal(15,9,1)
			pal(9,135,1)
			pal(3,139,1)
			pal(6,134,1)
		end
		if(mp==76)then
			t=0
			pal()
		end
		if(mp==86)then
			t,cx,cy,s,x=0,0,0.75,2,0
		end

		if(mp==96)then
			t=0
			memcpy(0xa000,0x0000,0x2000)
			px9_decomp(0,0,0xf500,sget,sset)
			pal(8,139,1)
			pal(15,140,1)
			pal(6,139,1)
			pal(5,2,1)
			pal(7,11,1)
			pal(13,135,1)
			pal(14,137,1)
			pal(10,136,1)
			pal(2,10,1)
		end
		if(mp==112)then
			t=0
			pal()
			memcpy(0x0000,0xa000,0x2000)
			pal(2,132,1)
			pal(7,1,1)
			pal(10,9,1)
			pal(11,138,1)
			pal(13,9,1)
			pal(14,137,1)
			pal(15,9,1)
			pal(15,4,1)
			pal(3,4,1)
			pal(6,134,1)
			pal(12,140,1)
		end
		if(mp==117)then
			reload(0x0000,0x0000,0x2000,"rasterizer.p8")
			tex=zoom_rotator_texture()
		end 
		if(mp==118) then 
			t=0 
			memset(0x6000,0,0x2000)
			pal()
		end
		if(mp==120)then
			t=0
			memset(0x6000,0,0x2000)
		end
		-- if(mp==124)then
		-- 	t=0
		-- end
	end
	p_elapsed=elapsed
	if(mp==23 and t==64)then
		t,img1,img2=0,img2,0xc000
	end

end

function _draw()
	cls(0)
	if(mp<20)then
		intro()
	elseif(mp<52)then
		spring()
	elseif(mp<64)then
		bridge1()
	elseif(mp<96)then
		summer()
	elseif(mp<112)then
		bridge2()
	elseif(mp<144)then
		autumn()
	elseif(mp<160)then
		draw_cube_anim()
	elseif(mp<192)then
		winter()
	end
	--print(@0xc000,0,50,7)
	--spr(0,0,0,16,16)
	-- print(mp,0,70,1)
	-- print(t,0,80,1)
end
--placeholders
function winter()
	print("winter",64,64,10)
end
__gfx__
__sfx__
410c00000e55010550115501154011530115200e5500e55010550105201055011550135501155010550105200e55010550115501154011530115200e5500e5500c5500c5200c5500e550105500e5500c5500c520
410c00000e55010550115501154011530115200e5500e550105501052010550115501355011550105501052011550115200e5500e520105500e5500c5500c5200e5500e5200e5500e5200c5500c5201055010520
410c00000e55010550115501154011530115200e5500e520105501052010550115501355011550105501052011550115200e5500e520105500e5500c5500c5200e5500e5400e5300e52016500165000e5000e500
410c00000e5500e5200e5500e5200e5500e5201655016520155501554015530155201355013540135301352011550115201155011520135501352010550105200e5500e5400e5300e5200c000000000000000000
410c000015550155401553015520115501154011530115200e5500e5200e5500e5201655016520155501552013550135401353013520135501352018550185401853018520165501652015550155201355013520
410c0000115501152010550105200e5500e5201655016520155501554015530155201555015540155301552011550115201155011520135501352010550105200e5500e5400e5300e5200c5000c5000c50000500
410c000015550155401553015520115501154011530115200e5500e5200e5500e5201155011520115501152010550105401053010520105501054010530105201555015520135501352011550115201055010520
410c0000115501152010550105200e5500e520135501352011550115401153011520105501054010530105200e5500e5200e5500e5200c5500c5200c5500c5200e5500e5400e5300e5200c0000c0000c0000c000
410c00001d5501d5201a5501a5201a5501a5401a5301d5501f5501f5201f5501f5201f5501f5401f5301f5201d5501d5201a5501a5201a5501a5401a5301a5501c5501a550185501a5501c5201c5201c5501c520
410c00001d5501d5201a5501a5201a5501a5401a5301d5501f5501f5201f5501f5201f5501f5401f5301f5201d5501d5401d5301c5501a5501a52018550185201a550185501a5501c5501d5501c5501d5501f550
410c00001d5501d5201a5501a5201a5501a5401a5301d5501f5501f5201f5501f5201f5501f5401f5301f5201d5501d5401d5301c5501a5501a52018550185201a5501a5401a5301a5201d5001c5001150013500
010c00000005300003246350000300053000032463500003000530000324635000030005300003246350000300053000032463500003000530000324635000030005300003246350000300053000032463500003
410c00001a5501c5501d5501d5501d5501d5501a5501a5201c5501c5201c5501d5501f5501d5501c5501c5201a5501c5501d5501d5501d5501d5501a5501a5201855018520185501a5501c5501a5501855018520
410c00001a5501c5501d5501d5501d5501d5501a5501a5201c5501c5201c5501d5501f5501d5501c5501c5201d5501d5201a5501a5201c5501a55018550185201a5501a5201a5501a52018550185201c5501c520
410c00001a5501c5501d5501d5501d5501d5501a5501a5201c5501c5201c5501d5501f5501d5501c5501c5201d5501d5201a5501a5201c5501a55018550185201a5501a5401a5301a520185000c5001050010500
410c00000e55010550115501154011530115200e5500e520105501052010550115501355011550105501052011550115200e5500e520105501355011550105200e5500e5400e5300e5200e5500e5400e5300e520
410c00000e14010140111401113011120111100e1400e14010140101101014011140131401114010140101100e14010140111401113011120111100e1400e1400c1400c1100c1400e140101400e1400c1400c110
410c00000e14010140111401113011120111100e1400e140101401011010140111401314011140101401011011140111400e1400e110101400e1400c1400c1100e1400e1100e1400e1100c1400c1101014010110
410c00000e14010140111401113011120111100e1400e110101401011010140111401314011140101401011011140111100e1400e140101400e1400c1400c1100e1400e1300e1200e11016100161000e1000e100
410c00000e1400e1100e1400e1100e1400e110131401311015140151301512015110101401013010120101100e1400e1100e1400e1100c1400c1100c1400c1100e1400e1300e1200e11018100181001810018100
410c000015140151301512015110111401113011120111100e1400e1100e1400e110161401611015140151101314013130131201311013140131100c1400c1300c1200c110161401611015140151101314013110
410c0000111401111010140101100e1400e1101614016110151401513015120151101514015130151201511011140111101114011110131401311010140101100e1400e1300e1200e1100c1000c1000c1000c100
410c00001814018130181201811018140181301812018110221402211022140221101a1401a1101a1401a1101c1401c1301c1201c1101c1401c1301c1201c1101d1401d1101c1401c1101a1401a1101c1401c110
410c00001d1401d1101c1401c1101a1401a1101c1401c1101a1401a1301a1201a1101f1401f1301f1201f11021140211102114021110211402111021140211102114021130211202111018100181001810018100
410c00001a1401a11015140151101514015130151101a1401a1401a1101a1401a1101a1401a1301a1201a1101a1401a1301a11015140151401511018140181101a1401a1301a1201a11015100151001510015100
d10c00001a1401a11015140151101514015130151201a1401a1401a1101a1401a1101a1401a1301a1201a1101a1001a1001510015100151001510015100151001510013100131001310015100151001510015100
d10c00001a1401a1301a110151101514015130151201a1401a1401a1101a1401a1101a1401a1301a1201a1101a1401a1101514015110151401513015120151401514013140131401314015140151101514015110
d10c00000e14010140111401113011120111100e1400e110101401011010140111401314011140101401011011140111100e1400e110101401314011140101100e1400e1300e1200e1100e1400e1300e1200e110
d10c00000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e3000e30011360103601136013360
d10c0000113601135011340113301d3001d3001a3001a3001136011350113401133011360113501134011330133601335013340133301c3001a3000c3600c3300e3600e330093600933007360073300536005330
d10c0000053400533005320053100434004330043200431002340023300232002310073000730007300073000234002330023200231000340003300032000310023400233002320023100e3000e3000e3000e300
d10c00000274202732027220271202742027320272202712057420573205722057120474204732047220471202742027220274202722007420072200742007220274202732027220271200002000020000200002
d10c00000234002320023400232002340023200734007320093400933009320093101034010330103201031002340023200234002320003400032000340003200234000340023400434005340043400534007340
d10c000011360113501134011330003000030000300003001136011350113401133011360113501134011330133601335013340133300c3000c3000c3600c3300e3600e3300a3600a33009360093300736007330
d10c00001a1501c1501d1501d1501d1501d1501a1501a1201c1501c1201c1501d1501f1501d1501c1501c1201a1501c1501d1501d1501d1501d1501a1501a1201815018120181501a1501c1501a1501815018120
d10c00001a1501c1501d1501d1501d1501d1501a1501a1201c1501c1201c1501d1501f1501d1501c1501c1201d1501d1201a1501a1201c1501a15018150181201a1501a1201a1501a12018150181201c1501c120
d10c00001a1501c1501d1501d1501d1501d1501a1501a1201c1501c1201c1501d1501f1501d1501c1501c1201d1501d1201a1501a1201c1501a15018150181201a1501a1401a1301a120181000c1001010010100
d10c00000536007360093600935009340093300536005330073600733007360093600a36009360073600733005360073600936009350093400933005360053300436004360043600535007340053300436004330
d10c00000536007360093600935009340093300536005330073600733007360093600a36009360073600733009360093300536005330073600536004360043300536005330023600233000360003300436004330
d10c00000536007360093600935009340093300536005330073600733007360093600a36009360073600733009360093300536005330073600536004360043300536005350053400533000300003000430004300
d10c000011340113200e3400e3200e3400e3300e32011340133401332013340133201334013330133201331011340113200e3400e3200e3400e3300e3200e340103400e3400c3401034011340113201134011320
d10c000011340113200e3400e3200e3400e3300e320113401334013320133401332013340133301332013310113401132011340103200e3400e3200c3400c3200e3400c3400e3401034011340103401134013340
d10c000011340113200e3400e3200e3400e3400e320113401334013320133401332013340133301332013310113401133011320103100e3400e3200c3400c3200e3400e3300e3200e31011300103001130013300
d10c00000534007340093400933009320093100534005320073400732007340093400a34009340073400732005340073400934009330093200931005340053200434004320043400534007340053400434004320
d10c00000534007340093400933009320093100534005320073400732007340093400a34009340073400732009340093200534005320073400534004340043200534005320023400232000340003200434004320
d10c00000534007340093400933009320093100534005320073400732007340093400a34009340073400732009340093200534005320093400c34010340103200e3400e3300e3200e3100e3400e3300e3200e310
__music__
00 4042430b
00 0010430b
00 0111430b
00 0010430b
00 0212430b
00 0313430b
00 0313430b
00 0414430b
00 05151c0b
00 06161d0b
00 07171e0b
00 06161d0b
00 07171e0b
00 0858430b
00 0942430b
00 0a42430b
00 03131f0b
00 0313200b
00 0414210b
00 05151e0b
00 0616430b
00 0717430b
00 0616430b
00 0717430b
00 0c22250b
00 0d23260b
00 0c22250b
00 0e24270b
00 03131e0b
00 03131f0b
00 0414200b
00 05151e0b
00 0616430b
00 0717430b
00 0616430b
00 0717430b
00 4118280b
00 4119290b
00 4318280b
00 431a2a0b
00 03131e0b
00 03131f0b
00 0414200b
00 05151e0b
00 0616430b
00 0717430b
00 0616430b
00 0717430b
00 00102b0b
00 01112c0b
00 00102b0b
00 0f1b2d0b

