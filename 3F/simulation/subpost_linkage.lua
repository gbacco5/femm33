-- SUBROUTINE of post-processing ======================
-- This subroutine computes the flux linkages
-- REQUIREMENTS:
--  - motor_data.lua file to be loaded before the call
--  - T_ab...m^AB = T_AB to be already created
--  - ab2dq() function loaded
--
-- bg, 2016/08/10
-- ====================================================

-- stator linkages ------------------------------------
stator.link = {}
groupselectblock(stator.group + 1)
stator.slot.area = blockintegral(5)
clearblock()

for qq = 1,stator.Q do
  if qq <= sim.slots then
    groupselectblock(stator.group + qq)
    stator.link[qq] = 2*stator.p/sim.poles*--...
      stator.L/1000*--... stator.winding.ncs
      blockintegral(1)/stator.slot.area
    clearblock()
  else
    stator.link[qq] = 0
  end
end

Lambda = {}
Lambda = prod(Kt, stator.link) -- vector of fluxes

Lambda_AB = prod(T_AB, Lambda) -- Alpha,Beta

lambda_d,lambda_q = ab2dq(Lambda_AB[1], Lambda_AB[2], thme)
