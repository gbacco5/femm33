-- DRAWING.lua ****************************************
-- This file start the drawing of the motor.
--
-- bg, 2016/08/08
-- ****************************************************

newdocument()


-- load DATA ******************************************
dofile("motor_data.lua")

-- get the slot matrix --------------------------------
stator.winding.K, stator.winding.ADsfas = slot_matrix(
    stator.winding.m,
    stator.winding.Q,
    stator.p,
    stator.winding.yq,
    stator.winding.sequence,
    folder.inp)

-- load input data, e.g. from optimiser ---------------
-- In this file some data will be overwritten. It is
-- important that the necessary methods for updating
-- the correlated variables are implemented.
dofile(folder.inp .. "input.lua")

-- load materials, boundary conditions and mesh sizes -
dofile("materials_and_bc.lua")



-- actual DRAWING *************************************
dofile(folder.draw .. "stator.lua")

dofile(folder.draw .. "rotor.lua")

dofile(folder.draw .. "airgap.lua")


zoomnatural()

-- SAVE ***********************************************
savefemmfile(filename .. ".fem")