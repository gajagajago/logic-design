`timescale 1ns / 1ps

module sign_extend(
    input [1:0] in,
    output [7:0] out
);
    assign out = {in[1], in[1], in[1], in[1], in[1], in[1], in[1], in[0]};

endmodule