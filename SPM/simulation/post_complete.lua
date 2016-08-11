-- POST_COMPLETE.lua **********************************
-- This script performs the complete post-processing
-- of quantities of the analized motor.
-- bg, 2016/08/08
-- ****************************************************

-- load motor_data ------------------------------------
dofile("motor_data.lua")
dofile(folder.inp .. "K.lua")

-- compute transformation matrices --------------------
T_AB = gen_T_matrix(stator.winding.m)
U_abc = gen_U_matrix(stator.winding.m)


-- Reading of the simulation inputs -------------------
dofile(folder.inp..'pass2post.lua')
thme = stator.p*thm
i_d = i_d or 0
i_q = i_q or 0

-- flux linkages computation --------------------------
dofile(folder.sim.."subpost_linkage.lua")

-- flux linkages computation --------------------------
dofile(folder.sim.."subpost_energy.lua")

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
lambda_string = ''
for mm = 1,stator.winding.m do
  lambda_string = lambda_string..
                  format('%+1.5e',Lambda[mm])..tab
end



ohandle = openfile(folder.out .. fn.res,'a')
write(ohandle,format('%+03.2f',thm),tab,
              --
              format('%+1.5e',rotor.torque),tab,
              format('%+1.5e',stator.torque),tab,
              format('%+1.5e',torque_dq),tab,
              --
              lambda_string,
              --
              format('%+1.5e',lambda_d),tab,
              format('%+1.5e',lambda_q),tab,
              --
              format('%+1.5e',mag_en),tab,
              format('%+1.5e',mag_co),tab,
              --
              format('%+1.5e',rotor.Fx),tab,
              format('%+1.5e',rotor.Fy),tab,
              format('%+1.5e',stator.Fx),tab,
              format('%+1.5e',stator.Fy),tab,
              '\n')
closefile(ohandle)

exitpost()