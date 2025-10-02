
## RTL-to-GDSII Execution Flow

### 1️⃣ RTL Design & Verification
RTL Coding: Write design in Verilog/SystemVerilog/VHDL.
Functional Verification: Develop UVM testbenches, assertions, coverage.
Linting & CDC: Use lint tools for coding style, and CDC tools to catch clock-domain crossing issues.

### 2️⃣ Synthesis (RTL → Gate-Level Netlist)
Logic Synthesis: Convert RTL to gate-level netlist using libraries (.lib).
Constraints: Apply timing, area, power constraints (SDC).
DFT Insertion: Insert scan chains, BIST logic, test points.
Reports: Check for timing (setup/hold), area, power violations.

### 3️⃣ Design for Testability (DFT)
Scan Insertion: Replace FFs with scan FFs for test.
ATPG: Generate test vectors for stuck-at and transition faults.
MBIST/LBIST: Insert memory and logic BIST.

### 4️⃣ Floorplanning
Define chip/block outline, IO pin placement, and power grid structure.
Partition macros/IPs and allocate routing resources.
Insert tie cells, spare cells, decaps.

### 5️⃣ Placement
Standard Cell Placement: Place gates from the netlist into floorplan.
Power Planning: Ensure IR drop and EM requirements are met.
Clock Planning (CTS prep): Prepare for balanced clock tree distribution.

### 6️⃣ Clock Tree Synthesis (CTS)
Build balanced clock distribution with buffers/inverters.
Optimize for skew, latency, duty cycle, and jitter.

### 7️⃣ Routing
Global Routing: Estimate routing paths.
Detailed Routing: Route metal layers considering DRC rules.
Ensure signal integrity (reduce crosstalk, noise).

### 8️⃣ Signoff Checks
Static Timing Analysis (STA): Verify setup/hold across corners.
Signal Integrity (SI): Crosstalk, noise checks.
Power Analysis (IR drop, EM): Ensure robust power delivery.
DFM/DRC/LVS: Check against foundry rules (Design Rule Check, Layout vs Schematic).
Antenna & ERC Checks: Validate fabrication readiness.

### 9️⃣ Physical Verification & Tapeout
Generate GDSII file (final mask layout).
Signoff with foundry-required checks.
Send GDSII for mask making → silicon fabrication.

**🔹 Summary Flow**
👉 RTL → Synthesis → Floorplan → Placement → CTS → Routing → STA → Signoff → GDSII
