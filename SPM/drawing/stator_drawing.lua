-- STATOR_DRAWING =====================================
-- This script draws the slotted stator of any type of
-- machine. It is based on a unified function.
-- bg @2016/03/18
-- ====================================================

-- load function --------------------------------------
dofile(draw_folder .. "fun_draw_slot.lua")
dofile(tools_folder .. "rotate.lua")

-- draw slot ------------------------------------------
draw_slot(Di,wso,hso,ws,hwed,wse,hs,alphas,1, slot_tipo,join_angle)
groupnumber = 1000

-- copy slots -----------------------------------------
selectgroup(groupnumber)
copyrotate(0,0,alphas,Qs - 1)
clearselected()

-- external stator drawing ----------------------------
addnode(De/2,0)
addnode(-De/2,0)
addarc(De/2,0,-De/2,0,180,1)
addarc(-De/2,0,De/2,0,180,1)

selectgroup(0) -- select all
setnodeprop("",groupnumber) -- set nodes in group 10
setblockprop("", 0, 0, "", 0, groupnumber) -- set blocks
setsegmentprop("", 0, 0, 0, groupnumber) -- set segments
setarcsegmentprop(1, "", 0, groupnumber)  -- set arcs
clearselected()

-- assign materials -----------------------------------
xY = Di/2 + hs + hbi/2
yY = 0
xY, yY = rotate(xY,yY,27)
addblocklabel(xY,yY)
selectlabel(xY,yY)
setblockprop(rotor_material, 0, mesh_fe, "", 0, groupnumber)
clearselected()

x0 = Di/2 + hs/2
y0 = 0
for qq = 1,Qs do
	x,y = rotate(x0,y0,(qq-1)*alphas)
	addmaterial(stator_slot_material .. qq, 1, 1, 0, 0, 0, sigma_Cu, 0, 0, 1, 0)
	addblocklabel(x,y)
	selectlabel(x,y)
	setblockprop(stator_slot_material .. qq, 1, 0, "", 0, 1000 + qq)
	clearselected()
end
selectgroup(0) -- select all
setblockprop("", 0, 0, "", 0, groupnumber) -- set blocks
clearselected()


-- boundary conditions --------------------------------
selectarcsegment(De/2,1)
selectarcsegment(-De/2,-1)
setarcsegmentprop(1, "Azero", 0, groupnumber)
clearselected()