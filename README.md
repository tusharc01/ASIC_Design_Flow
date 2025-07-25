## *Overview*
This repository contains the design and implementation of a Combination Lock using a Finite State Machine (FSM) in Verilog, as part of the ASIC design flow. The lock handles input sequences for unlocking, with error detection and reset functionality.

## *Introduction:*
The project presents a combination lock FSM with states such as S_reset, S_open, S_error, and transitions based on inputs/outputs (e.g., 0/00 or 1/00). It is implemented using combinational and sequential logic in two always blocks for robustness:  
- One always block for sequential logic (handling state transitions on clock edges with sensitivity to posedge clk).  
- Another for combinational logic (computing next states or outputs based on current state and inputs, with sensitivity to * for all changes).  
This separation improves maintainability, debuggability, and synthesis quality, reducing issues like inferred latches or timing problems.



## *FSM Design*
The FSM is based on a state diagram specifying states, transitions, unlock sequence (e.g., 1-2-3-4), error on wrong input, and outputs like "unlock" or "error".

## *Implementation Steps*
The design follows the ASIC flow with these key steps (completed ones marked):

__1. Specification:__ Define design behavior (e.g., FSM diagram specifying states, transitions, unlock sequence like 1-2-3-4, error handling, reset conditions). *Done.*

__2. RTL Design:__ Translate spec to Verilog RTL with FSM in two always blocks. Focus on functionality, not gates or timing. *Done.*
