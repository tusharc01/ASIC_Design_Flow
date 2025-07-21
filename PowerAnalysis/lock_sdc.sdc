# Define time unit (e.g., nanoseconds)
set_units -time ns

# Define the clock
# Assuming a 10 ns period (100 MHz frequency) - adjust as needed
create_clock -name CLK -period 10 -waveform {0 5} [get_ports clock]

# Set clock uncertainty (jitter) - optional, for realism
set_clock_uncertainty 0.1 [get_clocks CLK]

# Set input delay for 'x' and 'reset' relative to the clock
# Assuming inputs arrive 2 ns after the clock edge (adjust based on your system)
set_input_delay -clock CLK 2.0 [get_ports x]
set_input_delay -clock CLK 2.0 [get_ports reset]

# Set output delay for 'ready', 'unlock', and 'error'
# Assuming downstream logic expects outputs 2 ns before the next clock edge
set_output_delay -clock CLK 2.0 [get_ports ready]
set_output_delay -clock CLK 2.0 [get_ports unlock]
set_output_delay -clock CLK 2.0 [get_ports error]

# Set driving strength for inputs (optional, depends on your library)
# Example: assume 'x' and 'reset' are driven by a buffer from your library
set_driving_cell -lib_cell BUFX2 [get_ports x]
set_driving_cell -lib_cell BUFX2 [get_ports reset]

# Set load capacitance for outputs (optional, depends on your system)
# Example: assume 5 pF load - adjust based on your technology library
set_load 5 [get_ports ready]
set_load 5 [get_ports unlock]
set_load 5 [get_ports error]

# Set operating conditions (optional, depends on your library)
# Example: typical corner - adjust based on your tech library
set_operating_conditions -analysis_type on_chip_variation typical
