`timescale 1ns / 1ps
module ALU(
    input signed [31:0] alu_a,
	 input signed [31:0] alu_b,
	 input [4:0] shamt,
	 input 		  [3:0] 	alu_op,
	 output reg   [31:0] alu_out
);
parameter A_ADD  = 4'b000;
parameter A_ADDU = 4'b001;
parameter A_SUB  = 4'b010;
parameter A_SUBU  = 4'b011;
parameter A_AND  = 4'b100;
parameter A_OR   = 4'b101;
parameter A_XOR  = 4'b110;
parameter A_NOR  = 4'b111;
parameter A_SLL  = 4'b1000;
parameter A_SLLV = 4'b1001;
parameter A_SRL  = 4'b1010;
parameter A_SRLV = 4'b1011;

initial
alu_out = 0;

assign zero = alu_a > 0;

always@(*)
case(alu_op)
	A_ADD: 	alu_out = alu_a + alu_b;
	A_ADDU: 	alu_out = alu_a + alu_b;
	A_SUB: 	alu_out = alu_a - alu_b;
	A_SUBU: 	alu_out = alu_a - alu_b;
	A_AND:	alu_out = alu_a & alu_b;
	A_OR:		alu_out = alu_a | alu_b;
	A_XOR:	alu_out = alu_a ^ alu_b;
	A_NOR:   alu_out = ~(alu_a | alu_b);
	A_SLL: 	alu_out = alu_b << shamt;
	A_SLLV:  alu_out = alu_b << alu_a;
	A_SRL: 	alu_out = alu_b >> shamt;
	A_SRLV:	alu_out = alu_b >> alu_a;
endcase
	


endmodule
