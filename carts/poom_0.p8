pico-8 cartridge // http://www.pico-8.com
version 27
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
710085000000202020000020204040000800000020202000002020404000080000002020200000202040400007ff8c0040101000802020001000080001002020
2000002020404000080000004010100000202040400009000200202020000020204040000b000300202020000020204040008eff830000000020802020404000
0b000400202020000020204040008900052040202020402020404000890005204020202040202040400005000020002020000020201010000500002000202000
00202010100007008000202020000020204040000b000400202020000020204040000b000400501010204020204040000b000400202020000020204040000b00
040020202000002020404010040004200020202040202040401004000d002020200000202040401004000d002020200000202040401004008e00202020208020
204040082a3000602020006020200000000030006020200060202000000000300060202000602020000000003000602020006020200000000030000020200000
00002040202030006020200060202000000000100060202000602020000000001000602020006020200000000010000000000000000000000000300020202000
00000000000000100060202000602020000000001000000000000000000000000020006020200000000000000000100060202000602020000000001000602020
00602020000000002000602020006020200000000020006020200060202000000000200060202000602020000000002000602020006020200000000020000020
20000000002040202020006020200060202000000000200060202000602020000000003000602020006020200000000010006020200060202000000000100060
20200060202000000000100060202000602020000000001000602020006020200000000010006020200060202000000000200050101000000000000000002000
50101000000000000000002000501010000000000000000020005010100000000000000000200050101000000000000000004000000000000000002060202040
00000000000000002060202040000000000000000020602020400050101000000000206020204000000000000000002060202030006020200060202000000000
30000000000000000000000000600000000000602020000000008000000000000000002040202080006020200060202000000000600000000000000000000000
00600000000000602020000000005000000000006020200000000070000000000060202000000000500000000000602020000000005000000000000000002040
20205000000000000000002040202060000000000000000020402020700020202000000000000000008000602020006020200000000070000000000060202000
0000007000000000000000002040202080002020200000000000000000a0006020200060202000000000a0000000000000000000000000a00060202000602020
00000000a000000000006020200000000090000000000000000000000000a000602020006020200000000090000000000000000000000000a000602020006020
200000000090000000000000000000000000900000000000000000000000009000000000000000000000000090000000000000000000000000a0006020200000
000000602020a0006020200060202000000000a00060202000602020000000009000000000000000000000000090000000000000000000000000a00060202000
0000000060202090000000000000000000000000900000000000000000000000009000000000000000000000000090000000000000000000000000a000602020
006020200000000090000000000000000000000000b0000000000060202000000000b0000000000000000000000000b0000000000060202000000000b0000000
000000000000000000c0000000000060202000000000c0000000000000000000000000c0000000000060202000000000c0000000000000000000000000d00000
00000000000000000000d0000000000000000000000000d0000000000000000000000000d0000000000000000000000000302040202000000000006020203020
40202000000000006020203020402020000000000060202030204020200000000000602020e0000000000000000000000000e0000000000000000000000000e0
000000000000000000000000e0000000000000000000000000302040202000000000006020203020402020000000000060202030204020200000000000602020
30204020200000000000602020f0006020200060202000000000f0000000000000000000000000f0006020200060202000000000f00000000000000000000000
00a0006020200060202000000000a000000000000000000000000001000000000060202000000000010000000000000000000000000100000000006020200000
00000140008080000000000000000011000000002040202000000000110000000000000000000000001100000000204020200000000011000000000000000000
00000021000000000060202000000000210000000000602020000000002140008080000000000000000021000000000060202000000000210000000000a02080
0000000021000000000060202000000000a0000000000000000000000000a0000000000060202000000000310000000000602020000000003100000000000000
00002020203100000000006020200000000031000000000000000000000000410000000000002020000000004100602020006020200060202041000000000000
20200000000041002020200000000000000000510000000000000000000000005100000000006020200000000051000000000000202000000000510000000000
60202000000000610000000000602020000000006100000000006020200000000061000000000060202000000000610000000000602020000000006100000000
000000000000000061000000000060202000000000610000000000a0208000000000610000000000602020000000007100000000000000000000000071000000
00000000000000000071000000000000000000000000710000000000000000000000007100000000000000000000000071000000000000000000000000710000
00000000000000000000710000000000000000000000006100202020000000000050101061002020200000000000501010610020202000000000005010106100
20202000000000005010106100202020000000000050101061002020200000000000501010610020202000000000005010106100202020000000000050101008
08ff080000ef0c0000ff020000ff060000ff080000000200000008000000080000100800000002000010080000ff0e000000020000ef0a000000020000df0600
0000060000df0c0000cf0e0000df0a0000df060000df0c0000000e0000ef060000ff020000df000000ef080000ef040000df0a0000df06000010080000ef0600
00000e0000df0a000000060000cf0e0000ff040000cf080000df060000df000000bf0e0000df0a0000bf0a0000ef0a0000cf02000000000000ef000000000400
00ef060000ff060000cf0a0000ef0a0000df060000ef0a0000df0c0000ff020000df000000ff0a0000cf060000ff04000010080000ef0c0000100c0000ff0e00
00200e0000ff0e0000200e0000ef0c000020040000ef0c0000100c0000ef0c000020000000ff0e000020040000ff0e000020000000ef0c0000200e0000ef0000
00200e0000000800003008000000080000600000002004000080080000100a000040080000ef00000040000000ef000000400a0000ef000000400a0000ef0800
0040080000ff04000040080000ff000000400800000000000040080000ff080000800a0000bf0c000050060000bf06000040080000ef080000400a0000ff0400
00400a0000ff060000400a000000080000900e0000ef0c0000400a0000ff000000400a0000ff0800004008000000080000400a000000000000000e0000ff0a00
00000e0000ff0e000010020000ff0e000010020000ff0a0000000e0000ef0a0000000e0000ef0e000010020000ef0e000010020000ef0a000030080000ef0000
0030080000df0c000040000000df0c000030080000df0a000040000000df0a000030040000cf06000030040000df0a000040040000df0a000040040000cf0600
00400000000008000030080000000c000040000000000c00003008000010040000400000001004000030080000100800004000000010080000200a0000100800
002000000020080000200a000030080000400e0000300800005008000020080000400e000010080000300c00002002000030c7000020c3000030060000200800
0030c70000204c0000300c0000200e000040400000204c000040020000200800004040000020c30000200e000030080000200e000010080000000e000000c500
00ef575555ef0a0000cfee0b44dfd83aca00c8ccdcdf323343dfbfcaafcf6dc7a8ff0a0000cf0a0000ff4c29a4cf6dbde6ef73541dfffb702ccf26aaaa00803e
e8bf4b6d35ef9dd45610080000ef0e000010020000ef06000090644fed00000010200e000000000000509642291008000080f8d49e1008000040000000000000
00200e0000103c3c3c504550df206cc52d409a423920080010200e000030c3c3c340331e4b200b847b200e000020383c3c30c1ccdc10cdccdc30f87bb420c0e1
c49710000020000030000040000050a610600000e0000080000090d010c0a010700000310000f00000b00000710000810000910000a10000b10000c100006100
0001000051000011000041c610210000d12210e16210f1521002421012321072000082c210920000a2a310b20000d20000e20000f20000030000133310234310
530000630000738310930000b30000c30000240000e30000f30000640000a44510d40000b40000740000340000940000548510d30000e4000044651014000004
0000840000c40000f4000005251015000035000055000075000095d510a50610b5f510c5e510165610268610367610466610960000b60000d60000e60730b010
1101f60000170000274750370000570000679750770000870000a70000b70000c70000d70828305f104101e70000f70000080808681008180000083800000848
0878100858000008880000089808f8307f10410108a8000008b8000008c8000008d8000008e80000080900000819000008290000083908b9100849082a100859
081a100869080a10087908f910088908e910089908d91008a908c9102330a0009020b0000050a600410080b0109010a000510051006100610000c0a100b1d0b1
0000909600a100e000c00050900080007000a040c000010011001100b600006030c010a030700000e04400000150b000d000f0000070c600310041004100a600
0010608000700090000030b600110021002100d6000070e600008060f000e000d0000080e6000060d600210031003100c600005030d000b00080000060e60000
7050f60091f09100a10096000020b100c1d0c10000a05007008100810091f0f6000090c100d1d0d10000b0501700710071008100070000a0d100e1d0e10000c0
4061007100170000b0e100f1d0a100002050b110b120a110f1c0e110e1b0d110d1a0c110c190a010001000200050f03000200040006000860000611410943104
0000415410d411440000407000400050301050e02000250091109190f61091a081001500403700f000c00000404410051174000021404400d4e05400e4416400
f42174000501600100f000370000017410f4116400005127001281f100020040040094e01400a4612400b4513400c441400410c431340000516410e411540000
e0506000128127000021640000413410b431240000615050003000600000512410a431140000e08600600040020062005200a291720082004200928150271012
51600022000210927142005200f110122140520072006200d2a13200c2007210a27140120032c1220042003210d2916200b200808500b60095000700a500c600
66000003c70000d2e70000c2970000237600f600d0221032a11200f20057000032870000723300531243003400130043002300b32273008300d2002300e20045
d1840035008200e20040841045c1e2006500a40075e19400550040941075d1a4009500c400a5f1b400850060b410a5e1c400d500f400e5000500f500d400b500
e400c500b0f20033000300e322c3002400830093009300f300d3004412f30000824700c300b300d300530063006300730040431053c133005400f3104402d300
6400407310b3c123007400c310e30203008400505700f20092000300a200064215000072870000c14015100632a2002600250036523500460040351036422500
56004500666255007600405510665245008600650096237500a60040e3000400330000c1870000321500160050a300a300670000137700c30047000002f30014
0080e50027a2f50037b2060047c2160057d226006703360077e2460087f25600972330f5102792e500002308080000b24006103792f50000a20808000023f700
00c25016104792060000b2f7000023970000b1e70000d24026105792160000c2e70000b1c7000003304610779236000003d70000f24056108792460000e2d700
0003b7000023806600c600b500d600a7000023b70000f2d70000e236106792260000d2c70000b140b2001300c200c300770000826700a300c0751096626500f6
00760000b1970000c2f70000b208080000a2e5109792560000f2b7000003a700d600c5001700d500e60013ffff1cae00008fb5ef47e2f8df0c0000dfd80000cf
0e0000df060000ef0a0000df0a0000bf0a0000ef0800003010200000054f00002fcdefcbe2acef0a0000df32000000020000000e0000ef0a0000ef0600000002
0000000e00003030400000e36100008fb5cf0ea934df060000cf080000df0a0000ff4c0000df060000cf6d0000ff02000000020000307080ffffa2ff0000e800
ef07d99adf0c0000cf0a0000ff0a000000c80000df060000cf080000df0a00000002000010603000005d100000e800cf19a5bddf0c0000cf6d0000cfee0000df
bf0000df0c0000cf080000df0a000000c80000105040ffff90adffff9bca0014eeddef0a0000df32000000020000000e0000df0c0000cf080000cfee000000c8
00000020500000768fffff611100dfe6e2ef0a0000dfd80000bf0a0000ef080000ef0a0000cf080000cfee0000000e00000010600000de0b0000f531cfb511f0
ff040000ef0a0000bf0a0000cf0a0000ff0a0000ef0a0000cf060000df0c000030c0d00000385bffff42c7ef7cf24c00800000ef9d0000bf4b0000df000000ff
0a0000ef0a0000bf0a0000df0c000010b080ffff2700ffffa2ff109f2e6f00040000ff020000cf260000ef73000000800000ef0a0000bf0a0000df0c000010a0
90ffff33430000999910646666fffb0000ef0a0000df060000ef57000000040000ef0a0000bf0a0000ef7300001090a0ffffb170000027c70008cc9200080000
ef0a0000ff020000000e000000040000ff060000ef000000ff08000030e0f00000bed40000467def24b9cc00040000ef0a0000bf0a0000ef57000000080000ef
0a0000ef000000000e000000b0c00000000000100000ef0a0000ef0a0000cf080000bf0a0000000e000000080000ef0a0000bf0a0000000e00000070d0000000
0000100000ef0a0000ef0a0000ef060000000e000010020000ef0e0000ef0a0000000e000010020000300111001000000000000010020000ef0e0000ef060000
000e000010020000ef0e0000ef060000100200001008000020f02100000000ffff000000060000ff0e0000ff0a0000000e000010020000ff0a0000ef0e000000
0e000010020000303141001000000000000010020000ff0e0000ef0e0000000e000010020000ff0e0000ef0e0000100200001008000020115100000000001000
00ff0e0000ff0e0000ef0e0000000e00001008000000c50000ff0e0000000e0000100800002021610000000000100000ef0e0000ef0e0000ef060000000e0000
1008000000c50000ef0e0000000e000010080000000131ffff000000000000ef040000ff0e0000ef0c0000100c000020000000ff0e0000ef0c00001008000010
0c0000307181001000000000000020040000ff0e0000ef0c00002000000020040000ff0e0000ef0c000020040000200e00003091a10000000000100000ff0e00
00ff0e0000ef0c000020000000200e0000300800001008000020000000200e00002061b1001000000000000020000000ff0e0000ef0c00001008000020000000
30080000ef0c000020000000200e000000517100100000000000001008000000c50000ef060000000e00001008000030080000ef0c000010080000200e000000
41810010000000000000000e000000080000cf080000bf0a0000000e000030080000ef060000000e0000200e000000e09100000000ffff000020040000ef0000
00df0c00003008000040000000df0c0000df0a0000300800004000000030d1e100000000ffff000020060000ef000000df0a00003008000040000000df0a0000
cf060000300400004004000020b1f100000000ffff00002000000000000000ef000000200e000040080000ef000000cf060000300400004004000010c1c10000
0000ffff00000008000000000000ff08000040080000400a0000ff000000ef08000040080000400a0000301222ffff000000000000bf06000000000000bf0600
00400a0000900e000000000000ef08000040080000400a00001002e100100000000000004008000000000000cf060000200e00004008000000000000bf060000
40080000900e000000d1f10000000000100000000800000008000000000000200e000040000000000c0000000800003008000040000000303242000000000010
00001004000010040000000c00003008000040000000100800001004000030080000400000003052620000000000100000000c0000000c000000000000200e00
004000000010080000000c00003008000040000000001222001000000000000040080000000800000000000040000000400800001008000000000000400a0000
906400003072820010000000000000400000001008000000000000200e00004000000010080000000000004000000090640000003242ffffe988ffff3194cfb9
47f8200e000020020000300600004002000020c3000020c0000030c70000300c00003092a2ffff3194ffffe988bfde564f200e000020c0000030060000400200
002008000010cd000030c1000030f800002062b2ffff319400001687df4d2cd0200e000010cd000030c1000040020000204c0000103c0000200e000030c70000
2072c2ffffe9880000ce7b10b3b031200e0000103c0000200e00004002000030c3000020380000200e0000300c00002082d20000ce7b00001687404c323d30c3
0000103c0000200e000040020000204c00002008000040400000403300002092e20000ce7bffffe98820cd7cab30c30000103c0000200e000040330000200b00
0020c3000040400000409a000020a2f2000016870000ce7b4061518330c30000103c0000200e0000409a00003008000020080000200e00005045000020b203ff
ff634b0000e992cfca41b820040000100800005096000080f80000206c000010080000200e00005008000030132300001687ffff3194ff67e74b30080000103c
0000200e000050450000206c000010080000200e000080f8000000c2d20000000000100000100800001008000000000000200e00009064000030080000100800
00200e000080f800000052e200000000001000000000000000000000bf060000200e0000900e00003008000000000000200e0000906400000002f20010000000
000000200e000030080000cf080000bf0a0000200e000030080000bf060000200e0000900e000000a10300000000000000000000000000000000000000000000
