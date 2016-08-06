-- MATERIALS.lua ======================================
-- This script defines the materials used in the
-- simulations and the mesh size for every kind of block.
-- bg @2015/11/27
-- ====================================================

-- Mesh sizes -----------------------------------------
mesh_gap = g/3 --> airgap, to have at least 3 elements
mesh_fe  = 3 --> iron
mesh_air = 1 --> mesh air
mesh_barrier = 3 --> mesh air
mesh_pm  = 5 --> permanent magnet
mesh_shaft = mesh_fe --> shaft

mesh = {
  gap = g/3,
  fe = 3,
  cu = 2,
  air = 1,
  pm = 3,
  -- shaft = 
  -- barrier = 
}


-- Problem definitions --------------------------------
probdef(0, "millimeters", "planar", 1E-8, stator.L);
hidegrid();
--pause()

-- Materials definitions ------------------------------
-- Air
addmaterial("Air", 1, 1, 0, 0, 0, 0, 0, 0, 1, 0);
-- Copper
addmaterial("Cu", 1, 1, 0, 0, 0, 54, 0, 0, 1, 0);
-- Iron
addmaterial("Iron", 5000, 5000, 0, 0, 0, 0, 0, 0, 1, 0);
-- ideal Iron
addmaterial("iIron", 1e6, 1e6, 0, 0, 0, 0, 0, 0, 1, 0);
-- Magnet
addmaterial("Magnet", 1.08, 1.08, 666800, 0, 0, 0.667, 0, 0, 1, 0);
-- Stator copper
sigma_Cu = 0 -- [MS/m], from Alberti, to have no skin effect
-- Rotor Aluminum
sigma_Al_r = 15 -- [MS/m] @ 120K, from Alberti


-- Terni Iron -- non-linear
addmaterial("Terni",  7000, 7000, 0, 0, 0, 3, 0, 0, 1, 0);
-- Terni BH curve
addbhpoint("Terni", 0.00,  0);
addbhpoint("Terni", 0.40,  75);
addbhpoint("Terni", 0.52,  85);
addbhpoint("Terni", 0.57,  90);
addbhpoint("Terni", 0.65,  100);
addbhpoint("Terni", 0.70,  110);
addbhpoint("Terni", 0.80,  125);
addbhpoint("Terni", 0.90,  145);
addbhpoint("Terni", 0.95,  160);
addbhpoint("Terni", 1.00,  170);
addbhpoint("Terni", 1.05,  185);
addbhpoint("Terni", 1.10,  200);
addbhpoint("Terni", 1.18,  250);
addbhpoint("Terni", 1.25,  300);
addbhpoint("Terni", 1.30,  360);
addbhpoint("Terni", 1.33,  400);
addbhpoint("Terni", 1.37,  500);
addbhpoint("Terni", 1.40,  600);
addbhpoint("Terni", 1.43,  700);
addbhpoint("Terni", 1.47,  900);
addbhpoint("Terni", 1.48,  1000);
addbhpoint("Terni", 1.54,  1500);
addbhpoint("Terni", 1.58,  2000);
addbhpoint("Terni", 1.605, 2500);
addbhpoint("Terni", 1.63,  3000);
addbhpoint("Terni", 1.67,  4000);
addbhpoint("Terni", 1.70,  5000);
addbhpoint("Terni", 1.74,  6000);
addbhpoint("Terni", 1.78,  8000);
addbhpoint("Terni", 1.81,  10000);
addbhpoint("Terni", 1.88,  15000);
addbhpoint("Terni", 1.93,  20000);
addbhpoint("Terni", 2.00,  30000);
addbhpoint("Terni", 2.004, 33000);
addbhpoint("Terni", 2.075, 90000);
addbhpoint("Terni", 3.000, 1335600);  

-- Boudary conditions
addboundprop("Azero",0,0,0,0,0,0,0,0,0);

for l = 1,5 do -- 5 should be adaptive
  addboundprop("Az_per".. l,0,0,0,0,0,0,0,0,--...
    0.5*(-1)^(sim.poles+1) + 4.5 )
   -- 4 is for periodic, 5 for antiperiodic
end

-- ====================================================
