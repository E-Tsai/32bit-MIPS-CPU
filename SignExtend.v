`timescale 1ns / 1ps
module SignExtend(
	input signed [15:0]imm,
	output [31:0]signedimm
   );
	parameter [31:0] N = 32'hffffffff;
	parameter [31:0] P = 32'h0;
	
	assign signedimm = (imm[15] == 1)?(imm + N):(imm + P);

endmodule
