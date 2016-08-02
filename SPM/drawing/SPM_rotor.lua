-- SPM_rotor.lua --------------------------------------
-- This script draws all the possible SPM rotor
-- configuration.
--
-- REQUIREMENTS:
--   . The function 'rotate.lua' has already to be loaded
--
-- bg, 2016/08/01
-- ----------------------------------------------------

-- determine the diameter closer to the air-gap
if rotor.pos == -1 then -- conventional motor
  rotor.Dgap = rotor.De
  rotor.Dbound = rotor.Di
elseif rotor.pos == 1 then -- external motor
  rotor.Dgap = rotor.Di
  rotor.Dbound = rotor.De
end

if rotor.magnet.mgtz == 'parallel' then -- easy one
local x,y = {},{}

  if rotor.magnet.shape == 'rect' then
    x[1],y[1] = rotate(0,rotor.Dgap/2,-90/rotor.p)
    x[2],y[2] = rotate(0,rotor.Dgap/2,-rotor.magnet.ang_e/rotor.p)
  end

elseif rotor.magnet.mgtz == 'radial' then

end
