pico-8 cartridge // http://www.pico-8.com
version 23
__lua__

bsp={v0={6,6},v1={6,5},n={1.0,0.0},d=6.0,front={v0={20,-10},v1={30,0},n={-0.707,0.707},d=-21.213,front={v0={16,5},v1={15,5},n={0.0,-1.0},d=-5.0,front={v0={30,0},v1={30.0,5.0},n={-1.0,0.0},d=-30.0,front={v0={6.0,-3.75},v1={16,-10},n={0.53,0.848},d=0.0,front=nil,back={v0={16,-10},v1={16.0,-14.0},n={1.0,0.0},d=16.0,front=nil,back=nil}},back=nil},back={v0={15,5},v1={15,6},n={-1.0,0.0},d=-15.0,front={v0={15.0,15.0},v1={6.0,15.0},n={-0.0,-1.0},d=-15.0,front=nil,back=nil},back={v0={30,15},v1={15.0,15.0},n={-0.0,-1.0},d=-15.0,front={v0={30.0,5.0},v1={30,15},n={-1.0,-0.0},d=-30.0,front={v0={15,6},v1={16,6},n={0.0,1.0},d=6.0,front=nil,back={v0={16,6},v1={16,5},n={1.0,0.0},d=16.0,front=nil,back=nil}},back=nil},back=nil}}},back={v0={16,-30},v1={20,-30},n={0.0,1.0},d=-30.0,front={v0={20,-30},v1={20,-10},n={-1.0,0.0},d=-20.0,front={v0={16.0,-14.0},v1={16,-30},n={1.0,0.0},d=16.0,front=nil,back=nil},back=nil},back=nil}},back={v0={0,0},v1={6.0,-3.75},n={0.53,0.848},d=0.0,front={v0={4,15},v1={4,10},n={1.0,0.0},d=4.0,front={v0={6.0,15.0},v1={4,15},n={-0.0,-1.0},d=-15.0,front={v0={5,5},v1={5,6},n={-1.0,0.0},d=-5.0,front=nil,back={v0={5,6},v1={6,6},n={0.0,1.0},d=6.0,front=nil,back={v0={6,5},v1={5,5},n={0.0,-1.0},d=-5.0,front=nil,back=nil}}},back=nil},back={v0={4,10},v1={0,10},n={0.0,-1.0},d=-10.0,front={v0={0,10},v1={0,0},n={1.0,0.0},d=0.0,front=nil,back=nil},back=nil}},back=nil}}

local plyr={0,0,angle=0,av=0,v=0}

function world_to_cam(v)
  -- translate
  local x,y,z=v[1]-plyr[1],-5,v[2]-plyr[2]
  -- rotation
  local ca,sa=cos(plyr.angle+0.25),-sin(plyr.angle+0.25)
  x,z=x*ca-z*sa,x*sa+z*ca
  return {x,y,z}
end

function cam_to_screen(v)
  local w=64/v[3]
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

function draw_bsp(root)
  if(not root) return
  local x0,y0=project(root.v0)
  local x1,y1=project(root.v1)
  line(x0,y0,x1,y1,1)
  draw_bsp(root.front)
  draw_bsp(root.back)
end

_c=0
function cull_bsp(root,pos)
  if(not root) return
  
  local is_front=v_dot(root.n,pos)>root.d
  local far,near
  if is_front then
    far,near=root.back,root.front
  else 
    far,near=root.front,root.back
  end

  cull_bsp(far,pos)
  if is_front then
    -- clip
    local v0,v1=world_to_cam(root.v0),world_to_cam(root.v1)
    local z0,z1=v0[3],v1[3]
    if(z0>z1) v0,z0,v1,z1=v1,z1,v0,z0
    -- further tip behond camera plane
    if z1>0.25 then
      if z0<0.25 then
        -- clip?
        v0=v_lerp(v0,v1,(z0-0.25)/(z0-z1))
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
      color(_c%15+1)
      for x=cx,min(ceil(x1)-1,127) do
        if w0>0 then
          rectfill(x,y0,x,y0-8*w0)
        end
        y0+=dy
        w0+=dw
      end
    end
  end
  --print(_c,(x0+x1)/2,(y0+y1)/2,6)
  _c+=1
  cull_bsp(near,pos)    
end

function _update()
  local da,dv=0,0
  if(btn(0)) da-=1
  if(btn(1)) da+=1
  if(btn(2)) dv+=1
  if(btn(3)) dv-=1
  plyr.av+=da/128
  plyr.angle+=plyr.av
  plyr.v+=dv/8
  local ca,sa=cos(plyr.angle),sin(plyr.angle)
  plyr[1]+=plyr.v*ca
  plyr[2]+=plyr.v*sa
  -- damping
  plyr.v*=0.8
  plyr.av*=0.8
end

function _draw()
  cls()
  -- draw_bsp(bsp)
  _c=0
  cull_bsp(bsp,plyr)
  --[[
  local x0,y0=project(plyr)
  local ca,sa=cos(plyr.angle),sin(plyr.angle)
  local x1,y1=project({plyr[1]+2*ca,plyr[2]+2*sa})
  line(x0,y0,x1,y1,2)
  pset(x0,y0,8)
  ]]

end
