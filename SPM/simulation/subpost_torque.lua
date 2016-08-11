-- SUBROUTINE of post-processing ======================
-- This subroutine computes the torque on the rotor
-- and on the stator.
-- Moreover it computes the torque from fluxes and
-- currents.
-- Furthermore it computes the forces acting on the the
-- parts.
-- REQUIREMENTS:
--  - motor_data.lua file to be loaded before the call
--  - fluxes to be already computed
--
-- bg, 2016/08/10
-- ====================================================

-- torque + forces on rotor ---------------------------
groupplus_select_block(rotor.group,rotor.Q)
rotor.torque = 2*rotor.p/sim.poles* blockintegral(22)
-- I am not  sure about the forces ?!?!?!
rotor.Fx = blockintegral(18)
rotor.Fy = blockintegral(19)
clearblock()

-- torque + forces on stator --------------------------
groupplus_select_block(stator.group,stator.Q)
stator.torque = 2*stator.p/sim.poles* blockintegral(22)
stator.Fx = blockintegral(18)
stator.Fy = blockintegral(19)
clearblock()

-- torque from fluxes and currents --------------------
lambda_d = lambda_d or 0 -- provide lambda_d exists
lambda_q = lambda_q or 0
torque_dq = 3/2*stator.p*( lambda_d*i_q - lambda_q*i_d )