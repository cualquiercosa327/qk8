pico-8 cartridge // http://www.pico-8.com
version 19
__lua__
-- textured 3d demo
-- by freds72

-- globals
local time_t,cam=0

-- helper functions
function lerp(a,b,t)
	return a*(1-t)+b*t
end

-- vector helpers
local v_up={0,1,0}

function make_v(a,b)
	return {
		b[1]-a[1],
		b[2]-a[2],
		b[3]-a[3]}
end
function v_clone(v)
	return {v[1],v[2],v[3]}
end
function v_dot(a,b)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
end
function v_scale(v,scale)
	v[1]*=scale
	v[2]*=scale
	v[3]*=scale
end
function v_add(v,dv,scale)
	scale=scale or 1
	return {
		v[1]+scale*dv[1],
		v[2]+scale*dv[2],
		v[3]+scale*dv[3]}
end
-- safe vector length
function v_len(v)
	local x,y,z=v[1],v[2],v[3]
	local d=max(max(abs(x),abs(y)),abs(z))
	if(d<0.001) return 0
	x/=d
	y/=d
	z/=d
	return d*(x*x+y*y+z*z)^0.5
end
function v_normz(v)
	local x,y,z=v[1],v[2],v[3]
	local d=x*x+y*y+z*z
	if d>0.001 then
		d=d^.5
		return {x/d,y/d,z/d}
	end
	return v
end

function v_lerp(a,b,t)
	return {
		lerp(a[1],b[1],t),
		lerp(a[2],b[2],t),
		lerp(a[3],b[3],t)
	}
end
function v_cross(a,b)
	local ax,ay,az=a[1],a[2],a[3]
	local bx,by,bz=b[1],b[2],b[3]
	return {ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx}
end

-- inline matrix invert
-- inc. position
function m_inv_x_v(m,v)
	local x,y,z=v[1]-m[13],v[2]-m[14],v[3]-m[15]
	return {m[1]*x+m[2]*y+m[3]*z,m[5]*x+m[6]*y+m[7]*z,m[9]*x+m[10]*y+m[11]*z}
end

-- returns foward vector from matrix
function m_fwd(m)
	return {m[9],m[10],m[11]}
end
-- returns up vector from matrix
function m_up(m)
	return {m[5],m[6],m[7]}
end
function m_x_v(m,v)
	local x,y,z=v[1],v[2],v[3]
	return {m[1]*x+m[5]*y+m[9]*z+m[13],m[2]*x+m[6]*y+m[10]*z+m[14],m[3]*x+m[7]*y+m[11]*z+m[15]}
end

function m_x_m(a,b)
	local a11,a12,a13,a21,a22,a23,a31,a32,a33=a[1],a[5],a[9],a[2],a[6],a[10],a[3],a[7],a[11]
	local b11,b12,b13,b14,b21,b22,b23,b24,b31,b32,b33,b34=b[1],b[5],b[9],b[13],b[2],b[6],b[10],b[14],b[3],b[7],b[11],b[15]

	return {
			a11*b11+a12*b21+a13*b31,a21*b11+a22*b21+a23*b31,a31*b11+a32*b21+a33*b31,0,
			a11*b12+a12*b22+a13*b32,a21*b12+a22*b22+a23*b32,a31*b12+a32*b22+a33*b32,0,
			a11*b13+a12*b23+a13*b33,a21*b13+a22*b23+a23*b33,a31*b13+a32*b23+a33*b33,0,
			a11*b14+a12*b24+a13*b34+a[13],a21*b14+a22*b24+a23*b34+a[14],a31*b14+a32*b24+a33*b34+a[15],1
		}
end

function make_m_from_euler(x,y,z)
	local a,b = cos(x),-sin(x)
	local c,d = cos(y),-sin(y)
	local e,f = cos(z),-sin(z)

	-- yxz order
	local ce,cf,de,df=c*e,c*f,d*e,d*f
 	return {
 		ce+df*b,a*f,cf*b-de,0,
  		de*b-cf,a*e,df+ce*b,0,
  		a*d,-b,a*c,0,
  		0,0,0,1}
end

function prepare_model(model)
	for _,f in pairs(model.f) do
		-- de-reference vertex indices
		for i=1,4 do
			f[i]=model.v[f[i]]
		end

		-- normal
		f.n=v_normz(
				v_cross(
					make_v(f[1],f[4]),
					make_v(f[1],f[2])))
		-- fast viz check
		f.cp=v_dot(f.n,f[1])
	end
	return model
end

-- models
local cube_model=prepare_model({
		v={
			{0,0,0},
			{1,0,0},
			{1,0,1},
			{0,0,1},
			{0,1,0},
			{1,1,0},
			{1,1,1},
			{0,1,1},
		},
		-- faces + vertex uv's + lightmap uv offsets
		f={
			--floor
			{1,4,3,2,uv={0,0,8,0,8,8,0,8},lu=0,lv=8},
			{6,5,1,2,uv={8,0,16,0,16,8,8,8},lu=0,lv=8},
			{5,8,4,1,uv={8,0,16,0,16,8,8,8},lu=8,lv=8}
		}
	})

function make_cam(x0,y0,focal)
	local yangle,zangle=0,0
	local dyangle,dzangle=0,0

	return {
		pos={0,0,0},
		control=function(self,dist)
			if(btn(0)) dyangle+=1
			if(btn(1)) dyangle-=1
			if(btn(2)) dzangle+=1
			if(btn(3)) dzangle-=1

			yangle+=dyangle/128
			zangle+=dzangle/128
			-- friction
			dyangle*=0.8
			dzangle*=0.8

			local m=make_m_from_euler(zangle,yangle,0)
			local pos=m_fwd(m)
			v_scale(pos,dist)

			-- inverse view matrix
			-- only invert orientation part
			m[2],m[5]=m[5],m[2]
			m[3],m[9]=m[9],m[3]
			m[7],m[10]=m[10],m[7]		

			self.m=m_x_m(m,{
				1,0,0,0,
				0,1,0,0,
				0,0,1,0,
				-pos[1],-pos[2],-pos[3],1
			})
			
			self.pos=pos
		end,
		project=function(self,verts)
			local out={}
			local n,f=0.1,1000
      for i,v in pairs(verts) do
				local x,y,z=v[1],v[2],v[3]
				--local ze=(z*f)
				local w=focal/z
				out[i]={x=x0+x*w,y=y0-y*w,w=w,u=v.u and v.u*w,v=v.v and v.v*w}
			end
			return out
		end
	}
end

function draw_model(model,m,cam)
	-- cam pos in object space
	local cam_pos=m_inv_x_v(m,cam.pos)
	
	-- object to world
	-- world to cam
	m=m_x_m(cam.m,m)

	for _,face in pairs(model.f) do
		-- is face visible?
		if v_dot(face.n,cam_pos)<=face.cp then
			local verts={}
			for k=1,4 do
				-- transform to world
				local p=m_x_v(m,face[k])
				-- attach u/v coords to output
				p.u=face.uv[2*k-1]
				p.v=face.uv[2*k]
				verts[k]=p
			end
			-- transform to camera & draw			
			polytex(cam:project(verts),face.lu,face.lv)
		end
	end
end

local _lava={}
local _palettes={}
-- textured edge renderer
local dither_pat={0b1111111111111111,0b0111111111111111,0b0111111111011111,0b0101111111011111,0b0101111101011111,0b0101101101011111,0b0101101101011110,0b0101101001011110,0b0101101001011010,0b0001101001011010,0b0001101001001010,0b0000101001001010,0b0000101000001010,0b0000001000001010,0b0000001000001000,0b0000000000000000}

function _init()
	-- fillp color mode
	poke(0x5f34, 1)

	for k,fp in pairs(dither_pat) do
		dither_pat[k]=fp>>16
	end
	--[[
	for i=1,15 do
		pal(i,128+i,1)
	end
	]]

	cam=make_cam(63.5,63.5,96.5)
	for y=0,15 do
		for x=0,15 do
			_lava[x|y<<4]=sget(8+x,y)
		end
	end

	-- read fade tables
	for x=0,5 do
		local p={}
		for y=0,15 do
			p[y]=sget(x+48,y)
		end
		_palettes[x]=p
	end

	--[[
	cls()
	local dither_pat={0b1111111111111111,0b0111111111111111,0b0111111111011111,0b0101111111011111,0b0101111101011111,0b0101101101011111,0b0101101101011110,0b0101101001011110,0b0101101001011010,0b0001101001011010,0b0001101001001010,0b0000101001001010,0b0000101000001010,0b0000001000001010,0b0000001000001000,0b0000000000000000}
	for x=0,15 do
		fillp(dither_pat[x+1])
		rectfill(8*x,0,8*x+7,7,7)
	end
	fillp()
	memcpy(0x0+32*64,0x6000,64*8)
	cstore()
	]]
end

local _parts={}

function _update()
	-- update texture

	--[[
	local t=time()/4
	local cx={
		[0]=sin(t+0/50)<<2,
		sin(t+1/50)<<2,
		sin(t+2/50)<<2,
		sin(t+3/50)<<2,
		sin(t+4/50)<<2,
		sin(t+5/50)<<2,
		sin(t+6/50)<<2,
		sin(t+7/50)<<2,
		sin(t+8/50)<<2,
		sin(t+9/50)<<2,
		sin(t+10/50)<<2,
		sin(t+11/50)<<2,
		sin(t+12/50)<<2,
		sin(t+13/50)<<2,
		sin(t+14/50)<<2,
		sin(t+15/50)<<2
	 }
	local tex=_lava
	for y=0,15 do
		local sy=sin(t+y/50)<<2
		for x=0,15 do
			sset(8+x,y,tex[
				((x+sy)&0xf)|
				((y+cx[x])&0xf)<<4])
		end
	end 
	]]

	-- restore lightmap
	-- reload()

	if rnd()>0.8 then
		add(_parts,{
			rnd(),0,rnd(),
			trail={},
			dy=(2+rnd())/30})
	end
	for p in all(_parts) do
		add(p.trail,{p[1]+(1-rnd(2))/32,p[2],p[3]+(1-rnd(2))/32})
		if #p.trail>10 then
			for i=2,11 do
				p.trail[i-1]=p.trail[i]
			end
			p.trail[11]=nil
		end
		p[2]+=p.dy
		-- gravity
		p.dy-=0.01
		
		if p[2]<0 then
			del(_parts,p)
		else
			-- update lightmap
			for _,f in pairs(cube_model.f) do
				local fp=make_v(f[1],p)
				local d=v_dot(f.n,fp)
				if d<0.2*0.2 then
					local u,v=8+8*fp[1],16-8*fp[2]
					--mset(u,v,79)
				end
			end

		end
	end

	cam:control(1.2)

	time_t+=1
end

function _draw()
	cls()

	local m={
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		-0.5,-0.5,-0.5,1}
	draw_model(cube_model,m,cam)

	-- draw parts
	local out={}
	-- object to world
	-- world to cam
	m=m_x_m(cam.m,m)
	for _,p in pairs(_parts) do
		add(out,m_x_v(m,p)).u=1
		for _,t in pairs(p.trail) do
			add(out,m_x_v(m,t))
		end
	end
	
	local verts=cam:project(out)
	for _,p in pairs(verts) do
		if p.u then
			circfill(p.x,p.y,-1.5*p.w/64,10)
			circfill(p.x,p.y,-p.w/64,8)
		else
			pset(p.x,p.y,10)
		end
	end

	rectfill(0,0,127,6,8)
	local cpu=tostr(flr(100*stat(1))).."%"
	print(cpu,128-#cpu*4,1,2)

	print("⬆️⬇️⬅️➡️:rotate/🅾️:tline mode",8,120,14)
end

-->8

function polytex(v,lu,lv)
	local p0,spans,dither_pat=v[#v],{},dither_pat
	local x0,y0,w0,u0,v0=p0.x,p0.y,p0.w,p0.u,p0.v
	for i=1,#v do
		local p1=v[i]
		local x1,y1,w1,u1,v1=p1.x,p1.y,p1.w,p1.u,p1.v
		local _x1,_y1,_u1,_v1,_w1=x1,y1,u1,v1,w1
		if(y0>y1) x0,y0,x1,y1,w0,w1,u0,v0,u1,v1=x1,y1,x0,y0,w1,w0,u1,v1,u0,v0
		local dy=y1-y0
		local dx,dw,du,dv=(x1-x0)/dy,(w1-w0)/dy,(u1-u0)/dy,(v1-v0)/dy
		if(y0<0) x0-=y0*dx u0-=y0*du v0-=y0*dv w0-=y0*dw y0=0
		local cy0=ceil(y0)
		-- sub-pix shift
		local sy=cy0-y0
		x0+=sy*dx
		u0+=sy*du
		v0+=sy*dv
		w0+=sy*dw
		for y=cy0,min(ceil(y1)-1,127) do
			local span=spans[y]
			if span then
				-- rectfill(x[1],y,x0,y,7)
				-- backup current edge values
				local a,aw,au,av,b,bw,bu,bv=span.x,span.w,span.u,span.v,x0,w0,u0,v0
				if(a>b) a,aw,au,av,b,bw,bu,bv=b,bw,bu,bv,a,aw,au,av
				local dab=b-a
				local daw,dau,dav=(bw-aw)/dab,(bu-au)/dab,(bv-av)/dab
				if(a<0) au-=a*dau av-=a*dav aw-=a*daw a=0
				local ca,cb=ceil(a),min(ceil(b)-1,127)
				-- sub-pix shift
				local sa=ca-a
				au+=sa*dau
				av+=sa*dav
				aw+=sa*daw
				local dw,du,dv=daw<<2,dau<<2,dav<<2
				for k=ca,cb-4,4 do
					-- pick lightmap array directly (saves lu+/lv+)
					rectfill(k,y,k+3,y,0x1087|(dither_pat[lu+au/aw|(lv+av/aw)>>16] or 0))
					ca+=4
					au+=du
					av+=dv
					aw+=dw
				end
				-- left over from stride rendering
				if ca<=cb then
					rectfill(ca,y,cb,y,0x1087|(dither_pat[lu+au/aw|(lv+av/aw)>>16] or 0))
				end
			else
				spans[y]={x=x0,w=w0,u=u0,v=v0}
			end
			x0+=dx
			u0+=du
			v0+=dv
			w0+=dw
		end
		x0,y0,w0,u0,v0=_x1,_y1,_w1,_u1,_v1
	end
	fillp()
end
__gfx__
00000000200882202202200200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000890000222000200000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002982022882282200000000000000000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000028202822898880000000000000000000000000035200000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002228882992220000000000000000000000000042100000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000220022299820000000000000000000000000051000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000220220000289820200000000000000000000000066510000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022900002228222200000000000000000000000077651000000000000000000000000000000000000000000000000000000000000000000000000000
00000000289900022022028200000000000000000000000088821000000000000000000000000000000000000000000000000000000000000000000000000000
00000000822222028288229800000000000000000000000092210000000000000000000000000000000000000000000000000000000000000000000000000000
000000000880288228200282000000000000000000000000a9421000000000000000000000000000000000000000000000000000000000000000000000000000
000000002820898008002998000000000000000000000000b3521000000000000000000000000000000000000000000000000000000000000000000000000000
000000008200088289288922000000000000000000000000ccc51000000000000000000000000000000000000000000000000000000000000000000000000000
000000008200222022002202000000000000000000000000dd510000000000000000000000000000000000000000000000000000000000000000000000000000
000000009222202222000228000000000000000000000000eee21000000000000000000000000000000000000000000000000000000000000000000000000000
000000002008802898202889000000000000000000000000f9421000000000000000000000000000000000000000000000000000000000000000000000000000
999999991d9944990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444144455440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444144454440000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444144444440000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444445144444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444455144444440000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222122222220000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1da94499d59999992008822022022002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
124455449d4444440008900002220002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12445444444444440029820228822822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12444444444544440282028228988800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12444444444454440022288829922200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12444444444544440002200222998200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12222222221122222202200002898202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110229000022282222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700070007000700070707070707070707070707070707070707070707070707077707770777077707777777777777777777777777777777777777777
00000000000000000000000000000000000000000700070007000700070707070707070707070707070707070707070707070707770777077707770777777777
00000000000000000070007000700070707070707070707070707070707070707070707070707070707770777077707777777777777777777777777777777777
00000000000000000000000000000000000000000000000000070007000700070707070707070707070707070707070707070707070707070777077777777777
00000000700070007000700070707070707070707070707070707070707070707070707077707770777077707777777777777777777777777777777777777777
00000000000000000000000000000000000000000700070007000700070707070707070707070707070707070707070707070707770777077707770777777777
00000000000000000070007000700070707070707070707070707070707070707070707070707070707770777077707777777777777777777777777777777777
00000000000000000000000000000000000000000000000000070007000700070707070707070707070707070707070707070707070707070777077777777777
04444494444442255555555155555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04494942244494455515555155551555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04449492294449425555555115555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52244494299442205555555155555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52824442242422255555555155555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54222544294288455555551155155555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52228222248282255555555115555155000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54222244242822201151111111111115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
59228222242222400555555555155515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54282222242282441555555555555511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52028822828222451555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54442222222829451555555551555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44445992244244451555555555555155000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54444442849444441555515555555115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54944444249494951551555555551115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05054554455454400111511011011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
87778877877887778888877787888777877887778878877787778777887787778878888888888888888888888888888888888888888888888888888888888888
87778787878787888878887887888878878787888788878787888787878887878887888888888888888888888888888888888888888888888888888888888888
87878787878787788888887887888878878787788788877787788778877787778887888888888888888888888888888888888888888888888888888888888888
87878787878787888878887887888878878787888788878887888787888787888887888888888888888888888888888888888888888888888888888888888888
87878778877787778888887887778777878787778878878887778787877887888878888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
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
00000000000000000000000000000000000000000000000000001111777700000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000071117777111177771111700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000777711117777177771111777711117777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001111711117777111177771111111117777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000011111777711117777177771111177771111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777771177111117777111117777117771111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777711111777711117111117777111117777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111711117777711111777711111111117777000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000011111777711111771117777711111777771111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000777117777711111777771111177111777771111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007777711111777117777711111777771111177111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000077777111111777771111177111777771111177777700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000111111711117777711111777777111117111177777700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000111117777711111111111777771111117777711111700000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111177777711111777777111171111117777711111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000077777111777111111777771111117777771777711111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000777777111117777777777771111117777711111177777100000000000000000000000000000000000000000000
00000000000000000000000000000000000007777771111117777771111177711177777711111177777700000000000000000000000000000000000000000000
00000000000000000000000000000000000001111111111177777711111177777711111711111177777700000000000000000000000000000000000000000000
00000000000000000000000000000000000001111111111117777711111177777711111177777717777700000000000000000000000000000000000000000000
00000000000000000000000000000000000000111111111111111111111777777111111177777711111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000111111111111111111111111117111111777777711111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000111111111111111111111111111111111177777711111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000011111111111111111111111111111111111111111111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000011111111111111111111111111111111111111111111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111111111111111111111111111111111111111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111111111111111111111111111111111111111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111111111111188888111111111111111111111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000111111111111111188888111111111111111111111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000111111111111111188888111111111111111111111000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000111111111119999988888111111111111111111110000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000011111111111999977777ff1111111111111111110000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000111111aa111999977777ffffff111111111111110000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001111111aaaa777997777fffff1111111111111100000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000111111aaaa777777777fffff1111111111111100000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000011111111aa77777777777777e111111111111100000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000011111111111bb77777777777eeeee11111111100000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000001111111111bbbb777777777eeeee11111111000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000001111111111bbbb77777dddd1eeee11111111000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000001111111111111c7777dddd1111111111111000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000001111111111111ccccc1ddd1111111111110000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000001111111111111ccccc11111111111111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111111111111111c11111111111111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000111111111111111111111111111110000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000001111111111111111111111100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000001111111111111111100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000011111111111100000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000111111000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000
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
000000000eeeee000eeeee000eeeee000eeeee000000eee00ee0eee0eee0eee0eee000e00eeeee000000eee0e000eee0ee00eee00000eee00ee0ee00eee00000
00000000eee0eee0ee000ee0eee00ee0ee00eee00e00e0e0e0e00e00e0e00e00e0000e00ee000ee00e000e00e0000e00e0e0e0000000eee0e0e0e0e0e0000000
00000000ee000ee0ee000ee0ee000ee0ee000ee00000ee00e0e00e00eee00e00ee000e00ee0e0ee000000e00e0000e00e0e0ee000000e0e0e0e0e0e0ee000000
00000000ee000ee0eee0eee0eee00ee0ee00eee00e00e0e0e0e00e00e0e00e00e0000e00ee000ee00e000e00e0000e00e0e0e0000000e0e0e0e0e0e0e0000000
000000000eeeee000eeeee000eeeee000eeeee000000e0e0ee000e00e0e00e00eee0e0000eeeee0000000e00eee0eee0e0e0eee00000e0e0ee00eee0eee00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0102010201020102202120212021202100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112111211121112303130313031303100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010201020102202120212021202100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112111211121112303130313031303100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010201020102202120212021202100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112111211121112303130313031303100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010201020102202120212021202100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112111211121112303130313031303100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f404040404040404040404040454040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f4040404040404040404040454a4540400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f404040404040404040404040454040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f404040404040404040404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f424242424242424242424242424242420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f484848484848484848484848484848480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
