if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name MAX_TIMING\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ss.lib\
    ${::IMEX::libVar}/mmmc/tsl18cio150_max.lib]
create_library_set -name MIN_TIMING\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ff.lib\
    ${::IMEX::libVar}/mmmc/tsl18cio150_min.lib]
create_op_cond -name PVT_BEST -library_file ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ff.lib -P 1 -V 1.62 -T -40
create_op_cond -name PVT_WORST -library_file ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ss.lib -P 1 -V 1.62 -T 125
create_rc_corner -name RC_BEST\
   -cap_table ${::IMEX::libVar}/mmmc/SCL_NEW_26092019_basic.CapTbl\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125
create_rc_corner -name RC_WORST\
   -cap_table ${::IMEX::libVar}/mmmc/SCL_NEW_26092019_basic.CapTbl\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125
create_delay_corner -name MAX_DELAY\
   -rc_corner RC_WORST\
   -early_library_set MIN_TIMING\
   -late_library_set MAX_TIMING\
   -early_opcond_library tsl18fs120_scl_ff\
   -late_opcond_library tsl18fs120_scl_ss\
   -early_opcond PVT_BEST\
   -late_opcond PVT_WORST
create_delay_corner -name MIN_DELAY\
   -rc_corner RC_BEST\
   -early_library_set MIN_TIMING\
   -late_library_set MAX_TIMING\
   -early_opcond_library tsl18fs120_scl_ff\
   -late_opcond_library tsl18fs120_scl_ss\
   -early_opcond PVT_BEST\
   -late_opcond PVT_WORST
create_constraint_mode -name ALL\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name WORST_CASE -constraint_mode ALL -delay_corner MAX_DELAY
create_analysis_view -name BEST_CASE -constraint_mode ALL -delay_corner MIN_DELAY
set_analysis_view -setup [list WORST_CASE] -hold [list BEST_CASE]
