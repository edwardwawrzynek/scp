/*4 interupts availible
 *  0 is the higest priority, but this doesn't really matter, because an interupt puts the machine
 *  in privilaged mode. Interupts can only work in user mode, so any interupt occuring during another
 *  one has to wait for it to finish.
 *probably the following:
 *0:timer
 *1:(hardware, such as keyboard)
 *2:(hardware, such as keyboard)
 *3:software int
 */
module int_handler(
	input clk,
	input priv_lv,
	/* level triggered interupt lines - these should only be held for one cycle, or will fill the queue*/
	input int0,
	input int1,
	input int2,
	input int3,
	/* addresses for each of the interupts, in sys memory map */
	input [15:0] int0_vec,
	input [15:0] int1_vec,
	input [15:0] int2_vec,
	input [15:0] int3_vec,
	/* connection to cpu interupt system */
	input int_ack,
	output reg do_int,
	output reg [15:0] int_addr
);

//queue of interupt requests - the addr to jump to
reg [15:0] queue[0:7];
reg [3:0] queue_write_addr;
reg [3:0] queue_read_addr;

always @ (posedge clk) begin
	//write any new requests
	if(int0) begin
		queue[queue_write_addr] <= int0_vec;
		queue_write_addr <= queue_write_addr + 1; 
	end
	if(int1) begin
		queue[queue_write_addr] <= int1_vec;
		queue_write_addr <= queue_write_addr + 1; 
	end
	if(int2) begin
		queue[queue_write_addr] <= int2_vec;
		queue_write_addr <= queue_write_addr + 1; 
	end
	if(int3) begin
		queue[queue_write_addr] <= int3_vec;
		queue_write_addr <= queue_write_addr + 1; 
	end
	//if we have requested and interupt and priv_lv has gone to sys, the int has been handled
	if(!priv_lv && do_int) begin
		do_int <= 0;
		queue_read_addr <= queue_read_addr + 1;
	end
	//if the privilage level is user, we can trigger an int
	if(priv_lv) begin
		if(queue_read_addr != queue_write_addr) begin
			do_int <= 1;
			int_addr <= queue[queue_read_addr];
		end
	end
end

endmodule

	