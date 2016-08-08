-- SUBROUTINE of post-processing ======================
-- This subroutine computes the flux linkages
-- REQUIREMENTS:
--  - motor_data.lua file to be loaded before the call
--  - T_AB...m^dq to be already created
--
-- bg, 2016/08/08
-- ====================================================

-- stator linkages ------------------------------------
stator.link = {}

for qq = 1,stator.Q do
  if qq < sim.slots then
    groupselectblock(stator.group + qq)
    stator.link[qq] = 2*stator.p/sim.poles*--...
      stator.L/1000*--...
      blockintegral(1)/blockintegral(5)
    clearblock()
  else
    stator.link[qq] = 0
  end
end

Lambda = {}
Lambda = prod(Kt, stator.link)

Lambda_AB = prod(T_AB, Lambda)

lambda_d,lambda_q = ab2dq(Lambda_AB[1], Lambda_AB[2], thme)