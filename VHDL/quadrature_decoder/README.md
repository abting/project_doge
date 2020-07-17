# Quadrature Decoder

The quadrature decoder is a VHDL component that computes the angular direction, angular position and anglar speed of an incremental "quadrature" encoder.

## Architecture

As can be seen in its conceptual diagram in Figure 1 below, the quadrature decoder is composed of 3 internat component:
1. The direction and position computer (dir_pos_computer.vhd)
2. the speed computer (speed_computer.vhd)
3. and finally, the change detector (change_detector.vhd)

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/quadrature_encoder_decoder.png">

**Figure 1 - Conceptual Diagram of the Structural Architecture of the Quadrature Decoder**

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

**Figure 2 - State machine for the dir_pos_computer component**

When a state change is detected, the direction bit is pulled high for a CW rotation and pulled low for a CCW rotation.

#### Speed Computer
The Speed Computer is the component in charge of computing the angular speed of the encoder. It does so by sampling the change in position of the encoder every 1 mili-second. By default, a 16MHz clock is assumed to be available to the component.

As can be seen in Figure 3.1 below, the component is itself made up of 3 modules:
1. The clock timer,
2. the pulse timer, and finally,
3. a falling edge detector.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/speed_computer_struct_arch.png">

**Figure 3.1 - Conceptual Diagram of the Speed Computer Component**


The conceptual diagrams for the clock timer and the pulse timer are shown in Figure 3.2.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/speed_computer_internal_arch.png">

**Figure 3.2 - Conceptual Diagram of the Speed Computer Component's internal components**


The conceptual diagram of the falling edge detector is shown in Figure 4 below.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/neg_edge_detector.png">


**Figure 4 - Conceptual Diagram of the Falling Edge Detector**


#### Change Detector
The Change Detector is the component responsible for detecting a change in position. Whenever a change in position is detected, a pulse is produced to signal the event. The conceptual diagram of this component is shown in Figure 5 below.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/conceptual_diagrams/change_detector.png">


**Figure 5 - Conceptual Diagram of the Change Detector Component**

## Testbench
In this following testbench, the following is simulatied:
1. A 90 degree CW rotation completed at constant speed in 5 mili-seconds followed by
2. a 60 degree CCW rotation completed at constant speed in 2 mili-seconds.

### Assumptions
- Encoder Resolution: 24 PPR
- Change in position updated on rising and falling edges of both channels (each quarter of a pulse).
- Encoder is geared with the shaft of a motor with a gear ratio of 9.

Actual resolution: 24 x 4 x 9 = 864 quarter of a pulse per revolution (OR 3456 PPR).

### Overview

Figure 6 shows an overview of the similation. One can see 3 cursors at 1ms, 5ms, and 7ms. The cursor at 1ms is there to show that the speed is updated every 1ms. The cursor at 5ms shows the position of the encoder after 5ms which should be the equivalent of 90 degrees. The last cursor at 7ms is there to show the position of the encoder after 2ms following the 5ms mark where the encoder started rotating in a CCW motion for 60 degrees.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/testbenches/tb_waveform_results/Fig%206.png">

**Figure 6 - Testbench Overview**

### Speed
In Figure 6.1 below, it can be seen that after 1ms the encoder has rotated the equivalent of 43 quarters of a pulse (i.e. 17.92 degrees). The speed is shown to be updated to this number at the 1ms mark.

**Figure 6.1 - 1ms mark**

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/testbenches/tb_waveform_results/Fig%206_1.png">

### 90deg CW rotation for 5 ms
In Figure 6.2 below, it can be seen that just after the 5ms mark the position is 216 quarters of a pulse (i.e. 90degrees exactly). It should be noted that the position is updated AT the 5ms mark (documentation to follow for a detailed timing diagram of the position computer). Note that the speed is still 43 quarters of a pulse per milisecond.

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/testbenches/tb_waveform_results/Fig%206_3.png">

### 60deg CCW rotation for 2 ms
In Figure 6.3 below, it is shown that at the 7ms mark, the position is 72 quarters of a pulse. This is equivalent to 216 quarters of a pulse (i.e. 90deg) plus -144 quarters of a pulse (i.e. -60deg) or exactly 30 degrees. Note that the speed is 71 quarters of a pulse per ms just prior to the 7ms mark and 72 quarters of a pulse per ms just after. This is due to the imperfect simulation of the change of rotation as represented in channels A and B. Due to the method used in this testbench, one quarter of a pulse is lost right after the 5ms mark (see Figure 6.4 below).

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/testbenches/tb_waveform_results/Fig%206_4.png">
