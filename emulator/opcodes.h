#define NOP_N_N   0b000000
#define MOV_R_R   0b000001
#define CMP_R_F   0b000010
#define LD_R_RA   0b000011

#define ALU_R_R0  0b000100
#define ALU_R_R1  0b000101
#define ALU_R_R2  0b000110
#define ALU_R_R3  0b000111

#define ALU_R_I0  0b001000
#define ALU_R_I1  0b001001
#define ALU_R_I2  0b001010
#define ALU_R_I3  0b001011

#define LD_R_I    0b001100
#define LD_R_M    0b001101
#define LD_R_P    0b001110
#define LD_R_P_OF 0b001111

#define ST_R_M    0b010000
#define ST_R_P    0b010001
#define ST_R_P_OF 0b010010
#define JMP_C_J   0b010011

#define JMP_C_R   0b010100
#define PUSH_R_SP 0b010101
#define POP_R_SP  0b010110
#define CALL_J_SP 0b010111

#define CALL_R_SP 0b011000
#define RET_N_SP  0b011001

#define OUT_R_P   0b011010
#define IN_R_P    0b011011

#define INT_I_N   0b011100
