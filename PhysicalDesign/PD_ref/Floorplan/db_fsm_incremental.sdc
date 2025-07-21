# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Fri Mar 21 11:33:46 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design db_fsm

create_clock -name "clk" -period 100.0 -waveform {0.0 50.0} [get_ports clk]
set_clock_transition -min 0.1 [get_clocks clk]
set_clock_transition -max 0.15 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports sw]
set_input_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports rst]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports db]
set_max_fanout 10.000 [get_ports clk]
set_max_fanout 10.000 [get_ports rst]
set_max_fanout 10.000 [get_ports sw]
set_max_capacitance 0.5 [get_ports db]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb4]
set_clock_uncertainty -setup 0.3 [get_clocks clk]
set_clock_uncertainty -hold 0.3 [get_clocks clk]
