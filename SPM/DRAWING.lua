-- DRAWING.lua ****************************************
-- This file start the drawing of the motor.
--
-- bg @2016/07/29
-- ****************************************************

dofile("motor_data.lua")

-- dofile(folder.input .. "input.lua")

dofile("materials.lua")

dofile(folder.draw .. "stator.lua")

-- dofile(folder.draw .. "rotor.lua")

savefemmfile(filename .. ".fem")