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
210085000000202020000020204040000800000020202000002020404000080000002020200000202040400007ff8c0040101000802020001000080001002020
2000002020404000080000004010100000202040400009000200202020000020204040000b000300202020000020204040008eff830000000020802020404000
0b000400202020000020204040008900052040202020402020404000890005204020202040202040400005000020002020000020201010000500002000202000
00202010100007008000202020000020204040000b000400202020000020204040000b000400501010204020204040000b000400202020000020204040c73000
60202000602020000000003000602020006020200000000030006020200060202000000000300060202000602020000000003000002020000000002040202030
00602020006020200000000010006020200060202000000000100060202000602020000000001000000000000000000000000030002020200000000000000000
10006020200060202000000000100000000000000000000000002000602020000000000000000010006020200060202000000000100060202000602020000000
00200060202000602020000000002000602020006020200000000020006020200060202000000000200060202000602020000000002000002020000000002040
20202000602020006020200000000020006020200060202000000000300060202000602020000000001000602020006020200000000010006020200060202000
00000010006020200060202000000000100060202000602020000000001000602020006020200000000020005010100000000000000000200050101000000000
00000000200050101000000000000000002000501010000000000000000020005010100000000000000000400000000000000000206020204000000000000000
00206020204000000000000000002060202040005010100000000020602020400000000000000000206020203000602020006020200000000030000000000000
00000000000060000000000060202000000000800000000000000000204020208000602020006020200000000060000000000000000000000000600000000000
60202000000000500000000000602020000000007000000000006020200000000050000000000060202000000000500000000000000000204020205000000000
00000000204020206000000000000000002040202070002020200000000000000000800060202000602020000000007000000000006020200000000070000000
00000000002040202080002020200000000000000000a0006020200060202000000000a0000000000000000000000000a0006020200060202000000000a00000
0000006020200000000090000000000000000000000000a000602020006020200000000090000000000000000000000000a00060202000602020000000009000
0000000000000000000000900000000000000000000000009000000000000000000000000090000000000000000000000000a0006020200000000000602020a0
006020200060202000000000a00060202000602020000000009000000000000000000000000090000000000000000000000000a0006020200000000000602020
90000000000000000000000000900000000000000000000000009000000000000000000000000090000000000000000000000000a00060202000602020000000
0090000000000000000000000000b0000000000060202000000000b0000000000000000000000000b0000000000060202000000000b000000000000000000000
0000c0000000000060202000000000c0000000000000000000000000c0000000000060202000000000c0000000000000000000000000d0000000000000000000
000000d0000000000000000000000000d0000000000000000000000000d000000000000000000000000030204020200000000000602020302040202000000000
006020203020402020000000000060202030204020200000000000602020e0000000000000000000000000e0000000000000000000000000e000000000000000
0000000000e000000000000000000000000030204020200000000000602020302040202000000000006020203020402020000000000060202030204020200000
000000602020f0006020200060202000000000f0000000000000000000000000f0006020200060202000000000f0000000000000000000000000a00060202000
60202000000000a00000000000000000000000000100000000006020200000000001000000000000000000000000010000000000602020000000000140008080
00000000000000001100000000204020200000000011400080800000000000000000110000000020402020000000001100000000000000000000000021000000
00006020200000000021000000000060202000000000210000000000000000000000002100000000006020200000000021000000000000208000000000210000
0000006020200000000006ff080000ef0c0000ff020000ff060000ff080000000200000008000000080000100800000002000010080000ff0e000000020000ef
0a000000020000df06000000060000df0c0000cf0e0000df0a0000df060000df0c0000000e0000ef060000ff020000df000000ef080000ef040000df0a0000df
06000010080000ef060000000e0000df0a000000060000cf0e0000ff040000cf080000df060000df000000bf0e0000df0a0000bf0a0000ef0a0000cf02000000
000000ef00000000040000ef060000ff060000cf0a0000ef0a0000df060000ef0a0000df0c0000ff020000df000000ff0a0000cf060000ff04000010080000ef
0c0000100c0000ff0e0000200e0000ff0e0000200e0000ef0c000020040000ef0c0000100c0000ef0c000020000000ff0e000020040000ff0e000020000000ef
0c0000200e0000ef000000200e0000000800004008000000080000600000002004000080080000100a000040080000ef00000040000000ef000000400a0000ef
000000400a0000ef08000040080000ff04000040080000ff000000400800000000000040080000ff080000800a0000bf0c000050060000bf06000040080000ef
080000400a0000ff040000400a0000ff060000400a000000080000900e0000ef0c0000400a0000ff000000400a0000ff080000400a000000000000000e0000ff
0a0000000e0000ff0e000010020000ff0e000010020000ff0a0000000e0000ef0a0000000e0000ef0e000010020000ef0e000010020000ef0a000030080000ef
00000030080000df0c000040000000df0c000030080000df0a000040000000df0a000030040000cf06000030040000df0a000040040000df0a000040040000cf
06000000c8ccdcdf323343ffdab6a50013802400d06bcdef0e000010080000ef0e000010020000ef060000ff4c2994ff0e0000ef575555ef0a0000ff0a0000cf
0a0000ff4c29a4cf6dbde6cf0f0000dfc80000ef73541dfffb702ccf26aaaa00803ee8bf4b6d35ef9dd45640000000cf060000400000000008000040000000ff
00000040000000ef080000f510000020000030000040000050a610600000e0000080000090d010c0a010700000310000f00000b00000710000810000910000a1
0000b10000c1000061000001000051000011000041c610210000d12210e16210f1521002421012321072000082c210920000a2a310b20000d20000e20000f200
00030000133310234310530000630000738310930000b30000c30000240000e30000f30000640000a44510d40000b40000740000340000940000548510d30000
e40000446510140000040000840000c40000f4000005251015000035000055000075000095d510a50610b5f510c5e510165610268610367610466610960000b6
0000d60000e60710f60000170000274710370000570000679710770000870000a70000b70000c700005250900080007000a020c000010011001100050000b050
c010a01070000051250000604410d44034000030404500f000c00000203410054064000050403400d4204400e4805400f45064000530600100f0004500003064
10f4405400009035001281f10002005004109470f30000804400002025000051550000a040f30094600400a4a01400b4902400c48040f310c470240000905410
e44044000060506000128135000050540000802410b470140000a070150020004000600050003000600000901410a47004000060550000516080007000900000
100500110021002100750000c0850000d070f000e000d00000d0850000b0750021003100310041004100950000e030d000b000800000b0850000c040a00090f0
b000d000f00000c09500410080b01090e0a00051005100610061000031a100b141b10000016500a100e000c00050a50091619100a100650000f0b100c141c100
001150b500810081009161a5000001c100d141d100002150c500710071008100b5000011d100e141e10000314061007100c5000021e100f141a10000f050b110
b1f0a110f131e110e121d110d111c110c10170100010002000506130002000150000a055000060250000207000400050301050512000250091109101a5109111
8100150040020062005200a29172008200420092815035101290600022000210927142005200f110125040520072006200d2a13200c2007210a27140120032b1
220042003210d2916200b20090221032a11200f20092000300e5000042f500000206000022e20045c1740035008200e20040741045b1e2006500940075d18400
550040841075c194009500b400a5e1a400850050a410a5d1b4000032d500f500c400b500d400c500d0b2001300c200c300b300d3005300630063007300f20033
000300e312c3002400830093009300f300d3004452e3001400a300a300402300b31273000022060000b1f5000042407310b30223007400c310e3f10300840040
d2002300e20000b1060000027300830040b400d500e400e500f400f500d50000e170e5000300a200040033005352430034001300430023000002f50000b14043
10534233005400e31044f1d3006400420000054f00002fcdefcbe2acef0a0000df32000000020000000e0000ef0e0000ef06000000d00000000e000030102000
00000000100000ef0a0000ef0a0000ef060000000e000010020000ef0e0000ef0a0000000e000010020000303040001000000000000010020000ef0e0000ef06
0000000e000010020000ef0e0000ef06000010020000100800002020500010000000000000000e0000ef0e0000df32000000d00000000e0000ef0e0000ef0600
00000e00001008000000103000000000ffff000000060000ff0e0000ff0a0000000e000010020000ff0a0000ef0e0000000e0000100200003070800010000000
00000010020000ff0e0000ef0e0000000e000010020000ff0e0000ef0e000010020000100800002050900010000000000000000e0000ff0e0000ef0e0000ff4c
0000000e0000ff0e0000ef0e0000000e0000100800001060600000000000100000ff0e0000ff0e0000ef0e0000ff4c00001008000000080000ff0e0000ffda00
00100800002070a00000000000100000ef0e0000ef0e0000df32000000d000001008000000080000ef0e0000ffda000010080000004080ffff6ad10000fe3bdf
f7d850df060000cf6d0000ff02000000020000df0c0000df060000cf0e0000df0a000030d0e00000e36100008fb5cf0ea934dfc80000cf080000cf0f0000ff4c
0000df0c0000cf6d0000cf0e00000002000010c0a0ffffa2ff0000e800ef07d99adf0c0000cf0a0000ff0a000000c80000df0c0000cf080000cf0e0000000200
0010b0b0ffff1cae00008fb5ef47e2f8df0c0000cf080000cf0e000000c80000ef0a0000df0a0000bf0a0000ef08000020c0f00000de0b0000f531cfb511f0ff
040000ef0a0000bf0a0000cf0a0000ff0a0000ef0a0000cf060000df0c00003031410000385bffff42c7ef7cf24c00800000ef9d0000bf4b0000df000000ff0a
0000ef0a0000bf0a0000df0c00001021e0ffff2700ffffa2ff109f2e6f00040000ff020000cf260000ef73000000800000ef0a0000bf0a0000df0c00001011f0
ffff33430000999910646666fffb0000ef0a0000df060000ef57000000040000ef0a0000bf0a0000ef730000100101ffffb170000027c70008cc9200130000ef
0a0000ff0200000002000000040000ff060000ef000000ff0800003051610000bed40000467def24b9cc00040000ef0a0000bf0a0000ef57000000040000ef0a
0000ef000000000200000011210000000000100000ef0a0000ef0a0000cf080000bf0a000000c8000000040000ef0a0000bf0a00000002000000d031ffff90ad
ffff9bca0014eedd00080000df320000ffda00001008000000040000cf080000bf0a000000c80000009041ffff000000000000ef040000ff0e0000ef0c000010
0c000020000000ff0e0000ef0c000010080000100c0000307181001000000000000020040000ff0e0000ef0c00002000000020040000ff0e0000ef0c00002004
0000200e00003091a1001000000000000020000000ff0e0000ef0c00001008000020000000ff0e0000ef0c000020000000200e000000617100000000ffff0000
2000000000080000ef000000200e000040000000ef000000df0c0000300800004000000030b1c100000000ffff000020060000df0c0000df0a00003008000040
000000df0a0000cf060000300400004000000030d1e100000000ffff00002004000000080000df0c0000200e000040000000df0c0000cf060000300400004000
00000091a10010000000000000200e0000ff0e0000ef0c000010080000200e000000080000cf060000200e0000400000000081b1001000000000000040080000
ff000000ef0800004000000040080000ff000000ef08000040080000400a000030021200000000ffff000020060000ef080000ef0000004000000040080000df
0a0000cf060000400000004004000030223200000000ffff000010080000ff000000ef08000040000000400a0000ef080000cf060000400000004008000000d1
e100100000000000004008000000080000ff000000400000004008000000000000ff08000040080000400a00003042520000000000100000ff000000ff000000
cf06000040000000400a000000080000ff00000040000000400a000000f102ffff000000000000bf06000020040000bf060000400a0000900e000000080000cf
06000040000000400a000010f11200100000000000004000000000080000cf060000100800004000000020040000bf06000040000000900e000000c122001000
00000000001008000000080000cf080000bf0a00001008000020040000bf06000010080000900e00000051320000000000000000000000000000000000000000
