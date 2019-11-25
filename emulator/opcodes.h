#define NOP_N_N     0b000000
#define MOV_R_R     0b000001
#define CMP_R_F     0b000010
#define LD_R_RA     0b001000

#define ALU_R_R0    0b000100
#define ALU_R_R1    0b000101
#define ALU_R_R2    0b000110
#define ALU_R_R3    0b000111

#define ALU_R_I0    0b001100
#define ALU_R_I1    0b001101
#define ALU_R_I2    0b001110
#define ALU_R_I3    0b001111

#define LD_R_I      0b011000
#define LD_R_M      0b011001
#define LD_R_P      0b010000
#define LD_R_P_OF   0b011010

#define ST_R_M      0b011011
#define ST_R_P      0b010001
#define ST_R_P_OF   0b011100
#define JMP_C_J     0b011101

#define JMP_C_R     0b000011

#define PUSH_R_SP   0b010011
#define POP_R_SP    0b010100
#define CALL_J_SP   0b011110

#define CALL_R_SP   0b010101
#define RET_N_SP    0b010110

#define OUT_R_P     0b111000
#define IN_R_P      0b111001

#define INT_I_N     0b010111

#define MMU_R_R     0b110001
#define PTB_R_N     0b110000

#define RETI_IPC_N  0b100000
#define MOV_R_IPC   0b100001
#define MOV_IPC_R   0b100010

#define HLT_N_N     0b111111
