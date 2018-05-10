//Generic three input mux - used in a few spots if sel == 3, then out is zero
module mux_3_inputs(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [1:0] sel,
	output [15:0] out
);

assign out = sel[1] ? (sel[0] ? 15'b0 : c) : (sel[0] ? b : a);

endmodule