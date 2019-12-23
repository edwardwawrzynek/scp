module alu_unit(
	input clk,
	input [15:0] reg0,
	input [15:0] reg1,
	input [3:0] alu_op,
	output reg [15:0] out,
	output reg [4:0] cond_out
);

always @ (posedge clk) begin
	case(alu_op)
		4'h0: out <= reg0 | reg1;
		4'h1: out <= reg0 ^ reg1;
		4'h2: out <= reg0 & reg1;
		4'h3: out <= reg0 << reg1;
		4'h4: out <= reg0 >> reg1;
		4'h5: out <= reg0 >>> reg1;
		4'h6: out <= reg0 + reg1;
		4'h7: out <= reg0 - reg1;
		4'h8: out <= reg0 * reg1;
		4'h9: out <= ~reg0;
		4'ha: out <= -reg0;
		4'hb: out <= !reg0;
	endcase
	cond_out <= {
		$signed(reg0) > $signed(reg1),
		$signed(reg0) < $signed(reg1),
		reg0 > reg1,
		reg0 < reg1,
		reg0 == reg1
	};
end

endmodule
