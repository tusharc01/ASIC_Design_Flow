

read library -Both -Replace -sensitive -Statetable -Liberty typical.lib -nooptimize

 

read design lock.v -Verilog -Golden -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply

 

read design lock_netlist.v -Verilog -Revised -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply

 

set system mode lec

 

add compared points -all

 

compare

