-- FUN_DRAW_SLOT.lua ..................................
-- This function creates a slot and position it along
-- the x-axis. It is general for both the stator and
-- the rotor. The selection is made through the 
-- variable 'lp.pos', where
--   - +1 corresponds to outer position
--   - -1 corresponds to the inner position
--
-- REQUIREMENTS:
--   . The function 'rotate.lua' has already to be loaded
--
-- INPUT:
--   . lp --> lamination part, either stator or rotor
--			(this table contains all the necessary variables
--			and methods)
--
-- OUTPUT: none
--
-- bg, 2016/08/05
-- ....................................................


function draw_slot(lp)

-- half slot drawing : squared case
--
--    ----------D----4
--               	  /
--              	 C
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
local x = {}
local y = {}

-- determine the construction diameter
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
or lp.slot.shape == "rounded"
or lp.slot.shape == "roundsemi"
or lp.slot.shape == "roundarc" then

-- join_angle = atan(lp.winding.Q/PI)/2 - lp.slot.tooth_head_angle
join_angle = lp.slot.join_angle or atan(lp.winding.Q/PI)/2
-- atan(lp.winding.Q/PI)/2  is kinda black magic,
-- you better specify the join_angle

	if lp.pos == 1 then 
		addarc(x[2],y[2],x[3],y[3], join_angle,1)
	elseif lp.pos == -1 then
		addarc(x[3],y[3],x[2],y[2], join_angle,1)
	end -- of if selector

elseif lp.slot.shape == "semiround"
		or lp.slot.shape == "square"
		or lp.slot.shape == "semiarc" then
	addsegment(x[2],y[2],x[3],y[3])

else
	addsegment(x[2],y[2],x[3],y[3])
end -- of if lp.slot.shape
	
-- round corners
if lp.slot.shape == "rounded" then

	local center = {}
	center.y = y[4] - lp.pos*lp.slot.radius

	if lp.pos == 1 then 
		center.slot_angle = atan(2*lp.winding.Q/PI)
	elseif lp.pos == -1 then 
		center.slot_angle = 180 - atan(2*lp.winding.Q/PI)
	end

	-- local center.corner_dist = lp.slot.radius/sin(center.slot_angle/2)
	center.m4 = lp.pos*tan(center.slot_angle/2)
	center.q4 = y[4] - center.m4*x[4]
	center.x = (center.y - center.q4)/center.m4
	-- compute second point location
	x.D = center.x
	y.D = y[4]
	-- compute first point location
	center.mC = (-PI/2/lp.winding.Q)
	center.qC = center.y - center.mC*center.x
	center.mC4 = 2*lp.winding.Q/PI
	center.qC4 = y[4] - center.mC4*x[4]

	x.C = (center.qC4 - center.qC)/(center.mC - center.mC4)
	y.C = center.mC*x.C + center.qC
	
	-- delete corner point
	selectnode(x[4],y[4])
	deleteselectednodes()
	clearselected()
		-- get corner angle
	center.angle = 180 - center.slot_angle
	-- add corner nodes
	addnode(x.C,y.C)
	addnode(x.D,y.D)

	-- close corner
	if lp.pos == 1 then
		addarc(x.C,y.C, x.D,y.D, center.angle, lp.slot.arcangle)
	elseif lp.pos == -1 then
		addarc(x.D,y.D, x.C,y.C, center.angle, lp.slot.arcangle)
	end
	
	addsegment(x[3],y[3], x.C,y.C) -- close slot side

end


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

	-- help node to close the top
	hnode_x,hnode_y = rotate(x[4],y[4],lp.alphas)
	addnode(hnode_x,hnode_y)
	addarc(x[4],y[4], hnode_x,hnode_y, lp.alphas,1)
	-- delete help node
	selectnode(rotate(x[4],y[4],lp.alphas))
	deleteselectednodes()
	clearselected()

elseif lp.slot.shape == "rounded" then
	addsegment(x.D,y.D, -x.D,y.D)

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
setarcsegmentprop(lp.slot.arcangle, "", 0, lp.group)  -- set arcs

clearselected()

-- bring the slot along the x-axis --------------------
selectgroup(lp.group)
moverotate(0,0,-90)
clearselected()


end -- of function

-- END of file ........................................