`timescale 1ns / 1ps

module register_file(
    input [1:0] read_reg1,
    input [1:0] read_reg2,
    input [1:0] write_reg,
    input [7:0] write_data,
    input signal_regwrite,
    input clock,
    input clear,
    output [7:0] output_reg1,
    output [7:0] output_reg2,
    output [7:0] reg0_segment,
    output [7:0] reg1_segment,
    output [7:0] reg2_segment,
    output [7:0] reg3_segment
    );

    // total four registers
    reg [7:0] register [0:3];

    // initalize to 0
    initial begin
        register[0] <= 8'b0;
        register[1] <= 8'b0;
        register[2] <= 8'b0;
        register[3] <= 8'b0;
    end

    // SHOULD BE wire (only read)
    assign output_reg1 = register[read_reg1];
    assign output_reg2 = register[read_reg2];

    // for showing register value to seven segments
    assign reg0_segment = register[0];
    assign reg1_segment = register[1];
    assign reg2_segment = register[2];
    assign reg3_segment = register[3];

    // main loop
    always @(posedge clock or posedge clear) begin
        if (clear) begin
            register[0] <= 8'b0;
            register[1] <= 8'b0;
            register[2] <= 8'b0;
            register[3] <= 8'b0;
        end
        else begin
            if (signal_regwrite) begin
                register[write_reg] <= write_data;
            end
        end
    end
endmodule