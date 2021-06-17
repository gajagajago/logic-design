`timescale 1ns / 1ps

module pc(
    input clock,
    input clear,
    input [7:0] next_pc,
    output [7:0] pc_out 
);
    reg [7:0] current_pc;

    // initial pc value is 0
    initial begin
        current_pc <= 8'b0;
    end

    // pc output
    assign pc_out = current_pc;

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            current_pc <= 8'b0;
        end
        else begin
            // reload pc to next pc
            current_pc <= next_pc;
        end
    end

endmodule