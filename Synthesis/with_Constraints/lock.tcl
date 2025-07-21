set_db library typical.lib


read_hdl lock.v
elaborate

read_sdc lock_sdc.sdc

synthesize -to_mapped

write_hdl > lock_netlist.v

gui_show

report_units > units.rpt
report_timing > timing.rpt

report_area > area.rpt

report_power > power.rpt

