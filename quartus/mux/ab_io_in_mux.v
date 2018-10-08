/* selects from the io_in line of pc_cpy reg to go into AB_IN bus */

module ab_io_in_mux(
	input sel,
	input [15:0] io,
	input [15:0] pc_cpy,
	output [15:0] out
);

assign out = sel ? pc_cpy : io;

endmodule
