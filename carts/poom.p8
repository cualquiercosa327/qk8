pico-8 cartridge // http://www.pico-8.com
version 27
__lua__

-- globals
_bsp,_verts=nil
_cam=nil
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
  __index=function(t,v)
    local m=t.m
    local x,z=v[1],v[2]
    local ax,ay,az=
      m[1]*x+m[3]*z+m[4],
      m[8],
      m[9]*x+m[11]*z+m[12]
    local a={ax,ay,az}
    t[v]=a
    return a
  end
}

function cam_to_screen(v)
  local w=128/v[3]
  return 64+v[1]*w,64-v[2]*w,w
end

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

function project(v)
  return 64+v[1]/32,64-v[2]/32
end

function draw_segs(segs)
  local v0=segs[#segs].v0
  local x0,y0=project(v0)
  for i=1,#segs do
    local x1,y1=project(segs[i].v0)
    line(x0,y0,x1,y1,7)
    x0,y0=x1,y1
  end
end

function draw_bsp(root)
  for _,node in pairs(root) do
    if node.flags&0x1>0 then
      draw_segs(node.front)
    end
    if node.flags&0x2>0 then
      draw_segs(node.back)
    end
  end
end

function find_sector(root,pos)
  -- go down (if possible)
  if v_dot(root.n,pos)>root.d then
    if root.front then
      return find_sector(root.front,pos)
    end
    -- leaf?
    return root.sidefront.sector
  elseif root.back then
    return find_sector(root.back,pos)
  -- dual face
  elseif root.dual then
    return root.sideback.sector
  end
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

_c=0
_yfloor,_yceil=nil
_znear=16

function cull_bsp(v_cache,root,pos)
  if(not root) return
  
  local is_front=v_dot(root.n,pos)>root.d
  local far,near
  if is_front then
    far,near=root.back,root.front
  else 
    far,near=root.front,root.back
  end

  cull_bsp(v_cache,near,pos)

  --[[
  if root.dual then
    if is_front then
      top=frontsector.floor/16
    else
      bottom=root.sideback.sector.ceil/16
    end
  end
  ]]
  if is_front or root.dual then
    local frontsector=root.sidefront.sector
    local top=frontsector.ceil
    local bottom=frontsector.floor
  
    -- clip
    local v0,v1=v_cache[root.v0],v_cache[root.v1]
    local z0,z1=v0[3],v1[3]
    if(z0>z1) v0,z0,v1,z1=v1,z1,v0,z0
    -- further tip behond camera plane
    if z1>_znear then
      if z0<_znear then
        -- clip?
        v0=v_lerp(v0,v1,(z0-_znear)/(z0-z1))
      end
    
      -- span rasterization
      local x0,y0,w0=cam_to_screen(v0)
      local x1,y1,w1=cam_to_screen(v1)
      if(x0>x1) x0,y0,w0,x1,y1,w1=x1,y1,w1,x0,y0,w0
      local dx=x1-x0
      local dy,dw=(y1-y0)/dx,(w1-w0)/dx
      if(x0<0) y0-=x0*dy w0-=x0*dw x0=0
      local cx=ceil(x0)
      y0+=(cx-x0)*dy
      w0+=(cx-x0)*dw

      if root.dual then
        frontsector=is_front and root.sidefront.sector or root.sideback.sector
        top=frontsector.ceil
        bottom=frontsector.floor
    
        local othersector=is_front and root.sideback.sector or root.sidefront.sector
        local othert,otherb=othersector.ceil,othersector.floor

        local id=frontsector.id%16
        local wall_c=sget(0,id)
        local ceil_c,floor_c=sget(1,id),sget(2,id)

        for x=cx,min(ceil(x1)-1,127) do
          local maxt,minb=_yceil[x],_yfloor[x]
          local t,b=max(y0-top*w0,maxt),min(y0-bottom*w0,minb)
          local ot,ob=max(y0-othert*w0,maxt),min(y0-otherb*w0,minb)
          
          if t>maxt then
            -- ceiling
            rectfill(x,maxt,x,t,ceil_c)
          end
          -- floor
          if b<minb then
            rectfill(x,minb,x,b,floor_c)
          end

          -- wall
          -- top wall side between current sector and back sector
          if t<ot then
            rectfill(x,t,x,ot,wall_c)
            -- new window top
            t=ot
          end
          -- bottom wall side between current sector and back sector     
          if b>ob then
            rectfill(x,ob,x,b,wall_c)
            -- new window bottom
            b=ob
          end
          
          _yceil[x],_yfloor[x]=t,b
          y0+=dy
          w0+=dw
        end
      else
        local id=frontsector.id%16
        local wall_c=sget(0,id)
        local ceil_c,floor_c=sget(1,id),sget(2,id)

        for x=cx,min(ceil(x1)-1,127) do
          local maxt,minb=_yceil[x],_yfloor[x]
          local t,b=max(y0-top*w0,maxt),min(y0-bottom*w0,minb)
          if t>maxt then
            -- ceiling
            rectfill(x,maxt,x,t,ceil_c)
          end
          -- floor
          if b<minb then
            rectfill(x,minb,x,b,floor_c)
          end

          -- wall
          if t<=b then
            rectfill(x,t,x,b,wall_c)
          end

          -- kill this row
          _yceil[x],_yfloor[x]=128,-1
          y0+=dy
          w0+=dw
        end
      end
    
    end
  end
  --print(_c,(x0+x1)/2,(y0+y1)/2,6)
  _c+=1
  cull_bsp(v_cache,far,pos)    
end

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

  --[[
  local s=find_sector(_bsp,plyr)
  if s then
    plyr.height=s.floor
  end
  _cam:track(plyr,plyr.angle,plyr.height+32)
  ]]
end

function _draw()
  cls()
  -- draw_bsp(bsp)
  _c=0
  _yceil,_yfloor=setmetatable({},top_cls),setmetatable({},bottom_cls)
  local v_cache=setmetatable({m=_cam.m},v_cache_cls)
  --cull_bsp(v_cache,_bsp,plyr)
  draw_bsp(_bsp)

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
  --[[
  local s=find_sector(_bsp,plyr)
  if s then
    print("sector: "..s.id,2,8,7)
  end
  ]]
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
    local v={unpack_fixed(),unpack_fixed()}
    printh("v: "..v[1]..","..v[2])
    add(verts,v)
  end)
  printh("verts:"..#verts)

  local lines={}
  unpack_array(function()
    local s,b=unpack_variant(),unpack_variant()
    printh(s.." / "..b)
    local line={
      sidefront=sides[s],
      sideback=sides[b],
      flags=mpeek()}
    add(lines,line)
  end)
  printh("lines:"..#lines)

  local nodes={}
  local function unpack_segs(segs)
    return function()
      local s=add(segs,{
        v0=verts[unpack_variant()],
        side=mpeek(),
        line=lines[unpack_variant()]    
      })
      assert(s.v0,"invalid seg")
    end
  end
  unpack_array(function()
    local node={
      n={unpack_fixed(),unpack_fixed()},
      d=unpack_fixed()}
    printh("node:"..node.n[1].."/"..node.n[2])
    local flags=mpeek()
    local child=nil
    if flags&0x1>0 then
      child={}
      unpack_array(unpack_segs(child))
      printh("front segs: "..#child)
    else
      child=nodes[unpack_variant()]
    end
    node.front=child
    -- back
    child={}
    if flags&0x2>0 then
      child={}
      unpack_array(unpack_segs(child))
      printh("back segs: "..#child)
    else
      child=nodes[unpack_variant()]
    end
    node.back=child
    node.flags=flags
    add(nodes,node)
  end)
  printh("nodes: "..#nodes)

  -- restore main cart
  reload()
  return nodes,verts
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
