-- FUN_DRAW_SLOT.lua ..................................
-- This function creates a slot and position it along
-- the x-axis. It is general for both the stator and
-- the rotor. The selection is made through the 
-- variable 'selector', where
--   - 1 corresponds to the stator while
--   - 2 corresponds to the rotor
-- Notice that it is assumed the stator to be outside.
-- If you want the opposite behavior, just switch the
-- selector number in the function call.
--
-- REQUIREMENTS:
--   . The function 'rotate.lua' has already to be loaded
--
-- INPUT:
--   . lp --> lamination part, either stator or rotor
--
-- OUTPUT: none
-- 
-- FUTURE IMPROVEMENTS:
--   . This function deals only with round-shaped slots
--     so it is not general. In the future it will be 
--     general and it will permit the selection of the 
--     slot type through the variable 'shape'.
--
-- bg @2016/05/10
-- ....................................................


function draw_slot(lp)

-- half slot drawing
--
--    ---------------4
--               	  /
--              	 /
--    	       	  /
--    	      	 /
--          	  /
--         	   /
--         	  /
--         	 /
--    	  	3
--        	|
--    	  	|
--				 /
--    	  /
--       /
--       2
--       |
--       |
--       1

-- initialization -------------------------------------
x = {}
y = {}
-- lp.slot.shape = 'default'
if lp.pos == 1 then
	D = lp.Di 
elseif lp.pos == -1 then
	D = lp.De
end
lp:comp_ws_wse()
lp:comp_alphas()

-- points computation ---------------------------------
x[1] = lp.slot.wso/2
y[1] = D/2

x[2] = x[1]
y[2] = y[1] + lp.pos*lp.slot.hso

x[3] = lp.slot.ws/2
y[3] = y[2] + lp.pos*lp.slot.hwed

x[4] = lp.slot.wse/2

if lp.slot.shape == "round" or lp.slot.shape == "semiround" then
	-- thus if inner (in the iron) slot top is round
	y[4] = D/2 + lp.pos*lp.slot.hs - lp.pos*lp.slot.wse/2
else
	y[4] = D/2 + lp.pos*lp.slot.hs
end

for k = 1,4 do
	addnode(x[k],y[k])
end -- of for
addsegment(x[1],y[1],x[2],y[2])
addsegment(x[3],y[3],x[4],y[4])

clearselected()

-- add wedge ------------------------------------------

if lp.slot.shape == "round"
or lp.slot.shape == "roundsemi"
or lp.slot.shape == "roundarc" then

	if lp.pos == 1 then 
		addarc(x[2],y[2],x[3],y[3], atan(lp.winding.Q/PI)/2,1)
	elseif lp.pos == -1 then
		addarc(x[3],y[3],x[2],y[2], atan(lp.winding.Q/PI)/2,1)
	end -- of if selector

elseif lp.slot.shape == "semiround"
		or lp.slot.shape == "square"
		or lp.slot.shape == "semiarc" then
	addsegment(x[2],y[2],x[3],y[3])

else
	addsegment(x[2],y[2],x[3],y[3])
end -- of if lp.slot.shape
	


-- half slot mirroring --------------------------------
selectgroup(0) -- select all
mirror(0,0,0,1) -- mirror along y axix

-- close slot top -------------------------------------
if lp.slot.shape == "round"
or lp.slot.shape == "semiround" then

	addarc(lp.pos*x[4],y[4],-lp.pos*x[4],y[4],180,1)
	clearselected()

elseif lp.slot.shape == "squared"
or lp.slot.shape == "roundsemi" then

	addsegment(x[4],y[4], -x[4],y[4])

elseif lp.slot.shape == 'semiarc'
		or lp.slot.shape == "roundarc" then

	addnode(rotate(x[4],y[4],360/lp.winding.Q))
	addsegment(x[4],y[4], rotate(x[4],y[4],lp.alphas))
	selectarcsegment(rotate(x[4],y[4],lp.alphas/2))
	deleteselectedarcsegments()

else
	addsegment(x[4],y[4], -x[4],y[4])
end -- of if lp.slot.shape


-- close copper in slot -------------------------------
addsegment(x[2],y[2],-x[2],y[2])


-- close tooth head -----------------------------------
xT, yT = rotate(-x[1],y[1],-lp.alphas)
addnode(xT,yT)
addarc(xT,yT,-x[1],y[1],lp.alphas,1)
selectarcsegment(xT,yT)
setarcsegmentprop(1, "", 0, lp.group)  -- set arcs
clearselected()

-- insert slot materials ------------------------------
addblocklabel(0,D/2 + lp.pos*lp.slot.hs/2)
addblocklabel(0,D/2 + lp.pos*lp.slot.hso/2)
selectlabel(0,D/2 + lp.pos*lp.slot.hso/2)
setblockprop("Air",1,0,"",0,lp.group)
clearselected()

selectgroup(0) -- select all
setnodeprop("",lp.group) -- set nodes in the samee group
setblockprop("", 0, 0, "", 0, lp.group) -- set blocks
setsegmentprop("", 0, 0, 0, lp.group) -- set segments
setarcsegmentprop(20, "", 0, lp.group)  -- set arcs
-- 20 has been selected for reducing the number of elements
clearselected()

-- bring the slot along the x-axis --------------------
selectgroup(lp.group)
moverotate(0,0,-90)
clearselected()


end -- of function

-- END of file ........................................