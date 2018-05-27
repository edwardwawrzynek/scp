//This reg takes bytes from mdr and, with control signals, shifts them into words - clocked on delayed clock
module mdr_out_byte_shift_reg(
	input clk,
	input rst,
	output reg [15:0] val,
	input [7:0] in,
	input byte_high_we,
	input byte_low_we,
	input byte_high_rst,
	input inc
);

always @ (posedge clk)
	begin
		if (rst) begin
			val <= 0;
		end
		if (inc) begin
			val <= val + 1;
		end
		if (byte_high_rst) begin
			val[15:8] <= 0;
		end
		if (byte_high_we) begin
			val[15:8] <= in;
		end
		if (byte_low_we) begin
			val[7:0] <= in;
		end
	end

endmodule
