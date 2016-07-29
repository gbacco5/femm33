-- ROTOR_DRAWING ======================================
-- This script draws the slotted stator of any type of
-- machine. It is based on a unified function.
-- bg @2016/03/18
-- ====================================================

-- load function --------------------------------------
dofile(draw_folder .. "fun_draw_slot.lua")
dofile(tools_folder .. "rotate.lua")

-- draw slot ------------------------------------------
draw_slot(Dre,wsor,hsor,wsr,hwedr,wser,hsr,alphasr,2, slot_r_tipo,join_angle_r)
groupnumber = 10

-- copy slots -----------------------------------------
selectgroup(10)
copyrotate(0,0,alphasr,Qsr - 1)
clearselected()

-- rotor shaft creation -------------------------------
addnode(Dri/2,0)
addnode(-Dri/2,0)
addarc(Dri/2,0,-Dri/2,0,180,5)
addarc(-Dri/2,0,Dri/2,0,180,5)

selectgroup(0) -- select all
setnodeprop("",groupnumber) -- set nodes in group 10
setblockprop("", 0, 0, "", 0, groupnumber) -- set blocks
setsegmentprop("", 0, 0, 0, groupnumber) -- set segments
setarcsegmentprop(5, "", 0, groupnumber)  -- set arcs
clearselected()

-- circuit property -----------------------------------
addcircprop("bars",0,0,0,0,0)
-- zero-sum current flowing in the rotor bars

-- assign materials -----------------------------------
xY = (Dre + Dri)/4*0.75
yY = 0
xY, yY = rotate(xY,yY,27)
addblocklabel(xY,yY)
selectlabel(xY,yY)
setblockprop(rotor_material, 0, mesh_fe, "", 0, groupnumber)
clearselected()
-- shaft
xS = Dri/4
yS = 0
xS, yS = rotate(xS,yS,27)
addblocklabel(xS,yS)
selectlabel(xS,yS)
setblockprop(shaft_material, 0, mesh_fe, "", 0, groupnumber)
clearselected()

x0 = Dre/2 - hsr/2
y0 = 0
for qq = 1,Qsr do
	x,y = rotate(x0,y0,(qq-1)*alphasr)
	addmaterial(rotor_slot_material .. qq, 1, 1, 0, 0, 0, sigma_Al_r, 0, 0, 1, 0)
	addblocklabel(x,y)
	selectlabel(x,y)
	setblockprop(rotor_slot_material .. qq, 1, 0, "bars", 0, 10 + qq)
	clearselected()
end
selectgroup(0) -- select all
setblockprop("", 0, 0, "", 0, groupnumber) -- set blocks
clearselected()


-- boundary conditions --------------------------------
selectarcsegment(Dri/2,1e-6)
selectarcsegment(-Dri/2,-1e-6)
setarcsegmentprop(5, "Azero", 0, groupnumber)
clearselected()
