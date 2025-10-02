<p align="center">
  <img src="https://raw.githubusercontent.com/tusharc01/ASIC_Design_Flow/main/PhysicalDesign/backend.png" alt="Backend Design Flow" style="max-width:100%; height:auto;" />
</p>

REF:  [YouTube](https://youtu.be/jwVzHmIpLY8)



Above **backend design flow** for integrated circuits, which begins after the initial design description. This flow involves several key stages, starting with synthesis, followed by the place and route steps, utilizing various standard file formats for describing the design and technology.

### I. Inputs and Background

The foundation of the backend flow is the **standard cell library**. All standard cells within a given library must have the same height. This height is sometimes described in terms of the number of tracks. The library may contain thousands of cells, along with specialized components like filler cells, which are used to fill gaps after placement.

The primary inputs provided to the backend flow are the **behavioral Verilog (Vlog) code** and the **timing constraints**.

### II. Synthesis

Synthesis is the first major step, accomplished using specialized software.

1.  **Inputs to Synthesis:**
    *   **Behavioral Vlog:** The design code.
    *   **Timing Constraints:** Provided in SDC format, which stands for **Synopsis Design Constraints**. These constraints define the clock definitions and other timing characteristics of the circuit.
2.  **Process and Output:**
    *   Synthesis converts the behavioral Vlog into a **gate-level netlist** (or logic circuit).
    *   The output includes the logic circuit in **Verilog format** and the timing constraints in SDC format. While the timing constraints (SDC) provided as input and output are generally the same, the style may change.

### III. Place and Route

Place and route is the automatic layout flow, broadly comprising three steps: **placement**, **clock distribution**, and **routing**.

#### 1. Placement

Placement is the first step of the place and route flow. A placement tool (an Electronic Design Automation or EDA tool) uses advanced algorithms to place standard cells optimally.

*   **Inputs to Placement:**
    *   The **gate-level netlist** (logic circuit).
    *   The timing requirements/constraints (in **SDC format**).
    *   A **floor plan**.

*   **The Floor Plan:** The floor plan is crucial as it indicates the size and shape of the block where the circuit will be implemented. It defines the block's width and height, and specifies the arrangement of the **standard cell rows**. Because all standard cells share the same height, they can arrange neatly into these rows. The floor plan also specifies where the **input and output ports** are located, typically along the edge of the block. Floor plan information can be provided using Tcl scripts or in the **DEF** (Design Exchange Format). DEF is one of the formats used to describe the physical (layout-related) information of the design.

*   **Optimization Goals of Placement:** The placement tool does not place cells arbitrarily but uses optimal algorithms. Optimal placement aims for two main criteria:
    1.  **Minimum Net Length:** The placement minimizes the total length of all nets, meaning the sum total length of all connecting wires should be minimum.
    2.  **Timing Awareness:** The placement algorithms are aware of timing requirements. Standard cells through which a signal needs to flow very fast will be placed nearer to each other, while cells through which a signal can take longer may be placed further apart.

#### 2. Clock Distribution

Once placement is completed and the physical locations of all flip-flops are known, the clock is physically implemented. (The clock is only an "ideal clock" during the placement stage).

*   **Process:** The clock enters the design through an input port defined in the floor plan. It is then distributed to all flip-flops in a topology that can be viewed as a **tree** structure.
*   **Buffers:** Buffers are used throughout the clock tree distribution to maintain the quality of the clock signal.

#### 3. Routing

Routing is the step where the nets are physically implemented, connecting all the standard cells that need to be linked.

*   **Technology Information:** The router needs information about the available metal layers, which it reads from the **Tech LEF** (Technology Library Exchange Format).
*   **Details from Tech LEF:** This information tells the router how many layers of metal are available (e.g., eight layers), the required directionality for each layer (e.g., Metal one runs horizontally, Metal two runs vertically), the pitches, and the minimum width and spacing requirements for the metal layers.

---

The latter stages of the backend design flow detail the processes of **routing**, post-layout analysis, and final physical verification, which conclude the integrated circuit layout.

### I. Routing (Net Creation)

Routing is the step where the connections between standard cells (known as **nets**) are physically created. By the time routing begins, standard cells have already been placed, and the clock distribution (CTS) has been implemented.

1.  **Metal Layers and Vias:** The router connects the cells using different **metal layers**. Vias (**VRs**) are used to connect these different metal layers together.
2.  **Manhattan Topology:** Routing fundamentally relies on the **Manhattan topology**.
    *   This means all wires run exclusively **horizontally or vertically**. Wires never run in a diagonal direction.
    *   Each metal layer has a **preferred direction** (either horizontal or vertical), and alternate layers will have alternating directions (e.g., Metal 2 horizontal, Metal 3 vertical, Metal 4 horizontal, and so on).
    *   If a router needs to change direction from horizontal to vertical, it must switch to a metal layer designed for that vertical direction.
3.  **Manhattan Distance:** Since all nets run only horizontally and vertically across different layers, the actual length of any net is calculated as the **Manhattan distance**.
4.  **Technology Input:** The router, an advanced piece of software, determines which metal layers are available and their properties by reading the **Tech LEF** (Technology Library Exchange Format).

### II. The Role of Standard Cell Data in Placement

While the router focuses on physical creation, the placement step requires deep awareness of the technology to perform its function optimally. Every tool, including placement and routing, requires technology input regarding the standard cell library.

*   **Placement Tool Needs:** The placement tool needs to read both the **LEF** file (for standard cell dimensions and geometry) and the **.lib** (for functionality and timing/delay awareness).
*   **Logic Restructuring:** Placement tools today are often very advanced and can perform **logic restructuring**. The tool can modify the netlist generated by the synthesis tool—for example, by reimplementing combinational logic in a different structure—to optimize the placement results, provided the overall circuit functionality is maintained. To do this, the placement tool must be aware of the functionality of each cell, which it gathers by reading the **.lib**.
*   **Physical Awareness:** Unlike the synthesis tool, which has no physical awareness of distances or placement, the placement tool is **fully aware of the physical picture** and uses this awareness when restructuring the logic.

### III. Netlist Evolution and Layout Export

The netlist undergoes modifications throughout the entire place and route flow.

1.  **Netlist Changes:** The netlist is initially modified during placement due to any **logic restructuring**. It changes again during clock distribution when the **clock tree and its buffers** are introduced. Finally, the router may make minor adjustments, such as upsizing or downsizing standard cells to modify their drive strength.
2.  **Layout Completion and Exports:** Once routing is complete, the layout is considered finished. The place and route tool exports two main types of data:
    *   **The Physical Layout (DEF):** All the routes and the entire geometrical picture of each net are exported in the **DEF** (Design Exchange Format). This format contains details on which metal layers are used for which wires.
    *   **The Final Netlist:** This output netlist incorporates all modifications made during placement, clock distribution, and routing.

### IV. Post-Layout Analysis and Verification

After the layout is finished, several critical analysis steps ensure the design meets requirements before fabrication.

1.  **Parasitic Extraction:** To ensure accurate timing analysis, the layout information in the DEF file is fed into an **extraction tool**. This tool determines the accurate **resistance and capacitance** (referred to as parasitics) of each net based on the physical geometry.
2.  **SPEF:** The resistance and capacitance information is exported in a standard format called **SPEF** (Standard Parasitic Exchange Format).
3.  **Accurate Static Timing Analysis (STA):** The final netlist and the SPEF are then used by the timing analysis tool. Since the tool now accurately knows the parasitics, it can precisely determine the timing between flip-flops and check if all timing requirements have been met.
4.  **Physical Verification:** Before the chip can be sent for fabrication, physical verification ensures the layout adheres to technological rules and matches the circuit design.
    *   **DRC (Design Rule Checks):** Checks for any design rule violations in the layout.
    *   **LVS (Layout Versus Schematic):** Checks that the physical layout accurately represents the logical schematic.

If all checks are successful and there are no timing or design rule violations, the layout information can be sent to the foundry for fabrication.
