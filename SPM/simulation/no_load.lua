-- NO_LOAD.lua ****************************************
-- This file starts the no-load simulation.
--
-- bg, 2016/08/07
-- ****************************************************


-- pre-processing -------------------------------------
tolog('Mesh precision factor is ', precision,'.\n')
if sim.poles == 1 then
  tolog('The simulation is on 1 pole.\n')
else
  tolog('The simulation is on ', sim.poles,' poles.\n')
end
tolog("cr")
tolog("\n")



for thm = sim.thm_s,sim.thm_e,sim.dthm do

  sim.n = sim.n + 1
  tolog('\n+++ Simulation n. ',sim.n,' +++\n')

  -- open FEMM file -----------------------------------
  openfemmfile(filename .. ".fem")
  tolog(filename.." opened...\n")

  -- a-d axes alignment + rotor rotation --------------
  selectgroup(rotor.group)
  rotor.rotation = ADsfas + thm
  moverotate(0,0, rotor.rotation)
  clearselected()
  tolog('Rotor rotated by ',thm,'deg.\n')


  -- air-gap closing ----------------------------------
  if sim.partial then
    dofile(folder.draw .. "airgap_close.lua")
    tolog('Successfully closed the air-gap.\n')
  end

  -- pass to post-processing
  p2p = {
  thm = thm,
  }

  phandle = openfile(folder.inp .. 'pass2post.lua','w')
  for l,v in p2p do
    if type(v) == 'number' then
      write(phandle,l..'='..v..'\n')
    else
      write(phandle,l..'="'..v..'"\n')
    end
  end
  closefile(phandle)

  -- analyse ------------------------------------------
  savefemmfile('temp.fem')

  fea_ts = clock()
  analyse(1)
  fea_te = clock()
  
  tolog(format('FEA duration was %4.1f s.\n\n',fea_te-fea_ts))


  -- post-processing ----------------------------------
  runpost(folder.sim .. sim.post .. ".lua",'-windowhide')


end -- of for thm