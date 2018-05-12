module decode_addr_mux(
	input [7:0] mdr,
	input [7:0] ir,
	input [9:0] decode_next,
	input [1:0] sel,
	output [9:0] addr
);

assign addr = sel[1] ? (sel[0] ? 10'b0 : decode_next) : (sel[0] ? {2'b0,ir} : {2'b0,mdr});

endmodule
