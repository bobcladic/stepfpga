//=====================================================================
//
// Author: Bob.C
// Latest update: 2019/11/14 09:23:53
// Description:
//   Float led, shift one bit per second 
// Version: 0.01
// Info: 
//   0.01    Bob.C    Prototype code
// 
// ====================================================================

/*timescale*/
    `timescale 1ns / 1ps


module led_fsm_tb();
reg clk;
reg rst_n;
wire [7:0] led;
initial begin
    clk <= 0;
    rst_n <= 0;
    #20 rst_n <= 1;
end
always #10 clk = ~clk;

led_fsm_top led_fsm_top(
    .iclk(clk),
    .irst_n(rst_n),
    .owvled (led[7:0])
);
endmodule