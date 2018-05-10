//A and B regs - clk'd on positive edge, setable by bus_in (bus_we) and sec_in(sec_we), bus val is set if both latches are high
//General because A and B are general purpose regs
module general_reg(
	input clk,
	input rst,
	output reg [15:0] val,
	input [15:0] bus_in,
	input bus_we,
	input [15:0] sec_in,
	input sec_we
);

always @ (posedge clk)
	begin
		if (rst) begin
			val <= 0;
		end
		if (bus_we) begin
			val <= bus_in;
		end
		else if (sec_we) begin
			val <= sec_in;
		end
		
	end
	
endmodule
