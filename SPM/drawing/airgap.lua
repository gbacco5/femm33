-- AIRGAP.lua +++++++++++++++++++++++++++++++++++++++++
-- This file start the drawing of the air-gap.
--
-- bg, 2016/08/07
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++

-- assign material ------------------------------------
if gap.division == 1 then
  addblocklabel(stator.Dgap/2 - stator.pos*g/8,0)
  selectlabel(stator.Dgap/2 - stator.pos*g/8,0)
  setblockprop(gap.material, 0, mesh.gap, "", 0, gap.group)
  clearselected()

  -- the closing of the air-gap will be done inside the
  -- simulation file. ONLY for sim.partial.

end
