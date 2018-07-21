//If privilaged, ptb is wired to 0, else is ptb
module real_ptb(
	input [10:0] ptb,
	input privilage_level,
	output [10:0] out
);

assign out = 10'b0;
	
endmodule
