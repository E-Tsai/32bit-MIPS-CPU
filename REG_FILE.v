`timescale 1ns / 1ps
module REG_FILE(
input			 		clk,
input	[4:0]	 		r1_addr,
input	[4:0]	 		r2_addr,
input	[4:0]	 		r3_addr,
input	[31:0] 		r3_din,
input			 		r3_wr,
output [31:0]	r1_dout,
output [31:0]	r2_dout
);
reg [31:0] data[0:31];
integer i;
initial 
begin
for(i=0;i<32;i=i+1) data[i] = 32'h0;
end
assign r1_dout = data[r1_addr];
assign r2_dout = data[r2_addr];
always@(*)
begin
	if(r3_wr)
		data[r3_addr] = r3_din;
end


endmodule
