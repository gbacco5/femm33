-- SPM_rotor.lua --------------------------------------
-- This script draws all the possible SPM rotor
-- configuration.
--
-- REQUIREMENTS:
--   . The function 'rotate.lua' has already to be loaded
--
-- bg, 2016/08/05
-- ----------------------------------------------------


-- if rotor.magnet.mgtz == 'parallel' then -- easy one
local x,y = {},{}

if rotor.magnet.shape == 'rect' then
  x[1],y[1] = rotate(0,rotor.Dgap/2,-90/rotor.p)
  x[2],y[2] = rotate(0,rotor.Dgap/2,-rotor.magnet.ang_e/rotor.p)
  x[3],y[3] = x[2],y[2] + rotor.magnet.h

elseif rotor.magnet.shape == 'trapz' then
  x[1],y[1] = rotate(0,rotor.Dgap/2,-90/rotor.p)
  x[2],y[2] = rotate(0,rotor.Dgap/2,-rotor.magnet.ang_e/rotor.p)
  x[3],y[3] = rotate(0,rotor.Dgap/2 - rotor.pos*rotor.magnet.h,--...
    -rotor.magnet.ang_e/rotor.p)

end

for i = 1,3 do
  addnode(x[i],y[i])
  -- selectnode(x[i],y[i])
end
addsegment(x[2],y[2], x[3],y[3])

if rotor.magnet.mgtz == 'radial' then
  rotor.magnet.comp_segments(rotor,sim)

  selectsegment(x[3],y[3])
  copyrotate(0,0, sim.dth, rotor.magnet.segments)
  clearselected()

  for ns = 1,rotor.magnet.segments do

    local mag_block = {}
    mag_block.x, mag_block.y = rotate( (x[2]+x[3])/2, (y[2]+y[3])/2,--...
     (ns - 1)*sim.dth + sim.dth/2 )
    addblocklabel( mag_block.x, mag_block.y )
    selectlabel( mag_block.x, mag_block.y )
    setblockprop( rotor.magnet.material,--...
      0,mesh.pm,"", atan(mag_block.y/mag_block.x) ,rotor.group )
    clearselected()
    
  end
end


selectgroup(0)
selectgroup(rotor.group)
setsegmentprop("", 0, 0, 1, rotor.group) -- set segments
mirror(0,0, 0,1)
clearselected()

addarc(x[1],y[1], -x[1],y[1], 180/rotor.p,rotor.arcangle)
addarc(x[3],y[3], -x[3],y[3], --...
  2*rotor.magnet.ang_e/rotor.p,rotor.arcangle)


-- add central block property
rotor.magnet.x, rotor.magnet.y = 0, rotor.Dgap/2 - rotor.pos*rotor.magnet.h/2
addblocklabel( rotor.magnet.x, rotor.magnet.y )
selectlabel( rotor.magnet.x, rotor.magnet.y )
setblockprop( rotor.magnet.material,--...
  0,mesh.pm,"",90,rotor.group )
clearselected()

-- show magnet external segments
selectsegment(x[3],y[3])
selectsegment(-x[3],y[3])
setsegmentprop("", 0, 0, 0, rotor.group) -- set segments
clearselected()

selectgroup(0) -- select all
setnodeprop("",rotor.group) -- set nodes in the samee group
setblockprop("", 0, 0, "", 0, rotor.group) -- set blocks
setsegmentprop("", 0, 0, 0, rotor.group) -- set segments
setarcsegmentprop(rotor.arcangle, "", 0, rotor.group)  -- set arcs

clearselected()

-- bring the rotor (d-axis) along the x-axis ----------
selectgroup(rotor.group)
moverotate(0,0,-90)
clearselected()

rotor.magnet.x, rotor.magnet.y = --...
  rotate(rotor.magnet.x, rotor.magnet.y, -90)