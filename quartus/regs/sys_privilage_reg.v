//System privilage level reg - privilage_we sets privilage to privilage_level
module sys_privilage_reg(
	input clk,
	input rst,
	input privilage_we,
	input privilage_level,
	output reg privilage
);

always @ (posedge clk)
	begin
		if (rst) begin
			privilage <= 0;
		end
		if (privilage_we) begin
			privilage <= privilage_level;
		end
	end

endmodule
