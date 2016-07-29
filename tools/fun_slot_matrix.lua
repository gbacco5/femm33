-- FUN_SLOT_MATRIX.LUA ================================
-- This function computes the slot matrix and the
-- a-axis alignment for any poli-phase circuit, given
--	- m, number of phases
-- 	- Q, number of slots
--	- p, number of pole pairs
--	- yq, coil throw, already chorded
--	- phase, phase sequence, e.g. {-2,1,-3,2,-1,3}
-- OUTPUT:
--	- K, slot matrix
--	- ADsfas, displacement of a-axis with respect to
-- 		the d-axis (assuming it 0 deg)
-- This function also exports a file K.lua to be read
-- with the usual 'dofile' command.
-- bg @2015/10/18
-- ====================================================

function slot_matrix(m,Q,p,yq,phase)
alphas = 360/Q
alphase = p*alphas
-- initialization -------------------------------------
a_axis = 0
K = {}
for i = 1,m do -- for every phase
	K[i] = {}
	for qq = 1,Q do -- for every slot
		K[i][qq] = 0
	end
end

-- slot matrix K computation --------------------------
for qq = 1,Q do -- for every slot
	vangle = (qq-1)*alphase
	-- keep vangle between 0 and 360
	if vangle >= 360 then
		vangle = vangle - 360*floor(vangle/360)
	elseif vangle < 0 then
		vangle = vangle + 360*ceil(vangle/360)
	end
	-- compute the closing coil side
	coil_return = qq + yq
	-- keep coil_return between the actual slots
	if coil_return > Q then
		coil_return = coil_return - Q
	end
	-- cycle initialization
	sector = 0 -- sector counter
	slot_found = 0 -- boolean
	while (sector < 2*m and slot_found == 0) do
		sector = sector + 1
		if vangle >= ((sector-1)*180/m) and vangle < (sector*180/m) then
			K[abs(phase[sector])][qq] = K[abs(phase[sector])][qq] + phase[sector]/abs(phase[sector])*0.5;
			--messagebox("q = "..qq.."  coil_return = "..coil_return)
			K[abs(phase[sector])][coil_return] = K[abs(phase[sector])][coil_return] - phase[sector]/abs(phase[sector])*0.5;
			slot_found = 1;
		end
	end
end


-- a-axis computation ---------------------------------
sumK = 0
-- this operation weights each angle by its slot matrix
-- coefficient.
for qq = 1,Q/p do
	a_axis =  a_axis + abs(K[1][qq]*(qq-1)*alphase)
	sumK = sumK + abs(K[1][qq])
end
-- a-axis is the angle of the magnetic axis, usually
-- the north pole. So we subtract 180deg to switch pole
-- and divide by p to get the mechanical angle.
ADsfas = (a_axis/sumK - 180)/p


-- export K.lua ---------------------------------------
handle = openfile("K.lua","w")
string_start = "K = {{\n";
string_mid = "\n},{\n";
string_end = "\n}}";
write(handle,string_start)
for mm = 1,m do
	for qq = 1,Q do
		write(handle,K[mm][qq])
		if qq ~= Q then
			write(handle,",")
		end
	end
	if mm ~= m then
		write(handle,string_mid)
	end
end
write(handle,string_end)
closefile(handle)

-- output
return K, ADsfas
end