#!/bin/bash  
# previous command calls bash
# cd ..
# previous command change directory of execution
wine ../femm33Mar/bin/femme.exe -lua-script="ANALYSIS.lua"
# previous command calls Wine which calls femme and starts DRAWING in this case
exec $SHELL
# previous command keeps icon opened
