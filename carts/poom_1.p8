pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
-- data cart for POOM
local data=""
local mem=0x3100
for i=1,#data,2 do
    poke(mem,tonum("0x"..sub(data,i,i+1)))
    mem+=1
end
cstore()
__gfx__
00000000100000bf000000180a006008be08ceffff000000000000af0e0000186800601821088effffd042fffffac0cf43c8e518cc00202880089e00000000ff
ff000030080000184a185a7008be28900000000000100000bf0c0000186a187a10088e089effff000000000000af0e000018480000084f08be00000000001000
00bf0c000018f80060089e085f00000000ffff0000300800001809002008af089fffff000000000000af8c000018e918f930089f084fffff000000000000af8c
000018a918b91008ce282200000000ffff0000400600001878000028a0189000000000ffff00005008000018eb0020189018b0ffff000000000000af0e000018
0c002018b028b000000000001000009f0c0000184c000018f618070000000000100000df08000028860060188818e6ffff0000000000009f0400002876006018
76181600000000ffff0000100e000028c5006028421816001000000000000060000000283528457018e618d5ffff0000000000009f0400002877288710283218
06001000000000000050080000281500201806187600000000ffff0000100e000028b500001816182600002fcdfffffac060847f58282500001837189800006f
620000644560d4927928b60060181718f6ffffa2ff0000e8008fa7418b2896002018a81817ffff705affff1cae9fe1832a28e6000018271807ffff0000000000
009f000000289728a770180718180000000000100000df0800002818002018e6180800000000ffff00002004000028f70020181818d50000000000100000df08
0000282800201808182700000000ffff000020040000280800001827183700004e9fffffd8487044867928a6000008ae081e0000f9ceffff83916021d34c1858
0060082e08bfffff000000000000af00000018ba006008bf28120000000000100000bf000000180a002008de08ee0010000000000000508500001888006008ae
08eeffff000000000000af8a000018ea18fa50081e082e00000000ffff00003006000018080000282208de00000000ffff0000400600001878004008ee084f00
00000000100000bf0c000018e8000018d52852fffffac000002fcdbfe7660b2805000018f528320010000000000000500800002815006018e518660000000000
100000df04000028950020285218e5fffffac000002fcdbfe7660b28050020186618f50000000000100000df04000028a5002018e52842001000000000000060
0000002835284510085f08ae00000000ffff00003008000018190000000000000000000000000000000000000000000000000000000000000000000000000000
