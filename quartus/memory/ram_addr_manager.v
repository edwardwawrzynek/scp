/**
 * Convert bytes addresses + operations to word addresses + byte enables */

module ram_addr_manager(
	input [17:0] addr,			/* byte address to operate on */
	input	byte_enable,			/* high if only a byte is being written or read */
	input [15:0] write_data,	/* data to write */
	output [15:0] out_data, 	/* output data from mem */
	input sign_extend,			/* sign extend output */
	
	output [16:0] ram_addr,		/* address line to ram */
	output [1:0] ram_byte_en,	/* byte enable line to ram */
	output [15:0] ram_write_data, /* data line to ram */
	input [15:0] ram_read_data	/* data line from ram */
);

/* lose byte bit for word addresses */
assign ram_addr = addr[17:1];
/* do byte enables */
assign ram_byte_en = byte_enable ? {addr[0], !addr[0]} : 2'b11;
/* shift low byte to high byte if we are writing a byte at odd addr */
assign ram_write_data = byte_enable ? (addr[0] ? {write_data[7:0], 8'b0} : write_data): write_data;
/* shift high byte to low if we are reading a byte at odd addr */
wire [15:0] data;
assign data = byte_enable ? (addr[0] ? {8'b0, ram_read_data[15:8]} : {8'b0, ram_read_data[7:0]}): ram_read_data;

assign out_data = sign_extend ? ({{8{data[7]}}, data[7:0]}): data;

endmodule
	