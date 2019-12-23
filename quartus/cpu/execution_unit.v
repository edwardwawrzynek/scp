/**
 * Main CPU execution unit
 * handles decoding, executing, and control of externals (alu, mem, io, etc)
 */

module execution_unit(
  input clk,										/* clock */
  
  /* Memory signals */
  output reg [15:0] mem_addr,				/* address line to memory (really mmu) */
  output reg mem_byte_enable,				/* if mem should do byte ops */
  output reg [15:0] mem_write_data,		/* data to write to mem */
  output reg mem_write_enable,				/* write enable for memory */
  input [15:0] mem_in_data,					/* data in from mem */
  
  /* IO controls (io output reg is alu_reg0) */
  output reg io_write,
  output reg [7:0] io_addr,
  /* Interupt controls (TODO) */
  output reg [15:0] alu_reg0,
  output reg [15:0] alu_reg1,
  output reg [3:0] alu_op_reg,
  input [15:0] alu_res,
  input [4:0] cond_res,
  output reg sign_extend,

  input [15:0] io_in,

  output [11:0] ptb,
  output reg mmu_we,
  /* system privalege level */
  output reg priv_lv
);

/* program counter */
reg [15:0] pc_reg;
/* current microstep */
reg [1:0] microstep;

/* machine registers */
reg [15:0] regfile [15:0];

/* Current instruction being executed */
reg [15:0] instr;

/* page table base register */
reg [11:0] ptb_reg;

assign ptb = priv_lv ? ptb_reg: 0;

/* interupt program counter */
reg [15:0] ipc_reg;

/* Instruction conventions

o = opcode
p = primary reg
s = secondary reg
a = alu op
b = byte/word selector
u = sign extend/unsigned selector
c = condition code

i = instruction has imediate

--- argument positions ---
fedcba9876543210
oooooo----------
--i-------------
------------ssss
--------pppp----
----aaaa--------
------bu--------
-------ccccc----
*/

wire [15:0] reg0;
wire [15:0] reg1;

assign reg0 = regfile[reg0_i];
assign reg1 = regfile[reg1_i];

reg [3:0] reg0_i;
reg [3:0] reg1_i;

reg [3:0] write_back_reg_i;

/* reg writeback */
reg reg_write;
reg [15:0] reg_writeback_val;

reg [3:0] alu_op;

reg [4:0] condition_code;
reg [4:0] condition_reg = 5'b00001;

reg has_imd;

reg [5:0] opcode;

reg op_mem_su;
reg op_mem_bw;


/* current microstep in instruction */
//output reg [1:0] microstep;

/* immediate field */
/* immediate loading on microsteps:
0 - set mem addr (imd not availible)
1 - set imd_reg (imd in mem_in_data, not imd_reg)
2,3 - (imd in imd_reg) */
reg [15:0] imd_reg;

/* opcodes */
`define NOP_N_N 			6'b000000
`define MOV_R_R 			6'b000001

`define OUT_R_P				6'b111000
`define IN_R_P 				6'b111001

`define JMP_C_J				6'b011101
`define JMP_C_R 			6'b000011

`define ALU_R_R0  		6'b000100
`define ALU_R_R1  		6'b000101
`define ALU_R_R2  		6'b000110
`define ALU_R_R3  		6'b000111

`define ALU_R_I0  		6'b001100
`define ALU_R_I1  		6'b001101
`define ALU_R_I2  		6'b001110
`define ALU_R_I3  		6'b001111

`define CMP_R_F			  6'b000010

`define LD_R_I 			  6'b011000
`define LD_R_M				6'b011001
`define LD_R_P				6'b010000
`define LD_R_P_OFF		6'b011010

`define LD_R_RA 			6'b001000

`define ST_R_M      	6'b011011
`define ST_R_P      	6'b010001
`define ST_R_P_OFF   	6'b011100

`define PUSH_R_SP     6'b010011
`define POP_R_SP      6'b010100
`define CALL_J_SP     6'b011110

`define CALL_R_SP     6'b010101
`define RET_N_SP      6'b010110

`define PTB_R_N       6'b110000
`define MMU_R_R       6'b110001

`define MOV_R_IPC     6'b100001
`define MOV_IPC_R     6'b100010

always @ (posedge clk)
begin
  case(microstep)
    2'b00: begin /* memory access - load imd */
      /* finish loading instruction */
      instr <= mem_in_data;
      /* set reg values (and return data to be written if applicable) */
      //reg0 <= (reg_write && write_back_reg_i == mem_in_data[3:0]) ? reg_writeback_val : regfile[mem_in_data[3:0]];
      //reg1 <= (reg_write && write_back_reg_i == mem_in_data[7:4]) ? reg_writeback_val : regfile[mem_in_data[7:4]];
      reg0_i <= mem_in_data[3:0];
      reg1_i <= mem_in_data[7:4];

      alu_op <= mem_in_data[11:8];
      condition_code <= mem_in_data[8:4];
      opcode <= mem_in_data[15:10];
      op_mem_bw <= mem_in_data[9];
      op_mem_su <= mem_in_data[8];
      has_imd <= mem_in_data[13];
      /* load immediate (or next instruction) */
      mem_addr <= pc_reg;
      mem_byte_enable <= 0;
      mem_write_enable <= 0;
      microstep <= 2'b01;
      /* write back primary reg value if needed */
      if(reg_write) begin
        regfile[write_back_reg_i] <= reg_writeback_val;
      end
      reg_write <= 0;
      io_write <= 0;

      microstep <= 2'b01;

    end
    2'b01: begin /* memory access - arbitrary */
      /* copy immediate to reg */
      imd_reg <= mem_in_data;
      /* if we had imd, increment pc_reg*/
      if(has_imd) begin
        pc_reg <= pc_reg+ 2;
      end

      case(opcode)
        `JMP_C_J: begin /* increment pc by imd */
          if(condition_code & condition_reg) begin
            pc_reg <= pc_reg + mem_in_data;
          end
        end
        `JMP_C_R: begin /* jump to value in reg */
          if(condition_code & condition_reg) begin
            pc_reg <= reg0;
          end
        end
        `ALU_R_R0, `ALU_R_R1, `ALU_R_R2, `ALU_R_R3, `CMP_R_F: begin /* alu op */
          alu_reg0 <= reg0;
          alu_reg1 <= reg1;
          alu_op_reg <= alu_op;
        end
        `ALU_R_I0, `ALU_R_I1, `ALU_R_I2, `ALU_R_I3: begin /* alu op */
          alu_reg0 <= reg0;
          alu_reg1 <= mem_in_data;
          alu_op_reg <= alu_op;
        end
        `LD_R_M: begin
          mem_addr <= pc_reg + mem_in_data;
          mem_byte_enable <= op_mem_bw;
          sign_extend <= op_mem_su;
        end
        `LD_R_P: begin
          mem_addr <= reg1;
          mem_byte_enable <= op_mem_bw;
          sign_extend <= op_mem_su;
        end
        `LD_R_P_OFF: begin
          mem_addr <= reg1 + mem_in_data;
          mem_byte_enable <= op_mem_bw;
          sign_extend <= op_mem_su;
        end
        `LD_R_RA: begin
          reg_writeback_val <= mem_in_data + pc_reg;
        end
        `ST_R_M: begin
          mem_addr <= pc_reg + mem_in_data;
          mem_byte_enable <= op_mem_bw;
          mem_write_enable <= 1;
          mem_write_data <= reg0;
        end
        `ST_R_P: begin
          mem_addr <= reg1;
          mem_byte_enable <= op_mem_bw;
          mem_write_enable <= 1;
          mem_write_data <= reg0;
        end
        `ST_R_P_OFF: begin
          mem_addr <= mem_in_data + reg1;
          mem_byte_enable <= op_mem_bw;
          mem_write_enable <= 1;
          mem_write_data <= reg0;
        end
        `IN_R_P: begin 
          io_addr <= mem_in_data;
        end
        `PUSH_R_SP: begin
          reg_write <= 1;
          reg_writeback_val <= reg1 - 2;
          mem_addr <= reg1 - 2;
          mem_byte_enable <= 0;
          mem_write_enable <= 1;
          mem_write_data <= reg0;
        end
        `POP_R_SP: begin
          reg_write <= 1;
          reg_writeback_val <= reg1 + 2;
          mem_addr <= reg1;
          mem_byte_enable <= 0;
        end
        `CALL_J_SP: begin
          reg_write <= 1;
          reg_writeback_val <= reg1 - 2;
          mem_addr <= reg1 - 2;
          mem_byte_enable <= 0;
          mem_write_enable <= 1;
          mem_write_data <= pc_reg + 2;
          pc_reg <= pc_reg + mem_in_data;
        end
        `CALL_R_SP: begin
          reg_write <= 1;
          reg_writeback_val <= reg1 - 2;
          mem_addr <= reg1 - 2;
          mem_byte_enable <= 0;
          mem_write_enable <= 1;
          mem_write_data <= pc_reg;
          pc_reg <= reg0;
        end
        `RET_N_SP: begin
          reg_write <= 1;
          reg_writeback_val <= reg1 + 2;
          mem_addr <= reg1;
          mem_byte_enable <= 0;
        end
        `PTB_R_N: begin
          ptb_reg <= reg0;
        end
        `MOV_R_IPC: begin
          ipc_reg <= reg0;
        end
        default: begin
          /* do nothing */
        end
      endcase

      microstep <= 2'b10;
    end
    2'b10: begin /* memory access - next instruction */
      /* no matter what, reload instruction (even if it is already in imd reg) */
      /* inc pc so that it points to imd after this access */
      pc_reg <= pc_reg + 2;
      mem_addr <= pc_reg;
      mem_byte_enable <= 0;
      mem_write_enable <= 0;
      /* writeback secondary reg value if needed */
      if(reg_write) begin
        regfile[reg1_i] <= reg_writeback_val;
      end

      /* prepare for write back on microstep 00 */
      write_back_reg_i <= reg0_i;
      
      case(opcode)
        `MOV_R_R: begin /* write reg1 to reg0 */
          reg_write <= 1;
          reg_writeback_val <= reg1;
        end
        `LD_R_I: begin 	/* write imd to reg0 */
          reg_write <= 1;
          reg_writeback_val <= imd_reg;
        end
        `OUT_R_P: begin /* put reg on alu0 (io input), and write io_addr port) */
          alu_reg0 <= reg0;
          io_write <= 1;
          io_addr <= imd_reg;
        end
        `IN_R_P: begin
          reg_write <= 1;
          reg_writeback_val <= io_in;
        end
        `ALU_R_R0, `ALU_R_R1, `ALU_R_R2, `ALU_R_R3, `ALU_R_I0, `ALU_R_I1, `ALU_R_I2, `ALU_R_I3: begin /* setup writeback */
          reg_write <= 1;
          reg_writeback_val <= alu_res;
        end
        `CMP_R_F: begin
          condition_reg <= cond_res;
        end
        `LD_R_M, `LD_R_P, `LD_R_P_OFF: begin
          mem_byte_enable <= 0;
          sign_extend <= 0;

          reg_write <= 1;
          reg_writeback_val <= mem_in_data;
        end
        `LD_R_RA: begin
          reg_write <= 1;
          /* reg writeback value set last setp */
        end
        `PUSH_R_SP: begin
          reg_write <= 0;
        end
        `POP_R_SP: begin
          reg_write <= 1;
          reg_writeback_val <= mem_in_data;
        end
        `CALL_J_SP: begin
          reg_write <= 0;
        end
        `CALL_R_SP: begin
          reg_write <= 0;
        end
        `RET_N_SP: begin
          pc_reg <= mem_in_data + 2;
          mem_addr <= mem_in_data;
          reg_write <= 0;
        end
        `MOV_IPC_R: begin
          reg_write <= 1;
          reg_writeback_val <= ipc_reg;
        end

        `NOP_N_N: begin /* do nothing */
        end
        default: begin
        end
      endcase

      microstep <= 2'b00;
    end
    2'b11: begin
      /* write instr register and switch */
      microstep <= 2'b00;
    end
  endcase
end

endmodule
  