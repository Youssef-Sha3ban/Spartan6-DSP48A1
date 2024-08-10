# Spartan6 - DSP48A1 Repository
* The Spartan-6 family is known for its high ratio of DSP48A1 slices to logic resources, making it well-suited for math-intensive applications.
* This repository provides Verilog code for the DSP48A1's RTL implementation on a Spartan-6 FPGA, along with a testbench to ensure the design meets the required specifications.

## Contents
* A detailed report outlining the design procedure, verification using the testbench, and FPGA design flow using Xilinx Vivado.

* "Codes" folder contains the following files:

   * DSP.v: Verilog code for the RTL implementation of the DSP48A1 in a Spartan-6 FPGA (Top Module).
   
   * reg_mux_pair.v: Verilog code for a register and multiplexer pair, instantiated within the top module (Lower Module).
   
   * TB_DSP.v: Verilog testbench for the DSP48A1 in the Spartan-6 FPGA.

   * jo.do: DO file for automating Questa-Sim (or ModelSim). This file compiles the Verilog code, runs the simulation, and adds signals to the waveform.
