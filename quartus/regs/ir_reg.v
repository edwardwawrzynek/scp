//IR - setable by bus_in (bus_we), and clocked on delayed clock
module ir_reg(
	input clk,
	input rst,
	output reg [7:0] val,
	input [7:0] bus_in,
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
