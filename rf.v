`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:19:21 06/17/2021 
// Design Name: 
// Module Name:    rf 
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
module rf(    
    input [1:0] rs1,
    input [1:0] rs2,
    input [1:0] write_reg,
    input [7:0] write_data,
    input ctrl_regwrite,
    input clock,
    input clear,
    output [7:0] rval1,
    output [7:0] rval2
    );

    reg [7:0] register [0:3];

    initial begin
        register[0] <= 8'b0;
        register[1] <= 8'b0;
        register[2] <= 8'b0;
        register[3] <= 8'b0;
    end

    assign rval1 = register[rs1];
    assign rval2 = register[rs2];

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            register[0] <= 8'b0;
            register[1] <= 8'b0;
            register[2] <= 8'b0;
            register[3] <= 8'b0;
        end
        else begin
            if (ctrl_regwrite) begin
                register[write_reg] <= write_data;
            end
        end
    end
endmodule
