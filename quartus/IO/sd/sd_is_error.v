module sd_is_error(
	input [15:0] error,
	output out
);

assign out = error ? 1 : 0;

endmodule
