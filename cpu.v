`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:35 06/17/2021 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
	 input [7:0] instruction,
    input fast_clock,
	 output clock,
    input clear,
	 // test outputs need clear // 
	 output [7:0] rval1,
	 output [7:0] rval2,
	 
	 output [7:0] reg_write_data,
	 output ctrl_memtoreg,
	 output ctrl_alusrc,
	 output [7:0] data_out,
	 output [7:0] output_alu,
	 // until here // 
    output [6:0] first_segment,
    output [6:0] second_segment,
    output [7:0] read_address

    );

    // 1-second clock
    //wire clock;

    // control signals
	 //wire ctrl_memtoreg;
    wire ctrl_regwrite;
    //wire ctrl_alusrc;
    wire ctrl_branch;
    wire ctrl_memread;
    wire ctrl_memwrite;
    wire ctrl_regdst;
    wire ctrl_aluop;
	 
    // outputs from register file
    //wire [7:0] rval1;
    //wire [7:0] rval2;

    // output from sign extend
    wire [7:0] sign_extended_imm;

    // output from data memory
    // wire [7:0] output_memory;

    // output from ALU 
    // wire [7:0] output_alu;

    // write data for register file, and also input for seven segments
    //wire [7:0] reg_write_data;
    assign reg_write_data = ctrl_memtoreg ? data_out : output_alu;

    // wires for next pc
    wire [7:0] incremented_pc;
    wire [7:0] displaced_pc;
    wire [7:0] next_pc;
    wire [7:0] ppc;
    assign next_pc = ctrl_branch ? displaced_pc : incremented_pc;
    assign read_address = ppc;

    // convert fast clock to 1-second clock
    freq_divider clk(
        .clock_in(fast_clock),
        .clear(clear),
        .clock_out(clock)
    );

    // control signal distribution
    control control(
        .opcode(instruction[7:6]),
        .ctrl_aluop(ctrl_aluop),
        .ctrl_alusrc(ctrl_alusrc),
        .ctrl_branch(ctrl_branch),
        .ctrl_regdst(ctrl_regdst),
        .ctrl_memread(ctrl_memread),
        .ctrl_memtoreg(ctrl_memtoreg),
        .ctrl_memwrite(ctrl_memwrite),
        .ctrl_regwrite(ctrl_regwrite)
    );

    // register file
    rf regiters(
        .rs1(instruction[5:4]),
        .rs2(instruction[3:2]),
        // mux implementation
        .write_reg(ctrl_regdst ? instruction[1:0] : instruction[3:2]),
        .ctrl_regwrite(ctrl_regwrite),
        .clock(clock),
        .clear(clear),
        // mux implementation
        .write_data(reg_write_data),
        .rval1(rval1),
        .rval2(rval2)
    );
	
    // data memory
    dmem data_memory(
        .clock(clock),
        .clear(clear),
        .ctrl_memread(ctrl_memread),
        .ctrl_memwrite(ctrl_memwrite),
        .addr(output_alu),
        .data_in(rval2),
        .data_out(data_out)
    );

    // sign extend
    sign_extend sign_extend(
        .in(instruction[1:0]),
        .out(sign_extended_imm)
    );

    // ALU
    add alu(
        .in1(rval1),
        // mux implementation
        .in2(ctrl_alusrc ? sign_extended_imm : rval2),
        .out(output_alu),
        .ctrl_aluop(ctrl_aluop)
    );

    // seven segments
    hex_to_bcd first_seg(
        .bcd(reg_write_data[7:4]),
        .seg(first_segment)
    );

    hex_to_bcd second_seg(
        .bcd(reg_write_data[3:0]),
        .seg(second_segment)
    );

    // pc incrementer
    add incrementer(
        .in1(8'b1),
        .in2(ppc),
        .out(incremented_pc),
        .ctrl_aluop(1'b1)
    );

    // displacement calculator (for branch)
    add displacer(
        .in1(incremented_pc),
        .in2(sign_extended_imm),
        .out(displaced_pc),
        .ctrl_aluop(1'b1)
    );

    // program counter
    pc pc(
        .clock(clock),
        .clear(clear),
        .ppc(ppc),
        .next_pc(next_pc)
    );
endmodule
