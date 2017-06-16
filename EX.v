`timescale 1ns / 1ps
module EX(
	input clk,
	input rst_n,

	input [3:0]ALUControlE,
	input ALUSrcE,
	input RegDstE,
	input [31:0]RD1E,
	input [31:0]RD2E,
	input [4:0]RtE,
	input [4:0]RdE,
	input [31:0]SignImmE,
	input ALUASrcE,
	input [4:0]shamtE,

	input [31:0]ALUOutM,
	input [31:0]ResultW,

	input [1:0]ForwardAE,
	input [1:0]ForwardBE,

	output [31:0]ALUOutE,
	output [31:0]WriteDataE,
	output [4:0]WriteRegE
    );

	wire [31:0]SrcAE;
	wire [31:0]SrcAE_;
	wire [31:0]SrcBE;

	ALU alu(SrcAE,SrcBE,ALUControlE,ALUOutE);
	//////////////////////////////////////////////////////////////////////////////
	assign SrcAE_ = (ForwardAE == 0) ? RD1E : ((ForwardAE==1) ? ResultW : ALUOutM);
	assign WriteDataE = ForwardBE == 0 ? RD2E : ForwardBE == 1 ? ResultW : ALUOutM;
	assign SrcBE = ALUSrcE ? SignImmE : WriteDataE;
	assign WriteRegE = RegDstE ? RdE : RtE;
	assign SrcAE=ALUASrcE?shamtE:SrcAE_;

endmodule
