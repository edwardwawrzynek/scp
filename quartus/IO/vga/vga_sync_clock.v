/* delay vga h and v sync signals by a clock */

module vga_sync_clock(
	input clk,
	input h_sync,
	input v_sync,
	output reg h_sync_out,
	output reg v_sync_out
);

always @(posedge clk) begin
	v_sync_out <= v_sync;
	h_sync_out <= h_sync;
end

endmodule
