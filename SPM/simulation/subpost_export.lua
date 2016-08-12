-- POST_COMPLETE.lua **********************************
-- This script exports the results of the simulation.
-- The constant need to unpack everything as much as
-- possible lead to this subroutine.
--
-- bg, 2016/08/11
-- ****************************************************


tab = '    '
lambda_string = ''
for mm = 1,stator.winding.m do
  lambda_string = lambda_string..
                  format('% 1.5e',Lambda[mm])..tab
end



ohandle = openfile(folder.out .. fn.res,'a')
write(ohandle,format('% 3.2f',thm),tab,
              --
              format('% 1.5e',rotor.torque),tab,
              format('% 1.5e',stator.torque),tab,
              format('% 1.5e',torque_dq),tab,
              --
              lambda_string,
              --
              format('% 1.5e',lambda_d),tab,
              format('% 1.5e',lambda_q),tab,
              --
              format('% 1.5e',mag_en),tab,
              format('% 1.5e',mag_co),tab,
              --
              format('% 1.5e',rotor.Fx),tab,
              format('% 1.5e',rotor.Fy),tab,
              format('% 1.5e',stator.Fx),tab,
              format('% 1.5e',stator.Fy),tab,
              '\n')
closefile(ohandle)