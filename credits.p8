pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include utils.p8
#include intronoutro.p8
text,t,text_end,delays,melted=split("tHANK YOU,fOR WATCHING,,tHAT WAS,THE LATEST,PRODUCTION OF,aBERRATION,cREATIONS,CALLED,4 pORY rOKU,(fOUR SEASONS,IN pOLISH),,cREDITS,,cODE,yAMIfIVE,,gfx,yAMIfIVE,,mUSIC,yAMIfIVE,,dIRECTION,yAMIfIVE,,dRINKS,yAMIfIVE,,,gREETINGS,,fIRST OF ALL,i WANT TO THANK,mY GROUP,FOR HELP,AND PATIENCE,,mUSK cITRUS,aRGASEK,cLOWNBOSS bITER,,aLSO,,kYA/lAMERS,yOSHITAKA/boom!,mkm/lAMERS,kk/aLTAIR,,aLTAIR,aBYSS cONNECTION,aDDICT|aGENDA,aMNESTY|aNADUNE,aPPENDIX|aRISE,aRTWAY|aSD,aSTROIDEA,bONZAI,bRAINSTORM,cNCD|cOCOON,cONSPIRACY,dAMAGE|dESIRE,dIGITAL dYNAMITE,dILEMMA|dLG cREW,dREAMWEB|eLUDE,eLYSIUM|eXCEED,fAIRLIGHT,fAITH dESIGN,fARBRAUSCH|fCI,fLOPPY|fUTURIS,gENESIS pROJECT,gHOSTOWN|hAUJOBB,jOKER|kVASIGEN,lAMERS|lEMON,lEPSI.DE,lETHARGY,lNX|lOGICOMA,mADwIZARDS|mELON,mFX|nAH-KOLOR,nETRO|ng,nUANCE|oB5VR,oDBYT dESIGN,oFTENHIDE,pADAWANS,pOO BRAIN,pRISMBEINGS,rADIANCE,rAZOR 1911,rEBELS|rEVISION,sAMAR pRODUCTIONS,sATELLITE|sATORI,sPACEBALLS,sPECCY.PL,sTILL,sUNDIAL aEON,sWEET16|tBL,tGD|tIFECO,tRISTESSE|tRSI,uMLAUT dESIGN,uNITED fORCE,wHELPZ,,AND,,MY MOM,MY DAD,MY BOYFRIEND,AND OTHER PEOPLE,THAT HAD TO,LISTEN,ABOUT THE DEMO,AND DEMOSCENE,FOR THE LAST YEAR,,AND OF COURSE,ZEP,FOR CREATING,pICO-8,,i'VE STARTED,WORKING ON,THE DEMO,2023-08-27,,i WANTED TO HAVE,MORE SPRITES,AND SOMETHING,YOU CAN,FINALLY,CALLED MUSIC,eFFECTS OF,MY WORK,YOU'VE ALREADY,SEEN,,,,,iF YOU WANT,TO CONTACT ME,HERE IS MY,INSTAGRAM,@YAMI.FIVE,,,AGAIN,THANK YOU,FOR WATCHING,,AND GOODNIGHT!"),0,false,{},0
function _init()
    music(0)
    load_font()
	poke(24408,129)
    pal(12,1,1)
    pal(6,5,1)  
    gen_delays()  
end
function _update()
    t+=1
    if(t==1600 and text_end==false)then 
        text_end=true
        t=0
        memcpy(0x8000,0x0000,0x2000)
    end
end
function _draw()
    cls()
    if(text_end==false)then
        spr(0,0,0,16,16)
        for i=1,#text do
            local d=56-(#text[i]/2)*7
            print(text[i],0+d,148+i*9-flr(t*1),7)
        end
    else
        melting()
    end
end
function draw_text()
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
00000000000000000000000000000000006000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000066000000000000000000000000660000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000066000000006666666600000000660000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666000006666666666666600000666000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666600066660000000066660006666000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006606606660000000000000066606606600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006606666600000000000000006666606600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006600660000000000000000000066006600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006600000000000000000000000000006600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006600000000000000000000000000006600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000006600000000000000000000000000006600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000660000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000660000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000060000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000066066666666600000000666666666660000000066666666666600660006666666600066666666666666600000000000000000066000000000066
00000000000666006666666666000066666666666666600006666666666666006660066666666000666666666666666666000000000000000666000000000660
00000000000666000000000066600666000000000006660066600000000000006660000066000000660000000000000066600000000000000666000000000660
00000000006666000000000006600660000000000000660066000000000000066660000066000000660006000000000006660000000000006666000000006600
000000000660660000000000066006600000000c00c06600660c00c0000000660660000066000000600066000006666000666000000000666066000000066000
000000006600660000000000066006600000000c00c06600660c00c0000006600660000066000000000066000066666600066000000000660066000000660000
0000000066006600000000006660066600000000cc0666006660cc00000006600660000066000000000066000660000660006600000000660066000000660000
00000006600066000000000066000066000000000006600006600000000066000660000066000000060066006600000066006600000006600066000006600000
00000066000066000000666660000006666006666666000000666666600660000660000066000000660066006600000066006600000066000066000066000000
00000066000066000000066660000006666600666666000000666666000660000660000066000000660066006600000066006600000066000066000066000000
00000660000066000000000066000066000000066000000000000660006600000660000066000000660066006600000066006600000660000066000660000000
00006600000066000000000066600666000000066000000000000660066000000660000066000000660066000660000660006600006600000066006600000000
00006600000066000000000006600660000000006600000000006600066000000660000066000000660006600066666600006600006600000066006600000000
00066000000066000000000006600660000000000660000000066000660000000660000066000000660006660006666000006600066000000066066000000000
00660000000066000000000006600660000000000060000000060006600000000660000066000000660000666000000000006000660000000066660000000000
06600000000066000000000066600666000000000066000000660066000000000660000066000000660000066600000000000006600000000066600000000000
06600000000066666666666666000066666666666006600006600066000000000660000066000000660000006666666666666666600000000066600000000000
66000000000066666666666600000000666666666600600006000660000000000660000066000000660000000066666666666666000000000066000000000000
00000000000000000000000000000000000000000000660066000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000006666000000000000000000cccccccccc00cccc00000cc0ccc0c000cccc000cc000c00cc000000000000
000000000000000000000000000000000000000000000066000000000000000000cc00000000cc0c00000000cc00c00c00cc00cc00cc000c0c00c00000000000
00000000000000000000000000000000000000000000000000000000000000000cc0000000000c0c0000000c0c00c00c0cc0000cc0c0c00c0c00000000000000
00000000000000000000000000000000000000000000000000000000000000000c0000000000cc0cccc000c00c00c00c0c000000c0c0c00c0cc0000000000000
00000000000000000000000000000000000000000000000000000000000000000c00000000ccc00c000000c00c00c00c0c000000c0c00c0c000cc00000000000
00000000000000000000000000000000000000000000000000000000000000000cc00000000c000c00000c000c00c00c0cc0000cc0c00c0c0000c00000000000
000000000000000000000000000000000000000000000000000000000000000000cc00cc0000c00c0000c0000c00c00c00cc00cc00c000cc0c00c00000000000
0000000000000000000000000000000000000000000000000000000000000000000cccc000000c0cccc0c0000c00c00c000cccc000c000cc00cc000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
888888888888888888888888888888888888888888888888888888888888888888888888888888888882282288882288228882228228888888ff888888228888
888882888888888ff8ff8ff88888888888888888888888888888888888888888888888888888888888228882288822222288822282288888ff8f888888222888
88888288828888888888888888888888888888888888888888888888888888888888888888888888882288822888282282888222888888ff888f888888288888
888882888282888ff8ff8ff888888888888888888888888888888888888888888888888888888888882288822888222222888888222888ff888f888822288888
8888828282828888888888888888888888888888888888888888888888888888888888888888888888228882288882222888822822288888ff8f888222288888
888882828282888ff8ff8ff8888888888888888888888888888888888888888888888888888888888882282288888288288882282228888888ff888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555550000000000005555555555555555555555555555550000000000005500000000000055555555555
555555e555566656665555e555555555555566566656655550660060600005555555555556555566556656665550666066600005506660666000055555555555
55555ee555565656565555ee5555555555565556565656555006006060000555555555555655565656565656555060606060000550606060600005555d555555
5555eee555565656565555eee55555555556665666565655500600666000055555555555565556565656566655506060606000055060606060000555d5d55555
55555ee555565656565555ee55555555555556565556565550060000600005555555555556555656565656555550606060600005506060606000055d555d5d55
555555e555566656665555e55555555555566556555666555066600060000555555555555666566556655655555066606660000550666066600005555555d555
55555555555555555555555555555555555555555555555550000000000005555555555555555555555555555550000000000005500000000000055555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555566666577777566666566666555558888888856666666656666666656666666656666666656666666656666666656666666655555555555
55555665566566655565566575557565556565656555558887788856666676656666667756677777656666777656676666656676667656667766655555dd5555
5555656565555655556656657775756665656565655555887887885666776765666677675667666765666676765676766665767676765667777665555d55d555
5555656565555655556656657555756655656555655555878888785677666765667766675667666765666676765766676765777777775677667765555d55d555
55556565655556555566566575777566656566656555557888888757666666757766666757776667757777767757666776756767676757766667755555dd5555
55556655566556555565556575557565556566656555558888888856666666656666666656666666656666666656666666656766666756666666655555555555
55555555555555555566666577777566666566666555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555555555005005005005005dd500566555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555565655665655555005005005005005dd56656655555777777775dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd55555555555
5555656565656555550050050050050057756656655555777777775d55ddddd5dd5dd5dd5ddd55ddd5ddddd5dd5dd5ddddd5dddddddd5dddddddd55555555555
5555656565656555550050050050056657756656655555777777775d555dddd5d55d55dd5dddddddd5dddd55dd5dd55dddd55d5d5d5d5d55dd55d55555555555
5555666565656555550050050056656657756656655555777557775dddd555d5dd55d55d5d5d55d5d5ddd555dd5dd555ddd55d5d5d5d5d55dd55d55555555555
5555565566556665550050056656656657756656655555777777775ddddd55d5dd5dd5dd5d5d55d5d5dd5555dd5dd5555dd5dddddddd5dddddddd55555555555
5555555555555555550056656656656657756656655555777777775dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd5dddddddd55555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00ccc00000005500770000066600eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000000600e0e00c0000000005507000000000600e0e00c00000000055000000000000000000000000000005500000000000000000000000000000555
55507000000066600e0e00ccc00000005507000000066600e0e00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000060000e0e0000c00000005507000000060000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00ccc000d0005500770000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500770707066600eee00ccc00000005500770707066600eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000777000600e0e00c0000000005507000777000600e0e00c00000000055000000000000000000000000000005500000000000000000000000000000555
55507000707066600e0e00ccc00000005507000707066600e0e00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000777060000e0e0000c00000005507000777060000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55500770707066600eee00ccc000d0005500770707066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
555011111111111111111aaaaa111110550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55501771717166611eee1accca1111105500770707066600eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507111777111611e1e1aaaca1111105507000777000600e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507111717166611e1e1aacca1111105507000707066600e0e000cc000000055000000000000000000000000000005500000000000000000000000000000555
55507111777161111e1e1aaaca1111105507000777060000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55501771717166611eee1accca11d1105500770707066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
555011111111111111111aaaaa111110550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00000005507770000066000eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e00c0000000005507070000006000e0e00c00000000055000000000000000000000000000005500000000000000000000000000000555
55507700000006000e0e00ccc00000005507700000006000e0e00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e0000c00000005507070000006000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066600eee00ccc000d0005507770000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000001000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000017100000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00cc177100005500770000066600eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000000600e0e00c0177710005507000000000600e0e00c00000000055000000000000000000000000000005500000000000000000000000000000555
55507000000066600e0e00cc177771005507000000066600e0e00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000060000e0e0000177110005507000000060000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00ccc11710005500770000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00ccc00000005500770000066600eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000000600e0e0000c00000005507000000000600e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507000000066600e0e000cc00000005507000000066600e0e000cc000000055000000000000000000000000000005500000000000000000000000000000555
55507000000060000e0e0000c00000005507000000060000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55500770000066600eee00ccc000d0005500770000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00000005507770000066000eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e00c0000000005507070000006000e0e00c00000000055000000000000000000000000000005500000000000000000000000000000555
55507770000006000e0e00ccc00000005507770000006000e0e00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e0000c00000005507070000006000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507070000066600eee00ccc000d0005507070000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55507770000066000eee00ccc00000005507770000066000eee00ccc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e0000c00000005507070000006000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507770000006000e0e000cc00000005507770000006000e0e000cc000000055000000000000000000000000000005500000000000000000000000000000555
55507070000006000e0e0000c00000005507070000006000e0e0000c000000055000000000000000000000000000005500000000000000000000000000000555
55507070000066600eee00ccc000d0005507070000066600eee00ccc000d00055001000100010000100001000010005500100010001000010000100001000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55500000000000000000000000000000550000000000000000000000000000055000000000000000000000000000005500000000000000000000000000000555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5555dd555dd5ddd5ddd555555ddd5d5d5ddd5ddd555555dd55ddd5ddd5d5d5dd55ddd5555ddd5ddd5d5d5ddd5ddd5ddd5555dd55ddd5ddd5ddd5ddd5dd555555
5555d5d5d5d55d5555d555555d5d5d5d555d555d555555d5d5d5555d55d5d5d5d5d555555d5d5d555d5d5d555d5d5d5d5555d5d5d5d5ddd5d5d5d555d5d55555
5555d5d5d5d55d555d5555555dd55d5d55d555d5555555d5d5dd555d55d5d5d5d5dd55555dd55dd55d5d5dd55dd55dd55555d5d5ddd5d5d5ddd5dd55d5d55555
5555d5d5d5d55d55d55555555d5d5d5d5d555d55555555d5d5d5555d55d5d5d5d5d555555d5d5d555ddd5d555d5d5d5d5555d5d5d5d5d5d5d555d555d5d55555
5555d5d5dd55ddd5ddd555555ddd55dd5ddd5ddd555555ddd5ddd55d555dd5d5d5ddd5555d5d5ddd55d55ddd5d5d5ddd5555ddd5d5d5d5d5d555ddd5d5d55555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55551111111111111115555551111111111111115555551111111111111111111111155551111111111111111111111155551111111111111111111111155555
55551dddddd111111115555551dddddd111111115555551dddddd111111111111111155551dddddd111111111111111155551dddddd111111111111111155555
55551dddddd111111115555551dddddd111111115555551dddddd111111111111111155551dddddd111111111111111155551dddddd111111111111111155555
55551dddddd111111115555551dddddd111111115555551dddddd111111111111111155551dddddd111111111111111155551dddddd111111111111111155555
55551111111111111115555551111111111111115555551111111111111111111111155551111111111111111111111155551111111111111111111111155555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__sfx__
690c00001e5501e5501e5201c5501e5501e5201a5501a5201e5501e5501e5201c5501e5501e5201a5501a5201f5501f5501f5201e5501c5501c5201a5501a5201855017550155501552017550175401753017520
690c00001e5501e5501e5201e55013550135201555015520175501755017520175501f5501f5201e5501e5201f5501f5501f5201e5501c5501c5201a5501a5201855017550155501552017550175401753017520
010c00000b1430b1330b1230b1130b1430b1330b1230b1130b1430b1330b1230b1130b1430b1330b1230b11310143101331012310113101431013310123101130c1430c1330c1230c1130b1430b1330b1230b113
010c000012143121331212312113101431013310123101130b1430b1330b1230b1131314313133131231311310143101331012310113101431013310123101130c1430c1330c1230c1130b1430b1330b1230b113
010c00000b1430b1330b1230b1130b1430b1330b1230b1130b1430b1330b1230b1130e1430e1330e1230e1130b1430b1330b1230b1130b1430b1330b1230b1130c1430c1330c1230c1130b1430b1330b1230b113
010c00000b1400b1300b1200b1100b1400b1300b1200b1100b1400b1300b1200b1100b1400b1300b1200b11010140101301012010110101401013010120101100c1400c1300c1200c1100b1400b1300b1200b110
010c000012140121301212012110101401013010120101100b1400b1300b1200b1101314013130131201311010140101301012010110101401013010120101100c1400c1300c1200c1100b1400b1300b1200b110
010c00000b1400b1300b1200b1100b1400b1300b1200b1100b1400b1300b1200b1100e1400e1300e1200e1100b1400b1300b1200b1100b1400b1300b1200b1100c1400c1300c1200c1100b1400b1300b1200b110
010c00001e5501a5501e5501e5201355013520155501552017550175501a5501a5201c5501c5201a5501a5201f5501f5501f5201e5501c5501c5201a5501a5201855017550155501552017550175401753017520
010c00001e5501e520185501c550135501352015550155201e550175501a5501a5201e5501c5501a5501c5501f5501f5501f5201e5501c5501c5201a5501a5201855017550155501552017550175401753017520
010c00001e5501e5501e5201e550135501352015550155201c5501f55017520175501f5501f5201e5501e5201f5501f5501f5201e5501c5501c52018550185201a5501a5201a5501a52018550185201c5501c520
010c00001e5501e5501e5201c5501e5501e5201a5501a5201e5501e5501e5201c5501e5501e5201a5501a5201f5501f5501f5201e5501c5501c5201a5501a5201855017550175401753017520000000000000000
__music__
01 00020544
00 00030644
00 01040744
00 08020544
00 08030644
00 01040744
00 09020544
00 0a030644
00 00040744
00 01020544
00 08030644
00 08040744
00 01020544
00 09030644
00 0a040744
00 08024344
00 0b424344

