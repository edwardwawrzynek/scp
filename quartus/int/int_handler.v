/*6 interupts availible
 *  0 is the higest priority, but this doesn't really matter, because an interupt puts the machine
 *  in privilaged mode. Interupts can only work in user mode, so any interupt occuring during another
 *  one has to wait for it to finish.
 *probably the following:
 *0:segfault (issued by mmu)
 *1:timer
 *2:keyboard break/pause
 *3:
 *4:
 *5:software int
 */

 module int_handler(
	/* irq lines - edge triggered */
	input irq0,
	input irq1,
	input irq2,
	input irq3,
	input irq4,
	input irq5,
	/* interupt acknowledges (1 if no interupt pending, 0 if one is) */
	output reg ack0=1,
	output reg ack1=1,
	output reg ack2=1,
	output reg ack3=1,
	output reg ack4=1,
	output reg ack5=1,
	/* interupt hardware lines */
	input clk,
	input priv_lv,
	output reg manager_irq,
	output reg [15:0] int_addr
);

/* addr for each of the ints */
parameter IRQ0_ADDR = 16'h10;
parameter IRQ1_ADDR = 16'h14;
parameter IRQ2_ADDR = 16'h18;
parameter IRQ3_ADDR = 16'h1c;
parameter IRQ4_ADDR = 16'h20;
parameter IRQ5_ADDR = 16'h24;


/* if an interupt is pending on a line */
reg req [0:5];

/* which request is currently being made */
/* 0=none, 1=irq0, 2=irq1, etc (strangness) */
reg [2:0] cur_req;

/* past positions */

always @ (posedge clk) begin
	/* check for request, and set req lines if so */
	if (irq0) begin
		req[0] <= 1;
		ack0 <= 0;
	end
	if (irq1) begin
		req[1] <= 1;
		ack1 <= 0;
	end
	if (irq2) begin
		req[2] <= 1;
		ack2 <= 0;
	end
	if (irq3) begin
		req[3] <= 1;
		ack3 <= 0;
	end
	if (irq4) begin
		req[4] <= 1;
		ack4 <= 0;
	end
	if (irq5) begin
		req[5] <= 1;
		ack5 <= 0;
	end
	/* if we can make an interupt and have a request pending, make it */
	if (priv_lv) begin
		if (req[0]) begin
			manager_irq <= 1;
			cur_req = 1;
			req[0] <= 0;
			int_addr <= IRQ0_ADDR;
		end
		else if (req[1]) begin
			manager_irq <= 1;
			cur_req = 2;
			req[1] <= 0;
			int_addr <= IRQ1_ADDR;
		end
		if (req[2]) begin
			manager_irq <= 1;
			cur_req = 3;
			req[2] <= 0;
			int_addr <= IRQ2_ADDR;
		end
		if (req[3]) begin
			manager_irq <= 4;
			cur_req = 4;
			req[3] <= 0;
			int_addr <= IRQ3_ADDR;
		end
		if (req[4]) begin
			manager_irq <= 1;
			cur_req = 5;
			req[4] <= 0;
			int_addr <= IRQ4_ADDR;
		end
		if (req[5]) begin
			manager_irq <= 1;
			cur_req = 6;
			req[5] <= 0;
			int_addr <= IRQ5_ADDR;
		end
	end
	/* otherwise, if in sys mode, set the ack if needed */
	if (!priv_lv) begin
		/* stop asking for an interupt */
		manager_irq <= 0;
		/* if there was an interupt, set its ack */
		if(cur_req) begin
			case(cur_req)
				1: ack0 <= 1;
				2: ack1 <= 1;
				3: ack2 <= 1;
				4: ack3 <= 1;
				5: ack4 <= 1;
				6: ack5 <= 1;
				default: /* shouldn't be reached */ cur_req <= 0;
			endcase
			cur_req <= 0;
		end
	
	end
end

endmodule


	