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

/*define*/
    //`define SIMULATION
    `ifdef SIMULATION
        `define SYS_FREQ 12
    `else
        `define SYS_FREQ 60_000_000
    `endif
    `define PWM_FREQ 12_0000
    `define SAWTOOTH 2'b01
    `define TRIANGLE 2'b10

/*include*/

/*top module*/
module pwm_rgbled(
    input iclk,
    input irst_n,
    output [7:0] owvled,
    output [2:0] owvrgbled1,
    output [2:0] owvrgbled2
);

assign owvled[7:0] = 8'hff;

wire sysclk; assign sysclk = iclk;
wire sysrst_n; assign sysrst_n = irst_n;

// impl of sawtooth wave
wire [31:0] wvpwm;
counter#(/* synthesis syn_noprune=1 */
    .MODE("saw"),
    .COUNTER_NUM(`SYS_FREQ),
    .INIT_NUM(0),
    .STEP(`SYS_FREQ / `PWM_FREQ)
)
pwm(
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .owvcntnum(wvpwm[31:0])
);
//

//
wire [31:0] wvrgbled_pwm_r;
wire [31:0] wvrgbled_pwm_g;
wire [31:0] wvrgbled_pwm_b;
counter#( /* synthesis syn_noprune=1 */
    .MODE("tri"),
    .COUNTER_NUM(2*`SYS_FREQ),
    .INIT_NUM(2*`SYS_FREQ*0/3),
    .STEP(1)
)
rgbled_flash_r( // red led
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .owvcntnum(wvrgbled_pwm_r[31:0])
);

counter#( /* synthesis syn_noprune=1 */
    .MODE("tri"),
    .COUNTER_NUM(2*`SYS_FREQ),
    .INIT_NUM(2*`SYS_FREQ*1/3),
    .STEP(1)
)
rgbled_flash_g( // green led
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .owvcntnum(wvrgbled_pwm_g[31:0])
);

counter#( /* synthesis syn_noprune=1 */
    .MODE("tri"),
    .COUNTER_NUM(2*`SYS_FREQ),
    .INIT_NUM(2*`SYS_FREQ*2/3),
    .STEP(1)
)
rgbled_flash_b( // blue led
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .owvcntnum(wvrgbled_pwm_b[31:0])
);



assign owvrgbled1[0] = (wvrgbled_pwm_r > wvpwm) ? 1 : 0;
assign owvrgbled1[1] = (wvrgbled_pwm_g > wvpwm) ? 1 : 0;
assign owvrgbled1[2] = (wvrgbled_pwm_b > wvpwm) ? 1 : 0;
assign owvrgbled2[2:0] = owvrgbled1[2:0];

endmodule


module counter #(
    parameter MODE = "saw",
    parameter COUNTER_NUM = `SYS_FREQ,
    parameter INIT_NUM = 0,
    parameter STEP = 1
)
(
    input iclk,
    input irst_n,
    output [31:0] owvcntnum
);
    reg [31:0] rvcntnum_saw;
    reg [31:0] rvcntnum_tri;
    assign owvcntnum[31:0] = (MODE == "saw") ? rvcntnum_saw[31:0] : rvcntnum_tri[31:0];
    always @(posedge iclk or negedge irst_n ) begin
        if (!irst_n) begin
            rvcntnum_saw[31:0] <= INIT_NUM;
        end
        else if (rvcntnum_saw >= COUNTER_NUM - 1) begin
            rvcntnum_saw <= 0;
        end
        else begin
            rvcntnum_saw <= rvcntnum_saw + STEP;
        end
    end

    always @(posedge iclk or negedge irst_n ) begin
        if (!irst_n) begin
            rvcntnum_tri[31:0] <= INIT_NUM;
        end
        else if ((rvcntnum_saw >= 0) & (rvcntnum_saw < COUNTER_NUM/2 - 1)) begin
            rvcntnum_tri <= rvcntnum_tri + STEP;
        end
        else if ((rvcntnum_saw >= COUNTER_NUM/2) & (rvcntnum_saw < COUNTER_NUM - 1)) begin
            rvcntnum_tri <= rvcntnum_tri - STEP;
        end
    end
endmodule
