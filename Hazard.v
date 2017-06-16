`timescale 1ns / 1ps
module Hazard(
    input [4:0] RsD,
	 input [4:0] RtD,
	 input [4:0] RsE,
	 input [4:0] RtE,
	 input [4:0] WriteRegE,
	 input [4:0] WriteRegM,
	 input [4:0] WriteRegW,
	 input BranchD,
	 input JumpR,
	 input MemtoRegE,
	 input RegWriteE,
	 input RegWriteM,
	 input RegWriteW,
	 output reg StallF,
	 output reg StallD,
	 output reg ForwardAD,
	 output reg ForwardBD,
	 output reg FlushE,
	 output reg [1:0] ForwardAE,
	 output reg [1:0] ForwardBE
);

initial 
begin
	StallF = 0;
	StallD = 0;
	ForwardAD = 0;
	ForwardBD = 0;
	FlushE = 0;
	ForwardAE = 2'b0;
	ForwardBE = 2'b0;
end
always@(*)
begin
	if(BranchD || JumpR)
		begin
			FlushE = 1;
			if(RegWriteM && WriteRegM == RsD)
				ForwardAD = 1;
			else
				ForwardAD = 0;
			
			if(RegWriteM && WriteRegM == RtD)
				ForwardBD = 1;
			else
				ForwardBD = 0;
		end
	else
		begin
			FlushE = 0;
			ForwardAD = 0;
			ForwardBD  = 0;
		end
	
	if(RegWriteM && WriteRegM !=0 && WriteRegM == RsE)
		ForwardAE = 2'b10;
	else if(RegWriteW && WriteRegW !=0 && WriteRegM != 0 && WriteRegM != RsE && (WriteRegW == RsE))
		ForwardAE = 2'b01;
	else
		ForwardAE = 0;
	
	if(RegWriteM && WriteRegM !=0 && WriteRegM == RtE)
		ForwardBE = 2'b10;
	else if(RegWriteW && WriteRegW !=0 && WriteRegM != 0 && WriteRegM != RtE && (WriteRegW == RtE))
		ForwardBE = 2'b01;
	else
		ForwardBE = 0;
		
	if((MemtoRegE && (RtE == RsD || RtE == RtD)) || (RegWriteE && ((WriteRegE == RsD) || (WriteRegE == RtD)) && BranchD))
		begin
			StallF = 1;
			StallD = 1;
		end
	else
		begin
			StallF = 0;
			StallD = 0;
		end
	
end
endmodule
