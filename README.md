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

__7. Static Timing Analysis (STA):__ Analyze timing paths in the synthesized netlist using Cadence Tempus tool to ensure the design meets required clock frequency specifications, checking for setup and hold violations influenced by factors like clock skew (timing differences between clock paths), uncertainty (jitter and skew margins), jitter (clock edge variations), and logic delays (propagation times through gates and interconnects). *Done.*  
   - Loaded synthesized netlist, timing libraries, and constraints into Tempus GUI; performed analysis to generate setup and hold reports, where positive slack indicates timing is met and negative slack results in violations (e.g., setup violations from late-arriving signals, hold violations from early-changing signals).  
   - Identified and fixed violations by remodifying constraints (e.g., adjusting clock periods, input/output delays, or uncertainty values) to account for skew, jitter, and delay effects.  
   - Repeated synthesis with updated constraints, then re-ran STA to verify all timing paths are met with positive slack, ensuring reliable operation at the specified clock frequency through static delay estimation of each design element without dynamic simulation.  
   - **Note**: STA is conducted at a specific operating frequency defined by the design team or system architect based on application requirements (e.g., performance, power, or throughput needs); while the client (user) demands the overall design, the frequency is decided and fixed iteratively by the designer through constraints optimization and STA validation to balance feasibility and specifications.

__8. Power Analysis:__ Estimate internal, dynamic (switching), and static (leakage) power consumption based on the synthesized netlist and switching activity, using Cadence Genus for early-stage power estimation (rough power estimations done at the RTL or architectural level to guide design decisions related to power consumption), quick estimation during or right after synthesis and Synopsys Design Vision for post-synthesis analysis (initial power analysis on the synthesized netlist using library data and estimated switching activity or VCD/SAIF files) as a standalone step. *Done.*  
   - Generated reports directly in Genus via commands like `report_power` without always needing external files, using internal estimators for the following power types:  
     - **Internal power**: Dissipated within logic cells during operation, often due to short-circuit currents when transistors switch states, depending on cell internals like voltage and frequency.  
     - **Dynamic power (switching power)**: Consumed when signals toggle, charging/discharging capacitances, calculated as P = 0.5 * C * V² * f * α (where C is capacitance, V is voltage, f is frequency, and α is switching activity).  
     - **Static power (leakage power)**: Constantly leaked through transistors even when idle, mainly due to subthreshold leakage and gate oxide tunneling in 65nm nodes, increasing with temperature.  
   - Generated VCD file during simulation using SimVision by mentioning VCD generation syntax in the testbench, or alternatively using Verdi; then converted VCD to SAIF (Switching Activity Interchange Format) for efficient activity summarization in power analysis, as SAIF is more compact than VCD by summarizing toggle rates instead of storing every timestamped change, reducing file size and processing time for large designs.  
   - In Design Vision, loaded netlist, read SAIF file (e.g., via `read_saif`), and ran power analysis commands (e.g., `report_power`) to annotate switching activity from SAIF onto the design, computing internal, dynamic, and static power with results output to a report file (e.g., .txt or .rpt) for review.  
   - Note: Though Synopsys PrimePower is a dedicated power analysis tool (not primarily for synthesis) that excels at RTL-to-signoff power estimation, it was not used in this project.  
   - **Note (for knowledge)**: Post-Layout Power Analysis (after Placement and Routing) involves more detailed and accurate analysis, including dynamic and static power, performed after placement and routing when detailed parasitic information (RC extraction) is available; designers can refine power delivery networks based on power analysis results.

__9. Physical Design:__ Implement the layout of the synthesized netlist using Cadence Innovus tool, following key steps to transform the gate-level design into a physical chip representation ready for fabrication. *Done.*  

   - **Pre-Physical Design Preparation**: Before starting physical design in Innovus, prepared essential input files including:  
     - **Gate-Level Netlist**: The synthesized netlist (from lock.v RTL) to understand the circuit's structure.  
     - **Pre-PnR Synthesis (Using Multiple Libraries - Multi-Corner)**: Performed advanced synthesis using technology libraries (.lib files) for different Process, Voltage, and Temperature (PVT) corners to ensure robustness:  
       - Worst-Case Setup (e.g., _ss.lib, _max.lib): Slow Process, Low Voltage, High Temperature; used for checking maximum path delays (setup timing).  
       - Best-Case Hold (e.g., _ff.lib, _min.lib): Fast Process, High Voltage, Low Temperature; used for checking minimum path delays (hold timing).  
     - **Why Multiple Libraries?**: Accounts for real-world PVT variations to ensure the chip functions correctly across conditions; enables timing closure by optimizing for both slow (setup violations) and fast (hold violations) extremes, unlike initial synthesis which uses only a "Typical" (.lib) library for nominal conditions (faster but less robust).  
     - **Initial vs. Pre-PnR Netlist**: Initial synthesis focuses on basic typical timing (faster process, functionally correct but roughly optimized); Pre-PnR provides robust setup/hold closure across corners (slower, more complex optimization, PnR-ready).  
     - **Synthesis Process**: Automated via TCL script in Cadence Genus, which reads RTL, realizes logical structure, applies constraints, performs technology-independent optimization, maps to specific technology libraries, and conducts timing-driven optimization.  
     - **Timing Libraries Used**: Included _ss (Slow-Slow) and _max for setup analysis (worst-case delay), _ff (Fast-Fast) and _min for hold analysis (best-case delay); these provide timing (delay, setup, hold), power, and functional characteristics of standard cells (e.g., AND, OR, Flip-Flops) and I/O pads, used during mapping/optimization and matched in Innovus MMMC setup for consistent timing-driven operations.  
     - **Timing Constraints**: Loaded from SDC file (e.g., lock_sdc.sdc) defining clock periods, waveforms, input/output delays, timing exceptions (false/multicycle paths), and design rules (max transition/capacitance); used to guide optimization with internal path_adjust commands for added margin.  
     - **MMMC Setup in Innovus**: Multi-Mode Multi-Corner (MMMC) analysis setup, which defines multiple operating modes (e.g., functional vs. test) and PVT corners for comprehensive timing, power, and signal integrity analysis; it integrates the multi-corner libraries and constraints to ensure the design meets requirements across variations, as referenced in the tool's configuration (e.g., setup scripts or GUI screenshots from the project PDF, indicating specific corner definitions and library paths).  
       - **Multiple Modes**: These modes represent various ways the circuit might function in real-world use, each with its own set of timing constraints, clock definitions, or power states. For example:  
         - Functional mode: The normal operating state, like your lock processing input sequences at full speed.  
         - Test mode: A scan/test configuration for manufacturing testing, possibly with different clock frequencies or enabled scan chains.  
         - Low-power mode: A state with clock gating or voltage scaling to reduce power, altering timing paths.  
         - Other modes: Could include standby, high-performance, or multi-clock domain scenarios based on the design's requirements.  
         The MMMC setup defines these modes alongside PVT corners to run comprehensive checks—ensuring timing, power, and signal integrity hold across all combinations.  
       - **Multiple Corners**: These "corners" represent extreme or boundary conditions under which the design must operate reliably, such as:  
         - Worst-case corners (e.g., slow process, low voltage, high temperature) for checking maximum delays and setup timing.  
         - Best-case corners (e.g., fast process, high voltage, low temperature) for checking minimum delays and hold timing.  
         - Typical corners for nominal conditions.  
     - **Output Files Generated**:  
       - Optimized Gate-Level Netlist: RTL constructs replaced with gate-level equivalents, optimized for timing/area; primary input for Innovus design import.  
       - Final Timing Constraints (SDC): Reflects constraints as modified by Genus; loaded into Innovus via MMMC for PnR.  
       - Standard Delay Format (SDF) File: Contains estimated cell/interconnect delays; primarily for gate-level simulation (GLS) to verify timing/functionality (less common in direct PnR).  
       - LEC Script: For internal equivalence checking (not direct PnR input).  
       - Reports (.rpt), Logs (.log), Snapshots: For designer debugging/analysis (not direct PnR inputs).  

   - **Partitioning**: Breaks up a circuit into smaller sub-circuits or modules which can each be designed or analyzed individually (important for managing complexity in large designs by enabling parallel processing and easier optimization). For smaller designs like this FSM-based combination lock, partitioning was skipped or handled implicitly during floorplanning/import, as the entire netlist could be processed as one block without needing subdivision.  
