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
   - Incorporated typical library files for predefined gates, the design file, and a constraint file.  
   - Performed elaboration of RTL design to generate an initial unstandard schematic.  
   - Applied synthesize command to translate logic using standard gates, incorporating delays based on constraints, visible in the Genus GUI schematic.  
   - Generated the netlist in Verilog format directly from Genus.  
   - Constraints include: time unit definition, clock creation, clock uncertainty, input delays, output delays, driving cells, load capacitance, operating conditions. [Constraint File](https://github.com/tusharc01/Combinational_lock/blob/main/Synthesis/with_Constraints/lock_sdc.sdc)

__6. Gate Level Simulation (GLS):__

__7. Formal Verification (LEC):__ Verify functional equivalence between the original RTL (golden design) and the synthesized netlist (revised design) using Cadence Conformal tool for Logic Equivalence Checking (LEC). *Done.*  
   - Compared golden (RTL) and revised (netlist) designs to ensure no logical discrepancies were introduced during synthesis.  
   - Analyzed reports for key metrics including equivalence points, mapped points, non-equivalent points, unmapped logic, warnings, and errors.  
   - Resolved any identified issues (e.g., non-equivalences or unmapped elements) to confirm 100% logical match, including adjusting synthesis constraints or directives to prevent unwanted optimizations (e.g., retiming or logic restructuring) that alter the netlist structure, and fixing RTL issues like uninitialized variables or ambiguous logic that synthesis interprets differently.  
   - **Note on LEC Process**: In the ASIC flow, LEC is typically automated via a specific .do file (a TCL-based script in Conformal) containing commands like `read design`, `set system mode lec`, `map key points`, `add compared points`, and `report statistics` to load designs, perform mapping/comparison, and generate reports; this ensures repeatable verification without manual GUI steps, often run in batch mode for efficiency.

__8. Design for Testability (DFT):__ Lorem


__*. Static Timing Analysis (STA):__ Analyze timing paths in the synthesized netlist using Cadence Tempus tool to ensure the design meets required clock frequency specifications, checking for setup and hold violations influenced by factors like clock skew (timing differences between clock paths), uncertainty (jitter and skew margins), jitter (clock edge variations), and logic delays (propagation times through gates and interconnects). *Done.*  
   - Loaded synthesized netlist, timing libraries, and constraints into Tempus GUI; performed analysis to generate setup and hold reports, where positive slack indicates timing is met and negative slack results in violations (e.g., setup violations from late-arriving signals, hold violations from early-changing signals).  
   - Identified and fixed violations by remodifying constraints (e.g., adjusting clock periods, input/output delays, or uncertainty values) to account for skew, jitter, and delay effects.  
   - Repeated synthesis with updated constraints, then re-ran STA to verify all timing paths are met with positive slack, ensuring reliable operation at the specified clock frequency through static delay estimation of each design element without dynamic simulation.  
   - **Note**: STA is conducted at a specific operating frequency defined by the design team or system architect based on application requirements (e.g., performance, power, or throughput needs); while the client (user) demands the overall design, the frequency is decided and fixed iteratively by the designer through constraints optimization and STA validation to balance feasibility and specifications.

__*. Power Analysis:__ Estimate internal, dynamic (switching), and static (leakage) power consumption based on the synthesized netlist and switching activity, using Cadence Genus for early-stage power estimation (rough power estimations done at the RTL or architectural level to guide design decisions related to power consumption), quick estimation during or right after synthesis and Synopsys Design Vision for post-synthesis analysis (initial power analysis on the synthesized netlist using library data and estimated switching activity or VCD/SAIF files) as a standalone step. *Done.*  
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
     - **Synthesis Process**: Automated via TCL script in Cadence Genus, which reads RTL, realizes logical structure, applies constraints, performs technology-independent optimization, maps to specific technology libraries (e.g., TSMC 180nm based on filenames like tsl18...), and conducts timing-driven optimization (using syn_map and syn_opt commands).  
     - **Timing Libraries Used**: Included _ss (Slow-Slow) and _max for setup analysis (worst-case delay), _ff (Fast-Fast) and _min for hold analysis (best-case delay); these provide timing (delay, setup, hold), power, and functional characteristics of standard cells (e.g., AND, OR, Flip-Flops) and I/O pads, used during mapping/optimization and matched in Innovus MMMC setup for consistent timing-driven operations.  
     - **Timing Constraints**: Loaded from SDC file (e.g., lock_sdc.sdc) defining clock periods, waveforms, input/output delays, timing exceptions (false/multicycle paths), and design rules (max transition/capacitance); used to guide optimization with internal path_adjust commands for added margin.  
     - **Physical Libraries**: Included LEF (Library Exchange Format) files (`e.g., tsl18@14.lef`) containing physical information about standard cells, macros, and I/O pads for the technology node; this includes cell dimensions, pin locations, metal layer blockages, via rules, etc. (no timing information). Innovus uses LEF data to determine cell sizes/shapes for placement and routing rules. Also included specific timing libraries (.lib files) like tsl18fs120_scl_ss.lib and tsl18fs120_scl_ff.lib (Liberty Timing Format) for detailed cell characteristics.  
     - **MMMC Setup in Innovus**: Multi-Mode Multi-Corner (MMMC) analysis setup, which defines multiple operating modes (e.g., functional vs. test) and PVT corners for comprehensive timing, power, and signal integrity analysis; it integrates the multi-corner libraries and constraints to ensure the design meets requirements across variations, as referenced in the tool's configuration (e.g., setup scripts or GUI screenshots from the project PDF, indicating specific corner definitions and library paths). Orchestrated via a view definition file (e.g., db_fsm.view) to handle modern designs' need for correctness across operating conditions and manufacturing variations; configured and viewed in the MMMC Browser wizard (a GUI interface in Innovus for setting up and browsing MMMC elements).  
       - **Multiple Modes**: These modes represent various ways the circuit might function in real-world use, each with its own set of timing constraints, clock definitions, or power states. For example:  
         - Functional mode: The normal operating state, like your lock processing input sequences at full speed.  
         - Test mode: A scan/test configuration for manufacturing testing, possibly with different clock frequencies or enabled scan chains.  
         - Low-power mode: A state with clock gating or voltage scaling to reduce power, altering timing paths.  
         - Other modes: Could include standby, high-performance, or multi-clock domain scenarios based on the design's requirements.  
         The MMMC setup defines these modes (e.g., via commands like create_mode in scripts) alongside PVT corners to run comprehensive checks—ensuring timing, power, and signal integrity hold across all combinations.  
       - **Multiple Corners**: These "corners" represent extreme or boundary conditions under which the design must operate reliably, such as:  
         - Worst-case corners (e.g., slow process, low voltage, high temperature) for checking maximum delays and setup timing.  
         - Best-case corners (e.g., fast process, high voltage, low temperature) for checking minimum delays and hold timing.  
         - Typical corners for nominal conditions.  
       - **Analysis View List (inside MMMC Browser)**: Combining a Constraint Mode and a Delay Corner to create a specific view for timing analysis (e.g., worst_case view for setup checks using max_delay, best_case view for hold checks using min_delay). Includes:  
         - **General Analysis Views**: best_case (Constraint Mode: all, Delay Corner: min_delay); worst_case (Constraint Mode: all, Delay Corner: max_delay).  
         - **Setup Analysis Views**: worst_case.  
         - **Hold Analysis Views**: best_case.  
       - **MMMC Objects**: Includes Library Sets (MAX_TIMING, MIN_TIMING), RC Corners (rc_worst, rc_best), OP Conds (pvt_worst, pvt_best), Delay Corners (max_delay, min_delay), Constraint Modes (all).  
         - **Library Sets**: Grouping .lib files for different corners (e.g., MAX_TIMING using slow libraries for setup checks, MIN_TIMING using fast libraries for hold checks).  
         - **RC Corners**: Defining parasitic (Resistance/Capacitance) variations (e.g., rc_worst, rc_best) based on Cap Tables (e.g., _basic.CapTbl) and temperature (125°C for worst, -40°C for best); parasitics significantly affect wire delays.  
         - **OP Conds (Operating Conditions)**: Defining PVT points (e.g., pvt_worst, pvt_best) by specifying process factor, voltage, and temperature, linking them to specific library characteristics.  
         - **Delay Corners**: Combining RC Corners and OP Conds (e.g., max_delay, min_delay) to create specific scenarios for delay calculation (e.g., worst RC with worst PVT for maximum delay); often includes setup for On-Chip Variation (OCV) by using different conditions for early and late paths.  
         - **Constraint Modes**: Grouping SDC files if different constraints apply in different functional modes (here, just one mode 'all' using arbiter_constraints.sdc).  
       - **Why Create MMMC Objects and Analysis Views?** (Necessary Knowledge for Understanding Pre-PnR Process):  
         - **MMMC Objects**: These are foundational building blocks created to model real-world variations (e.g., PVT differences, parasitics like resistance/capacitance) for accurate timing analysis and optimization. They break down design complexity into manageable parts, enable reuse of settings across scenarios, and ensure reliability by simulating extreme conditions without manual repetition—preventing post-fabrication failures from unaccounted variations.  
         - **Analysis Views**: These combine MMMC Objects (e.g., a Constraint Mode + Delay Corner) into targeted scenarios for focused timing verification, such as separating setup checks (for slow paths that might miss clock edges) from hold checks (for fast paths that might cause data races). They drive tool optimization during steps like placement/routing, balancing trade-offs (e.g., area, power, timing) and verifying the design's robustness across all defined combinations to achieve a production-ready layout.  
     - **Output Files Generated**:  
       - Optimized Gate-Level Netlist: RTL constructs replaced with gate-level equivalents, optimized for timing/area; primary input for Innovus design import.  
       - Final Timing Constraints (SDC): Reflects constraints as modified by Genus; loaded into Innovus via MMMC for PnR.  
       - Standard Delay Format (SDF) File: Contains estimated cell/interconnect delays; primarily for gate-level simulation (GLS) to verify timing/functionality (less common in direct PnR).  
       - LEC Script: For internal equivalence checking (not direct PnR input).  
       - Reports (.rpt), Logs (.log), Snapshots: For designer debugging/analysis (not direct PnR inputs).  

   - **Partitioning**: Breaks up a circuit into smaller sub-circuits or modules which can each be designed or analyzed individually (important for managing complexity in large designs by enabling parallel processing and easier optimization). For smaller designs like this FSM-based combination lock, partitioning was skipped or handled implicitly during floorplanning/import, as the entire netlist could be processed as one block without needing subdivision.

   - **Floorplanning**: Determined the shapes and arrangement of sub-circuits or modules, as well as the locations of external ports and IP or macro-blocks.  
     - **Purpose**: Defines the overall chip area (die size) and the core area where standard cells will be placed. Key parameters include core utilization (target percentage of core area to be filled by cells, e.g., 0.7 or 70% for balanced density without overcrowding), aspect ratio (height/width ratio for shape optimization, e.g., 1:1 for square chips to minimize wire lengths), and core margins (space between core and die edge for I/O pads, power rings, and routing).  
     - **Tool Action**: Creates the physical boundary for placement, reserves space for I/Os and power structures; performed in Innovus GUI by setting parameters and generating an initial floorplan view.  
     - **How to Choose Parameters**: Selection is based on design requirements like cell count, power needs, and technology node; utilization is chosen to avoid congestion (too high causes routing failures) while minimizing area (too low wastes space)—e.g., 70% selected for this project to balance density and routability in a small FSM design. Aspect ratio is set for efficient layout (e.g., rectangular for elongated blocks); margins ensure room for peripherals.
    

   - **Power Planning**: Distributed power (VDD) and ground (GND) nets throughout the chip, often integrated with floorplanning.  
     - **Purpose**: Designs the Power Distribution Network (PDN) to deliver VDD (power) and VSS (ground) reliably to all cells with minimal voltage drop (IR drop, where resistance causes voltage to sag under load, potentially leading to timing failures or reduced performance) and electromigration issues (metal degradation from high current density over time, risking open circuits). A strong PDN ensures stable power supply, reduces noise, and supports high current demands in dense areas, critical for low-power designs like this combination lock to maintain functionality without excessive heat or failures.  
     - **Tool Action**: Accessed via Power > Power Planning menus for Global Net Connections, Add Rings, and Add Stripes, followed by Route > Special Route (SRoute) for final connections. Global Net Connections links cell power/ground pins (e.g., *.VDD) to main nets (VDD, VSS). Add Rings creates metal rings around the core boundary for robust distribution. Add Stripes adds vertical/horizontal metal stripes across the core, connected to rings, forming a grid. SRoute connects standard cell power pins to the nearest stripes/rings.  
     - **How to Choose Parameters**: Selections are driven by current requirements, technology rules (e.g., 180nm node limits on metal width/thickness), and design specs like power consumption and area. Choices are iterated via IR drop analysis to meet targets, prioritizing reliability in this FSM-based lock where consistent voltage is key for state transitions. Key considerations include:  
       - **Metal Layers**: Chosen for low resistance (e.g., thicker upper layers like TOP_M (4) for rings and main distribution, lower like M3 for stripes and local connections) to minimize IR drop—upper layers selected here for better conductivity in a small design.  
       - **Ring/Stripe Width and Spacing**: Balanced for current capacity (wider for high current to avoid electromigration) and area efficiency (narrower to save space); e.g., wider rings around the core ensure uniform supply, while stripe density targets <5% IR drop.  
       - **Global Connections**: Use pattern matching (e.g., *.VDD) for automation to efficiently link all relevant pins without manual specification.  
       - **SRoute Application**: Applied last to ensure fine-grained connections without shorts, verifying integration with the overall grid.
      
- **Placement**: Found the spatial locations of all cells within each block.  
  - **Purpose**: Positions the standard cells (from the netlist) onto site rows created in the core area during floorplanning. The placement engine optimizes to minimize total wire length (reducing delays and power), alleviate routing congestion (preventing overcrowded areas that block signals), and satisfy initial timing estimates derived from the MMMC setup, ensuring a foundation for subsequent routing and timing closure in designs like this combination lock where efficient cell arrangement supports quick state transitions.  
  - **Tool Action**: Accessed via Place > Place Standard Cells menu; runs advanced algorithms (potentially leveraging multiple CPUs for faster computation) to assign optimal locations to each cell, snapping them to predefined site rows within the core boundary. Includes options for pre-place optimization (to refine initial estimates) and full/incremental modes (full for complete re-placement, incremental for refinements without starting over).  
  - **How to Choose Parameters**: Choices depend on design complexity, timing goals, and area constraints. Selections are iterated via placement reports (e.g., congestion maps, timing summaries) to refine outcomes, prioritizing timing-critical paths in the lock's state machine for reliable operation. Key considerations include:  
    - **Pre-Place Optimization**: Enable to incorporate early timing data from MMMC for better initial quality, reducing later iterations—selected here to align with multi-corner robustness in a timing-sensitive FSM.  
    - **Multi-CPU Mode**: Choose for speed in larger designs (parallel processing cuts runtime), but for this small FSM, single-thread suffices to avoid unnecessary overhead and simplify setup.  
    - **Full vs. Incremental Placement**: Opt for full initially to establish a clean baseline (complete optimization from scratch), switching to incremental for targeted tweaks post-analysis without disrupting the entire layout.  
    - **Density Targets**: Aim for even distribution (e.g., 70-80% utilization) to prevent hotspots; balances wirelength minimization (shorter wires for faster signals) with congestion avoidance (even spacing for routability), targeting `.

- **Clock Tree Synthesis**: Determined the buffering, gating (e.g., for power management), and routing of the clock signal to meet prescribed skew and delay requirements.  
  - **Purpose**: Builds a balanced clock distribution network (clock tree) from the clock source to all sequential elements (e.g., flip-flops) in the design, minimizing clock skew (differences in arrival times that could cause timing violations) and insertion delay (total latency from source to sinks), while controlling power consumption and area overhead. Essential for synchronous designs like this combination lock's FSM to ensure consistent timing across state transitions, reducing hold/setup violations and enabling reliable operation at the target frequency.  
  - **Tool Action**: Accessed via Clock > Clock Tree Synthesis menu or commands like `synthesizeClockTree`; automatically inserts buffers/inverters, routes clock nets with specified metal layers, and applies gating for low-power modes if enabled. Optimizes based on SDC constraints and MMMC views, generating a tree structure (e.g., H-tree or mesh) with balanced branches, followed by post-CTS checks for skew and transition times.  
  - **How to Choose Parameters**: Selections are based on clock frequency, design size, power budget, and technology node (e.g., 180nm here limits buffer sizing); iterated via skew/delay reports to meet specs like <100ps skew. Key considerations include:  
    - **Skew and Delay Targets**: Set low skew (e.g., 50-100ps) for high-speed paths to avoid race conditions; balance with insertion delay to not exceed clock period—chosen conservatively for this small FSM to prioritize reliability over aggressive optimization.  
    - **Buffer/Inverter Types**: Select from library cells (e.g., low-power vs. high-drive) to minimize power while driving loads; e.g., use clock gating cells for dynamic power savings in idle states of the lock.  
    - **Routing Layers and Topology**: Choose mid-to-upper metal layers (e.g., M4-M6) for low resistance and shielding from noise; opt for H-tree topology for balanced distribution in uniform designs like this, as it reduces skew variance compared to spine or mesh in larger chips.  
    - **Gating and Optimization Options**: Enable clock gating for power reduction (inserts AND gates to disable unused branches); use multi-corner optimization from MMMC to ensure robustness across PVT variations, avoiding over-buffering that increases area/power.
   
- **Routing**: Created physical metal wire connections between placed cell pins, following the netlist logic while adhering to design rules (DRCs) from LEF and technology files. Encompasses global routing (planning general paths), track assignment (assigning nets to tracks), and detailed routing (creating exact wire segments and vias).  
  - **Purpose**: Establishes interconnects to complete the circuit, minimizing signal delays, power consumption, and violations like shorts or spacing errors. Optimizes for timing (reducing path lengths), routability (avoiding congestion), and signal integrity (mitigating crosstalk or electromigration), crucial for this combination lock to ensure fast, reliable signal propagation in the FSM without noise-induced errors.  
  - **Tool Action**: Utilizes the NanoRoute engine for an integrated flow: global routing plans coarse paths across regions; track assignment allocates nets to specific tracks (organizing wires efficiently to reduce overlaps and enable easier via insertion, with parameters like track width/spacing set per layer to match technology rules for minimal detours and better signal integrity—e.g., denser tracks in lower layers for local connections to save upper layers for clocks/power); detailed routing finalizes wire segments and vias on metal layers (e.g., M1, M2, M3, TOP_M(4)). Configured with options like timing-driven effort (to prioritize critical paths), SI (signal integrity) optimization (to reduce crosstalk), and layer limits (to control resource usage).  
  - **Process Overview and Execution**: In Cadence Innovus, the tool follows this sequence to ensure efficient planning before precise implementation, reducing failures like unroutable nets:  
    - Global routing is performed first, planning coarse paths and allocating resources to manage congestion (always a prerequisite, as detailed builds on this plan).  
    - Track assignment follows, assigning nets to specific tracks.  
    - Detailed routing comes last, creating exact wires and vias.  
    - Typically done in one go using a single command like `routeDesign` (or via the GUI under Route > NanoRoute), which automatically handles the full sequence for convenience.  
    - For advanced control or debugging (e.g., to analyze global results first), run separately: e.g., `globalRoute` then `detailRoute`.  
    - In this small FSM-based lock design, the one-go approach is efficient and sufficient unless iterating on congestion hotspots.  
  - **Key Differences Between Global and Detailed Routing (Necessary Knowledge for Understanding)**: These are sequential sub-steps in the routing process:  
    - **Global Routing**: High-level planning phase that allocates general paths and resources for all nets across the chip, dividing the layout into regions (e.g., grids or G-cells) to manage congestion and estimate wire lengths without creating actual wires. Focuses on feasibility and quick iterations (faster but uses estimates), like sketching a rough map of signal highways—essential to avoid overcrowding before detailed work.  
    - **Detailed Routing**: Fine-grained implementation phase that follows global routing, assigning specific metal layers, exact wire segments, vias, and track positions to complete physical connections while fixing DRC issues. More precise and compute-intensive, ensuring manufacturability (e.g., no shorts), like drawing exact roads and intersections on the map—builds on global plans for a final, GDSII-ready layout.  
    - The distinction allows efficient strategy (global for broad optimization) before precision (detailed for rule compliance), preventing costly re-runs; in Innovus, run via `routeDesign` or GUI, with global converging fast in small designs like this FSM.  
  - **How to Choose Parameters**: Selections balance design goals (e.g., timing, area, power) with technology constraints (e.g., 180nm rules on min-width/spacing); iterated via DRC reports and congestion maps to achieve clean routing with <5% violations. Key considerations include:  
    - **Timing-Driven Effort**: Enable high effort for critical nets to shorten paths and meet setup/hold times—selected here for the lock's clock-sensitive FSM to avoid delays in state changes.  
    - **SI Optimization**: Activate to insert shielding or spacing for noise-prone signals; chosen to mitigate crosstalk in dense areas, ensuring signal stability without excessive area penalty.  
    - **Layer Limits and Assignment**: Restrict lower layers (e.g., M1-M2) for local shorts and upper (e.g., M3-TOP_M(4)) for long global routes due to lower resistance—opted for this hierarchy to optimize delay and power in a small design, avoiding overuse of premium layers.  
    - **Congestion and DRC Handling**: Set moderate search/repair iterations to resolve overflows; targets low congestion (<10%) to prevent reruns, based on initial global routing estimates for efficient resource allocation.

*To be continued...*
