# Quadrature Decoder

The quadrature decoder is a VHDL component that computes the angular direction, angular position and anglar speed of an incremental "quadrature" encoder.

## Architecture

As can be seen in its conceptual diagram in Figure 1 below, the quadrature decoder is composed of 3 internat component:
1. The direction and position computer (dir_pos_computer.vhd)
2. the spee computer (speed_computer.vhd)
3. and finally, the change detecro (change_detector.vhd)

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

### Direction and Position Computer
This component computes the angular direction of the rotation encoder (CW or CCW). It does so by looking at the state of channels A and B just before the rising or falling edge of the signal in channel A, and comparing it to the new state of said channels. It also calculates the angular position of the encoder by adding or subtracting from a counted immediately after a change in state. For a CW chage, the counter is incremented, and it is decremented for a CCW change

The conditions to determine CW and CCW rotation are:
  
| Direction     | Edge of A     | Previous State (A&B)  | Current State (A&B) |
| ------------- |:-------------:|:---------------------:|:-------------------:|
| CW            | Rising        | 01                    | 11                  |
| CW            | Falling       | 10                    | 00                  |
| CCW           | Rising        | 00                    | 10                  |
| CCW           | Falling       | 11                    | 01                  |

A caveat of the current architecture is that changes in position will only be detected after the encoder has travelled the angular distance equivalent to 1/2 of a pulse. For large PPR devices however, the angle associated with 1 pulse is usually on the order of 1/10 of a degree which in the scope of this project is an acceptable compromise in presicion.

In other words, the direction computer component is capable of detecting a change in direction within 1 pulse but not below 1/2 of a pulse.

To illustrate this, consider the following situation:

<img src="https://github.com/abting/project_doge/blob/p_carva/quadrature_decoder/VHDL/quadrature_decoder/testbenches/tb_waveform_results/direction_change_detection_testbench_waveform.png">

The direction of rotation is as follows:

| Time Interval | Direction |
|:-------------:|:---------:|
| 0ns - 20ns    | CW        |
| 20ns - 30ns   | CCW       |
| 30ns - 70ns   | CW        |
| 70ns - 110ns  | CCW       |
| 110ns - 130ns | CW        |

Notice that the change in direction at t=20ns is not captured by the component (i.e. the `direction` bit indicated a CW direction). This is because the next change in direction happens exactly at 30ns, or 10ns after the initial change: which is exactly 1/2 of a pulse in this scenario.

On the other hand, the change of direction at 70ns is caught after 10ns (1/2 a pulse) since the next change does not happen until t=110ns.

### Position Computer
### Speed Computer
