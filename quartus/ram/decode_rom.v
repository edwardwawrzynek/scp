/*
//Decode rom - select right microinstruction, and set cntrl signals - clk'd on positive edge, later delayed to negative
module decode_rom(
	input clk,
	input rst,
	input [9:0] addr,
	output [43:0] v
);

reg [9:0] real_addr;

//If all 256 instructions are used, each can use on average 4 microinstructions
reg [43:0] rom[0:1023];

always @ (posedge clk)
	begin
		real_addr <= addr;
	end

//current rom value
assign v = rom[real_addr];

initial begin
 $readmemh("decode_rom.txt", rom);
end
	
endmodule
*/
module decode_rom
(
	input clk,
	input [9:0] addr,
	output [43:0] v
);

	// Declare the RAM variable
	reg [43:0] ram[1023:0];
	
	// Variable to hold the registered read address
	reg [9:0] addr_reg;
	
	always @ (posedge clk)
	begin
		addr_reg <= addr;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign v = ram[addr_reg];
	
initial begin
 $readmemh("decode_rom.txt", ram);
end
	
endmodule