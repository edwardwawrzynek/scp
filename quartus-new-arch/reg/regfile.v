//Regfile

module regfile(
	//clock for latching
	input clk,
	//in reg
	input [3:0] reg_in_sel,
	input [15:0] reg_in,
	input reg_in_we,
	//out regs
	input [3:0] reg_out0_sel,
	output [15:0] reg_out0,
	input [3:0] reg_out1_sel,
	output [15:0] reg_out1
);

//regfile
reg [15:0] regfile [15:0];

assign reg_out0 = regfile[reg_out0_sel];
assign reg_out1 = regfile[reg_out1_sel];

always @ (posedge clk) begin
	if(reg_in_we) begin
		regfile[reg_in_sel] <= reg_in;
	end
end

endmodule
