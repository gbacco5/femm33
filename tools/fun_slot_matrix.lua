-- FUN_SLOT_MATRIX.LUA ================================
-- This function computes the slot matrix and the
-- a-axis alignment for any poli-phase circuit, given
--  - m, number of phases
--  - Q, number of slots
--  - p, number of pole pairs
--  - yq, coil throw, already chorded
--  - phase, phase sequence, e.g. {-2,1,-3,2,-1,3}
-- OUTPUT:
--  - K, slot matrix
--  - ADsfas, displacement of a-axis with respect to
--    the d-axis (assuming it 0 deg)
-- This function also exports a file K.lua to be read
-- with the usual 'dofile' command.
--
-- bg, 2016/08/06
-- ====================================================

function slot_matrix(m,Q,p,yq,phase, folder)
local alphas = 360/Q
local alphase = p*alphas
-- initialization -------------------------------------
local a_axis = 0
local K = {}
for qq = 1,Q do -- for every slot
  K[qq] = {}
  for i = 1,m do -- for every phase
    K[qq][i] = 0
  end
end

-- slot matrix K computation --------------------------
for qq = 1,Q do -- for every slot
  local vangle = (qq-1)*alphase
  -- keep vangle between 0 and 360
  if vangle >= 360 then
    vangle = vangle - 360*floor(vangle/360)
  elseif vangle < 0 then
    vangle = vangle + 360*ceil(vangle/360)
  end
  -- compute the closing coil side
  local coil_return = qq + yq
  -- keep coil_return between the actual slots
  if coil_return > Q then
    coil_return = coil_return - Q
  end
  -- cycle initialization
  local sector = 0 -- sector counter
  local slot_found = 0 -- boolean
  while (sector < 2*m and slot_found == 0) do
    sector = sector + 1
    if vangle >= ((sector-1)*180/m) and vangle < (sector*180/m) then
      K[qq][abs(phase[sector])] = K[qq][abs(phase[sector])] + phase[sector]/abs(phase[sector])*0.5;
      K[coil_return][abs(phase[sector])] = K[coil_return][abs(phase[sector])] - phase[sector]/abs(phase[sector])*0.5;
      slot_found = 1;
    end
  end
end


-- a-axis computation ---------------------------------
local sumK = 0
-- this operation weights each angle by its slot matrix
-- coefficient.
for qq = 1,Q/p do
  a_axis =  a_axis + abs(K[qq][1]*(qq-1)*alphase)
  sumK = sumK + abs(K[qq][1])
end
-- a-axis is the angle of the magnetic axis, usually
-- the north pole. So we subtract 180deg to switch pole
-- and divide by p to get the mechanical angle.
ADsfas = (a_axis/sumK - 180)/p


-- export K.lua ---------------------------------------
handle = openfile(folder .. "K.lua","w")
local string_start = "Kt = {{\n";
local string_start_2 = "K = {{\n";
local string_mid = "\n},{\n";
local string_end = "\n}}\n\n";
write(handle,string_start)
for mm = 1,m do
  for qq = 1,Q do
    write(handle,K[qq][mm])
    if qq ~= Q then
      write(handle,",")
    end
  end
  if mm ~= m then
    write(handle,string_mid)
  end
end
write(handle,string_end)
write(handle,string_start_2)
for qq = 1,Q do
  for mm = 1,m do
    write(handle,K[qq][mm])
    if mm ~= m then
      write(handle,",")
    end
  end
  if qq ~= Q then
    write(handle,string_mid)
  end
end
closefile(handle)

-- output
return K, ADsfas
end