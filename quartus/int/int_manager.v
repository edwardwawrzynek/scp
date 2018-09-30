module int_manager(
	input clk,
	input irq,
	input int_ack,
	input reset,
	output reg do_int
);

reg p_irq;

always @ (posedge clk) begin
	p_irq <= irq;
	if(irq && (!do_int)) begin
		do_int <= 1;
	end
	if(int_ack) begin
		do_int <= 0;
	end
end

endmodule
