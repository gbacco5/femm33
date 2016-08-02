# Structure

Linux:    # 0.RUN.sh (Wine necessary)
Windows:  # 0.RUN.cmd
            * DRAWING
              + motor_data
              + materials_and_bc
              + drawing/stator
                - drawing/fun_draw_slot
              + drawing/rotor
                - drawing/SPM_rotor
              + drawing/airgap
              
            * ANALYSIS
              + (DRAWING)
              + some analysis
              + some post-processing


## drawing

### motor_data
All the motor and simulation data are defined here.
Make your changes here.

### materials_and_bc
Here are defined:
- materials
- mesh sizes
- boundary conditions

### drawing/stator
Launch the drawing of the stator. It may be external or
internal. It may have different slot shapes. It can be
complete or just a slice.

### drawing/rotor

### draw the air-gap
- common air-gap
- discretised air-gap and magnet (also for radial magnetisation)



## analyses
Take the drawing and start processing.
If the drawing does not exist, launch it.

### no-load analysis


### on-load analysis
Impose currents in the cicuits.
Typically the current is given in the dq reference frame.
Therefore dq --> AlphaBeta --> abc...m --> slots
           T_dq^AB     T_AB^a...m       K
