-- AUTO.lua ###########################################

-- bg @2016/07/30
-- ####################################################

tipi_cava = {
  "squared",
  "round",
  "semiround",
  "roundsemi",
  "semiarc",
  "roundarc",
  "rounded"
}

for i = 1,getn(tipi_cava) do
  tipo = tipi_cava[i]

  handle = openfile(".\\input\\input.lua","w")
  write(handle, "stator.slot.shape = '" .. tipo .. "'")
  closefile(handle)

  dofile("DRAWING.lua")

end