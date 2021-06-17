`timescale 1ns / 1ps

module adder(
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] out,
    input signal_aluop
);
    // only need add
    assign out = in1 + in2;

endmodule 