# Cadence Genus(TM) Synthesis Solution, Version 20.11-s111_1, built Apr 26 2021 14:57:38

# Date: Thu Mar 27 19:27:02 2025
# Host: vlsilab9.nitrkl.ac.in (x86_64 w/Linux 3.10.0-1160.el7.x86_64) (4cores*8cpus*1physical cpu*Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz 8192KB)
# OS:   CentOS Linux release 7.9.2009 (Core)

read_libs typical.lib
real_hdl -v2001 lock.v
read_hdl -v2001 lock.v
elaborate
read_sdc lock_sdc.sdc
synthesize -to_mapped
write_hdl > lock_netlist.v
report_units > units.rpt
report_units
report_gates > gates.rpt
report_power > power.rpt
report_utilization > utilization.rpt
report_utilization
report_sequential > sequential.rpt
exit
