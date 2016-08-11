-- NO_LOAD.lua ****************************************
-- This file starts the no-load simulation.
--
-- bg, 2016/08/07
-- ****************************************************


-- pre-processing -------------------------------------
tolog(format('\nMesh precision factor is %2.f.\n',precision))
if sim.poles == 1 then
  tolog('The simulation is on 1 pole.\n\n')
else
  tolog(format('The simulation is on %3.f poles.\n\n',sim.poles))
end




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
  runpost(folder.sim .. "post_complete.lua",'-windowhide')


end