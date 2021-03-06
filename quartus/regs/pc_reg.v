//Program Counter - clk'd on positive edge, setable by bus_in (bus_we), incrementable by inc
module pc_reg(
	input clk,
	input rst,
	output reg [15:0] val,
	input [15:0] bus_in,
	input bus_we,
	input [15:0] mdr_in,
	input mdr_we,
	input inc,
	input dec,
	input [15:0] int_in,
	input int_we
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
			val <= val -1;
		end
		if (bus_we) begin
			val <= bus_in;
		end
		if(mdr_we) begin
			val <= mdr_in;
		end
		if(int_we) begin
			val <= int_in;
		end
	end
	
endmodule
