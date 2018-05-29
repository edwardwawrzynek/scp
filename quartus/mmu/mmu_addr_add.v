module mmu_addr_add(
	input [11:0] ptb,
	input [4:0] page,
	output [11:0] out
);

assign out = page + ptb;

endmodule
