###################################################################################################
## 					Routing 						 ##
###################################################################################################

set ROUTE_TIMING true ; 	# true | false ‐> For timing driven routing

set ROUTE_TDR_EFFORT 0 ; 	# 0..10 ‐> 0: opt. for congestion; 1: opt. for timing

set ROUTE_SI true ; 		# true | false ‐> For SI aware routing

set ANTENNA_CELL true ; 	# To insert Antenna cells

set ANTENNA_CELL_NAME adiode ; 	# Name of antenna cell to be used in design

###################################################################################################

## Controls certain aspects of how the NanoRoute router routes the design. It affect the behavior 
## of the following commands - detailRoute, globalRoute, globalDetailRoute, routeDesign.
## 
## -routeWithTimingDriven : Minimizes timing violations by analyzing the timing slack for each path,
## 							the drive strengths of each cell in the library, and the maximum cap 
## 							and maximum transition limits.
## -routeTdrEffort 		: To set congestion and timing efforts.
## -routeWithSiDriven 	: Prevents or reduces crosstalk in conjunction with timingdriven routing.
## -routeInsertAntennaDiode : Inserts & places antenna diode cells if there are available placement
## 							  locations. Default - the NanoRoute router repairs antenna violations 
## 							  by changing layers.
## -routeAntennaCellName 	: Specifies antenna diode cells to use during postroute optimization.

###################################################################################################

setNanoRouteMode \
	-routeWithTimingDriven $ROUTE_TIMING \
	-routeTdrEffort $ROUTE_TDR_EFFORT \
	-routeWithSiDriven $ROUTE_SI \
	-routeInsertAntennaDiode $ANTENNA_CELL \
	-routeAntennaCellName $ANTENNA_CELL_NAME

###################################################################################################

## routeDesign : 
## 			Runs routing or postroute via or wire optimization using the NanoRoute router. If you 
## 			specify this command without any arguments, it runs global and detailed routing.
## -globalDetail 	: Runs timing-driven and SI-driven global and detailed routing,
## -detail 			: Runs timing-driven and SI-driven detailed routing,
## -global 			: Runs timing-driven and SI-driven global routing,
##
## checkRoute :
## 			Checks the routing connectivity and reports the unconnected terminals, the number of 
## 			open connections, and the number of dislocated and offgrid terminals.

###################################################################################################

routeDesign -globalDetail

##routeDesign -Detail

#checkRoute > ./Routing/${init_top_cell}_route.rpt

#reportCongestion -overflow -hotSpot > ./Routing/${init_top_cell}_postRoute_congestion.rpt

source ./userDrawHotSpots.tcl

clearDrc

userDrawHotSpots

saveDesign ./Routing/${init_top_cell}_detailedRoute.enc

###################################################################################################

## Timing and DRVs Optimization
## Timing and DRVs report generation

###################################################################################################

#source ./sta_route.tcl

#source drv.tcl

#timeDesign -postRoute > ./Routing/${init_top_cell}_postRoute_setup.rpt

#timeDesign -postRoute -hold > ./Routing/${init_top_cell}_postRoute_hold.rpt

###################################################################################################
###                              STANDARD CELL FILLERS                                            ##
####################################################################################################

###################################################################################################

set FILLER_CELL_NAME {feedth feedth3 feedth9}

set FILLER_PREFIX FILLER

addFiller -doDRC -fitGap -markFixed \
        -cell $FILLER_CELL_NAME \
                -prefix $FILLER_PREFIX

reportCongestion -overflow -hotSpot > ./Routing/${init_top_cell}_postFill_congestion.rpt
#


###################################################################################################
## Post Route Gatecount and congestion report generation
###################################################################################################

reportGateCount -hinst fifo -level 10 -outfile ./Routing/${init_top_cell}_gatecount.rpt

reportCongestion -overflow -hotSpot > ./Routing/${init_top_cell}_postOpt_congestion.rpt

saveDesign ./Routing/${init_top_cell}_postRoute_timing.enc

saveNetlist -includePowerGround ./Routing/${init_top_cell}_postRoute_withPG.v

saveNetlist ./Routing/${init_top_cell}_postRoute_withoutPG.v

write_sdc ./Routing/${init_top_cell}_postRoute.sdc

write_sdf -version 2.1 -edges noedge -recrem split -setuphold merge_when_paired ./Routing/${init_top_cell}_postRoute_with_pad_delay.sdf

rcOut -spef ./Routing/${init_top_cell}_postRoute.spef

streamOut CYPHER_route.gds -mapFile /home/nitrkl04/Desktop/PD/dependencies/routing/gds2_fe_4l.map -libName DesignLib -units 1000 -mode ALL

###################################################################################################
## Post Route Design Checks and saving the design
###################################################################################################

saveDesign ./Routing/${init_top_cell}_Route.enc

