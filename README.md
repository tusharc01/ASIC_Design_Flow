## *Overview*
This repository contains the design and implementation of a Combination Lock using a Finite State Machine (FSM) in Verilog, as part of the ASIC design flow. The lock handles input sequences for unlocking, with error detection and reset functionality.

## *Introduction:*
The project presents a combination lock FSM with states such as S_reset, S_open, S_error, and transitions based on inputs/outputs.

<p align="center">
  <img src="https://github.com/tusharc01/Combinational_lock/blob/main/lock.png" alt="FSM State Diagram" width="500"/>
</p>


## *FSM Design*
The FSM is based on a state diagram specifying states, transitions, unlock sequence (e.g., 1-2-3-4), error on wrong input, and outputs like "unlock" or "error".

## *Implementation Steps*
The design follows the ASIC flow with these key steps (completed ones marked):

__1. Specification:__ Define design behavior (e.g., FSM diagram specifying states, transitions, unlock sequence like 1-2-3-4, error handling, reset conditions). *Done.*

__2. Logic Design:__ Translate spec to Verilog RTL with FSM in two always blocks. Focus on functionality, not gates or timing. *Done.*  
   It is implemented using combinational and sequential logic in two always blocks for robustness:  
   - One always block for sequential logic (handling state transitions on clock edges with sensitivity to posedge clk).  
   - Another for combinational logic (computing next states or outputs based on current state and inputs, with sensitivity to * for all changes).  
   This separation improves maintainability, debuggability, and synthesis quality, reducing issues like inferred latches or timing problems.

__3. Functional Verification:__ Simulate the RTL code using Cadence tools to verify functionality against the specification. *Done.*  
   - Used nclaunch for multi-step simulation processes and irun for streamlined, one-click combined simulation.  
   - Viewed simulation outputs and waveforms in Simvision for debugging. SimVision is a dedicated waveform viewer and debugger tool in Cadence's Incisive/Xcelium simulation suite, used for visualizing and analyzing simulation results (like signal waveforms, values over time, and debugging hierarchies) in a graphical interface. It's a standalone tool for waveform viewing, often launched or integrated as part of the simulation workflow.  
     - Access via nclaunch: nclaunch is a GUI-based launcher for setting up and running Cadence simulations (compiling, elaborating, and simulating Verilog/VHDL designs). It can directly invoke SimVision to display waveforms after simulation, or you can send signals from the nclaunch design browser to a SimVision waveform window for viewing.  
     - Access via irun: irun is a command-line utility for streamlined, single-step simulation invocation (compiling, elaborating, and running in one go). You can run it with options like -gui to open a graphical interface, which often includes or leads to SimVision for waveform viewing and debugging (e.g., irun -gui your_design.v would simulate and allow waveform inspection in SimVision).  
   - Performed linting to check for errors and warnings, generating a log file (e.g., hal.log) for analysis. Errors were corrected based on identified issues to ensure clean, robust code.

__4. Code Coverage:__ Analyze testbench effectiveness using the IMC (Incisive Metrics Center) tool to measure how thoroughly simulations exercise the RTL code. *Done.*  
   - Evaluated metrics such as statement coverage, branch coverage, toggle coverage, and condition coverage.  
   - Identified uncovered code sections and refined the testbench to achieve higher coverage percentages, ensuring comprehensive verification.


__5. Logic Synthesis:__ Convert RTL to gate-level netlist using Cadence Genus tool, viewed in GUI. *Done.*  
   - Incorporated typical library files for predefined gates (using the 65nm technology node), the design file, and a constraint file.  
   - Performed elaboration of RTL design to generate an initial unstandard schematic.  
   - Applied synthesize command to translate logic using standard gates, incorporating delays based on constraints, visible in the Genus GUI schematic.  
   - Generated the netlist in Verilog format directly from Genus.  
   - Constraints include: time unit definition, clock creation, clock uncertainty, input delays, output delays, driving cells, load capacitance, operating conditions. [Constraint File](https://github.com/tusharc01/Combinational_lock/blob/main/Synthesis/with_Constraints/lock_sdc.sdc)


__6. Formal Verification (LEC):__ Verify functional equivalence between the original RTL (golden design) and the synthesized netlist (revised design) using Cadence Conformal tool for Logic Equivalence Checking (LEC). *Done.*  
   - Compared golden (RTL) and revised (netlist) designs to ensure no logical discrepancies were introduced during synthesis.  
   - Analyzed reports for key metrics including equivalence points, mapped points, non-equivalent points, unmapped logic, warnings, and errors.  
   - Resolved any identified issues (e.g., non-equivalences or unmapped elements) to confirm 100% logical match, including adjusting synthesis constraints or directives to prevent unwanted optimizations (e.g., retiming or logic restructuring) that alter the netlist structure, and fixing RTL issues like uninitialized variables or ambiguous logic that synthesis interprets differently.

__7. Power Analysis:__ Estimate internal, dynamic (switching), and static (leakage) power consumption based on the synthesized netlist and switching activity, using Cadence Genus for early, quick estimation during or right after synthesis and Synopsys Design Vision for post-synthesis analysis as a standalone step. *Done.*  
   - Generated reports directly in Genus via commands like `report_power` without always needing external files, using internal estimators for the following power types:  
     - **Internal power**: Dissipated within logic cells during operation, often due to short-circuit currents when transistors switch states, depending on cell internals like voltage and frequency.  
     - **Dynamic power (switching power)**: Consumed when signals toggle, charging/discharging capacitances, calculated as P = 0.5 * C * V² * f * α (where C is capacitance, V is voltage, f is frequency, and α is switching activity).  
     - **Static power (leakage power)**: Constantly leaked through transistors even when idle, mainly due to subthreshold leakage and gate oxide tunneling in 65nm nodes, increasing with temperature.  
   - Generated VCD file during simulation using SimVision by mentioning VCD generation syntax in the testbench, or alternatively using Verdi; then converted VCD to SAIF (Switching Activity Interchange Format) for efficient activity summarization in power analysis, as SAIF is more compact than VCD by summarizing toggle rates instead of storing every timestamped change, reducing file size and processing time for large designs.  
   - In Design Vision, loaded netlist, read SAIF file (e.g., via `read_saif`), and ran power analysis commands (e.g., `report_power`) to annotate switching activity from SAIF onto the design, computing internal, dynamic, and static power with results output to a report file (e.g., .txt or .rpt) for review.  
   - Note: Though Synopsys PrimePower is a dedicated power analysis tool (not primarily for synthesis) that excels at RTL-to-signoff power estimation, it was not used in this project.
