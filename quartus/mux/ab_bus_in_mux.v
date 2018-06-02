//ab bus in mux - sel selects from pc, mdr, sp, io_data
module ab_bus_in_mux(
	input [15:0] mdr,
	input [15:0] pc,
	input [15:0] sp,
	input [15:0] io_data,
	input [1:0] sel,
	output [15:0] out
);

assign out = sel[1] ? (sel[0] ? io_data : sp) : (sel[0] ? pc : mdr);

endmodule
