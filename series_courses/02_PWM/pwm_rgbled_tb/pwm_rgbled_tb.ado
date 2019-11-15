setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled_tb/pwm_rgbled_tb.adf"]} { 
	design create pwm_rgbled_tb "D:/Project/Verilog/STEP/series_courses/02_PWM"
  set newDesign 1
}
design open "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled_tb"
cd "D:/Project/Verilog/STEP/series_courses/02_PWM"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled.v"
addfile "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled_tb.v"
vlib "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled_tb/work"
set worklib work
adel -all
vlog -dbg -work work "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled.v"
vlog -dbg -work work "D:/Project/Verilog/STEP/series_courses/02_PWM/pwm_rgbled_tb.v"
module pwm_rgbled_tb
vsim  +access +r pwm_rgbled_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
