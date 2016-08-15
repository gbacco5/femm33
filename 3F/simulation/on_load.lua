-- ON_LOAD.lua ****************************************
-- This file starts the on-load simulation varying the
-- rotor position.
--
-- bg, 2016/08/15
-- ****************************************************



for thm = sim.thm_s,sim.thm_e,sim.dthm do

  sim.n = sim.n + 1
  thme = stator.p*thm

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


  -- compute currents ---------------------------------
  dofile(folder.sim .. "subpre_currents_".. sim.control ..".lua")

  -- impose currents ----------------------------------
  dofile(folder.sim .. "subpre_impose_i.lua")


  -- air-gap closing ----------------------------------
  if sim.partial then
    dofile(folder.draw .. "airgap_close.lua")
    tolog('Successfully closed the air-gap.\n')
  end

  -- pass to post-processing
  p2p = {
  thm = thm,
  i_d = i_d,
  i_q = i_q,
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