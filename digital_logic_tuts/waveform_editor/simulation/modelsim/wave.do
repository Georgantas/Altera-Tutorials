onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /majority3/x1
add wave -noupdate /majority3/x2
add wave -noupdate /majority3/x3
add wave -noupdate /majority3/f
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {840 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 400ps sim:/majority3/x1 
wave modify -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 400ps -endtime 800ps Edit:/majority3/x1 
wave modify -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 400ps Edit:/majority3/x1 
wave modify -driver freeze -pattern constant -value 1 -starttime 400ps -endtime 800ps Edit:/majority3/x1 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 800ps sim:/majority3/x2 
wave edit invert -start 200ps -end 400ps Edit:/majority3/x2 
wave edit invert -start 600ps -end 800ps Edit:/majority3/x2 
wave create -driver freeze -pattern clock -initialvalue {Not Logged} -period 200ps -dutycycle 50 -starttime 0ps -endtime 800ps sim:/majority3/x3 
WaveCollapseAll -1
wave clipboard restore
