-- POST_COMPLETE.lua **********************************
-- This script performs the complete post-processing
-- of quantities of the analized motor.
-- bg, 2016/08/08
-- ****************************************************

-- load motor_data ------------------------------------
dofile("motor_data.lua")
dofile(folder.inp .. "K.lua")

T_AB = gen_T_matrix(stator.winding.m)

-- Reading of the simulation inputs -------------------
dofile(folder.inp..'pass2post.lua')
thme = stator.p*thm

-- flux linkages computation --------------------------
dofile(folder.sim.."subpost_linkage.lua")

-- -- Bg computation -------------------------------------
-- -- if thetam == thetammin then
-- dofile(sim_folder.."subpost_Bcontour.lua")
-- end

-- torque computation
dofile(folder.sim.."subpost_torque.lua")

-- screenshot saving
-- dofile(sim_folder.."subpost_images.lua")
-- dofile(sim_folder.."subpost_images_2.lua")


-- export results
tab = '    '
ohandle = openfile(folder.out .. fn.res,'a')
write(ohandle,format('%3.2f',thm),tab,
              format('%1.5e',rotor.torque),tab,
              format('%1.5e',stator.torque),tab,
              format('%1.5e',Lambda[1]),tab,
              format('%1.5e',Lambda[2]),tab,
              format('%1.5e',Lambda[3]),tab,
              format('%1.5e',lambda_d),tab,
              format('%1.5e',lambda_q),tab,
              '\n')
closefile(ohandle)

exitpost()