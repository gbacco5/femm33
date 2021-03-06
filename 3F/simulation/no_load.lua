-- NO_LOAD.lua ****************************************
-- This file starts the no-load simulation.
--
-- bg, 2016/08/07
-- ****************************************************



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

  pass2post(p2p)
  

  -- analyse ------------------------------------------
  savefemmfile('temp.fem')

  fea_ts = clock()
  analyse(1)
  fea_te = clock()
  
  tolog(format('FEA duration was %4.1f s.\n\n',fea_te-fea_ts))


  -- post-processing ----------------------------------
  runpost(folder.sim .. sim.post .. ".lua",'-windowhide')


end -- of for thm