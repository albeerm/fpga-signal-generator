# FPGA Signal Generator

This project uses VHDL and a Basys 3 FPGA board to generate a sinusoidal signal at different frequencies and pass it through two versions of a digital FIR filter.

## What the project does

The system generates an 8-bit sinusoidal signal using 16 stored samples in a ROM. Two switches are used to select between four output frequencies: approximately 500 Hz, 950 Hz, 2 kHz, and 4 kHz.

The generated signal is sent through two versions of the same FIR low-pass filter. One uses a parallel architecture, while the other uses a pipelined architecture. This makes it possible to compare the outputs and see the delay introduced by the pipelined design.

## Main features

- 8-bit sinusoidal signal generation
- 16-sample ROM lookup table
- Four selectable output frequencies
- Parallel FIR filter
- Pipelined FIR filter
- LED output for the generated signal
- Two 8-bit Pmod outputs for comparing the filters
- VHDL testbench for simulation
- Basys 3 pin constraints

## How it works

The signal generator reads through 16 stored sine-wave values. A counter controls how quickly the design moves to the next sample, and the selected counter limit determines the output frequency.

The top module sends the generated samples to both FIR filters at a 10 kHz sampling rate. Both filters use the same ten coefficients:

```text
0, 2, 9, 21, 31, 31, 21, 9, 2, 0
```

The parallel filter adds the multiplied samples through one direct path. The pipelined filter separates the calculations into multiple registered stages. This adds some delay but reduces the amount of work that has to happen during one clock cycle.

## Technologies used

- VHDL
- Basys 3 FPGA
- Vivado
- Digital signal processing
- ROM-based signal generation
- FIR filters
- Pipelining
- Testbenches and simulation

## Source code

The main VHDL files are located in:

```text
src/
```

The testbench is located in `sim/`, and the Basys 3 pin assignments are in `constraints/`.

## What I learned

This project helped me understand how signals can be generated digitally using a ROM and counters. I got more experience writing VHDL, connecting multiple modules, creating testbenches, and using Vivado for simulation and synthesis. I also learned the difference between parallel and pipelined hardware designs, including how pipelining can improve timing while using more registers and adding latency.
