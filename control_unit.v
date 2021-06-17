`timescale 1ns / 1ps

module control_unit(
    input [1:0] opcode,
    output signal_memtoreg,
    output signal_regwrite,
    output signal_alusrc,
    output signal_branch,
    output signal_memread,
    output signal_memwrite,
    output signal_regdst,
    output signal_aluop
    );

    wire A;
    wire B;

    assign A = opcode[1];
    assign B = opcode[0];

    // K-map minimization (combinational logic)
    assign signal_regdst = ~A && ~B;
    assign signal_regwrite = ~A;
    assign signal_alusrc = (~A && B) || (A && ~B);
    assign signal_branch = A && B;
    assign signal_memread = ~A && B;
    assign signal_memwrite = A && ~B;
    assign signal_memtoreg = B;
    assign signal_aluop = ~A && ~B;

endmodule