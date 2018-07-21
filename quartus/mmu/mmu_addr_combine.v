module mmu_addr_combine(
	input [5:0] high,
	input [10:0] low,
	output [16:0] out
);

assign out = {high, low};

endmodule
