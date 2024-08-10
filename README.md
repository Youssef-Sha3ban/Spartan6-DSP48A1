# Spartan6 - DSP48A1 Repository
* The Spartan-6 family offers a high ratio of DSP48A1 slices to logic, making it ideal for math-intensive applications.
* This repository contains Verilog code for the RTL implementation of the DSP48A1 in a Spartan-6 FPGA, as well as a Verilog testbench to verify that it meets the required specifications.

## Contents
The repository includes the following files:

1. DSP.v: The Verilog code for the RTL implementation of the DSP48A1 in a Spartan-6 FPGA (Top Module).
   
2. reg_mux_pair.v: The Verilog code for a register and multiplexer pair, which is instantiated in the top module (Lower Module).

3. TB_DSP.v: The Verilog testbench for the Spartan6 - DSP48A1.

4. jo.do: DO file to automate Questa-Sim(or ModelSim), which compiles the Verilog files, runs the simulation, and adds the signals to the waveform.
