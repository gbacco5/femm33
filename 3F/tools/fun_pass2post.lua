function pass2post(p2p)


phandle = openfile(folder.inp .. 'pass2post.lua','w')
for l,v in p2p do
  if type(v) == 'number' then
    write(phandle,l..'='..v..'\n')
  else
    write(phandle,l..'="'..v..'"\n')
  end
end
closefile(phandle)

end