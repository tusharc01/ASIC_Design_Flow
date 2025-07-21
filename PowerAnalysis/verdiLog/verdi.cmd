simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
verdiSetActWin -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_InteractiveConsole_2
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
srcHBSelect "testbench.u1" -win $_nTrace1
wvCreateWindow
srcHBAddObjectToWave -clipboard
wvDrop -win $_nWave3
verdiDockWidgetMaximize -dock windowDock_nWave_3
srcTBRunSim
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
verdiSetActWin -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomAll -win $_nWave3
verdiDockWidgetHide -dock windowDock_nWave_3
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiDockWidgetHide -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave3
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_2
verdiSetActWin -win $_InteractiveConsole_2
report_power > power1
report_power > power1
report_power
srcHBSelect "testbench.u1" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
verdiSetActWin -win $_InteractiveConsole_2
report_power
debExit
