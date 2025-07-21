###################################################################################################
## 					PLACEMENT						 ##
###################################################################################################

set PROCESS 180				; 	# Specifies the process technology value to set for all the applications units in nanometers (nm).
set EFFORT_LEVEL standard 		; 	# {standard|medium|low} -> To Specifies the congestion effort level.

###################################################################################################
## To set the design process node information.
###################################################################################################

setDesignMode \
	-process $PROCESS \
	-flowEffort $EFFORT_LEVEL

set MIN_LAYER 1		;#
set MAX_LAYER 4		;#

###################################################################################################
## Sets global parameters for the Early Global Route. These parameters run with earlyGlobalRoute 
## command or internally during in-place optimization, partitioning, or Full placement,
###################################################################################################

setRouteMode \
	-earlyGlobalMinRouteLayer $MIN_LAYER \
	-earlyGlobalMaxRouteLayer $MAX_LAYER \
	-earlyGlobalEffortLevel $EFFORT_LEVEL 

###################################################################################################
## To Set Placement Mode Variables
###################################################################################################

#set FP_MODE true					; 	# {true|false} -> run placement in floorplan mode(default=>false). This mode is used for prototyping and runs quickly to gauge the feasibility of the netlist, but might not place design components in legal locations. (**It disables congestion-driven placement).

#set GLOBAL_CONGESTION_EFFORT high 			; 	# {low|medium|high|auto} -> Specifies the effort level for relieving congestion (default=>auto). 

#set GLOBAL_MAX_DENSITY 0.7 				; 	# 0(0%)....1(100%)	-> Controls the maximum density of local bins during global placement. (**** It is recommended to keep its value greater than standard cell utilization of design).

#set PLACE_IO_PIN false					; 	# Place IO Pins concurrently with std. cell placement, and do layer assignment (default => false). 

##set REFINE_PLACE true 				; 	# Calls to refinePlace from other commands such as placeDesign, optDesign will not run refinePlace (default=>true)

#set CLOCK_GATING false 				; 	# Specifies that placement is aware of clock gate cells in the design (default=>true).

#set SCAN_REORDER false 				; 	# Performs scan chain reordering after placement (default=>true).

#set GLOBAL_PLACE full 					; 	# {none|seed|full} -> Changes the Global Placement behavior inside place_opt_design command (default => full).


###################################################################################################
## To Controls certain aspects of how the software places cells. 
###################################################################################################

setPlaceMode -place_design_floorplan_mode false -place_design_refine_place true -place_global_cong_effort high -place_global_max_density 0.8 -place_global_place_io_pins false -place_global_clock_gate_aware false -place_global_reorder_scan false

setOptMode -fixFanoutLoad true -reclaimArea true -simplifyNetlist true -setupTargetSlack 0.2

## Placement in Florplan view (Nano/Global Placement 			-> FLOORPLAN_MODE will be 'true'

placeDesign -noPrePlaceOpt

## Full Placement (Global, Legalization and Detailed) 			-> FLOORPLAN_MODE will be 'false'

#placeDesign

## Full Placement plus optimizatio using one command (automatically sey Floorplan mode to 'false') and/or incremental placement command (use after initial placement in non-floorplan mode only).

setPlaceMode -place_design_floorplan_mode false -congEffort high

place_opt_design

#placeDesign -incremental

checkPlace > ./Placement/place_summary.rpt

###################################################################################################
## Check for Placement Congestion (Cell and Pin Density) and Routing congestion with global route
###################################################################################################

set GRID_ROW 20						; 	# Specifies the horizontal or vertical dimension of a grid in the map, measured in number of rows (default=> 10). If you specify a value less than 1 , the software uses 1.

#set GRID_MICRON 50 					; 	# Specifies the horizontal or vertical dimension of a grid in the map, measured in microns (default=> 50). Use -gridInMicron option instead of -gridInRow for this.

set CELL_DNSTY_THRSLD 0.8 ;	# Specifies a threshold density value for the grid. Any grid under the threshold value is not reported (DEFAULT=> 0.75). 

set CELL_PIN_THRSLD 0.50 ;	# Specifies the threshold value for cells pin over which the densities must be reported (default=> 0.5).

set MAP_DISPLAY_STEP 0.1 ;	# Specifies the range step for displaying the cell or pin density map calculations.

setDensityMapMode \
	-gridInRow $GRID_ROW \
	-threshold $CELL_DNSTY_THRSLD \
	-displayStep $MAP_DISPLAY_STEP

reportDensityMap > ./Placement/${init_top_cell}_cellDensity.rpt

setPinDensityMapMode \
	-gridInRow $GRID_ROW \
	-threshold $CELL_PIN_THRSLD \
	-displayStep $MAP_DISPLAY_STEP

reportPinDensityMap > ./Placement/${init_top_cell}_pinDensity.rpt

reportCongestion -overflow -hotSpot > ./Placement/${init_top_cell}_congestion.rpt


###################################################################################################
##Check for timing(setup) before CTS
###################################################################################################

set timing_report [report_timing -collection -late]

set slack_time [get_property $timing_report slack]

if { $slack_time < 0.2 } {
puts "Optimizing for Slack"
optDesign -preCTS -drv
puts "Optimization Complete"
} else {
puts "No slack violation 1"
}

set timing_report [report_timing -collection -late]

set slack_time [get_property $timing_report slack]

if { $slack_time < 0.2 } {
puts "Optimizing for Slack"
optDesign -preCTS -incr
puts "Optimization Complete"
} else {
puts "No slack violation 2"
}

set timing_report [report_timing -collection -late]

set slack_time [get_property $timing_report slack]

if { $slack_time < 0.2 } {
puts "Optimizing for Slack"
optDesign -preCTS -incr
puts "Optimization Complete"
} else {
puts "No slack violation 3"
}
set timing_report [report_timing -collection -late]

set slack_time [get_property $timing_report slack]

if { $slack_time < 0.2 } {
puts "Optimizing for Slack"
optDesign -preCTS -incr
puts "Optimization Complete"
} else {
puts "No slack violation 4"
}

saveDesign ./Placement/${init_top_cell}_place_timing.enc

###################################################################################################
## Reports generation:
###################################################################################################

checkPlace > ./Placement/placeOpt_summary.rpt

timeDesign -preCTS -expandedViews > ./Placement/timing_preCTS.rpt

saveNetlist ./Placement/${init_top_cell}_preCTS.v

saveNetlist -includePowerGround ./Placement/${init_top_cell}_preCTS_withPG.v

write_sdc ./Placement/fifo_preCTS.sdc

saveDesign ./Placement/${init_top_cell}_place.enc
