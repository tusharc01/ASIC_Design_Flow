# Process Design Kit (PDK)

A **PDK (Process Design Kit)** is a collection of files, models, and rules provided by a semiconductor foundry (e.g., TSMC, Samsung, Intel, GlobalFoundries).  
It acts as the **bridge** between semiconductor manufacturing and chip design tools (EDA).

- **Foundry** → defines the physics, materials, and device characteristics.  
- **Designers** → use this data in CAD tools to create standard cells, IPs, and SoCs.  
- **PDK** → packaged knowledge of the process, usable in design flows.  

---

## 🔹 What’s Inside a PDK?

1. **Design Rules**
   - **DRC**: min width/spacing, enclosure, antenna rules  
   - **LVS**: device recognition rules (Layout vs. Schematic)  
   - **ERC/DFM**: electrical and manufacturability checks  

2. **Device Models**
   - **SPICE models**: transistors, diodes, resistors, capacitors  
   - **Corner models**: TT, SS, FF, SF, FS for process variations  
   - **Parasitic models**: RC extraction decks  

3. **Technology Files**
   - Layer definitions (metal stack, vias, diffusion, poly)  
   - Process stack info for layout tools  

4. **Standard Cell / IP Views** (sometimes provided as separate libraries)
   - **Liberty (.lib)** → timing & power data  
   - **LEF/DEF** → abstract views for place & route  
   - **GDS/OASIS** → physical layout data  

---

## 🔹 Why is PDK Useful for SoC/IP Design?

1. **Accuracy in Simulation**  
   - Foundry-calibrated models for SPICE, analog, timing, power, and noise analysis.  

2. **Physical Verification**  
   - DRC/LVS ensure the layout follows foundry rules → prevents yield loss.  

3. **Standardization**  
   - Aligns analog, digital, and mixed-signal teams with the same process definitions.  
   - Makes IP portable across SoC projects in the same node.  

4. **IP Integration**  
   - Provides abstract LEF/lib views for clean integration into SoC place & route.  

5. **Manufacturability & Yield**  
   - Includes DFM rules to avoid systematic yield problems.  

---

## TL;DR

A **PDK is the recipe book for a semiconductor process**.  
Without it, you can’t reliably design or tape-out an SoC/IP.  
It ensures your design matches the physics of the foundry process and is manufacturable with good yield.

---
