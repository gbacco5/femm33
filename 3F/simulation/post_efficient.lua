-- POST_EFFICIENT.lua *********************************
-- This script performs the efficient post-processing
-- of quantities of the analized motor.
-- Every computation is in this same file for
-- efficiency purposes.
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
-- stator linkages ------------------------------------
stator.link = {}
Azsum = {}
Azsum[0] = 0 -- cumulated sum

for qq = 1,stator.Q do
  if qq <= sim.slots then
    groupselectblock(stator.group + qq)
    if qq == 1 then
      stator.slot.area = blockintegral(5)
    end
    
    Azsum[qq] = blockintegral(1)/stator.slot.area

    stator.link[qq] = 2*stator.p/sim.poles*--...
      stator.L/1000*--... stator.winding.ncs
      ( Azsum[qq] - Azsum[qq - 1] )
  else
    stator.link[qq] = 0
  end
end
-- slots still selected

Lambda = {}
Lambda = prod(Kt, stator.link) -- vector of fluxes

Lambda_AB = prod(T_AB, Lambda) -- Alpha,Beta

lambda_d,lambda_q = ab2dq(Lambda_AB[1], Lambda_AB[2], thme)


-- torque + forces on stator --------------------------
group_select_block(stator.group)
stator.torque = 2*stator.p/sim.poles* blockintegral(22)
stator.Fx = blockintegral(18)
stator.Fy = blockintegral(19)
stator.mag_en = 2*stator.p/sim.poles* blockintegral(2) -- magn. energy
stator.mag_co = 2*stator.p/sim.poles* blockintegral(17) -- magn. coenergy
clearblock()

-- torque + forces on rotor ---------------------------
groupplus_select_block(rotor.group,rotor.Q)
rotor.torque = 2*rotor.p/sim.poles* blockintegral(22)
rotor.Fx = blockintegral(18)
rotor.Fy = blockintegral(19)
rotor.mag_en = 2*rotor.p/sim.poles* blockintegral(2) -- magn. energy
rotor.mag_co = 2*rotor.p/sim.poles* blockintegral(17) -- magn. coenergy
clearblock()

-- air-gap
group_select_block(gap.group)
gap.mag_en = 2*stator.p/sim.poles* blockintegral(2) -- magn. energy
gap.mag_co = 2*stator.p/sim.poles* blockintegral(17) -- magn. coenergy
clearblock()

-- compute energies
mag_en = stator.mag_en + rotor.mag_en + gap.mag_en
mag_co = stator.mag_co + rotor.mag_co + gap.mag_co



-- torque from fluxes and currents --------------------
lambda_d = lambda_d or 0 -- provide lambda_d exists
lambda_q = lambda_q or 0
torque_dq = 3/2*stator.p*( lambda_d*i_q - lambda_q*i_d )


-- export results -------------------------------------
dofile(folder.sim .. 'subpost_export.lua')

exitpost()