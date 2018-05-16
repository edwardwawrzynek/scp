module ram
(
	input clk,
	input [15:0] addr,
	input [7:0] data,
	input we,
	output [7:0] q
);

	// Declare the RAM variable
	(* ram_init_file = "ram_init.mif" *) reg [7:0] ram[65535:0];
	
	// Variable to hold the registered read address
	reg [15:0] addr_reg;
	
	always @ (posedge clk)
	begin
	// Write
		if (we)
			ram[addr] <= data;
		
		addr_reg <= addr;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr_reg];
	
endmodule