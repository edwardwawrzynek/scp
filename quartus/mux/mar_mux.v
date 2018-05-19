//MAR in mux - choose from a,b,pc,sp
module mar_mux(
	input [15:0] a,
	input [15:0] b,
	input [15:0] pc,
	input [15:0] sp,
	input [1:0] sel,
	output [15:0] mar
);

assign mar = sel[1] ? (sel[0] ? sp : pc) : (sel[0] ? b : a);

endmodule
