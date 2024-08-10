# Spartan6 - DSP48A1 Repository
* The Spartan-6 family is known for its high ratio of DSP48A1 slices to logic resources, making it well-suited for math-intensive applications.
* This repository provides Verilog code for the DSP48A1's RTL implementation on a Spartan-6 FPGA, along with a testbench to ensure the design meets the required specifications.

## Contents
The repository includes the following files:

1. DSP.v: Verilog code for the RTL implementation of the DSP48A1 in a Spartan-6 FPGA (Top Module).
   
2. reg_mux_pair.v: Verilog code for a register and multiplexer pair, instantiated within the top module (Lower Module).
   
3. TB_DSP.v: Verilog testbench for the DSP48A1 in the Spartan-6 FPGA.

4. jo.do: DO file for automating Questa-Sim (or ModelSim). This file compiles the Verilog code, runs the simulation, and adds signals to the waveform.
