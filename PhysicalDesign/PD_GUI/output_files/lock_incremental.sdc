# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Tue Apr 01 17:44:25 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design lock

create_clock -name "CLK" -period 10.0 -waveform {0.0 5.0} [get_ports clock]
set_load -pin_load 5.0 [get_ports ready]
set_load -pin_load 5.0 [get_ports unlock]
set_load -pin_load 5.0 [get_ports error]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks CLK] -add_delay 2.0 [get_ports x]
set_input_delay -clock [get_clocks CLK] -add_delay 2.0 [get_ports reset]
set_output_delay -clock [get_clocks CLK] -add_delay 2.0 [get_ports ready]
set_output_delay -clock [get_clocks CLK] -add_delay 2.0 [get_ports unlock]
set_output_delay -clock [get_clocks CLK] -add_delay 2.0 [get_ports error]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb4]
set_clock_uncertainty -setup 0.1 [get_clocks CLK]
set_clock_uncertainty -hold 0.1 [get_clocks CLK]
