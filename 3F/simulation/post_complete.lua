-- POST_COMPLETE.lua **********************************
-- This script performs the complete post-processing
-- of quantities of the analized motor.
-- Every computation is unpacked and more or less
-- unrelated to the other subpackages. However it is
-- inefficient in the selection of areas. This lead me
-- to create a new and efficient post-processing
-- routine, which will be selected in the 'motor_data'
-- file.
--
-- bg, 2016/08/11
-- ****************************************************

-- load motor_data ------------------------------------
dofile("motor_data.lua")
dofile(folder.inp .. "K.lua")


-- Reading of the simulation inputs -------------------
dofile(folder.inp..'pass2post.lua')
thme = stator.p*thm
i_d = i_d or 0
i_q = i_q or 0

-- flux linkages computation --------------------------
dofile(folder.sim.."subpost_linkage.lua")

-- energies computation -------------------------------
dofile(folder.sim.."subpost_energy.lua")

-- torque computation ---------------------------------
dofile(folder.sim.."subpost_torque.lua")

-- screenshot saving
-- dofile(sim_folder.."subpost_images.lua")
-- dofile(sim_folder.."subpost_images_2.lua")



-- export results -------------------------------------
dofile(folder.sim .. 'subpost_export.lua')

exitpost()