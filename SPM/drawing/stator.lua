-- STATOR.lua +++++++++++++++++++++++++++++++++++++++++
-- This file start the drawing of the stator.
--
-- bg @2016/07/29
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++

-- load function --------------------------------------
dofile(folder.tools .. "rotate.lua")
dofile(folder.draw .. "fun_draw_slot.lua")

-- draw a single slot ---------------------------------
draw_slot(stator)

-- copy slots -----------------------------------------
-- selectgroup(groupnumber)
-- copyrotate(0,0,alphas,Qs - 1)
-- clearselected()