//Clock select - manual or pll
module clk_se(
	input pll_clk,
	input pll_clk_delayed,
	input man_clk,
	input man_clk_delayed,
	input sel,
	output clk,
	output clk_delayed
);
assign clk = sel ? man_clk : pll_clk;
assign clk_delayed = sel ? man_clk_delayed : pll_clk_delayed;

endmodule
