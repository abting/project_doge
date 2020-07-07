# Quadrature Decoder

The quadrature decoder is a VHDL component that computes the angular direction, angular position and anglar speed of an incremental "quadrature" encoder.

## Architecture

As can be seen in its conceptual diagram in Figure 1 below, the quadrature decoder is composed of 3 internat component:
1. The direction and position computer (dir_pos_computer.vhd)
2. the speed computer (speed_computer.vhd)
3. and finally, the change detector (change_detector.vhd)

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/quadrature_encoder_decoder.png">
Figure 1 - Conceptual Diagram of the Structural Architecture of the Quadrature Decoder 

### Inputs
The quadrature decoder taken in the following inputs:
- The quadrature signal of the incremental decoder,
- the Z_index channel (where applicable) of the incremental decoder,
- a global reset (asserted) signal,
- and a global clock signal.

### Outputs
The quadrature decoder has 3 different outputs:
- The direction of rotation (1-bit number): 1, when A leads B; 0 when B leads A,
- the speed of rotation (unsigned 32-bit number) in 1/4 of a pulse (of channel A or B) per milisecond,
- and the position in (signed 13-bit number) 1/4 of a pulse (of channel A or B);

### Components

#### Direction and Position Computer
This component computes the angular direction of the encoder (CW or CCW). It does so by looking at the state of channels A and B as shown in Fig 2 below. It also calculates the angular position of the encoder by adding or subtracting from a counted immediately after a change in state. For a CW chage, the counter is incremented, and it is decremented for a CCW change

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/dir_pos_computer.png">
Figure 2 - State machine for the dir_pos_computer component

When a state change is detected, the direction bit is pulled high for a CW rotation and pulled low for a CCW rotation.

#### Speed Computer
#### Change Detector
