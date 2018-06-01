//Conditional jumping enable - adjust we1 and we2
module cond(
	input in_we1,
	input in_we2,
	output out_we1,
	output out_we2,
	input cond_en,
	input mode,
	input [15:0] a
);

//whether or not to let the signal pass, assuming cond_en
wire good;
//mode 0 is if a is true (not zero), 1 is if a if false (zero)
assign good = mode ? (a ? 0:1) : (a ? 1:0);

assign out_we1 = cond_en ? (good ? in_we1 : 0) : in_we1;
assign out_we2 = cond_en ? (good ? in_we2 : 0) : in_we2;

endmodule
