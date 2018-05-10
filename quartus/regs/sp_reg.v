//Stack Pointer - clk'd on positive edge, setable by bus_in (bus_we), incrementable by inc, deincrementable by dec
module sp_reg(
	input clk,
	input rst,
	output reg [15:0] val,
	input [15:0] bus_in,
	input bus_we,
	input inc,
	input dec
);

always @ (posedge clk)
	begin
		if (rst) begin
			val <= 0;
		end
		if (inc) begin
			val <= val + 1;
		end
		if (dec) begin
			val <= val - 1;
		end
		if (bus_we) begin
			val <= bus_in;
		end
	end
	
endmodule
