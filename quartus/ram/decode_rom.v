module decode_rom
(
	input clk,
	input [9:0] addr,
	input [43:0] data,
	input we,
	output [43:0] q
);

	// Declare the RAM variable
	reg [43:0] rom[1023:0];
	
	// Variable to hold the registered read address
	reg [9:0] addr_reg;
	
	always @ (posedge clk)
	begin
	// Write
		if (we)
			rom[addr] <= data;
		
		addr_reg <= addr;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = rom[addr_reg];

initial begin
 $readmemh("decode_rom.txt", rom);
end
endmodule