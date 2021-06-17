`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:31 06/17/2021 
// Design Name: 
// Module Name:    freq_divider 
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
module freq_divider(
    input clock_in,
    input clear,
    output reg clock_out
    );
	 
	 reg [31:0] cnt;
	 
	 initial begin
		clock_out <= 1'b0;
		cnt <= 0;
	 end
	 
	 always@(posedge clock_in) begin
		if(clear) begin
			cnt <= 32'd0;
			clock_out <= 1'b0;
		end
		else if(cnt == 32'd25000000) begin
			cnt <= 32'd0;
			clock_out <= ~clock_out;
		end else begin
			cnt <= cnt + 1;
		end
	 end

endmodule
