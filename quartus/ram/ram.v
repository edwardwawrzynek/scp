//64k Ram - clocked on positive edge of clock - addrs_we latches the addrs to read into mar
module ram(
	input clk,
	input rst,
	input [15:0] addrs,
	input [7:0] data_in,
	input addrs_we,
	input mem_we,
	output [7:0] data_out
);

reg [15:0] real_addrs;

reg [7:0] mem[0:65535];

assign data_out = mem[real_addrs];

always @ (posedge clk)
	begin
		if(rst) begin
			real_addrs <= 0;
		end
		if(mem_we) begin
				mem[real_addrs] <= data_in;
		end
		if(addrs_we) begin
			real_addrs <= addrs;
		end
	end

endmodule
