-- MOTOR_DATA.lua *************************************
-- This file start the drawing of the motor.
-- '?!' options have already to be implemented.
--
-- bg @2016/07/29
-- ****************************************************

username = "Giacomo"
motor_model = "test"
filename = "SPM".."_"..motor_model
date_time = date("%Y%m%d_%H%M%S")

-- I/O stuff ------------------------------------------
folder = {
  tools = '..\\tools\\',
  draw = '.\\drawing\\',
  sim = '.\\simulation\\',
  out = '.\\output\\',
  inp = '.\\input\\'
}

fn = {
  all = 'results'..date_time..'out',
  sett = 'settings'
}

dofile(folder.tools .. "ufuns.lua")
dofile(folder.tools .. "wait.lua")



-- Stator ---------------------------------------------
stator = {
  -- external parameters
  De = 200, -- [mm], external diameter
  Di = 125, -- [mm], internal diameter
  L = 40, -- [mm], stator stack lenght
  p = 3, -- # of pole pairs
  -- position of the stator
  pos = 1, -- +1 outer, -1 inner
  group = 1000,
  material = 'Iron',

  -- slot parameters
  slot = {
    wso = 3, -- [mm], stator slot opening width
    hso = 1, -- [mm], stator slot opening height
    hwed = 1, -- [mm], stator slot wedge height
    hs = 25, -- [mm], stator slot total height
    wt = 7, -- [mm], teeth width
    shape = 'rounded',
    -- 'squared/rounded/
    --  round/semiround/roundsemi/
    --  semiarc/roundarc'

    -- if round/semiround/semiarc/roundarc
    arcangle = 20,

    -- if round/rounded/roundsemi/roundarc
    join_angle = 30, -- input if desired

    -- if rounded
    radius = 2 -- [mm] 
  },

  -- winding parameters
  winding = {
    m = 3, --  # oh phases
    Q = 36, -- # of stator slots
    chording = 0, -- # of slots chorded
    sequence = {1,-3,2,-1,3,-2}
    -- yq = self.Q/2/self.p -- winding pitch
  },
  
  -- Method: compute back-iron height
  comp_hbi = function(self)
  -- to perform the computation even in the absence of slot
  local decrease
  if self.slot == nil then 
    decrease = 0
  else
    decrease = self.slot.hs
  end
    self.hbi = (self.De - self.Di)/2 - decrease
  end,

  -- Method: compute remaining slot parameters
  comp_ws_wse = function(self)
    self.slot.ws = (self.Di + self.pos*2*self.slot.hso
          + self.pos*2*self.slot.hwed)*PI/self.winding.Q
          - self.slot.wt
    self.slot.wse = (self.Di + self.pos*2*self.slot.hs)*PI/self.winding.Q
          - self.slot.wt
    if self.slot.shape == 'semiround' then
      self.slot.wse = self.slot.wse/(1 + self.pos*PI/self.winding.Q)
    end
  end,

  -- Method: compute slot angle
  comp_alphas = function(self)
    self.alphas = 360/self.winding.Q
    self.alphase = self.p*self.alphas
  end
}



-- Rotor ----------------------------------------------
-- the rotor table uses the stator one as a template.
-- we cannot simply do  rotor = stator, otherwise both
-- of them would reference to the same table.
rotor = copy_table(stator)

-- unfortunately we have to reference each label
-- individually, otherwise we would overwrite the table.
rotor.tipo = 'SPM'
rotor.group = 10

rotor.magnet = {
  -- magnetisation direction
  material = 'Magnet', -- magnet material
  mgtz = 'parallel', -- 'parallel'/'radial'
  shape = 'rect', -- 'rect'/'trapz'/'?!sin'
  h = 5, -- [mm], magnet height
  ang_e = 75, --[el°], magnet half electrical angle span

  pole = 1,

  comp_segments = function(self, sim)
  self.magnet.segments = floor(self.magnet.ang_e/self.p/sim.dth) - 1
  end

}

rotor.De = 113 -- [mm], external diameter
rotor.Di = 40 -- [mm], internal diameter
rotor.pos = -stator.pos -- opposite position than the stator
rotor.arcangle = 1 -- maximum discretisation angle

rotor.slot = nil -- no slots
rotor.winding = nil -- no winding
rotor.ws_wse = nil -- delete useless method
rotor.comp_alphas = nil -- delete useless method

shaft = {material = '<No Mesh>'}


-- Air-gap --------------------------------------------
if stator.pos == 1 then -- conventional motor, inner rotor
  if rotor.tipo == 'SPM' then
    g = (stator.Di - rotor.De)/2 - rotor.magnet.h
  else
    g = (stator.Di - rotor.De)/2
  end
  ag_R = stator.Di/2 - g/2 -- average a-g radius

elseif stator.pos == -1 then -- outer rotor
  if rotor.tipo == 'SPM' then
    g = (rotor.Di - stator.De)/2 - rotor.magnet.h
  else
    g = (rotor.Di - stator.De)/2
  end
  ag_R = rotor.Di/2 - g/2
  
end
-- check whether g is negative
if g < 0 then error('Negative air-gap lenght, g.') end

gap = {
  t = g, -- thickness
  r = ag_R, -- radius
  Rs = ag_R + stator.pos*1e-6, -- upper radius
  Rr = ag_R - rotor.pos*1e-6, -- lower radius
}



-- Simulation -----------------------------------------
sim = {
  tipo = '?!unknown',
  poles = 1,
  -- either 1, 2, stator.p,2*stator.p, where 2p --> complete
  dth = 1,
  -- this is also necessary for the segmentation of the magnet
}



-- magnet shapes. 'Rectified' view
--         _________
-- trapz   \_______/
--         _________
-- rect   |_________|
--            ___ 
--         _--   --_
-- sin    |_________|