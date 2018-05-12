//Decode rom - select right microinstruction, and set cntrl signals - clk'd on negative edge
module decode_rom(
	input clk,
	input rst,
	input [9:0] addr,
	output [43:0] v
);

reg [9:0] real_addr;

//If all 256 instructions are used, each can use on average 4 microinstructions
reg [43:0] rom[0:1023];

always @ (negedge clk)
	begin
		real_addr <= addr;
	end

//current rom value
assign v = rom[real_addr];

initial begin
 $readmemh("decode_rom.txt", rom);
end
	
endmodule
