# Quadrature Decoder

The quadrature decoder is a VHDL component that computes the angular direction, angular position and anglar speed of a incremental "quadrature" encoder.

## Architecture

The quadrature decoder is made up of 4 different internal blocks, each a VHDL component:
- previous_state_register.vhd
- direction_computer.vhd
- position_computer.vhd
- speed_computer.vhd

### Conceptual diagrams
- [quadrature decoder structural architecture](conceptual_diagrams/quadrature_decoder_conceptual_diagram.png)
- [previous state register](conceptual_diagrams/quadrature_decoder_conceptual_diagram_previous_state_register.png)
- [direction computer](conceptual_diagrams/quadrature_decoder_conceptual_diagram_direction_computer.png)
- [position computer](conceptual_diagrams/quadrature_decoder_conceptual_diagram_position_computer.png)
- [speed computer](conceptual_diagrams/quadrature_decoder_conceptual_diagram_speed_computer.png)

### Previous State Register
This component computes the state of channels A and B on the encoder prior to a rising of falling edge of the signal in channel A.

### Direction Computer
This component computes the angular direction of the rotation encoder (CW or CCW). It does so by looking at the state of channels A and B just before the rising or falling edge of the signal in channel A, and comparing it to the new state of said channels.

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

Notice that the change in direction at t=20ns is not captured by the component (i.e. the `dir` bit indicated a CW direction). This is because the next change in direction happens exactly at 30ns, or 10ns after the initial change: which is exactly 1/2 of a pulse in this scenario.

On the other hand, the change of direction at 70ns is caught after 10ns (1/2 a pulse) since the next change does not happen until t=110ns.

### Position Computer
### Speed Computer
