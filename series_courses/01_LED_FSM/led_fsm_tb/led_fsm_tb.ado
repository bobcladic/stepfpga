setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_tb/led_fsm_tb.adf"]} { 
	design create led_fsm_tb "D:/Project/Verilog/STEP/series_courses/01_LED_FSM"
  set newDesign 1
}
design open "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_tb"
cd "D:/Project/Verilog/STEP/series_courses/01_LED_FSM"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_top.v"
addfile "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_tb.v"
vlib "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_tb/work"
set worklib work
adel -all
vlog -dbg -work work "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_top.v"
vlog -dbg -work work "D:/Project/Verilog/STEP/series_courses/01_LED_FSM/led_fsm_tb.v"
module led_fsm_tb
vsim  +access +r led_fsm_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
