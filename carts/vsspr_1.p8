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
c6b5f7ffffffff66cc5c5505ffffff55665655bb0b5706657666656b557600657b67666b6607f0b77b7677776677f0706776f0ff7000ff07f0ffffff0ff0ff00
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff57ff
ffffffff575555ffffffffff656666ffffffffff557666ffffffffff556556ffffffff66550b77ffffffff5665ff00ffffffff7ff7ff00ffffffffffffff0fff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f0fffffffffffff6f0ffffffffffff565607ffffffffff566606ffffffffff5576f6ffffffffff666666f7f0ffffff6665660606ffffff6666666666ffffff66
66666666f0ffff6676776666f6ffff66066f666675ffff666666665755ffff666666667065f7ff66666666f660f6ffabda7766077fffffb7bbbb6bffffff7fff
ffffffffffff6fffffffffffff0070ffffffffffffff7fffffffffffffffbfffffffffffff0f7fffffffffffffff0fffffffffffffff66ffffffffffffbf66ff
ffffffffff6f66ffffffffffff6765ffffffffffff6756ffffffffffffbf66ffffffffffff7fbbffffffffffff7077ffffffffffff0f77ffffffffbb7bffff67
b7bbabbbbbf0ff6776b7b7b7bb7bff67667777b77bb77b6776707777f0700777067f7707ff0ff0bb0b7f77fbffffffb7fb7fb7f7ffffffb7f77fb7ffffffffb7
fb7f07ffffffff67f77f07ffffffff67f07f77f7ffffff67f00f67ffffffff66f0ffffffffffff77f0ffffffffffffffffffffffffffffffffffffffffff77ff
ffffffffffff70ffffffffffffff7fffffffffffffff7fffffffffffffff7fffffffffffffff0fffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f7fffffffffffffffffffffffffffff0ff7ff7ffffffff660756f6ffffffff667700ffffffffff76000f60ff66f6ff666066600f76ffff6666760f07f0ffff66
6677706666f7ff667677676666f6ff66000067666606ff76f00f77776766ff70ff0f00f06656f677ffff0f0070666676f0ffff000067076007f7fffffffff0ff
ffffffffffff0fffffffffffffff0fffffffffffffff5fffffffffff0fff0fffffffffffffff7fffffffffff0fff67ffffffffffffff66ffffffffffff7f66ff
ffffffffff6766ffffffffff0f7666ffffffffff7f6666ffffffffff7f6676ffffffffff776666ffffffffff7f6666ffffffffff0f7007ffffffff0ff000ff70
0777ff60f6ffff0077000077f0f7ff766700007606ffff676606606676f0ff766776676676ffff006676666677ffff777607606707ffff677607770700ffff77
070077f0ffffff70070f70ffffffff70770007ffffffff70070f77f0ffffff70077f77ffffffff6006ffffffffffff7007ffffffffffffffffffffffff0007ff
ffffffffff7000ffffffffffff0070ffffffffffff0f70ffffffffff0fff70ffffffffffffff70ffffffffffff0f0fffffffffffffff70ffffffffffffff0fff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffff0ffffffffffffffffffffffffffff6ff6ffffffff000760f5ffffffff00f00ff0ffffffff66f6ffffff0fffff66f60f00ff60f0ff66f00f67ff6ff6ff06
ff6f060fffffff00ff60f60ffffffff70f70f775fff0ff060f77f0667666f7f7ff00ff666666f6f0ff0f00660766f7ffff0f70770056f6ffff0f70ffffffffff
fffffffffffff6ffffffffffffffffffffffffffff0f06ffffffffffff6f76ffffffffffff6677ffffffffffff076fffffffffffffff6fffffffffffffff0fff
ffffffffff6666ffffffffff706665ffffffffff775665ffffffff7f776607ffffffff67767707ffffffff776676f7ffffffff707666f6ffffffff000066f6ff
ffff00f00f67f670fffffff06777f070f7ffffff66f0ff77f7fffff700ffff0700f7ff7600ffff0f66f7706676ffff0f6606706606ffff677670666606ffff66
0670676677ffff660700777707ffff76777777ffffffff770077f0ffffffff770777f0ffffffff70f0ffffffffffff70f0ffffffffffffffffffff0f00f076ff
ffffffffffff66ffffffffffff7f67fffffffffff07060ffffffff0f776777ffffffff0f706606ffffffff0f7066f0fffffffff0607667ffffffffff007077ff
ffffffffff7076ffffffffffff0f77ffffffffffffff0fffffffffffffff0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffff7ff067ffffffffff0ff060f7ffffffffffff00f7ffffffffffffffffff0ffffffffffff0ff66fffffffff0ffff67ffffff
ffff67f00fffffffffff70ffffffffff0070ff7fffffffff7f66ff6ff0ffffff7f770f6ff6ffffff0f70ff670766f6ffff6f0766066606ffff6f66ff6f0fffff
ffffffffffffffffffffffff60f7f7ffffffffff66f7ffffffffffff76f7ffffffffffff6666ffffffffffff6666ffffffffffff07f0ffffffffffffffffffff
ffffffff0706ffffffffff675506ffffffff0f6676f7ffffffff7f760700ffffffff6f7707ffffffff0f666666f0ffffff6f66067fffffffff7f66660066f6ff
ff7f66070056f6ffffff67f70f6706fffffffff77066f7f70ffffff66776fff760ff676606fffff06600676607ffff606677666607ffff667677666607ffff67
7777777707ffff07777777fffffffff7fffffffffffffff0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff070fffffff
ff0f77ff70fffffffffff0ff70ffffffffffffff70766fffffff0f00766770ffffff7066707070ffffff6776ff00f0ffffff6067066076ffffff0060666666ff
fffff00f677666ffffffffff707666ffffffffff0f7777fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0ffffffff
fffffffffffffffffffffffffffffffff7ffffffffffffff077ff6ffffffffffff0f76ffffffffffff0f77fffffffffffffffffffffffffffffffffffff0ffff
ff0fffff6ff6ffffffffff666ff6ffffffffff7700fffffffff0ffffffffffff0f06ffffffffffff0f66ffff0fffffffff77ffff6fffffffffff7fffffffffff
fffffffffff0ffffffffff7fffffffffffffff7fff0fffffffffff66f00fffffffffff66f0ffffffffffff6606ffffffffffff76f6ffffffffffff77f0ffffff
ffffffffffffffffffffffffff0fffffffffffffffffffffffffffff0f0fffffffffff6660f7ffffffff7f5576ffffffff0f677600f0ffffff0f66ff6f6706ff
ffff60f0576666ffffff6767656766f7ff707766666766f60f76776666660677667766667766f7666677677777f0ff66767777777707ff06000077ffffffff07
ffffffffffffff00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff07f0ffffff
ff607667f6ffffffff66767666f07fffff6766f0606760ffff7766f0607076ffff777707666766ffff706666667766ffff006600766667ffffff70ff7f7766ff
fffff0ff0f0077ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0fffffffff
ffffffffffffffffffffffffffffffff0bffffffffffffff007ff6ffffffffffff0f76ffffffffffff0f77f0ffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffff6ff6ffffffffff6f60f6ffffffffff0f60fffffffff0f7ff6fffffffff70f6ff5ff0ffff0f66f6676666f6f76f7677ffffffffff
fffffff70ffffffffffffff7ffffffffffffff06fff7ffffffff6f06fff0ffffffff6f66ffffffffffff6f77ffffffffffff6ff0ffffffffffff6fffffffffff
ffff0ffffff0fffffffffffffffffffffffffffff0fffffffffffff667ffffffffff6065f7ffffffff0f56f7f0ff7fffff676666767767ff6f66776666666677
76676676676666666677677777660666777777707776ff07007077ffffffff07ffffffffffffff07ffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff66766077ff
7f666666666766ff7f676667666766ff0f676670677666ff0f07000f776776fffff0ffff707777ffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0fffffffff
ffffffffffffffffffffffffffffffff07ffffffffffffff707ff6ffffffffffff0f76ffffffffffff0ff7ffffffffffffffffffffffffffffffffff7fffffff
ff0ff0ff6ff6fffffffff76f56f6ffffff60f6606666f7f77f7677666666767776776676676666666677677777660666767777707766f007707777ffffffffff
ffffffffffffffffffffffffffffffffffff7fff0fffffffffff7ff07ff0ffffffff76f0ffffffffffff66f6ffffffffffff66f7ffffffffffff66f7ffffffff
ffff6665f7f0ffffff0f56f7f7ff7fffff606666660767ff6f667766766077ff6f666666766766ff7f676667666766ff0f676660677666ff0f777770f0ffff07
f0ff0fffffffff76f0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0f776776ff
fff0ffff777777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0fffffff
ffffffffffffffffffffffffffffffff7ff0ffff77ffffff0f0776ff67ffffffff0f65ff67ffffffff6066606666f7f77f766766666676777677667667666666
6677677777660666767777707766f0070077777707ffff0700f070ffffffff66f0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffff7fff0fffffffffff606507f0ffffff0f56f7ffffffffff606666060767ff6f667766766077ff6f666666766766ff
7f676667666766ff0f676660677666ff0f77770f776776fffff0ff0f667777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff77fffffffffff6ff67ffffffff7ff5ff66f0ffffff6706576666f6f7607667666666667776676676676666666607677777660766777777707766f007
0077777707ffff0700ff00ffffffff66f0ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffff76ffffffffffff6675ffffffffff7f56f770f76fff0f666666767667ff6f667766766066ff7f666666666666ff0f676667667766ff0f676670777666ff
0f00000f776776fffff0ff0f667777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000