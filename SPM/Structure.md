# Structure


## drawing

### motor_data

### drawing/stator

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
