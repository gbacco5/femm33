--*****************************************************
-- WAIT.LUA function ---------------------------------
-- This function makes the execution wait for n seconds
-- to let the CPU cool down. This is useful in long FOR
-- cycles and non linear problems.
-- bg @ 2015-04-06 ------------------------------------
--*****************************************************

function wait(n)
local t0 = clock()
while clock() < t0 + n do end
end
-- END ------------------------------------------------
--*****************************************************