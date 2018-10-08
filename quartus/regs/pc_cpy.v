/* reg to save the pc during interupts */

module pc_cpy(
input clk,
input we,
input [15:0] in,
output reg [15:0] out
);

always @ (posedge clk) begin
	if(we)
		out <= in;
end
endmodule
