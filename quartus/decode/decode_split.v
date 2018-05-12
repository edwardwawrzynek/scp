//Split decode rom value into signals
module decode_split(
	input [43:0] v,
	//Control Signals
	output A_BUS_WE,
	output A_ALU_WE,
	output B_BUS_WE,
	output B_A_WE,
	output [4:0] ALU_OP,
	output [1:0] AB_BUS_IN_SEL,
	output AB_BUS_OUT_SEL,
	output PC_BUS_WE,
	output SP_BUS_WE,
	output BP_BUS_WE,
	output IO_DATA_BUS_WE,
	output IO_ADDR_BUS_WE,
	output MDR_IN_BYTE_SEL,
	output MDR_OUT_BYTE_LOW_WE,
	output MDR_OUT_BYTE_HIGH_WE,
	output RAM_ADDR_WE,
	output RAM_DATA_WE,
	output PC_INC,
	output SP_INC,
	output SP_DEC,
	output [1:0] MAR_MUX_SEL,
	output IR_WE,
	output [1:0] DECODE_NEXT_SEL,
	output [9:0] DECODE_NEXT,
	output PRIVILAGE_WE,
	output PRIVILAGE_SET_LEVEL,
	output RST_OUT,
	output IO_WE
);

//Control Signals
assign A_BUS_WE = v[0];
assign A_ALU_WE = v[1];
assign B_BUS_WE = v[2];
assign B_A_WE = v[3];
assign ALU_OP = v[8:4];
assign AB_BUS_IN_SEL = v[10:9];
assign AB_BUS_OUT_SEL = v[11];
assign PC_BUS_WE = v[12];
assign SP_BUS_WE = v[13];
assign BP_BUS_WE = v[14];
assign IO_DATA_BUS_WE = v[15];
assign IO_ADDR_BUS_WE = v[16];
assign MDR_IN_BYTE_SEL = v[17];
assign MDR_OUT_BYTE_LOW_WE = v[18];
assign MDR_OUT_BYTE_HIGH_WE = v[19];
assign RAM_ADDR_WE = v[20];
assign RAM_DATA_WE = v[21];
assign PC_INC = v[22];
assign SP_INC = v[23];
assign SP_DEC = v[24];
assign MAR_MUX_SEL = v[26:25];
assign IR_WE = v[27];
assign DECODE_NEXT_SEL = v[29:28];
assign DECODE_NEXT = v[39:30];
assign PRIVILAGE_WE = v[40];
assign PRIVILAGE_SET_LEVEL = v[41];
assign RST_OUT = v[42];
assign IO_WE = v[43];

endmodule
