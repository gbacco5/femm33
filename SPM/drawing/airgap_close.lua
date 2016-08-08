-- AIRGAP_CLOSE.lua -----------------------------------
-- This file finishes the drawing of the air-gap.
--
-- bg, 2016/08/07
-- ----------------------------------------------------

-- points update --------------------------------------
local r1x,r1y = rotate(gap.r1.x,gap.r1.y, rotor.rotation)
local r2x,r2y = rotate(gap.r2.x,gap.r2.y, rotor.rotation)

-- 1st arc
addarc(r1x,r1y, gap.s1.x,gap.s1.y,--...
  rotor.rest - rotor.rotation, mesh.gap)

-- 2nd arc
addarc(r2x,r2y, gap.s2.x,gap.s2.y,--...
  rotor.rest - rotor.rotation, mesh.gap)


-- add B.C. -------------------------------------------
selectarcsegment(r1x,r1y)
selectarcsegment(r2x,r2y)
setarcsegmentprop(mesh.gap,"Az_per5",0,0)
clearselected()