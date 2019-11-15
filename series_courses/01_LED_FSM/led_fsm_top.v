//=====================================================================
//
// Author: Bob.C
// Latest update: 2019/11/13/11:44:04
// Description:
//   Float led, shift one bit per second 
// Version: 0.02
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
		`define SYS_FREQ 12_000_000
    `endif

/*include*/

/*top module*/
module led_fsm_top(
    input iclk,
    input irst_n,
    output [7:0] owvled,
    output [2:0] owvrgbled1,
    output [2:0] owvrgbled2
);

assign owvrgbled1[2:0] = 3'b111;
assign owvrgbled2[2:0] = 3'b111;

wire sysclk; assign sysclk = iclk;
wire sysrst_n; assign sysrst_n = irst_n;

// impl of led controller
wire [2:0] wvstate;
led_controller impl_led_controller( // led state output 
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .ivstate(wvstate[2:0]),
    .owvled(owvled[7:0])
);
//

// impl of state control
wire wcondition;
state_controller impl_state_controller( // state jump 
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .icondition(wcondition),
    .owvstate(wvstate[2:0])
);
//

// impl of condition judge
condition_judge condition_judge( // jump condition generator
    .iclk(sysclk),
    .irst_n(sysrst_n),
    .owcondition(wcondition)
);
//

endmodule

`define LED1 3'b000 
`define LED2 3'b001 
`define LED3 3'b010 
`define LED4 3'b011 
`define LED5 3'b100 
`define LED6 3'b101 
`define LED7 3'b110 
`define LED8 3'b111 
module led_controller(
    input iclk,
    input irst_n,
    input [2:0] ivstate,
    output [7:0] owvled
);
    reg [7:0] rvled;
    assign owvled[7:0] = rvled[7:0];
    always @(posedge iclk or negedge irst_n ) begin
        if (!irst_n) begin
            rvled[7:0] <= 8'b1111_1110;
        end
        else begin
            case (ivstate[2:0])
                `LED1: rvled[7:0] <= 8'b1111_1110;
                `LED2: rvled[7:0] <= 8'b1111_1101;
                `LED3: rvled[7:0] <= 8'b1111_1011;
                `LED4: rvled[7:0] <= 8'b1111_0111;
                `LED5: rvled[7:0] <= 8'b1110_1111;
                `LED6: rvled[7:0] <= 8'b1101_1111;
                `LED7: rvled[7:0] <= 8'b1011_1111;
                `LED8: rvled[7:0] <= 8'b0111_1111;
                default: rvled[7:0] <= 8'b1111_1110;
            endcase
        end
    end
    always @(ivstate) begin
        $display("%b",rvled[7:0]);
    end
endmodule

module state_controller(
    input iclk,
    input irst_n,
    input icondition,
    output [2:0] owvstate
);
    reg [2:0] rvstate;
    assign owvstate[2:0] = rvstate[2:0];
    always @(posedge iclk or negedge irst_n ) begin
        if (!irst_n) begin
            rvstate[2:0] <= 3'b000;
        end
        else if (icondition) begin
            rvstate <= rvstate + 1;
        end
        else
            rvstate <= rvstate;
        /*case (icondition)
            0: rvstate <= rvstate;
            1: rvstate <= rvstate_1; 
            2: rvstate <= rvstate_2; 
            3: rvstate <= rvstate_3; 
            default: rvstate <= rvstate;
        endcase*/
            
    end
endmodule

module condition_judge #(
    parameter COUNTER_NUM = `SYS_FREQ
)
(
    input iclk,
    input irst_n,
    output owcondition
);
    reg [31:0] rvcounter;
    assign owcondition = (rvcounter == COUNTER_NUM) ? 1 : 0;
    always @(posedge iclk or negedge irst_n ) begin
        if (!irst_n) begin
            rvcounter[31:0] <= 32'h00000000;
        end
        else if (rvcounter == COUNTER_NUM) begin
            rvcounter[31:0] <= 32'h00000000;
        end
        else begin
            rvcounter <= rvcounter + 1;
        end
    end
endmodule
