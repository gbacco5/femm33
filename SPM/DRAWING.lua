-- DRAWING.lua ****************************************
-- This file start the drawing of the motor.
--
-- bg @2016/07/29
-- ****************************************************

newdocument()

dofile("motor_data.lua")

dofile(folder.inp .. "input.lua")

dofile("materials_and_bc.lua")

dofile(folder.draw .. "stator.lua")

-- dofile(folder.draw .. "rotor.lua")

savefemmfile(filename .. ".fem")
