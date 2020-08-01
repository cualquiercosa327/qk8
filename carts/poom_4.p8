pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- data cart
-- @freds72
local data=""
local mem=0x3100
for i=1,#data,2 do
    poke(mem,tonum("0x"..sub(data,i,i+1)))
    mem+=1
end
cstore()
__gfx__
00000000ffff0000200600000000080000df0a0000bf0800001008000021df0a0000af0400009f080000000e000062ffff000000000000ef0400003092a20010
0000000000002004000030b2c200100000000000002000000000ff0e0000ef0c0000100800002000000082ff0e0000ef0c000020000000200e00009200000000
ffff00002000000030d2e2ffff000000000000cf0800002000000000df0c00003008000040000000b2f200000000ffff00002006000030031300000000ffff00
00200400000000000000df0c0000200e000040000000c2df0c0000cf0600003004000040000000d20010000000000000200e000000ff0e0000ef0c0000100800
00200e0000a200000000cf060000200e000040000000e200000000ffff0000200000003023330000000000100000ff000000305363ffff000000000000bf0600
00104300000000ef08000040080000400a0000130010000000000000400800000000000000cf06000040000000400800000300000000bf06000040080000900e
0000230010000000000000400000000000000000cf0600001008000040000000f200000000bf06000040000000900e0000330000000000100000000800003073
830000000000100000000c000020000c00000000000030080000400000005393ffff000000000000bf06000030a3b30010000000000000400000000010040000
0000000030080000400000006310040000000000004000000090640000730010000000000000200e000030c3d3ffff000000000000df04000020000800000000
0000200c00003008000093e3ffff000000000000cf080000001004000000000000300800009064000083000c0000000000002000000030080000a3ffff3194ff
ffe988bfde564f30f304ffff319400001687df4d2cd020200e00002002000030c4000040020000c314000016870000ce7b4061518320200e000020020000206d
000040020000d3240000ce7b00001687404c323d20203f000020020000206d000040020000e334ffffe9880000ce7b10b3b031203032000020020000206d0000
40360000f3440000ce7bffffe98820cd7cab20300800002002000020b20000409800000454ffffe988ffff3194cfb947f820300800002002000020b200005045
0000146400000000001000001008000030748400009d61ffff872530658c443094a40010000000000000400000000020a300001004000020b800004000000034
206c0000100400004000000080da00004400001687ffff3194ff67e74b0030080000100a0000200000005045000024206c00001004000020b8000080da000054
0000000000100000100400000010040000000000002000000090640000b330080000100400002000000080da0000640000000000100000000000000000000000
bf06000010080000900e00004330080000000000002000000090640000740010000000000000100800000000080000af0400009f080000100800007230080000
bf06000010080000900e000084f00060202000602020000020200000202000202020002020202000202020002020004010100040101020402020204020200080
20200080202020602020206020202080202020802020005010100050101000a0802000a08020400080804000808080a0202080a0202000c0802000e0802000e0
802000c0802000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
