module mmu_addr_combine(
	input [4:0] high,
	input [10:0] low,
	output [15:0] out
);

assign out = {high, low};

endmodule
