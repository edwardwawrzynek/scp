module decode_addr_mux(
	input [7:0] ir,
	input [9:0] decode_next,
	input sel,
	output [9:0] addr,
	input int
);

parameter INT_ADDR = 1023;

wire [9:0] norm_out;
assign norm_out = sel ? {2'b0,ir} : decode_next;

assign addr = (sel && int) ? INT_ADDR : norm_out;

endmodule
