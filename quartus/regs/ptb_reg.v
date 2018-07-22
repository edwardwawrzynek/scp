module ptb_reg(
	input clk,
	input rst,
	input [10:0] bus,
	input we,
	output reg [10:0] out
);

always @ (posedge clk) 
	begin
		if(rst)
			begin
			out <= 0;
			end
		if(we)
			begin
			out<=bus;
			end
	end
endmodule
