-- MOTOR_DATA.lua *************************************
-- This file start the drawing of the motor.
-- '?!' options have already to be implemented.
-- '<<.>>' labels identify the kind of motors which
-- need that feature.
--
-- bg, 2016/08/15
-- ****************************************************

username = "Giacomo"
motor_model = "template"

filename = "SPM".."_"..motor_model
date_time = date("%Y%m%d_%H%M%S")
data = date('%Y/%m/%d')
ora = date('%H:%M:%S')


-- ####       ##  #######  
--  ##       ##  ##     ## 
--  ##      ##   ##     ## 
--  ##     ##    ##     ## 
--  ##    ##     ##     ## 
--  ##   ##      ##     ## 
-- #### ##        #######  
-- I/O stuff ------------------------------------------
folder = {
  tools = '.\\tools\\',
  draw = '.\\drawing\\',
  sim = '.\\simulation\\',
  out = '.\\output\\',
  inp = '.\\input\\',
  log = '.\\log\\',
}

fn = {
  res = 'results'..'.out',
  sett = 'settings'..'.out',
}

-- load some useful functions
dofile(folder.tools .. "ufuns.lua")
-- load rotate function
dofile(folder.tools .. "rotate.lua")
-- load wait function
dofile(folder.tools .. "wait.lua")
-- load slot matrix
dofile(folder.tools .. "fun_slot_matrix.lua")



--  ######  ########    ###    ########  #######  ########  
-- ##    ##    ##      ## ##      ##    ##     ## ##     ## 
-- ##          ##     ##   ##     ##    ##     ## ##     ## 
--  ######     ##    ##     ##    ##    ##     ## ########  
--       ##    ##    #########    ##    ##     ## ##   ##   
-- ##    ##    ##    ##     ##    ##    ##     ## ##    ##  
--  ######     ##    ##     ##    ##     #######  ##     ## 
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
    material = 'Cu', 
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
    sequence = {-2,1,-3,2,-1,3},

    ncs = 1, -- # of series conductors per slot

    supply = 'circuit', -- 'circuit'/'material'
    -- this selects if you want to impose current in the
    -- slots either with a circuit or with the material.

    comp_yq = function(self)
      self.winding.yq = floor(self.winding.Q/2/self.p) - --...
        self.winding.chording -- winding pitch
    end
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

  -- Method: get air-gap diameter
  comp_D = function(self)
    if self.pos == 1 then -- conventional motor
      self.Dbound = self.De
      self.Dgap = self.Di
    elseif self.pos == -1 then -- outer rotor
      self.Dbound = self.Di
      self.Dgap = self.De
    end
  end,
  
  -- Method: compute remaining slot parameters
  comp_ws_wse = function(self)
    self.slot.ws = (self.Dgap + self.pos*2*self.slot.hso
          + self.pos*2*self.slot.hwed)*PI/self.winding.Q
          - self.slot.wt
    self.slot.wse = (self.Dgap + self.pos*2*self.slot.hs)*PI/self.winding.Q
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
-- compute the slot angle
stator:comp_alphas()
-- compute the slot area

-- compute the winding pitch
stator.winding.comp_yq(stator)
-- let stator.Q
stator.Q = stator.winding.Q




-- ########   #######  ########  #######  ########  
-- ##     ## ##     ##    ##    ##     ## ##     ## 
-- ##     ## ##     ##    ##    ##     ## ##     ## 
-- ########  ##     ##    ##    ##     ## ########  
-- ##   ##   ##     ##    ##    ##     ## ##   ##   
-- ##    ##  ##     ##    ##    ##     ## ##    ##  
-- ##     ##  #######     ##     #######  ##     ## 
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
  material = 'Magnet', -- magnet material
  -- magnetisation direction
  mgtz = 'parallel', -- 'parallel'/'radial'/'tangential', <<S/IPM>>
  shape = 'trapz', -- 'rect'/'trapz'/'?!sin', <<SPM>>
  h = 5, -- [mm], magnet height
  ang_e = 75, --[el°], magnet half electrical angle span, <<SPM>>
  -- w = , --[mm], magnet width, ?!<<IPM>>

  pole = 1, -- ?????

  -- Method: compute the number of magnet segments
  comp_segments = function(self, sim)
  self.magnet.segments = floor(self.magnet.ang_e/self.p/sim.dth) - 1
  end

}

rotor.De = 113 -- [mm], external diameter
rotor.Di = 40 -- [mm], internal diameter
rotor.pos = -stator.pos -- opposite position than the stator
rotor.arcangle = 1 -- maximum discretisation angle
rotor.rotation = 0

rotor.slot = nil -- no slots
rotor.winding = nil -- no winding
rotor.ws_wse = nil -- delete useless method
rotor.comp_alphas = nil -- delete useless method
rotor.Q = nil

shaft = {material = '<No Mesh>'}



--    ###    #### ########           ######      ###    ########  
--   ## ##    ##  ##     ##         ##    ##    ## ##   ##     ## 
--  ##   ##   ##  ##     ##         ##         ##   ##  ##     ## 
-- ##     ##  ##  ########  ####### ##   #### ##     ## ########  
-- #########  ##  ##   ##           ##    ##  ######### ##        
-- ##     ##  ##  ##    ##          ##    ##  ##     ## ##        
-- ##     ## #### ##     ##          ######   ##     ## ##        
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
  ag_R = stator.De/2 + g/2
  
end
-- check whether g is negative
if g < 0 then error('Negative air-gap lenght, g.') end

gap = {
  t = g, -- thickness
  r = ag_R, -- radius
  Rs = ag_R + stator.pos*1e-6, -- upper radius
  Rr = ag_R - rotor.pos*1e-6, -- lower radius
  material = 'Air',
  -- this variable tells the program how many physical
  -- divisions you want to draw
  group = 1,
  division = 1,
  n_ele = 4, -- # of elements you'd like in the gap
}



-- ##     ## ########  ######  ##     ## 
-- ###   ### ##       ##    ## ##     ## 
-- #### #### ##       ##       ##     ## 
-- ## ### ## ######    ######  ######### 
-- ##     ## ##             ## ##     ## 
-- ##     ## ##       ##    ## ##     ## 
-- ##     ## ########  ######  ##     ## 
precision = 1
-- Mesh sizes -----------------------------------------
mesh = {
  gap = 0.95*g/gap.n_ele/precision, -- air-gap mesh
  fe = 3/precision, -- iron mesh
  cu = 2/precision, -- copper mesh
  air = 0.5/precision, -- air mesh, other than air-gap
  pm = 1/precision, -- PM mesh
  -- shaft = 
  -- barrier = 
}
stator.mesh = {air = mesh.air}



--  ######  #### ##     ## ##     ## ##          ###    ######## ####  #######  ##    ##    
-- ##    ##  ##  ###   ### ##     ## ##         ## ##      ##     ##  ##     ## ###   ##    
-- ##        ##  #### #### ##     ## ##        ##   ##     ##     ##  ##     ## ####  ##    
--  ######   ##  ## ### ## ##     ## ##       ##     ##    ##     ##  ##     ## ## ## ##    
--       ##  ##  ##     ## ##     ## ##       #########    ##     ##  ##     ## ##  ####    
-- ##    ##  ##  ##     ## ##     ## ##       ##     ##    ##     ##  ##     ## ##   ###    
--  ######  #### ##     ##  #######  ######## ##     ##    ##    ####  #######  ##    ##    
-- Simulation -----------------------------------------
sim = {
  tipo = 'on_load',
  -- tipology = 'no_load'/'?!on_load'/'?!compute_L'/'?!map'

  poles = 1,
  -- either 1, 2, stator.p,2*stator.p, where 2p --> complete

  dth = 1,
  -- this is also necessary for the segmentation of the magnet
  thm_s = 0, -- [deg]
  thm_e = 0,--180/stator.winding.m/stator.p - 1, -- 180/3/3 = 19
  dthm = 1, -- [deg], rotation step 
  
  control = 'sin', -- 'sin'/'?!bldc'/'?!square'
  I = 1, -- [A], peak current in the series equivalent wye winding
  alpha_ie = 90, -- [el.deg], (desired) current angle

  n = 0, -- # of simulation

  post = 'post_efficient', -- 'post_complete'/'post_efficient'

  is_partial = function(self,ls)
    self.partial = self.poles ~= 2*ls.p
  end,

  total = function (self)
    self.ntot = (self.thm_e - self.thm_s)/self.dthm + 1
  end
}
sim:is_partial(stator) -- get if the simulation is not complete
sim:total() -- get the total number of simulations





--  ######     ###    ##        ######   ######  
-- ##    ##   ## ##   ##       ##    ## ##    ## 
-- ##        ##   ##  ##       ##       ##       
-- ##       ##     ## ##       ##        ######  
-- ##       ######### ##       ##             ## 
-- ##    ## ##     ## ##       ##    ## ##    ## 
--  ######  ##     ## ########  ######   ######  

-- These points are the ones for closing the air-gap.
--  - 's' stands for stator
--  - 'r' stands for rotor
gap.s1, gap.s2 = {},{}
gap.s1.x, gap.s1.y = rotate(gap.Rs,0, -stator.alphas/2)
gap.s2.x, gap.s2.y = rotate(gap.Rs,0, -- ...
  stator.alphas*(stator.winding.Q/2/stator.p*sim.poles - 1/2) )

gap.r1, gap.r2 = {},{}
gap.r1.x, gap.r1.y = rotate(gap.Rr,0, -90/rotor.p)
gap.r2.x, gap.r2.y = rotate(gap.r1.x,gap.r1.y, -- ...
  sim.poles*180/rotor.p)


-- resting position of the rotor with respect to s1
rotor.rest = 90/rotor.p - stator.alphas/2
-- # of simulated slots
sim.slots = stator.winding.Q/2/stator.p*sim.poles


-- compute transformation matrices --------------------
T_AB = gen_T_matrix(stator.winding.m)
U_abc = gen_U_matrix(stator.winding.m)




-- magnet shapes. 'Rectified' view
--         _________
-- trapz   \_______/
--         _________
-- rect   |_________|
--            ___ 
--         _--   --_
-- sin    |_________|