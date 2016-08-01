-- STATOR.lua +++++++++++++++++++++++++++++++++++++++++
-- This file start the drawing of the stator.
--
-- bg @2016/07/30
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++

-- load functions -------------------------------------
dofile(folder.tools .. "rotate.lua")
dofile(folder.draw .. "fun_draw_slot.lua")

-- draw a single slot ---------------------------------
draw_slot(stator)

-- stator closing diameter ----------------------------
if stator.pos == 1 then -- conventional motor
  stator.Dclose = stator.De
elseif stator.pos == -1 then -- conventional motor
  stator.Dclose = stator.Di
end

-- copy slots -----------------------------------------
selectgroup(stator.group)
copyrotate(0,0,stator.alphas, -- ...
  sim.poles/2/stator.p*stator.winding.Q - 1)
clearselected()


if sim.poles ~= 2*stator.p then -- if simmetric sim
  -- select first arc
  selectarcsegment(rotate(gap.Rs,0, -stator.alphas/2))
  -- copy it at the end
  copyrotate(0,0,stator.alphas*2*stator.p*sim.poles, 1)
  -- add gap nodes
  gap.s1, gap.s2 = {},{}
  gap.s1.x, gap.s1.y = rotate(gap.Rs,0, -stator.alphas/2)
  gap.s2.x, gap.s2.y = rotate(gap.Rs,0, -- ...
    stator.alphas*(2*stator.p*sim.poles - 1/2) )
  addnode(gap.s1.x, gap.s1.y)
  addnode(gap.s2.x, gap.s2.y)
  
  -- add stator closing
  back = {}
  back.s1,back.s2 = {},{}
  back.s1.x,back.s1.y = rotate(stator.Dclose/2,0, -stator.alphas/2)
  back.s2.x, back.s2.y = rotate(stator.Dclose/2,0, -- ...
    stator.alphas*(2*stator.p*sim.poles - 1/2) )
  addnode(back.s1.x,back.s1.y)
  addnode(back.s2.x,back.s2.y)
  -- add lateral segments
  addsegment(gap.s1.x,gap.s1.y, back.s1.x,back.s1.y)
  addsegment(gap.s2.x,gap.s2.y, back.s2.x,back.s2.y)
  -- delete construction points
  selectnode(rotate(gap.Rs,0, -stator.alphas))
  selectnode(rotate(gap.Rs,0, --...
    stator.alphas*2*stator.p*sim.poles))
  deleteselectednodes()
  clearselected()
  -- close stator
  addarc(back.s1.x,back.s1.y, back.s2.x,back.s2.y, --...
    360*sim.poles/2/stator.p, 5)
  
  -- assign everything stator to stator group -----------
  selectgroup(0) -- select all
  setnodeprop("",stator.group) -- set nodes in group
  setblockprop("", 0, 0, "", 0, stator.group) -- set blocks
  setsegmentprop("", 0, 0, 0, stator.group) -- set segments
  setarcsegmentprop(1, "", 0, stator.group)  -- set arcs
  clearselected()
      
  -- set B.C. -----------------------------------------
  -- 1st segment
  selectsegment(back.s1.x,back.s1.y)
  selectsegment(back.s2.x,back.s2.y)
  setsegmentprop("Az_per1",0,1,0,stator.group)
  clearselected()
  
  -- 2nd segment
  selectsegment(gap.s1.x,gap.s1.y)
  selectsegment(gap.s2.x,gap.s2.y)
  setsegmentprop("Az_per2",0,1,0,stator.group)
  clearselected()
  
  -- back
  selectarcsegment(stator.Dclose/2,0)
  setarcsegmentprop(5,"Azero",0,stator.group)
  clearselected()

  

elseif sim.poles == 2*stator.p then -- if complete sim
  -- add stator back-iron
  addnode( stator.De/2,0)
  addnode(-stator.De/2,0)
  addarc( stator.De/2,0,-stator.De/2,0,180,1)
  addarc(-stator.De/2,0, stator.De/2,0,180,1)
  
  -- assign everything stator to stator group -----------
  selectgroup(0) -- select all
  setnodeprop("",stator.group) -- set nodes in group
  setblockprop("", 0, 0, "", 0, stator.group) -- set blocks
  setsegmentprop("", 0, 0, 0, stator.group) -- set segments
  setarcsegmentprop(1, "", 0, stator.group)  -- set arcs
  clearselected()
  
  -- set B.C. -----------------------------------------
  selectarcsegment(0, stator.Dclose/2)
  selectarcsegment(0,-stator.Dclose/2)
  setarcsegmentprop(5,"Azero",0,stator.group)
  clearselected()


end -- of if

-- END of file ++++++++++++++++++++++++++++++++++++++++