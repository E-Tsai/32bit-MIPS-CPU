`timescale 1ns / 1ps
module IF(
	input				clk,
	input 			rst_n,
	input 			PCSrcD,
	input [31:0]	PCBranchD,
	input			 	StallF,	
	output [31:0]	InstrF,
	output [31:0]	PCPlus4F
    );
	
	wire [31:0] iPC;

	reg [31:0]	PCF;
	
	IMEM imem(PCF[9:2],InstrF);		//every four

	assign iPC = PCSrcD ? PCBranchD : PCPlus4F;
	assign PCPlus4F = PCF + 4;

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) 
		begin
			PCF<=0;
		end
		else if(~StallF)
		begin
			PCF<=iPC;
		end
	end

endmodule
