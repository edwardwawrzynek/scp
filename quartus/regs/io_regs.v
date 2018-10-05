//IO addrs and data reg - clocked on positive edge
module io_regs(
	input clk,
	input rst,
	input [15:0] data_bus,
	input [15:0] addrs_bus,
	input data_we,
	input addrs_we,
	input [15:0] addrs_sec_bus,
	input addrs_sec_we,
	output reg [15:0] io_data,
	output reg [7:0] io_addr
);

always @ (posedge clk)
	begin
		if (rst) begin
			io_data <= 0;
			io_addr <= 0;
		end
		if (data_we) begin
			io_data <= data_bus;
		end
		if (addrs_we) begin
			io_addr <= addrs_bus[7:0];
		end
		if (addrs_sec_we) begin
			io_addr <= addrs_sec_bus[7:0];
		end
	end
	
endmodule
	