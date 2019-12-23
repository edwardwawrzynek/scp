module ram_mmu(
	/* input address from execution_unit */
	input [15:0] in_addr,
	/* page table base from execution_unit */
	input [11:0] ptb,
	/* output addr to memory */
	output [17:0] out_addr,
	/* output address to page table */
	output [8:0] page_table_addr,
	/* input entry from page table */
	input [15:0] page_table_entry,
	/* unassigned page int */
	output page_assigned,
	/* text protection */
	output page_read_only
);

wire [10:0] low_addr;
wire [4:0] high_addr;

assign low_addr = in_addr[10:0];
assign high_addr = in_addr[15:11];

assign page_table_addr = high_addr + ptb;

assign page_assigned = page_table_entry[15];
assign page_read_only = page_table_entry[14];
assign out_addr = {page_table_entry[6:0], low_addr};

endmodule
