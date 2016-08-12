TEMPLATE README ***************************************
bg, 2016/08/12
*******************************************************

You can make a copy of this folder in '../' and make it
your own. You can bring your own drawing in this
folder and use all the good stuff in '../3F/'.

!CAUTION: there are some constraints though.

  1. make sure you have modified accordingly 'motor_data.lua'
     (in particular the groups)
  
  2. make sure you provide the slot matrix in
     'input/K.lua', together with its transpose and the
     displacement angle between the a- and the d-axis.
     See '../3F/examples/K.lua' for an example.
     
  3. make sure the slots have increasing group number,
     starting from (stator.group + 1).
     
  4. for current sources in the slots either have a
     material for each slot (specify the material root
     name in 'motor_data.lua') or a circuit for each one
     (necessarily with the root "Islot_")
     
  5. Modify 'type.sh' variable TYPE in accordance with
     your purposes (specifically put 'ANALYSIS' given
     the fact that you already provide a drawing).
