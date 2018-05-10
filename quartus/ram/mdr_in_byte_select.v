//Selects a byte from a word for writing into ram - if byte_sel is high, high byte is outputted, and same for low
module mdr_in_byte_select(
	input [15:0] in,
	input byte_sel,
	output [7:0] out
);

assign out = byte_sel ? in[15:8] : in[7:0];

endmodule
