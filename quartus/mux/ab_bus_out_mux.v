//AB bus out mux - if reg_sel is low, a is output, if high, b is out
module ab_bus_out_mux(
	input [15:0] a,
	input [15:0] b,
	input reg_sel,
	output [15:0] out
);

assign out = (reg_sel) ? b : a;

endmodule
