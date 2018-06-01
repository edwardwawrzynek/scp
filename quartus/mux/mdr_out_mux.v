//Selects which to be put on mdr into memory
module mdr_out_mux(
	input [15:0] a,
	input [15:0] b,
	input [15:0] pc,
	input [1:0] sel,
	output [15:0] out
);

assign out = sel[1] ? pc : (sel[0] ? b : a);

endmodule
