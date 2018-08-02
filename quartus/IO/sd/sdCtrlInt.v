//sdCardCtrl interface module
module sdCtrlInt(
input clk,
//Interface to data read memory
input data_rd_inc,
output [7:0] data_rd,
input data_rd_en,
output reg [8:0] data_rd_addr,
//Interface to sdCardCtrl
input busy_i,
input hndshk_i,
output reg hndshk_o,
input [7:0] data_in,
output reg rd_o,
output reg wr_o,
output reg [7:0] data_out,
//Interface to data write memory
input data_wr_inc,
input [7:0] data_wr,
input data_we,
input data_wr_en,
output reg [8:0] data_wr_addr
);

//SD card read in memory
reg [7:0] data_rd_mem[0:511];
assign data_rd = data_rd_mem[data_rd_addr];
reg [8:0] data_rd_wr_addr;

//SD card write out memory
reg [7:0] data_wr_mem[0:511];
reg [8:0] data_wr_rd_addr;

//state (with reagrds to sdCardCtrl)
reg [2:0] state;
parameter STATE_IDLE = 3'd0;
parameter STATE_RD_INIT = 3'd1;
parameter STATE_RD_WAIT_DATA = 3'd2;
parameter STATE_RD_HND = 3'd3;

parameter STATE_WR_INIT = 3'd4;
parameter STATE_WR_WRITE_DATA = 3'd5;
parameter STATE_WR_HND = 3'd6;

always @ (posedge clk) begin
	//Interface to memory
	if(data_rd_inc)
		data_rd_addr <= data_rd_addr + 1;
	if(data_wr_inc)
		data_wr_addr <= data_wr_addr + 1;
	if(data_we)
		data_wr_mem[data_wr_addr] <= data_wr;
	
	//state machine
	case(state)
		STATE_IDLE: begin
			rd_o <= 0;
			wr_o <= 0;
			if(data_rd_en) begin
				state <= STATE_RD_INIT;
			end
			if(data_wr_en) begin
				state <= STATE_WR_INIT;
			end
		end
		STATE_RD_INIT: begin
			//Begin read
			rd_o <= 1;
			state <= STATE_RD_WAIT_DATA;
			data_rd_wr_addr <= 0;
			data_rd_addr <= 0;
		end
		STATE_RD_WAIT_DATA: begin
			//Disable rd enable - don't do muti block read
			rd_o <= 0;
			//Wait for data
			if(!busy_i) begin
				state <= STATE_IDLE;
			end
			else if(hndshk_i) begin
				data_rd_mem[data_rd_wr_addr] = data_in;
				data_rd_wr_addr <= data_rd_wr_addr + 1;
				hndshk_o <= 1;
				state = STATE_RD_HND;
			end
		end
		STATE_RD_HND: begin
			rd_o <= 0;
			if(!hndshk_i) begin
				hndshk_o <= 0;
				//If there is more data to be read, loop back to waiting for it
				state <= STATE_RD_WAIT_DATA;
			end
		end
		STATE_WR_INIT: begin
			//Begin write
			wr_o <= 1;
			state <= STATE_WR_WRITE_DATA;
			data_wr_rd_addr <= 0;
			data_wr_addr <= 0;
		end
		STATE_WR_WRITE_DATA: begin
			wr_o <= 0;
			//wait for request for data, and give it
			if(!busy_i) begin
				state <= STATE_IDLE;
			end
			else if(hndshk_i) begin
				data_out <= data_wr_mem[data_wr_rd_addr];
				data_wr_rd_addr <= data_wr_rd_addr + 1;
				hndshk_o <= 1;
				state = STATE_WR_HND;
			end
		end
		STATE_WR_HND: begin
			wr_o <= 0;
			//wait for data to be accepted
			if(!hndshk_i) begin
				hndshk_o <= 0;
				state <= STATE_WR_WRITE_DATA;
			end
		end
	endcase
	
end
/*
  Write data:
--         To write a data block to the SD card, the address of a block is placed 
--         on the addr_i input bus and the wr_i input is raised. The address and 
--         write strobe can be removed once busy_o goes high to indicate the write 
--         operation is underway. The data to be written to the SD card is passed as 
--         follows: 
--     
--         1. The controller requests a byte of data by raising the hndShk_o output.
--         2. The host applies the next byte to the data_i input bus and raises the 
--            hndShk_i input.
--         3. The controller accepts the byte and lowers the hndShk_o output.
--         4. The host lowers the hndShk_i input.
--     
--         This sequence of steps is repeated until all BLOCK_SIZE_G bytes of the 
--         data block are passed from the host to the controller. Once all the data 
--         is passed, the sector on the SD card will be written and the busy_o output 
--         will be lowered.
*/
endmodule

