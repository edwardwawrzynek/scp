//SP adder
module sp_adder(
	input [15:0] sp,
	input [15:0] offset,
	input just_off,
	output [15:0] out
);

assign out = just_off ? offset : (sp + offset);

endmodule
