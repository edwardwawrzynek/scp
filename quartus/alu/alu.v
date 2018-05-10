//The ALU - Note: The alu is clocked on the FALLING EDGE of the clock, to perform operations between each micro-instruction
module alu(
	input clk,
	input rst,
	input [15:0] a,
	input [15:0] b,
	input [4:0] op,
	output reg [15:0] res
);

always @ (negedge clk)
	begin
	//Nothing to do on reset
			case(op)
			5'h00: res <= b + a;
			5'h01: res <= b - a;
			5'h02: res <= b * a;
			5'h03: res <= b | a;
			5'h04: res <= b ^ a;
			5'h05: res <= b & a;
			5'h06: res <= $signed(b) >>> $signed(a);
			5'h07: res <= b >> a;
			5'h08: res <= b << a;
			5'h09: res <= -a;
			5'h0a: res <= !a;
			5'h0b: res <= ~a;
			5'h0c: begin
				if (a) begin
					res <= 16'b1; end
				else begin
					res <= 16'b0; end
				end
			5'h0d: res <= (b == a);
			5'h0e: res <= (b != a);
			5'h0f: res <= ($signed(b) < $signed(a));
			5'h10: res <= (b < a);
			5'h11: res <= ($signed(b) <= $signed(a));
			5'h12: res <= (b <= a);
			5'h13: res <= {{8{a[7]}}, a};
			//Copy b as result - for moving b to a
			5'h14: res <= b;
			default: res <= a;
		endcase
	end
	
endmodule
