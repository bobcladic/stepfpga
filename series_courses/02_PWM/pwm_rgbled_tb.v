//=====================================================================
//
// Author: Bob.C
// Latest update: 2019/11/14 31:32:46
// Description:
//   PWM generator, rgbled vision effect 
// Version: 0.01
// Info: 
//   0.01    Bob.C    Prototype code
//   0.02    Bob.C    Add testbench file led_fsm_tb.v
// 
// ====================================================================

/*timescale*/
    `timescale 1ns / 1ps

module pwm_rgbled_tb();
	
reg clk;
reg rst_n;
wire [7:0] wvled;
wire [2:0] wvrgbled1;
wire [2:0] wvrgbled2;
initial begin
	rst_n <= 0;
	clk <= 0;
	#20 rst_n <= 1;
end

always #10 clk =~clk;

pwm_rgbled pwm_rgbled(
    .iclk(clk),
    .irst_n(rst_n),
    .owvled(wvled),
    .owvrgbled1(wvrgbled1),
    .owvrgbled2(wvrgbled2)
);


endmodule