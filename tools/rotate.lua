function rotate(x,y,th)
	local xx = x*cos(th) - y*sin(th)
	local yy = y*cos(th) + x*sin(th)
	return xx,yy
end