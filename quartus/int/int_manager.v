module int_manager(
	input clk,
	input irq,
	input priv_lv,
	input reset,
	output reg do_int
);

always @ (posedge clk) begin
	if(irq && (!do_int) && priv_lv) begin
		do_int <= 1;
	end
	if(!priv_lv) begin
		do_int <= 0;
	end
end

endmodule
