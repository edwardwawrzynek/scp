//SP adder
module sp_adder(
	input [15:0] sp,
	input [15:0] offset,
	output [15:0] out
);

assign out = sp + offset;

endmodule
