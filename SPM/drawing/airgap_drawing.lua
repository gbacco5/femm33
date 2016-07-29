-- AIRGAP_DRAWING -------------------------------------
-- This script draws the slotted stator of any type of
-- machine. It is based on a unified function.
-- bg @2016/03/18
-- ----------------------------------------------------

-- load function --------------------------------------
dofile(tools_folder .. "rotate.lua")


-- assign materials -----------------------------------
xG = Dre/2 + g/2
yG = 0
xG, yG = rotate(xG,yG,27)
addblocklabel(xG,yG)
selectlabel(xG,yG)
setblockprop("Air", 0, mesh_gap, "", 0, 1)

clearselected()


-- EXPERIMENTAL !!! -----------------------------------
-- mb_pt = floor(3*PI*(Dre+Di)/2/g)
-- messagebox(mb_pt)

-- for ii = 1,mb_pt do
	-- xMB1 = Dre/2 + g/3
	-- yMB1 = 0
	-- xMB2 = Dre/2 + 2*g/3
	-- yMB2 = 0
	
	-- x,y = rotate(xMB1,yMB1, (ii-1)*360/mb_pt)
	-- addnode(x,y)
	-- selectnode(x,y)
	-- setnodeprop("",10)
	-- clearselected()

	-- x,y = rotate(xMB2,yMB2, (ii-1)*360/mb_pt)
	-- addnode(x,y)
	-- selectnode(x,y)
	-- setnodeprop("",1000)
	-- clearselected()
-- end