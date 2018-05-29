module mmu_addr_combine(
	input [6:0] high,
	input [10:0] low,
	output [17:0] out
);

assign out = {high, low};

endmodule
