-- SPM_rotor.lua --------------------------------------
-- This script draws all the possible SPM rotor
-- configuration.
--
-- REQUIREMENTS:
--   . The function 'rotate.lua' has already to be loaded
--
-- bg, 2016/08/01
-- ----------------------------------------------------


if rotor.magnet.mgtz == 'parallel' then -- easy one
local x,y = {},{}

  if rotor.magnet.shape == 'rect' then
    x[1],y[1] = rotate(0,rotor.Dgap/2,-90/rotor.p)
    x[2],y[2] = rotate(0,rotor.Dgap/2,-rotor.magnet.ang_e/rotor.p)
    x[3],y[3] = x[2],y[2] + rotor.magnet.h

    for i = 1,3 do
      addnode(x[i],y[i])
      selectnode(x[i],y[i])
    end
    mirror(0,0, 0,1)
    addsegment(x[2],y[2], x[3],y[3])
    addsegment(-x[2],y[2], -x[3],y[3])
    addarc(x[1],y[1], -x[1],y[1], 180/rotor.p,rotor.arcangle)
    addarc(x[3],y[3], -x[3],y[3], --...
      2*rotor.magnet.ang_e/rotor.p,rotor.arcangle)

    local mag_block = {}
    mag_block.x, mag_block.y = 0, rotor.Dgap/2 - rotor.pos*rotor.magnet.h/2
    addblocklabel( mag_block.x, mag_block.y )
    selectlabel( mag_block.x, mag_block.y )
    setblockprop("Magnet",1,0,"",90,rotor.group)
    clearselected()

  end

elseif rotor.magnet.mgtz == 'radial' then

end


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
