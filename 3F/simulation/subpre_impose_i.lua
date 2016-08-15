-- SUBROUTINE of post-processing ++++++++++++++++++++++
-- This subroutine imposes the currents in the slots
-- given the vector of currents 'i_ph'.
--
-- bg, 2016/08/15
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++


-- compute stator currents
I_slot = prod(stator.winding.ncs, prod(K, i_ph)) -- [A], slot currents


if stator.winding.supply == 'circuit' then
  for qq = 1,stator.Q do
    modifycircprop("Islot_" .. qq, 1, I_slot[qq])
  end -- of for


elseif stator.winding.supply == '?!material' then 
  for qq = 1,stator.Q do
    local J = I_slot[qq]/stator.slot.area
    modifymaterial(stator.slot.material .. qq, 4, J)
  end -- of for

end -- of if