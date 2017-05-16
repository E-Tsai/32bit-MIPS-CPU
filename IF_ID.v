`timescale 1ns / 1ps
module IF_ID(
	input clk,
	input rst_n,
	input en,
	input clr,

	input [31:0]InstrF,
	output reg [31:0]InstrD,
	input [31:0]PCPlus4F,
	output reg [31:0]PCPlus4D
    );
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			InstrD<=0;
			PCPlus4D<=0;
		end
		else if (en) begin
			InstrD<=InstrF;
			PCPlus4D<=PCPlus4F;
			if(clr) begin
				InstrD<=0;
				PCPlus4D<=0;
			end
		end
	end
endmodule
