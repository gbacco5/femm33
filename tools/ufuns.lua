-- Useful FUNctionS -----------------------------------
-- This script contains some useful shortcut functions.
-- bg @2016/05/13
-------------------------------------------------------

function select_groupplus(gp, Q)
	local Q = Q or 0
	selectgroup(gp)
	for qq = 1,Q do
		selectgroup(gp + qq)
	end
	return
end


function groupplus_select_block(gp, Q)
	local Q = Q or 0
	groupselectblock(gp)
	for qq = 1,Q do
		groupselectblock(gp + qq)
	end
	return
end


function copy_table(t)
	v = {}
	for ind, val in t do
		v[ind] = val
	end
	return v
end

function unpack (t, i)
  i = i or 1
  if t[i] ~= nil then
    return t[i], unpack(t, i + 1)
  end
end



alphabet = {'a','b','c','d','e','f','g','h','i',
			'j','k','l','m','n','o','p','q','r',
			's','t','u','v','w','x','y','z'}


function load_slot_matrix()
	dofile("K.lua")
	Kprime = {}
	for qq = 1,getn(K[1]) do
		Kprime[qq] = {}
		for mm = 1,getn(K) do
			Kprime[qq][mm] = K[mm][qq]
		end
	end
	
	-- ka = {}
	-- kb = {}
	-- kc = {}
	-- for qqq = 1,Qs do
		-- ka[qqq] = K[1][qqq]
		-- kb[qqq] = K[2][qqq]
		-- kc[qqq] = K[3][qqq]
	-- end

	return Kprime
end



-- determine Scalar/Vector/Matrix
function svm(x)
	local tipo
	if type(x) == "number" then -- if scalar
		tipo = 0
	elseif type(x[1]) == "number" then -- if vector
		tipo = 1
		x.h = getn(x)
	else -- matrix
		tipo = 2
		x.h = getn(x)
		x.w = getn(x[1])
	end
	return tipo
end


-- function PROD --------------------------------------
function prod(A, B)
-- initialization
local Cmat = {}
A_svm = svm(A)
B_svm = svm(B)

-- check whether A is a number
if A_svm == 0 then
	if B_svm == 0 then -- B is a number
		return A*B -- scalar times scalar

	elseif B_svm == 1 then -- B is a vector
		for k = 1, B.h do
			Cmat[k] = A*B[k]
		end
		return C -- scalar times vector

	elseif B_svm == 2 then -- B is a matrix
		for k = 1, B.h do
			for h = 1, B.w do
				Cmat[k] = {}
				Cmat[k][h] = A*B[k][h]
			end
		end
		return Cmat -- scalar times matrix
	end

-- check whether A is a vector
elseif A_svm == 1 then
	if B_svm == 0 then -- B is a number
		for k = 1, A.h do
			Cmat[k] = A[k]*B
		end
	return Cmat -- vector times scalar

	elseif B_svm == 1 then
		local ccc = 0		
		if A.h == B.h then
			for k = 1, A.h do
				ccc = ccc + A[k]*B[k]
			end
		else
			error("Incompatible vector dimensions.")
			return
		end
		return ccc -- scalar product

	elseif B_svm == 2 then -- B is a matrix
		if A.h == B.h then 
			for k = 1, A.h do
				for h = 1, B.w do
					Cmat[h] = A[k]*B[k][h]
				end
			end
			return Cmat -- vector times matrix
		else
			error("Incompatible matrix/vector dimensions.")
			return
		end
	end

-- check whether A is a matrix
elseif A_svm == 2 then
	if B_svm == 0 then -- if B is a scalar
		for k = 1, A.h do
			for h = 1, A.w do
				Cmat[k] = {}
				Cmat[k][h] = A[k][h]*B
			end
		end
		return Cmat -- matrix times scalar

	elseif B_svm == 1 then
		if A.w == B.h then
			for k = 1, A.h do
				local somma = 0
				for h = 1, A.w do
					somma = somma + A[k][h]*B[h]
				end
				Cmat[k] = somma
			end
		else
			error("Incompatible matrix/vector dimensions.")
			return
		end
		return Cmat -- matrix times vector

	elseif B_svm == 2 then -- B is a matrix
		if A.w == B.h then 
			for k = 1, A.h do
				Cmat[k] = {}
				for h = 1, B.w do
					local somma = 0
					for l = 1, A.w do
						somma = somma + A[k][l]*B[l][h]
					end
					Cmat[k][h] = somma
				end
			end
			return Cmat -- matrix times matrix
		else
			error("Incompatible matrix/vector dimensions.")
			return
		end
	end

end

end









-- -- bg, 2016/05/13
-- function prod(A, B)
-- -- WARNING: This function works only for
-- --	- matrix * matrix
-- --	- matrix * vector
-- --	- vector * matrix
-- --	- vector * vector --> scalar product
-- -- So it is a limited function and it is not intended
-- -- to be a complete matrix product library.

-- -- initialization
-- local C = {}
-- local AA = {}
-- local BB = {}

-- -- check whether numbers
-- if type(A) == "number" and type(B) == "number" then
-- 	return A*B

-- -- check whether matrices
-- elseif type(A[1]) ~= "number" and type(B[1]) ~= "number" then
-- 	widA = getn(A[1])
-- 	heiB = getn(B)

-- 	heiA = getn(A)
-- 	widB = getn(B[1])
	
-- 	AA = A
-- 	BB = B
	
-- else
	
-- 	-- check whether A is a vector
-- 	if type(A[1]) == "number" then --> vector
-- 		widA = getn(A)
-- 		heiA = 1
-- 		AA[1] = A
-- 	else
-- 		widA = getn(A[1])
-- 		heiA = getn(A)
-- 		AA = A
-- 	end
	
-- 	-- check whether B is a vector
-- 	if type(B[1]) == "number" then --> vector
-- 		heiB = getn(B)
-- 		widB = 1
-- 		-- BBtemp[1] = B
		
-- 		-- transpose BB
-- 		for k = 1,heiB do
-- 			BB[k] = {}
-- 			BB[k][1] = B[k]
-- 		end
-- 	else
-- 		heiB = getn(B)
-- 		widB = getn(B[1])
-- 		BB = B
-- 	end
	
-- end

-- -- verify compatibility of product
-- if widA == heiB then
-- 	for i = 1,heiA do
-- 		C[i] = {}
-- 		for j = 1,widB do
-- 		acc = 0
-- 			for k = 1,widA do
-- 				acc = acc + AA[i][k]*BB[k][j]
-- 			end -- of for k
-- 		C[i][j] = acc
-- 		end -- of for j
-- 	end -- of for i
	
-- 	-- return compressed C if not a matrix
-- 	if getn(C[1]) == 1 then --> vector or number
-- 		if getn(C) == 1 then --> number
-- 			return C[1][1]
-- 		end
-- 		local D = {}
-- 		-- mistake here somewhere
-- 		if widB == 1 then
-- 			for k = 1,heiA do
-- 				D[k] = C[1][k]
-- 			end
-- 		else
-- 			for k = 1,heiB do
-- 				D[k] = C[k][1]
-- 			end
-- 		end

-- 		return D
-- 	else --> matrix
-- 		return C
-- 	end
	
-- else
-- 	error"incompatible matrices dimensions"
-- 	return
-- end -- of if

-- end -- of function






function gen_T_matrix(m)
-- This function generates the transformation matrix T,
-- used for obtaining the space vector given the phase
-- quantities. 
-- Note that the homopolar component is not taken into
-- consideration.
-- bg, 2016/06/04

local T = {}
T[1] = {}
T[2] = {}


for k = 1,m do
	T[1][k] = 2/m*cos((k-1)*360/m)
	T[2][k] = 2/m*sin((k-1)*360/m)
end

return T
end



function gen_U_matrix(m)
-- This function generates the inverse matrix, U, of
-- the transformation matrix T, used for obtaining the
-- space vector given the phase quantities. In addition
-- to that, the function can also output the imaginary
-- part matrix for getting the phasor of each phase
-- quantity, used in time-harmonic problems.
-- bg, 2016/06/04

local Ure, Uim = {},{}

for k = 1,m do
	Ure[k] = {cos((k-1)*360/m), sin((k-1)*360/m)}
	Uim[k] = {-sin((k-1)*360/m), cos((k-1)*360/m)}
end

return Ure,Uim
end



function dq2ab(id,iq,theta)
i_a,i_b = rotate(id,iq,theta)
return i_a,i_b
end
--
function ab2dq(i_a,i_b,theta)
id,iq = rotate(i_a,i_b,-theta)
return id,iq
end