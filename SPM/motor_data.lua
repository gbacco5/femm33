-- MOTOR_DATA.lua *************************************
-- This file start the drawing of the motor.
--
-- bg @2016/07/29
-- ****************************************************

username = "Giacomo"
motor_model = "test"
filename = "SPM".."_"..motor_model
date_time = date("%Y%m%d_%H%M%S")

-- Stator ---------------------------------------------
stator = {
  -- external parameters
  De = 200, -- [mm], external diameter
  Di = 125, -- [mm], internal diameter
  L = 40, -- [mm], stator stack lenght
  p = 2, -- # of pole pairs
  -- position of the stator
  pos = 1, -- +1 outer, -1 inner
  group = 1000,

  -- slot parameters
  slot = {
    wso = 3, -- [mm], stator slot opening width
    hso = 1, -- [mm], stator slot opening height
    hwed = 2, -- [mm], stator slot wedge height
    hs = 25, -- [mm], stator slot total height
    wt = 7, -- [mm], teeth width
    shape = 'round' -- 'squared/round/semiround/roundsemi/semiarc'
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
    self.hbi = (self.De - self.Di)/2 - self.slot.hs
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
rotor = stator
rotor = {
  tipo = 'SPM',
  group = 10,
  -- magnet
  magnet = {
    h = 5, -- [mm], magnet height
    ang_e = 75 --[el°], magnet electrical angle span
  },

  De = 113, -- [mm], external diameter
  Di = 60, -- [mm], internal diameter
  pos = -stator.pos, -- opposite position than the stator
  slot = nil, -- no slots
  winding = nil -- no winding
}

-- Air-gap --------------------------------------------
if stator.pos == 1 then -- conventional motor, inner rotor
  if rotor.tipo == 'SPM' then
    g = (stator.Di - rotor.De)/2 - rotor.magnet.h
  else
    g = (stator.Di - rotor.De)/2
  end

elseif stator.pos == -1 then -- outer rotor
  if rotor.tipo == 'SPM' then
    g = (rotor.Di - stator.De)/2 - rotor.magnet.h
  else
    g = (rotor.Di - stator.De)/2
  end
end
-- check whether g is negative
if g < 0 then error('Negative air-gap lenght, g.') end



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