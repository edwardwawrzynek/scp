/* timer interupt - TODO: clk output*/

module int_timer(
	input clk,
	/* next interupt time - nxt_int * (2^12) clks ticks from now */ 
	input [15:0] nxt_int,
	input nxt_int_we,
	output reg do_int
);

reg [31:0] clk_counter;
reg [27:0] ticks_to_int;
reg do_countdown;

always @ (posedge clk ) begin
	clk_counter <= clk_counter + 1;
	if (nxt_int_we) begin
		ticks_to_int <= {nxt_int, 12'b0};
		do_countdown <= 1;
	end
	if(do_countdown) begin
		ticks_to_int <= ticks_to_int - 1;
	end
	if(ticks_to_int == 0 && do_countdown) begin
		do_int <= 1;
		do_countdown <= 0;
	end
	else begin
		do_int <= 0;
	end
end

endmodule
