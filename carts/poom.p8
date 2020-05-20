pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

-- globals
_bsp,_verts=nil
_cam=nil
_znear=16
_yceil,_yfloor=nil
local k_far,k_near=0,2
local k_right,k_left=4,8

local plyr={0,0,height=0,angle=0,av=0,v=0}

function _init()
  _bsp,_verts=unpack_map()
  -- start pos
  --[[
  local s=find_sector(_bsp,plyr)
  assert(s,"invalid start position")
  plyr.sector=s
  plyr.height=s.floor
  ]]
  _cam=make_camera()
end

function make_camera()
  return {
    m={
      1,0,0,
      0,1,0},
    track=function(self,pos,angle,height)
      local ca,sa=cos(angle+0.25),-sin(angle+0.25)
      -- world to cam matrix
      self.m={
        ca,0,-sa,-ca*pos[1]+sa*pos[2],
        0, 1,0,-height,
        sa,0,ca,-sa*pos[1]-ca*pos[2]
      }
    end
  }
end

v_cache_cls={
  __index=function(t,seg)
    local m,v=t.m,seg.v0
    local x,z=v[1],v[2]
    local ax,ay,az=
      m[1]*x+m[3]*z+m[4],
      m[8],
      m[9]*x+m[11]*z+m[12]
    local outcode=k_near
    if(az>_znear) outcode=k_far
    if(ax>az) outcode+=k_right
    if(-ax>az) outcode+=k_left
    
    local a={ax,ay,az,outcode=outcode,clipcode=outcode&2,seg=seg,x=63.5+((ax/az)<<7),y=63.5-((ay/az)<<7),w=128/az}
    t[v]=a
    return a
  end
}

function v_dot(a,b)
  return a[1]*b[1]+a[2]*b[2]
end

function v_lerp(a,b,t)
  return {
    a[1]*(1-t)+t*b[1],
    a[2]*(1-t)+t*b[2],
    a[3]*(1-t)+t*b[3]
  }
end
function v2_normal(v)
  local d=max(abs(v[1]),abs(v[2]))
  local n=min(abs(v[1]),abs(v[2])) / d
  d*=sqrt(n*n + 1)
  return {v[1]/d,v[2]/d}
end

function cam_to_screen(v,yoffset)
  local w=128/v[3]
  return 64+v[1]*w,64-(v[2]+yoffset)*w,w
end

function cam_to_screen2d(v)
  local x,y=v[1]/32,v[3]/32
  return 64+x,64-y
end

function polyfill(v,offset,c)
  color(c)
  local v0,nodes=v[#v],{}
  local x0,y0,w0=v0.x,v0.y,v0.w
  y0-=offset*w0
  for i=1,#v do
    local v1=v[i]
    local x1,y1,w1=v1.x,v1.y,v1.w
    y1-=offset*w1
    local _x1,_y1=x1,y1
    if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
    local cy0,cy1,dx=y0\1+1,y1\1,(x1-x0)/(y1-y0)
    if(y0<0) x0-=y0*dx y0=0
    x0+=(-y0+cy0)*dx
    for y=cy0,min(cy1,127) do
      local x=nodes[y]
      if x then
        rectfill(x,y,x0,y)
      else
       nodes[y]=x0
      end
      x0+=dx					
    end			
    x0,y0=_x1,_y1
  end
end

function draw_segs2d(v_cache,segs)
  local verts,clipcode={},0

  for i=1,#segs do
    local s0=segs[i]
    local v0=add(verts,v_cache[s0])
    clipcode+=v0.clipcode
  end
  --if(clipcode!=0) verts=z_poly_clip(_znear,verts)
  if #verts>2 then
    local v0=verts[#verts]
    local x0,y0,w0=cam_to_screen2d(v0)
    for i=1,#verts do
      local v1=verts[i]
      local x1,y1,w1=cam_to_screen2d(v1)
      
      line(x0,y0,x1,y1,v0.seg.partner and 11 or 8)
      x0,y0=x1,y1
      v0=v1
    end
  end
end

function draw_sub_sector(segs,pos)
  if(not segs.v_cache) return
  -- 
  local ytop,ybottom=_yceil,_yfloor

  local sector=segs.sector
  local top,bottom=sector.ceil,sector.floor
  color((sector.id+2)%15+1)
  local v_cache=segs.v_cache
  local v0=v_cache[#v_cache]
  local z0=v0[3]

  for i=1,#v_cache do
    local seg=v0.seg
    local v1=v_cache[i]
    -- front facing?
    if v_dot(seg.n,pos)<seg.d then
      local ldef=seg.line
      -- span rasterization
      local x0,y0,w0=v0.x,v0.y,v0.w
      local x1,y1,w1=v1.x,v1.y,v1.w
      if(x0>x1) x0,y0,w0,x1,y1,w1=x1,y1,w1,x0,y0,w0
      local dx=x1-x0
      local dy,dw=(y1-y0)/dx,(w1-w0)/dx
      if(x0<0) y0-=x0*dy w0-=x0*dw x0=0
      local cx=ceil(x0)
      y0+=(cx-x0)*dy
      w0+=(cx-x0)*dw

      -- logical split or wall?
      if ldef then
        -- dual?
        color((sector.id+3)%15+1)

        local otherside=ldef.sides[not seg.side]
        if otherside then
          local otop,obottom=otherside.sector.ceil,otherside.sector.floor
          for x=cx,min(ceil(x1)-1,127) do
            local maxt,minb=ytop[x],ybottom[x]
            local t,b=max(y0-top*w0,maxt),min(y0-bottom*w0,minb)
            local ot,ob=max(y0-otop*w0,maxt),min(y0-obottom*w0,minb)

            -- wall
            -- top wall side between current sector and back sector
            if t<ot then
              rectfill(x,t,x,ot)
              -- new window top
              t=ot
            end
            -- bottom wall side between current sector and back sector     
            if b>ob then
              rectfill(x,ob,x,b)
              -- new window bottom
              b=ob
            end
            w0+=dw
            y0+=dy
            ytop[x],ybottom[x]=t,b
          end
        else
          for x=ceil(x0),min(ceil(x1)-1,128) do
            local t0,b0=max(ytop[x],y0-top*w0),min(ybottom[x],y0-bottom*w0)
            if(t0<b0) rectfill(x,t0,x,b0)
            w0+=dw
            y0+=dy
            ytop[x]=129
            ybottom[x]=-1
          end
        end
      end
    end
    v0=v1
  end
end
function draw_sub_sectors(node,pos)
  if(not node) return
  local side=v_dot(node.n,pos)<node.d
  if node.leaf[side] then
    draw_sub_sector(node.leaf[side],pos)
  else
    draw_sub_sectors(node.child[side],pos)
  end
  if node.leaf[not side] then
    draw_sub_sector(node.leaf[not side],pos)
  else
    draw_sub_sectors(node.child[not side],pos)
  end
end

-- ceil/floor rendering
function draw_flat(v_cache,segs)
  local verts,outcode,clipcode={},0xffff,0
  for i=1,#segs do
    local v0=v_cache[segs[i]]
    verts[i]=v0
    outcode&=v0.outcode
    clipcode+=v0.clipcode
  end
  -- out of screen
  if outcode==0 then
    if(clipcode!=0) verts=z_poly_clip(_znear,verts)
    if #verts>2 then
      -- keep verts for wall rendering
      segs.v_cache=verts
      local sector=segs.sector
      
      polyfill(verts,sector.floor,(sector.id+1)%15+1)--plyr.sector==segs.sector and rnd(15) or 1)
      polyfill(verts,sector.ceil,sector.id%15+1)--plyr.sector==segs.sector and rnd(15) or 1)
    end
  end
end
function draw_flats(v_cache,node,pos)
  if(not node) return
  local side=not (v_dot(node.n,pos)<node.d)
  if node.leaf[side] then
    draw_flat(v_cache,node.leaf[side])
  else
    draw_flats(v_cache,node.child[side],pos)
  end
  if node.leaf[not side] then
    draw_flat(v_cache,node.leaf[not side])
  else
    draw_flats(v_cache,node.child[not side],pos)
  end
end

function draw_bsp(v_cache,node)
  if(not node) return

  if node.leaf[true] then
    draw_segs2d(v_cache,node.leaf[true])
  else
    draw_bsp(v_cache,node.child[true])
  end
  if node.leaf[false] then
    draw_segs2d(v_cache,node.leaf[false])
  else
    draw_bsp(v_cache,node.child[false])
  end
end

function draw_portals(v_cache,root,pos)
  -- go down (if possible)
  local side=v_dot(root.n,pos)<root.d
  if root.child[side] then
    return draw_portals(v_cache,root.child[side],pos)
  end
  -- leaf?
  draw_segs(v_cache,root.leaf[side],0,128,{})
end

function draw_bsp2(node)
  if(not node) return
  -- split
  local p={node.d*node.n[1],node.d*node.n[2]}
  local p0={p[1]-512*node.n[2],p[2]+512*node.n[1]}
  local p1={p[1]+512*node.n[2],p[2]-512*node.n[1]}
  local x0,y0=project(p0)
  local x1,y1=project(p1)
  local side=v_dot(node.n,plyr)<node.d
  line(x0,y0,x1,y1,side and 11 or 8)

  if node.child[side] then
    return draw_bsp(node.child[side])
  end
  draw_segs(node.leaf[side],side and 3 or 2)
end

function find_sector(root,pos)
  -- go down (if possible)
  local side=v_dot(root.n,pos)<root.d
  if root.child[side] then
    return find_sector(root.child[side],pos)
  end
  -- leaf?
  return root.leaf[side].sector,root.leaf[side]
end

top_cls={
  __index=function(t,k)
    t[k]=0
    return 0
  end
}
bottom_cls={
  __index=function(t,k)
    t[k]=127
    return 127
  end
}

function _update()
  local da,dv=0,0
  if(btn(0)) da-=1
  if(btn(1)) da+=1
  if(btn(2)) dv+=1
  if(btn(3)) dv-=1
  plyr.av+=da/128
  plyr.angle+=plyr.av
  plyr.v+=dv*4
  local ca,sa=cos(plyr.angle),sin(plyr.angle)
  plyr[1]+=plyr.v*ca
  plyr[2]+=plyr.v*sa
  -- damping
  plyr.v*=0.8
  plyr.av*=0.8

  local s=find_sector(_bsp,plyr)
  if s then
    plyr.sector=s
    plyr.height=s.floor
  end
  _cam:track(plyr,plyr.angle,plyr.height+32)
end

function _draw()
  cls()
  -- draw_bsp(bsp)
  _yceil,_yfloor=setmetatable({},top_cls),setmetatable({},bottom_cls)
  local v_cache=setmetatable({m=_cam.m},v_cache_cls)
  -- cull_bsp(v_cache,_bsp,plyr)
  -- draw_portals(v_cache,_bsp,plyr)
  -- draw_bsp(v_cache,_bsp)
  draw_flats(v_cache,_bsp,plyr)
  draw_sub_sectors(_bsp,plyr)
  -- pset(64,64,8)

  --[[
  local x0,y0=project(plyr)
  local ca,sa=cos(plyr.angle),sin(plyr.angle)
  local x1,y1=project({plyr[1]+2*ca,plyr[2]+2*sa})
  line(x0,y0,x1,y1,2)
  pset(x0,y0,8)
  ]]
  --[[
  for x,zb in pairs(_zbuffer) do
    rectfill(x,zb.b,x,0,6)
    rectfill(x,zb.t,x,127,5)
  end
  ]]
  print(stat(1),2,2,7)
  local s,segs=find_sector(_bsp,plyr)
  if s then
    print("sector: "..s.id,2,8,7)
  end
end

-->8
-- 3d functions
function z_poly_clip(znear,v)
	local res,v0={},v[#v]
	local d0=v0[3]-znear
	for i=1,#v do
		local v1=v[i]
		local d1=v1[3]-znear
		if d1>0 then
			if d0<=0 then
        local nv=v_lerp(v0,v1,d0/(d0-d1))
				local z=nv[3]
				nv.x=63.5+((nv[1]/z)<<7)
				nv.y=63.5-((nv[2]/z)<<7)
				nv.w=128/z        
        nv.seg=v0.seg
        
				res[#res+1]=nv
			end
			res[#res+1]=v1
		elseif d0>0 then
			local nv=v_lerp(v0,v1,d0/(d0-d1)) 
      local z=nv[3]
      nv.x=63.5+((nv[1]/z)<<7)
      nv.y=63.5-((nv[2]/z)<<7)
      nv.w=128/z        
      nv.seg=v0.seg
		  res[#res+1]=nv
		end
		v0,d0=v1,d1
	end
	return res
end

-->8
-- unpack map
local cart_id,mem
local cart_progress=0
function mpeek()
	if mem==0x4300 then
		cart_progress=0
    cart_id+=1
		reload(0,0,0x4300,"poom_"..cart_id..".p8")
		mem=0
	end
	local v=peek(mem)
	if mem%779==0 then
		cart_progress+=1
		rectfill(0,120,shl(cart_progress,4),127,cart_id%2==0 and 1 or 7)
		flip()
  end
	mem+=1
	return v
end

-- w: number of bytes (1 or 2)
function unpack_int(w)
  w=w or 1
	local i=w==1 and mpeek() or mpeek()<<8|mpeek()
	return i
end
-- unpack 1 or 2 bytes
function unpack_variant()
	local h=mpeek()
	-- above 127?
  if h&0x80>0 then
    local hl=mpeek()
    h=(h&0x7f)<<8|hl
  end
	return h
end
-- unpack a fixed 16:16 value
function unpack_fixed()
	return mpeek()<<8|mpeek()|mpeek()>>8|mpeek()>>16
end

-- unpack an array of bytes
function unpack_array(fn)
	local n=unpack_variant()
	for i=1,n do
		fn(i)
	end
end

function unpack_map()
  -- jump to data cart
  cart_id,mem=0,0
  reload(0,0,0x4300,"poom_"..cart_id..".p8")
  
  -- sectors
  local sectors={}
  unpack_array(function(i)
    add(sectors,{id=i,ceil=unpack_int(2),floor=unpack_int(2)})
  end)
  local sides={}
  unpack_array(function()
    add(sides,{sector=sectors[unpack_variant()]})
  end)

  local verts={}
  unpack_array(function()
    add(verts,{unpack_fixed(),unpack_fixed()})
  end)

  local lines={}
  unpack_array(function()
    local line={
      sides={
        [true]=sides[unpack_variant()],
        [false]=sides[unpack_variant()]
      },
      flags=mpeek()}
    add(lines,line)
  end)

  local sub_sectors,all_segs={},{}
  unpack_array(function()
    local segs={}
    unpack_array(function()
      local s=add(segs,{
        -- debug
        v0=verts[unpack_variant()],
        side=mpeek()==0,
        line=lines[unpack_variant()],
        partner=unpack_variant()
      })
      -- direct link to sector (if not already set)
      if s.line and not segs.sector then
        segs.sector=s.line.sides[s.side].sector
      end
      assert(s.v0,"invalid seg")
      assert(segs.sector,"missing sector")
      add(all_segs,s)
    end)
    -- normals
    local s0=segs[#segs]
    local v0=s0.v0
    for i=1,#segs do
      local s1=segs[i]
      local v1=s1.v0
      local n=v2_normal({v1[1]-v0[1],v1[2]-v0[2]})
      n={-n[2],n[1]}
      s0.n,s0.d=n,v_dot(n,v0)
      v0,s0=v1,s1
    end

    add(sub_sectors,segs)
  end)
  -- fix seg -> sub-sector link (e.g. portals)
  for _,seg in pairs(all_segs) do
    seg.partner=sub_sectors[seg.partner]
  end

  local nodes={}
  unpack_array(function()
    local node={
      n={unpack_fixed(),unpack_fixed()},
      d=unpack_fixed()}
    local flags=mpeek()
    local child,leaf={},{}
    if flags&0x1>0 then
      leaf[true]=sub_sectors[unpack_variant()]
    else
      child[true]=nodes[unpack_variant()]
    end
    -- back
    if flags&0x2>0 then
      leaf[false]=sub_sectors[unpack_variant()]
    else
      child[false]=nodes[unpack_variant()]
    end
    node.child=child
    node.leaf=leaf
    add(nodes,node)
  end)

  -- restore main cart
  reload()
  return nodes[#nodes],verts
end

__gfx__
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
41600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
