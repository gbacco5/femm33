-- SUBROUTINE of post-processing ++++++++++++++++++++++
-- This subroutine computes the currents to impose in
-- the model based on the space vector PWM modulation.
-- REQUIREMENTS:
--  + sim.I
--  + sim.alpha_ie
--  + thme
--  + 'dq2ab' function
--  + 'prod' function
--  + 'U_abc' matrix, AlphaBeta --> abc...m
--
-- bg, 2016/08/15
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ensure everything is set up ------------------------
sim.I = sim.I or 0
sim.alpha_ie = sim.alpha_ie or 0
thme = thme or 0

-- compute currents -----------------------------------
i_d = sim.I*cos(sim.alpha_ie) -- [A], d-axis current
i_q = sim.I*sin(sim.alpha_ie) -- [A], q-axis current

i_A, i_B = dq2ab(i_d,i_q,thme) -- [A], Alpha,Beta-axes currents

i_ph = prod(U_abc, {i_A,i_B} ) -- [A], phase currents