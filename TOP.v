`timescale 1ns / 1ps
module top(
	input c,
	input [7:0] switch,
	output [6:0] digits,
	output [3:0] sel
);

wire [31:0] PC3, PC2, PC, PC_N, PCN, PCF, PCPlus4F, InstF, PCPlus4D, InstD, WriteDataE, WriteDataM, ALUOutE, ALUOutM, ALUOutW, SrcAE, SrcBE, ResultW;
wire [31:0] RD1E, RD2E, RD1D, RD2D, RD1Out, RD2Out, SignImmD, SignImmE, PCBranchD, ReadDataW, ReadDataM, SignImmD2, MEMREAD;
wire [25:0] address;
wire [15:0] immediate, READOUT;
wire [5:0] opcode, funct;
wire [4:0] RsD, RtD, RdD, RsE, RtE, RdE, shamt, A1, A2, WriteRegE, WriteRegM, WriteRegW, shamtE;
wire [3:0] ALUControlD, ALUControlE;
wire [1:0] ForwardAE, ForwardBE,PredictorStateF, PredictorStateD;
wire PCSrcD, StallF, StallD, BranchD, EqualD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, Wrong;
wire RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, RegWriteM, MemtoRegM, MemWriteM, RegWriteW, MemtoRegW;
wire ForwardAD, ForwardBD, FlushE, Jump, JumpR, PredictF, PredictD, PredictedF, PredictedD, Success;
wire clk;

assign opcode = InstD[31:26];
assign RsD = InstD[25:21];
assign RtD = InstD[20:16];
assign RdD = InstD[15:11];
assign shamt = InstD[10:6];
assign funct = InstD[5:0];
assign immediate = InstD[15:0];
assign address = InstD[25:0];
assign A1 = RsD;
assign A2 = RtD;
assign Wrong = PCSrcD ^ PredictD;
assign Success = PredictedD & (~Wrong);

converter con(c, 1, clk);
 
Plus PC_Inc(PCF, 32'h4, PCPlus4F);					
Update PC_Update(clk, ~StallF, PCN, PCF);
SignExtend32 extend2(InstF[15:0], SignImmD2);

BranchPredictor bp(PredictorStateD, Success, Wrong, InstF[31:26],  PredictF, PredictedF, PredictorStateF);
Mux32 PC_Mux(PCSrcD & (~PredictD), PCBranchD, PCPlus4F, PC_N);
Mux32 predict_mux(PredictedF & PredictF, SignImmD2, PC_N, PC);
Mux32 predict_mux2(PredictedF & PredictD & (~PCSrcD), PCPlus4D, PC, PC2);
Mux32 Jr_Mux(JumpR, RD1D, PC2, PC3);
Mux32 J_Mux(Jump, {{4{address[25]}}, address, 2'b0} ,PC3, PCN);

IROM Insts(PCF >> 2, InstF);
IFID_R if_id(clk, (PredictedD & (PredictD ^ PCSrcD)) | (~PredictedD & PCSrcD), ~StallD, InstF, PCPlus4F, PredictF, PredictedF, PredictorStateF, InstD, PCPlus4D, PredictD, PredictedD, PredictorStateD); 
REG_FILE regfile(clk, A1, A2, WriteRegW, ResultW, RegWriteW, RD1Out, RD2Out);

Mux32 rd1mux(ForwardAD, ALUOutM, RD1Out, RD1D);
Mux32 rd2mux(ForwardBD, ALUOutM, RD2Out, RD2D);
BranchUnit branch(opcode, RtD, funct, RD1D, RD2D, Jump, JumpR, PCSrcD);



SignExtend32 extend(immediate, SignImmD);
Plus pcbranchd(SignImmD << 2, PCPlus4D, PCBranchD);
Control ctrl_unit(c,  opcode, shamt,funct, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD,BranchD);
Hazard  hzd_unit(RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW, BranchD, JumpR, MemtoRegE, RegWriteE, RegWriteM, RegWriteW, StallF, StallD, ForwardAD, ForwardBD, FlushE, ForwardAE, ForwardBE);

IDEX_R id_ex(clk, FlushE, RsD, RtD, RdD, SignImmD, RD1D, RD2D, shamt, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, RsE, RtE, RdE, SignImmE, RD1E, RD2E, shamtE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE);

Mux5 writerege(RegDstE, RdE, RtE, WriteRegE);
Mux32_4 srcae(ForwardAE, RD1E, ResultW, ALUOutM, 0, SrcAE);
Mux32_4 writedatae(ForwardBE, RD2E, ResultW, ALUOutM, 0, WriteDataE);
Mux32 srcbe(ALUSrcE, SignImmE, WriteDataE, SrcBE);
ALU alu(SrcAE, SrcBE, shamtE, ALUControlE, ALUOutE);

EXMEM_R em_mem(clk, RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE, RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM);

DATARAM dataram(ALUOutM >> 2, WriteDataM, switch[6:0], clk, MemWriteM, ReadDataM, MEMREAD);
Mux32 read_mux(switch[7], MEMREAD[31:16], MEMREAD[15:0], READOUT);
display dis(c, READOUT, sel, digits);

MEMWB_R mem_wb(clk, RegWriteM, MemtoRegM, ReadDataM, ALUOutM, WriteRegM, RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW);

Mux32 resultw(MemtoRegW, ReadDataW, ALUOutW, ResultW);

endmodule
