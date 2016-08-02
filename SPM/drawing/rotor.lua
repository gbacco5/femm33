-- ROTOR.lua ++++++++++++++++++++++++++++++++++++++++++
-- This file start the drawing of the rotor.
--
-- bg, 2016/08/01
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++


-- load functions -------------------------------------
dofile(folder.tools .. "rotate.lua")


-- if SPM (motor of interest) -------------------------
if rotor.tipo == 'SPM' then 
  dofile(folder.draw .. "SPM_rotor.lua")
end





-- if IPM ---------------------------------------------


-- if REL ---------------------------------------------


-- if PMAREL ------------------------------------------


-- if IM ----------------------------------------------


-- IF personalised ------------------------------------