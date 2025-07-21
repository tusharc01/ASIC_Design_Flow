###################################################################################################
##				POWERPLANING							 ##
###################################################################################################

#set PWR_NET_CORE VDD_CORE	;	# power net name as in LEF file
#set GND_NET_CORE VSS_CORE	;	# ground net name as in LEF file
#set PWR_NET_ALOG VDDO_CORE	;	# ANALOG power net name as in LEF file
#set GND_NET_ALOG VSSO_CORE	;	# ANALOG ground net name as in LEF file

###################################################################################################

## Global Net connections:
## clearGlobalNets 		- Resets the global net as well as all of the tie-high and tie-low nets
## globalNetConnect 		- The globalNetConnect command connects PG pins or 1'b0/1'b1 pins to the 
## 				- specified global net, which is either a power or ground net.
###################################################################################################

#clearGlobalNets

##globalNetConnect VDD_CORE 	-type pgpin -pin VDD 	-instanceBasename * -verbose
##globalNetConnect VSS_CORE       -type pgpin -pin VSS    -instanceBasename * -verbose
##
##globalNetConnect VDDO_CORE 	-type pgpin -pin VDDO 	-instanceBasename * -verbose
##globalNetConnect VSSO_CORE 	-type pgpin -pin VSSO 	-instanceBasename * -verbose
##
##globalNetConnect VDD_CORE 	-type tiehi -inst * 	-verbose
##globalNetConnect VSS_CORE 	-type tielo -inst * 	-verbose

globalNetConnect VDD_CORE       -type pgpin -pin VDD -all  
globalNetConnect VSS_CORE       -type pgpin -pin VSS -all 

globalNetConnect VDDO_CORE      -type pgpin -pin VDDO -all
globalNetConnect VSSO_CORE      -type pgpin -pin VSSO -all

globalNetConnect VDD_CORE       -type tiehi    
globalNetConnect VSS_CORE       -type tielo    


#####################################################################################################

## Global Ring connections:
## setAddRingMode 			- Sets global variables for block rings and core rings when you use addRing command
## addRing 				- Creates rings for specified nets around the core boundary or selected blocks and groups of core rows.
## -snap_wire_center_to_grid 		: Controls the snapping of the center of the rings. If we do not specify this parameter, rings are not snapped to the routing grid. Specify 
## 					  one of the following values: None, Grid, Half-Grid or Either.


########################################################################################################

setAddRingMode -stacked_via_top_layer TOP_M -stacked_via_bottom_layer M1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { noshape }

addRing -nets {VDD_CORE VSS_CORE} -type core_rings -follow core -center 1 -layer {top M3 bottom M3 left TOP_M right TOP_M} -width {top 30 bottom 30 left 30 right 30} -spacing {top 30 bottom 30 left 30 right 30} -offset {top 10 bottom 10 left 10 right 10} -snap_wire_center_to_grid None

###################################################################################################

## Stripes (Vertical and Horizontal ) connections:
## setAddStripeMode 						- Sets global variables for power stripes,
## addStripe  							- Creates power stripes within the specified area. If the router encounters an obstruction, the stripe connects to the last stripe on the same net.
## -skip_via_on_wire_shape 					- Prevents vias from being generated on the specified wire shapes.
## 							 	- If you specify -skip_via_on_wire_shape{} , the power planning software makes connections to all five categories of wire shapes.

###################################################################################################

setAddStripeMode -spacing_type edge_to_edge -stacked_via_top_layer TOP_M -stacked_via_bottom_layer M1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_wire_shape {  noshape }

addStripe -nets {VDD_CORE VSS_CORE} -layer TOP_M -direction vertical -width 11.2 -spacing 11.2 -set_to_set_distance 112 -start_from left -start_offset 84.28 -switch_layer_over_obs true -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit TOP_M -padcore_ring_bottom_layer_limit M1 -block_ring_top_layer_limit TOP_M -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin { standardcell } 

addStripe -nets {VDD_CORE VSS_CORE} -layer M3 -direction horizontal -width 5.6 -spacing 11.2 -set_to_set_distance 224 -start_from bottom -start_offset 120.4 -switch_layer_over_obs true -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit TOP_M -padcore_ring_bottom_layer_limit M1 -block_ring_top_layer_limit TOP_M -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin { standardcell } 

###################################################################################################

## Route Power Nets to Std Cell Power Pins:
## setSrouteMode 					- Sets global variables for sroute,
## sroute 						- Routes power structures. Use this command after creating power rings and power stripes.

###################################################################################################

setSrouteMode -viaConnectToShape { ring stripe followpin }
sroute -connect { padPin corePin } -layerChangeRange { M1(1) TOP_M(4) } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -allowJogging 1 -crossoverViaLayerRange { M1(1) TOP_M(4) } -nets {VDD_CORE VSS_CORE} -allowLayerChange 1 -targetViaLayerRange { M1(1) TOP_M(4) }

###################################################################################################
## Reports generation:
###################################################################################################

verifyConnectivity -type all -connLoop -error 10000 -warning 5000 > ./PowerPlanning/${init_top_cell}.connectivity.rpt

checkDesign -all > ./PowerPlanning/${init_top_cell}_PP_design.rpt

timeDesign -prePlace > ./PowerPlanning/timing_prePlace.rpt

saveDesign ./PowerPlanning/${init_top_cell}_fp_powerplan.enc

