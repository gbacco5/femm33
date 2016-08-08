-- SUBROUTINE of post-processing ======================
-- This subroutine computes the torque on the rotor
-- and on the stator.
-- REQUIREMENTS:
--  - motor_data.lua file to be loaded before the call
--
-- bg, 2016/08/08
-- ====================================================

-- torque on rotor
groupplus_select_block(rotor.group,rotor.Q)
rotor.torque = 2*rotor.p/sim.poles*blockintegral(22)
clearblock()

-- torque on stator
groupplus_select_block(stator.group,stator.Q)
stator.torque = 2*stator.p/sim.poles*blockintegral(22)
clearblock()