-- ROTOR.lua ++++++++++++++++++++++++++++++++++++++++++
-- This file start the drawing of the rotor.
--
-- bg, 2016/08/05
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++


-- load functions -------------------------------------
dofile(folder.tools .. "rotate.lua")


-- determine the diameter closer to the air-gap
if rotor.pos == -1 then -- conventional motor
  rotor.Dgap = rotor.De
  rotor.Dbound = rotor.Di
elseif rotor.pos == 1 then -- external motor
  rotor.Dgap = rotor.Di
  rotor.Dbound = rotor.De
end


-- if SPM (motor of interest) -------------------------
if rotor.tipo == 'SPM' then 
  dofile(folder.draw .. "SPM_rotor.lua")
end



-- if IPM ---------------------------------------------

-- if REL ---------------------------------------------

-- if PMAREL ------------------------------------------

-- if IM ----------------------------------------------

-- IF personalised ------------------------------------



-- repeat for the number of poles simulated -----------

selectgroup(rotor.group)
copyrotate(0,0, 180/rotor.p, sim.poles - 1)

if sim.poles ~= 2*stator.p then -- if simmetric sim

  -- add gap nodes
  gap.r1, gap.r2 = {},{}
  gap.r1.x, gap.r1.y = rotate(gap.Rr,0, -90/rotor.p)
  gap.r2.x, gap.r2.y = rotate(gap.r1.x,gap.r1.y, -- ...
    sim.poles*180/rotor.p)
  addnode(gap.r1.x, gap.r1.y)
  addnode(gap.r2.x, gap.r2.y)

    -- add stator closing
  back.r1,back.r2 = {},{}
  back.r1.x,back.r1.y = rotate(rotor.Dbound/2,0, -90/rotor.p)
  back.r2.x, back.r2.y = rotate(back.r1.x,back.r1.y, -- ...
     sim.poles*180/rotor.p)
  addnode(back.r1.x,back.r1.y)
  addnode(back.r2.x,back.r2.y)
  -- add lateral segments
  addsegment(gap.r1.x,gap.r1.y, back.r1.x,back.r1.y)
  addsegment(gap.r2.x,gap.r2.y, back.r2.x,back.r2.y)

  -- close rotor
  addarc(back.r1.x,back.r1.y, back.r2.x,back.r2.y, --...
    sim.poles*180/stator.p, 5)

  -- set B.C. -----------------------------------------
  -- 1st segment
  selectsegment(back.r1.x,back.r1.y)
  selectsegment(back.r2.x,back.r2.y)
  setsegmentprop("Az_per3",0,1,0,rotor.group)
  clearselected()
  
  -- 2nd segment
  selectsegment(gap.r1.x,gap.r1.y)
  selectsegment(gap.r2.x,gap.r2.y)
  setsegmentprop("Az_per4",0,1,0,rotor.group)
  clearselected()
  
  -- back
  selectarcsegment(rotor.Dbound/2,0)
  setarcsegmentprop(5,"Azero",0,rotor.group)
  clearselected()


elseif sim.poles == 2*rotor.p then -- if complete sim
  -- add rotor back-iron
  addnode( rotor.Dbound/2,0)
  addnode(-rotor.Dbound/2,0)
  addarc( rotor.Dbound/2,0,-rotor.Dbound/2,0,180,1)
  addarc(-rotor.Dbound/2,0, rotor.Dbound/2,0,180,1)

  -- add shaft "material"
  local shaft_block = {}
  shaft_block.x, shaft_block.y = (rotor.Dbound)/4, 0
  addblocklabel( shaft_block.x, shaft_block.y )
  selectlabel( shaft_block.x, shaft_block.y )
  setblockprop(shaft.material,1,0,"",0,rotor.group)
  clearselected()
  
  -- set B.C. -----------------------------------------
  selectarcsegment(0, rotor.Dbound/2)
  selectarcsegment(0,-rotor.Dbound/2)
  setarcsegmentprop(5,"Azero",0,rotor.group)
  clearselected()

end


-- magnet orientation adjustment --------------------
if rotor.magnet then -- if rotor has magnet

  if rotor.magnet.mgtz == 'parallel' then
    for mm = 2,sim.poles,2 do
      -- for even magnets, the 1st (d-axis) is a North
      local angle = (mm - 1)*180/rotor.p
      local mag_x,mag_y = rotate(rotor.Dgap/2,0, --...
        angle)

      selectlabel(mag_x, mag_y)
      setblockprop(rotor.magnet.material,--...
        1,0,"",angle+180,rotor.group)
      clearselected()
    end
  
  elseif rotor.magnet.mgtz == 'radial' then
    for mm = 2,sim.poles,2 do
      -- for even magnets, the 1st (d-axis) is a North
      local angle = (mm - 1)*180/rotor.p

      -- 1st magnet half
      for ns = 1,rotor.magnet.segments do
        local mag_x,mag_y = rotate(rotor.Dgap/2,0, --...
          angle - rotor.magnet.ang_e/rotor.p + sim.dth/2 + --....
          (ns-1)*sim.dth )
        local mag_dir

        if mag_x < 0 then
          mag_dir = atan(mag_y/mag_x)
        else
          mag_dir = atan(mag_y/mag_x) + 180
        end

        selectlabel(mag_x, mag_y)
        setblockprop(rotor.magnet.material,--...
          1,0,"", mag_dir, rotor.group)
        clearselected()
      end
      -- 2nd magnet half
      for ns = 1,rotor.magnet.segments do
        local mag_x,mag_y = rotate(rotor.Dgap/2,0, --...
          angle + rotor.magnet.ang_e/rotor.p - sim.dth/2 - --....
          (ns-1)*sim.dth )
        local mag_dir
        
        if mag_x < 0 then
          mag_dir = atan(mag_y/mag_x)
        else
          mag_dir = atan(mag_y/mag_x) + 180
        end

        selectlabel(mag_x, mag_y)
        setblockprop(rotor.magnet.material,--...
          1,0,"", mag_dir, rotor.group)
        clearselected()
      end
      -- center of the magnet
      local mag_x,mag_y = rotate(rotor.Dgap/2,0, --...
        angle)

      selectlabel(mag_x, mag_y)
      setblockprop(rotor.magnet.material,--...
        1,0,"",angle+180,rotor.group)
      clearselected()

    end

  end
end


-- add rotor material
local rot_block = {}
rot_block.x, rot_block.y = (rotor.De + rotor.Di)/4, 0
addblocklabel( rot_block.x, rot_block.y )
selectlabel( rot_block.x, rot_block.y )
setblockprop(rotor.material,1,0,"",0,rotor.group)
clearselected()

-- assign everything rotor to rotor group -------------
selectgroup(0) -- select all
setnodeprop("",rotor.group) -- set nodes in group
setblockprop("", 0, 0, "", 0, rotor.group) -- set blocks
setsegmentprop("", 0, 0, 0, rotor.group) -- set segments
setarcsegmentprop(5, "", 0, rotor.group)  -- set arcs
clearselected()