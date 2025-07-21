###################################################################################################
## 	       				FLOORPLAN 						 ##
###################################################################################################

#set ASPECT_RATIO     1.0 	; 	# Shape of design e.g. rectangle with height = 1.0*width
#set CORE_UTILIZATION 0.60 	; 	# Core utilization 0.1(0%).... 1.0(100%)
#set CELL_DENSITY     0.075 	; 	# Core and module sizes by standard cell density.


set CORE_TO_LEFT   125 		; 	# Distance from core to die/io in micron. (150 width if you are using core to io margin here and use noSnapToGrid option with floorplan command).
set CORE_TO_BOTTOM 125 		; 	# Distance from core to die/io in micron. (150 width if you are using core to io margin here and use noSnapToGrid option with floorplan command).
set CORE_TO_RIGHT  125	 	; 	# Distance from core to die/io in micron. (150 width if you are using core to io margin here and use noSnapToGrid option with floorplan command).
set CORE_TO_TOP    125		; 	# Distance from core to die/io in micron. (150 width if you are using core to io margin here and use noSnapToGrid option with floorplan command).


set   DIE_WIDTH   1240		; 	# Width of the die
set   DIE_HEIGHT  1240		; 	# Height of the die 


#set  CORE_HEIGHT 500	 	; 	# Height of the core
#set  CORE_WIDTH  500 		; 	# Width of the core


set   CORE_MARGIN_BY die	; 	# Specify die -> core to die and io -> core to io 
set   DESIGN_SITE CoreSite 	; 	# Specifies a core row site.


#set FP_ORIGIN center 		; 	# Specifies whether the origin of the floorplan should be at the center or at the lower left corner (default=> lcorner).


###################################################################################################

## Specifying floorpln using Size and Core Margins by size; or by die, I/O, or core coordinates,
## -adjustToSite: Adjusts the width of die area such that it is an integer multiple of the width of
## 				  the IO site or core site,
## -coreMArginBy: Specifies whether the core margins are calculated using the core-to-IO boundary 
##				  or the core-to-die boundary, (Default : io)
## -site	: Specifies a core row site
## -d 		: Specifies the die size and the spacing, in micrometers, between the die edge,
## 		  	  which is the margin between the outside edge of the die.
## -r 		: Specifies the chip's core dimensions as the ratio of the height divided by the width.
## (**By default floorplan origin at LL corner)

###################################################################################################


##Select coreMarginBy io for core to io boundary and coreMarginBy die for core to die boundary.


##By Die size only with core to die/io margin

floorPlan -site $DESIGN_SITE \
	-d $DIE_WIDTH $DIE_HEIGHT $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP


##To originate floorplan from center set fplanorigin to center

#floorPlan \
#	-fplanOrigin $FP_ORIGIN \
#	-site $DESIGN_SITE \
#	-d $DIE_WIDTH $DIE_HEIGHT $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP


###By Aspect Ratio and Core Utilization 

#floorPlan \
#	-coreMarginsBy $CORE_MARGIN \
#	-site $DESIGN_SITE \
#	-r $ASPECT_RATIO $CORE_UTILIZATION $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP


###By Aspect Ratio and standard cell density/utilization (stdCellDensity = std cell area/(core area - block/macro area))

# floorPlan \
#	-coreMarginsBy $CORE_MARGIN_BY\
#	-site $DESIGN_SITE \
#	-r $ASPECT_RATIO $CELL_DENSITY $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP



###################################################################################################

## To delete existing routing tracks & honors the pitch specified in the LEF file

###################################################################################################

add_tracks -honor_pitch

#setObjFPlanBox Module DUT 420 420 1591.52 1591.52

checkFPlan -outFile ./FloorPlanning/${init_top_cell}_floorplan.rpt

saveDesign ./FloorPlanning/${init_top_cell}_floorplan.enc



###################################################################################################

## Add I/O instances in the I/O box. These are added between the gap of existing I/O pad instances.
## -cell		: Specifies the name list of the I/O filler cells to be added,
## -prefix		: Specifies the prefix name for the new I/O filler instances,
## -fillAnyGap	: Forces the I/O filler instance into a gap even though the gap (clearance) is not 
## 				  large enough,

###################################################################################################

set IO_CELL_PREFIX FILLER 	; 									# Specifies the prefix name for the new I/O filler instances.
set IO_CELL_NAME {pfeed30000 pfeed10000 pfeed02000 pfeed01000 pfeed00540 pfeed00120 pfeed00040}	; 	# Specifies the name list of the I/O filler cells to be added.

addIoFiller \
	-prefix	$IO_CELL_PREFIX \
	-cell $IO_CELL_NAME


## To forces the I/O filler instance into a gap even though the gap (clearance) is not large enough.	 
addIoFiller -fillAnyGap \
	-prefix $IO_CELL_PREFIX \
	-cell pfeed00010



###################################################################################################

## Reports generation:
## setVerifyGeometryMode - Sets global parameters for verify geometry, like shorts, overlap, etc
## verifyGeometry - Checks width, spacing, and internal geometry of objects and wiring between them,
## verify_drc - Checks for DRC violations and creates violation markers in the design database,
## verifyConnectivity - Detects conditions such as opens, unconnected wires (geometric antennas), 
## 						unconnected pins, loops, partial routing, and unrouted nets,
## timeDesign - Runs Early Global Route, extraction, and timing analysis, and generates detailed 
## 				timing reports.
## saveDesign - Saves files for design import, floorplan, placement, routing, and power switch 
## 				state information in the specified directory,

###################################################################################################	

setVerifyGeometryMode -short true -padFillerCellsOverlap false -error 100000

verifyGeometry > ./FloorPlanning/${init_top_cell}.geom.rpt

verify_drc > ./FloorPlanning/${init_top_cell}.drc.rpt

verifyConnectivity -type all -connLoop -error 10000 -warning 5000

timeDesign -prePlace -outDir ./FloorPlanning/${init_top_cell}_timing.rpt

saveDesign ./FloorPlanning/${init_top_cell}_fp_filler.enc
