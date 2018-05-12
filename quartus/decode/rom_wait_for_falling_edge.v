//Delays rom cntrl lines until negative edge of clock
module rom_wait_for_falling_edge(
	input clk,
	input [43:0] in,
	output reg [43:0] out
);

always @ (posedge clk) begin
	out <= in;
end

endmodule
