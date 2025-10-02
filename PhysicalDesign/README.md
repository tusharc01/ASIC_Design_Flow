<p align="center">
  <img src="https://raw.githubusercontent.com/tusharc01/ASIC_Design_Flow/main/PhysicalDesign/backend.png" alt="Backend Design Flow" style="max-width:100%; height:auto;" />
</p>


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
