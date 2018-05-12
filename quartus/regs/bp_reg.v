//BP reg - setable by bus_in (bus_we)
module bp_reg(
	input clk,
	input rst,
	output reg [15:0] val,
	input [15:0] bus_in,
	input bus_we
);

always @ (posedge clk)
	begin
		if (rst) begin
			val <= 0;
		end
		if (bus_we) begin
			val <= bus_in;
		end
	end
	
endmodule
