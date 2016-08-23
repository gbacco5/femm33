# Structure
?! means not yet implemented
{text} means invisible

Linux:

    # 3Flin{.desktop} (Wine necessary) <-- {.run.sh} <-- type.sh
      * DRAWING
        + motor_data
        + materials_and_bc
        + drawing/stator
          - drawing/fun_draw_slot
        + drawing/rotor
          - drawing/SPM_rotor
        + drawing/airgap
         
      * ANALYSIS
        + some analysis
        + some post-processing

      * DRAWING+ANALYSIS
        * DRAWING
        * ANALYSIS


Windows:

    # 3Fwin{.lnk} <-- {.run.cmd} <-- type.sh
      [... same as before ...]


## DRAWING

### motor_data
All the motor and simulation data are defined here.
Make your changes here.

### materials_and_bc
Here are defined:

- materials
- boundary conditions

### drawing/stator
Launch the drawing of the stator. It may be external or
internal. It may have different slot shapes. It can be
complete or just a slice.

### drawing/rotor
- SPM
- ?!IPM
    + radial magnetisation
    + tangential magnetisation
- ?!REL
- ?!PMAREL
- ?!IM

### draw the air-gap
- common air-gap
- ?! discretised air-gap and magnet (also for radial magnetisation)



## ANALYSIS
Take the drawing and start processing.

### no-load analysis
For various rotor position it computes all the quantities. You can
compute the cogging torque and the no-load bemf.

If you perform this on 60°el, you can recover the complete behavior
of flux linkages through the use of the dq-transform.


### on-load analysis
Impose currents in the cicuits.
Typically the current is given in the dq reference frame.
Therefore dq --> AlphaBeta --> abc...m --> slots

Two current impositions:

1. sinusoidal through the dq transform
2. BLDC control
