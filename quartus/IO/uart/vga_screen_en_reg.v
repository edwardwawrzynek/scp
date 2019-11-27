module vga_screen_en_reg(
	input clk,
	input screen_en,
	output reg out
);

always @ (posedge clk) begin
	out <= screen_en;
end
endmodule
	