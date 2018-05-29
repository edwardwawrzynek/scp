//If privilaged, ptb is wired to 0, else is ptb
module real_ptb(
	input [11:0] ptb,
	input privilage_level,
	output [11:0] out
);

assign out = privilage_level ? 11'b0 : ptb;
	
endmodule
