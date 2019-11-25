/* TODO: proper mmu */

module ram_mmu(
	input clk,
	input [15:0] in_addr,
	output reg [17:0] out_addr
);

always @ (posedge clk)
begin
	out_addr <= {2'b00, in_addr};
end

endmodule
