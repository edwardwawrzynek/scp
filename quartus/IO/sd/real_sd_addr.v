module real_sd_addr(
input [15:0] in,
output [31:0] out
);

assign out = {7'b0, in, 9'b0};

endmodule
