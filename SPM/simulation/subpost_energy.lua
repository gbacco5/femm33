-- SUBROUTINE of post-processing ======================
-- This subroutine computes the magnetic energy and
-- coenergy.
-- REQUIREMENTS:
--  - motor_data.lua file to be loaded before the call
--
-- bg, 2016/08/11
-- ====================================================

-- select everything ----------------------------------
groupplus_select_block(stator.group,--...
  stator.Q*sim.poles/2/stator.p) -- stator

-- ensure rotor.winding.Q exists
rotor.Q = rotor.Q or 0

groupplus_select_block(rotor.group,--...
  rotor.Q*sim.poles/2/stator.p) -- rotor

groupplus_select_block(gap.group)

mag_en = 2*stator.p/sim.poles* blockintegral(2) -- magn. energy
mag_co = 2*stator.p/sim.poles* blockintegral(17) -- magn. coenergy

clearblock()
