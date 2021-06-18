`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:59 06/17/2021 
// Design Name: 
// Module Name:    control 
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
module control(    
    input [1:0] opcode,
    output ctrl_memtoreg,
    output ctrl_regwrite,
    output ctrl_alusrc,
    output ctrl_branch,
    output ctrl_memread,
    output ctrl_memwrite,
    output ctrl_regdst,
    output ctrl_aluop
    );

    wire A;
    wire B;

    assign A = opcode[1];
    assign B = opcode[0];

    assign ctrl_regdst = ~A && ~B;
    assign ctrl_regwrite = ~A;
    assign ctrl_alusrc = (~A && B) || (A && ~B);
    assign ctrl_branch = A && B;
    assign ctrl_memread = ~A && B;
    assign ctrl_memwrite = A && ~B;
    assign ctrl_memtoreg = B;
    assign ctrl_aluop = ~A && ~B;

endmodule
