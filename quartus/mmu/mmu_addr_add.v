module mmu_addr_add(
	input [10:0] ptb,
	input [4:0] page,
	output [10:0] out
);

assign out = ptb + page;

endmodule
