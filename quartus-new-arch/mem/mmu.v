//MMU
//the bottom 11 bit of an address are kept, and the top 5 correspond to an entry in the page table
//the page table has 4096(32*128) entries (each proc can address 32 pages, and their are 128 pages at most present)

module mmu(
	input clk,
	//address to access
	input [15:0] addr,
	//page table base
	input [11:0] ptb,
	//system privilage level (0=sys, 1=usr)
	input priv_lv,
	//output addr in 18 bit addr space
	output [17:0] addr_out
);

//page table
reg [7:0] page_table [4095:0]; /* synthesis ram_init_file = "startup/mmu.mif" */; 

//addr in table
reg [11:0] page_addr;

//output entry
wire [7:0] page_entry;

//read mem
assign page_entry = page_table[page_addr];

//compose output addr
assign addr_out = {page_entry[6:0], addr[10:0]};

always @ (posedge clk) begin 
	if(priv_lv) begin
		page_addr <= addr[15:11] + ptb;
	end
	else begin
		page_addr <= addr[15:11];
	end
end

endmodule
