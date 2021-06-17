`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:07 06/17/2021 
// Design Name: 
// Module Name:    pc 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pc(
	 input clock,
    input clear,
    input [7:0] next_pc,
    output [7:0] ppc 
);
    reg [7:0] curr_pc;

    // initial pc value is 0
    initial begin
        curr_pc <= 8'b0;
    end

    // pc output
    assign ppc = curr_pc;

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            curr_pc <= 8'b0;
        end
        else begin
            // reload pc to next pc
            curr_pc <= next_pc;
        end
    end
endmodule
