#!/bin/bash  
# previous command calls bash

# load script type
source type.sh

# get current date
DATE=$(date +%Y%m%d)_$(date +%H%M%S)
# get current directory
DIR=$(dirname $(readlink -f motor_data.lua))
DIRFFF="../3F"

# copy files and folder in the framework folder
\cp *.fem $DIRFFF # provide your own drawing
\cp motor_data.lua $DIRFFF/motor_data.lua # provide your motor_data
\cp materials_and_bc.lua $DIRFFF/materials_and_bc.lua # provide your materials
\cp -R input/ $DIRFFF # provide your overwriting inputs


cd $DIRFFF
# change directory to the framework one

wine femm33Mar/bin/femme.exe -lua-script="$TYPE.lua"
# previous command calls Wine which calls femme and starts $TYPE in this case

if [ "$TYPE" == "ANALYSIS" ]; then
  # copy results
  cp output/results.out $DIR/output/results.out
  cp $DIR/output/results.out $DIR/output/results_$DATE.out
  # copy temps
  cp temp.fem $DIR/temp.fem
  cp temp.ans $DIR/temp.ans
  # remove *.fem from framework folder
  rm *.fem ;
elif [ "$TYPE" == "DRAWING" ]; then
  cp *.fem $DIR/
  rm *.fem ;
else
  # copy results
  cp output/results.out $DIR/output/results.out
  cp $DIR/output/results.out $DIR/output/results_$DATE.out
  # copy temps
  cp temp.ans $DIR/temp.ans
  cp *.fem $DIR/
  rm *.fem ;
fi 


exec $SHELL
# previous command keeps icon opened
