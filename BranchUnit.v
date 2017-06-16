`timescale 1ns / 1ps
module BranchUnit(
	input [5:0] Op,
	input [4:0] Rt,
	input [5:0] Funct,
	input [31:0] l,
	input [31:0] r,
	output reg Jump,
	output reg JumpR,
	output reg Branch
);
initial	
begin
	Branch = 0;
	JumpR = 0;
	Jump = 0;
end
always@(*)
case(Op)
	6'h0:
		case(Funct)
			//bubble
			6'h0:
				begin
					Branch = 0;
					JumpR = 0;
					Jump = 0;
				end
			//jr
			6'h8:
				begin
					Branch = 1;
					JumpR = 1;
					Jump = 0;
				end
			default:
				begin
					Branch = 0;
					JumpR = 0;
					Jump = 0;
				end
		endcase
	6'h1:
		case(Rt)
			//bltz
			5'h0:
				if($signed(l) < 0)
					begin
						Branch = 1;
						JumpR = 0;
					Jump = 0;
					end
				else
					begin
						Branch = 0;
						JumpR = 0;
						Jump = 0;
					end
			//bgez
			5'h1:
				if($signed(l) >= 0)
					begin
						Branch = 1;
						JumpR = 0;
						Jump = 0;
					end
				else
					begin
						Branch = 0;
						JumpR = 0;
						Jump = 0;
					end
			default:
				begin
					Branch = 0;
					JumpR = 0;
					Jump = 0;
				end
		endcase
	//j
	6'h2:
		begin
			Branch = 1;
			JumpR = 0;
			Jump = 1;
		end
	//beq
	6'h4:
		if($signed(l) == $signed(r))
			begin
				Branch = 1;
				JumpR = 0;
				Jump = 0;
			end
		else
			begin
				Branch = 0;
				JumpR = 0;
				Jump = 0;
			end
	//bne
	6'h5:
		if($signed(l) != $signed(r))
			begin
				Branch = 1;
				JumpR = 0;
				Jump = 0;
			end
		else
			begin
				Branch = 0;
				JumpR = 0;
				Jump = 0;
			end
	//blez
	6'h6:
		if($signed(l) <= 0)
			begin
				Branch = 1;
				JumpR = 0;
				Jump = 0;
			end
		else
			begin
				Branch = 0;
				JumpR = 0;
				Jump = 0;
			end
	//bgtz
	6'h7:
		if($signed(l) > 0)
			begin
				Branch = 1;
				JumpR = 0;
				Jump = 0;
			end
		else
			begin
				Branch = 0;
				JumpR = 0;
				Jump = 0;
			end
	default:
		begin
			Branch = 0;
			JumpR = 0;
			Jump = 0;
		end
endcase

endmodule
