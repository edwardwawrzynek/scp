module decode_addr_mux(
	input [7:0] ir,
	input [9:0] decode_next,
	input sel,
	output [9:0] addr
);

assign addr = sel ? {2'b0,ir} : decode_next;

endmodule
