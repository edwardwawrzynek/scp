//ram controller

module ram_controller(
	//input addr
	input [17:0] addr,
	//if a byte or word is being read/writen (0=word, 1=byte)
	input is_byte,
	//data in to ram (if writing a byte, byte is [7:0] part)
	input [15:0] data_in,
	//data out (if reading a byte, byte is [7:0] part)
	output [15:0] data_out,
	
	//output addr to ram block
	output [16:0] addr_out,
	//byte enable output to ram
	output [1:0] byte_en,
	//data out from ram
	input [15:0] data_ram_out,
	//data in to ram
	output [15:0] data_in_ram
);

//cut off last bit of addr
assign addr_out = addr[17:1];

//set byte enable
assign byte_en = is_byte ? (addr[0] ? 2'b10 : 2'b01) : 2'b11;

//set data_out
assign data_out = is_byte ? (addr[0] ? {8'b0, data_ram_out[15:8]} : {8'b0, data_ram_out[7:0]}): data_ram_out;

//set data_in to ram
assign data_in_ram = is_byte ? (addr[0] ? {data_in[7:0], 8'b0} : {8'b0, data_in[7:0]}): data_in;

endmodule
