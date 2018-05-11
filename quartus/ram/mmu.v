//Basic mmu - if sys_privilege is 1, add base_pointer to adrrs_in, if 0, don't
//Note - this MAY be changed to add bp times some power of two to addrs_in
module mmu(
	input [15:0] base_pointer,
	input [15:0] addrs_in,
	input sys_privilege,
	output [15:0] addrs_out
);

assign addrs_out = sys_privilege ? (addrs_in + base_pointer) : addrs_in;

endmodule
