module sound_gen(
	input clk,
	input [15:0] cycle_time,
	output out
);

reg [19:0] count;

assign out = (count[19:4] >= (cycle_time>>1)) ? 1 : 0;

always @ (posedge clk)
begin
		if(count[19:4] >= cycle_time) begin
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
end

endmodule
