# FPGA Signal Generator

A VHDL signal-generation and digital-filtering project implemented for the **Basys 3 FPGA board**. The design generates an 8-bit sinusoidal waveform from a 16-sample ROM and processes it through two implementations of a 10-tap FIR low-pass filter.

## Features

- 16-sample, 8-bit sinusoidal lookup table
- Four switch-selectable output frequencies
- Parallel FIR filter implementation
- Pipelined FIR filter implementation
- Simultaneous output comparison through two 8-bit Pmod interfaces
- LED display of the raw signed waveform samples
- VHDL testbench covering every frequency selection

## Design overview

`genSen.vhd` generates the waveform using a ROM and a programmable sample counter. The two-bit `per` input selects the counter limit:

| `per` | Counter limit | Approximate output frequency |
|---|---:|---:|
| `00` | 12,499 | 500 Hz |
| `01` | 6,579 | 950 Hz |
| `10` | 3,124 | 2 kHz |
| `11` | 1,562 | 4 kHz |

The `top.vhd` module samples the generated signal at 10 kHz and sends it to both FIR implementations. Both filters use the symmetric coefficients:

```text
0, 2, 9, 21, 31, 31, 21, 9, 2, 0
```

The parallel implementation forms a direct accumulation chain. The pipelined implementation divides multiplication and addition across registered stages, trading additional latency and resources for a shorter critical path.

## Repository structure

```text
.
├── constraints/
│   └── Basys-3-Master.xdc
├── sim/
│   └── tb_top.vhd
└── src/
    ├── filter.vhd
    ├── filter_pipeline.vhd
    ├── genSen.vhd
    └── top.vhd
```

## Hardware mapping

- `tClk`: Basys 3 100 MHz clock
- `tReset`: switch SW0
- `tper[1:0]`: switches SW2–SW1
- `tled[7:0]`: LEDs LD7–LD0
- `tdac[7:0]`: Pmod JB, parallel-filter output
- `tdac_pipe[7:0]`: Pmod JC, pipelined-filter output

## Running the project in Vivado

1. Create a new RTL project targeting the Basys 3 board.
2. Add every VHDL file from `src/` as a design source.
3. Set `top` as the synthesis top module.
4. Add `sim/tb_top.vhd` as a simulation source.
5. Set `tb_top` as the simulation top module.
6. Add `constraints/Basys-3-Master.xdc` as a constraint file.
7. Run behavioral simulation, synthesis, implementation, and bitstream generation.

The testbench uses a 10 ns clock period and cycles through all four `per` selections.
