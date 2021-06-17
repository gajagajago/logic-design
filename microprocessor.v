`timescale 1ns / 1ps

module microprocessor(
    input [7:0] instruction,
    input fast_clock,
    input clear,
	 // test outputs need clear // 
	 output [7:0] reg_write_data,
	 output [7:0] output_memory,
	 output [7:0] output_alu,
	 // until here // 
    output [6:0] first_segment,
    output [6:0] second_segment,
    output [7:0] read_address,
    // additional implementation (show register to seven segment)
	 // input [3:0] tactile,
    output [6:0] reg0_segment,
    output [6:0] reg1_segment,
    output [6:0] reg2_segment,
    output [6:0] reg3_segment,
    // show clock signal (red led)
    output out_clock
    );

    // 1-second clock
    wire clock;
    // show clock to led
    assign out_clock = clock;

    // control signals
	 wire signal_memtoreg;
    wire signal_regwrite;
    wire signal_alusrc;
    wire signal_branch;
    wire signal_memread;
    wire signal_memwrite;
    wire signal_regdst;
    wire signal_aluop;
	 
    // outputs from register file
    wire [7:0] output_reg1;
    wire [7:0] output_reg2;

    // output from sign extend
    wire [7:0] sign_extended_imm;

    // output from data memory
    // wire [7:0] output_memory;

    // output from ALU 
    // wire [7:0] output_alu;

    // write data for register file, and also input for seven segments
    //wire [7:0] reg_write_data;
    assign reg_write_data = signal_memtoreg ? output_memory : output_alu;

    // wires for next pc
    wire [7:0] incremented_pc;
    wire [7:0] displaced_pc;
    wire [7:0] next_pc;
    wire [7:0] output_pc;
    assign next_pc = signal_branch ? displaced_pc : incremented_pc;
    assign read_address = output_pc;

    // wire for showing seven segment of register content
    wire [7:0] reg0_segment_;
    wire [7:0] reg1_segment_;
    wire [7:0] reg2_segment_;
    wire [7:0] reg3_segment_;


    // convert fast clock to 1-second clock
    clock_divider new_clock(
        .clock_in(fast_clock),
        .clear(clear),
        .clock_out(clock)
    );

    // control signal distribution
    control_unit control(
        .opcode(instruction[7:6]),
        .signal_aluop(signal_aluop),
        .signal_alusrc(signal_alusrc),
        .signal_branch(signal_branch),
        .signal_regdst(signal_regdst),
        .signal_memread(signal_memread),
        .signal_memtoreg(signal_memtoreg),
        .signal_memwrite(signal_memwrite),
        .signal_regwrite(signal_regwrite)
    );

    // register file
    register_file regiters(
        .read_reg1(instruction[5:4]),
        .read_reg2(instruction[3:2]),
        // mux implementation
        .write_reg(signal_regdst ? instruction[1:0] : instruction[3:2]),
        .signal_regwrite(signal_regwrite),
        .clock(clock),
        .clear(clear),
        // mux implementation
        .write_data(reg_write_data),
        .output_reg1(output_reg1),
        .output_reg2(output_reg2),
        // additional implementation
        .reg0_segment(reg0_segment_),
        .reg1_segment(reg1_segment_),
        .reg2_segment(reg2_segment_),
        .reg3_segment(reg3_segment_)
    );

    // data memory
    data_memory data_memory(
        .clock(clock),
        .clear(clear),
        .signal_memread(signal_memread),
        .signal_memwrite(signal_memwrite),
        .address(output_alu),
        .data_to_write(output_reg2),
        .data_out(output_memory)
    );

    // sign extend
    sign_extend sign_extend(
        .in(instruction[1:0]),
        .out(sign_extended_imm)
    );

    // ALU
    adder alu(
        .in1(output_reg1),
        // mux implementation
        .in2(signal_alusrc ? sign_extended_imm : output_reg2),
        .out(output_alu),
        .signal_aluop(signal_aluop)
    );

    // seven segments
    hex_to_seven_segment first_seg(
        .bcd(reg_write_data[7:4]),
        .seg(first_segment)
    );

    hex_to_seven_segment second_seg(
        .bcd(reg_write_data[3:0]),
        .seg(second_segment)
    );

    // pc incrementer
    adder incrementer(
        .in1(8'b1),
        .in2(output_pc),
        .out(incremented_pc),
        .signal_aluop(1'b1)
    );

    // displacement calculator (for branch)
    adder displacer(
        .in1(incremented_pc),
        .in2(sign_extended_imm),
        .out(displaced_pc),
        .signal_aluop(1'b1)
    );

    // program counter
    pc pc(
        .clock(clock),
        .clear(clear),
        .pc_out(output_pc),
        .next_pc(next_pc)
    );


    // CODE BELOW ARE ADDITIONAL IMPLEMENTATION
    
    hex_to_seven_segment h1(
        .bcd(reg0_segment_[3:0]),
        .seg(reg0_segment)
    );

    hex_to_seven_segment h2(
        .bcd(reg1_segment_[3:0]),
        .seg(reg1_segment)
    );

    hex_to_seven_segment h3(
        .bcd(reg2_segment_[3:0]),
        .seg(reg2_segment)
    );

    hex_to_seven_segment h4(
        .bcd(reg3_segment_[3:0]),
        .seg(reg3_segment)
    );
	 
	 

endmodule