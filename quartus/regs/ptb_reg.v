module ptb_reg(
	input clk,
	input rst,
	input [10:0] in,
	input we,
	output reg [10:0] out
);

always @ (posedge clk)
	begin
		if(rst)
			out <= 0;
		if(we)
			out <= in;
	end
endmodule
