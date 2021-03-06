-- ANALYSIS.lua ****************************************
-- This file starts the simulation indicated in
-- motor_data file.
--
-- bg, 2016/08/07
-- ****************************************************


-- load data ------------------------------------------
dofile("motor_data.lua")
dofile(folder.inp .. "K.lua")
dofile(folder.tools .. 'fun_pass2post.lua')


-- prepare results ------------------------------------
tab = '    '
ohandle = openfile(folder.out..fn.res,'w')
write(ohandle,'RESULTS for ',sim.tipo,--...
  ' analysis\nlaunched at ',ora,
  ' on ',data,
  ' by ',username,
  ' on ',motor_model,'.\n\n')

lambda_string = ''
for mm = 1,stator.winding.m do
  lambda_string = lambda_string..
                  '  lambda_'..alphabet[mm]..'   '..tab
end

local n_out = 12 + stator.winding.m
out_string = '  1  '..tab
for i_out = 2,n_out do
  if i_out < 10 then 
    out_string = out_string .. '      '..i_out..'      '..tab
  else
    out_string = out_string .. '     '..i_out..'      '..tab
  end
end

write(ohandle,out_string,'\n')

write(ohandle,' thm ',tab,
              --
              '    torque   ',tab,
              'stator torque',tab,
              '   torque_dq ',tab,
              --
              lambda_string,
              '  lambda_d   ',tab,
              '  lambda_q   ',tab,
              --
              'magn energy  ',tab,
              'magn coenergy',tab,
              --
              '     Fx      ',tab,
              '     Fy      ',tab,
              '  stator Fx  ',tab,
              '  stator Fy  ',tab,
              '\n\n')

closefile(ohandle)


-- output to log --------------------------------------
tolog("cr") -- carriage return (line filled with *)
tolog("Analysis '"..sim.tipo.."' started at "..date().."\n")
tolog("by "..username.." on "..filename..".\n\n")
tolog("The number of simulations is ", sim.ntot, ".\n")



-- pre-processing -------------------------------------
tolog('Mesh precision factor is ', precision,'.\n')
if sim.poles == 1 then
  tolog('The simulation is on 1 pole.\n')
else
  tolog('The simulation is on ', sim.poles,' poles.\n')
end
tolog("cr")
tolog("\n")


-- launch simulation ----------------------------------
dofile(folder.sim .. sim.tipo .. ".lua")



-- make a copy of the outputs -------------------------
execute('copy '..folder.out..fn.res..' '..---
  folder.out..'results_'..date_time..'.out')

-- clear garbage stuff --------------------------------
dofile(folder.tools .. "sub_clearall_temp.lua")


-- output to log --------------------------------------
tolog("\nAnalysis finished at ",date(),"\n")
tolog("cr")


exitpre()