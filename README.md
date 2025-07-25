## *Overview*
This repository contains the design and implementation of a Combination Lock using a Finite State Machine (FSM) in Verilog, as part of the ASIC design flow. The lock handles input sequences for unlocking, with error detection and reset functionality.

## *Introduction:*
The project presents a combination lock FSM with states such as S_reset, S_open, S_error, and transitions based on inputs/outputs.

<img src="https://github.com/tusharc01/Combinational_lock/blob/main/lock.png">

## *FSM Design*
The FSM is based on a state diagram specifying states, transitions, unlock sequence (e.g., 1-2-3-4), error on wrong input, and outputs like "unlock" or "error".

## *Implementation Steps*
The design follows the ASIC flow with these key steps (completed ones marked):

__1. Specification:__ Define design behavior (e.g., FSM diagram specifying states, transitions, unlock sequence like 1-2-3-4, error handling, reset conditions). *Done.*

__2. RTL Design:__ Translate spec to Verilog RTL with FSM in two always blocks. Focus on functionality, not gates or timing. *Done.*  
   It is implemented using combinational and sequential logic in two always blocks for robustness:  
   - One always block for sequential logic (handling state transitions on clock edges with sensitivity to posedge clk).  
   - Another for combinational logic (computing next states or outputs based on current state and inputs, with sensitivity to * for all changes).  
   This separation improves maintainability, debuggability, and synthesis quality, reducing issues like inferred latches or timing problems.

__3. RTL Verification:__ Simulate the RTL code using Cadence tools to verify functionality against the specification. *Done.*  
   - Used nclaunch for multi-step simulation processes and irun for streamlined, one-click combined simulation.  
   - Viewed simulation outputs and waveforms in Simvision for debugging. SimVision is a dedicated waveform viewer and debugger tool in Cadence's Incisive/Xcelium simulation suite, used for visualizing and analyzing simulation results (like signal waveforms, values over time, and debugging hierarchies) in a graphical interface. It's a standalone tool for waveform viewing, often launched or integrated as part of the simulation workflow.  
     - Access via nclaunch: nclaunch is a GUI-based launcher for setting up and running Cadence simulations (compiling, elaborating, and simulating Verilog/VHDL designs). It can directly invoke SimVision to display waveforms after simulation, or you can send signals from the nclaunch design browser to a SimVision waveform window for viewing.  
     - Access via irun: irun is a command-line utility for streamlined, single-step simulation invocation (compiling, elaborating, and running in one go). You can run it with options like -gui to open a graphical interface, which often includes or leads to SimVision for waveform viewing and debugging (e.g., irun -gui your_design.v would simulate and allow waveform inspection in SimVision).  
   - Performed linting to check for errors and warnings, generating a log file (e.g., hal.log) for analysis. Errors were corrected based on identified issues to ensure clean, robust code.

__4. Code Coverage:__ Analyze testbench effectiveness using the IMC (Incisive Metrics Center) tool to measure how thoroughly simulations exercise the RTL code. *Done.*  
   - Evaluated metrics such as statement coverage, branch coverage, toggle coverage, and condition coverage.  
   - Identified uncovered code sections and refined the testbench to achieve higher coverage percentages, ensuring comprehensive verification.

