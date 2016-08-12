-- DRAWING.lua ****************************************
-- This file start the drawing of the motor.
--
-- bg, 2016/08/01
-- ****************************************************

iDraw = 1

while iDraw == 1 do

newdocument()

-- load DATA ******************************************
dofile("motor_data.lua")

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


zoomnatural()

wait(10)

end

-- SAVE ***********************************************
savefemmfile(filename .. ".fem")