`define DATA_W 16
`define OP_W 16
`define OPCODE_W 5
`define OPADDR_W 11
`define OPDATA_W 8
`define REG_N 4
`define MEM_DEPTH 65536
`define REG_FILE 16
`define NOP  `OPCODE_W'b00000
`define LSR  `OPCODE_W'b00001
`define LSL  `OPCODE_W'b00010
`define ASR  `OPCODE_W'b00011
`define LDRH `OPCODE_W'b00100
`define LDRL `OPCODE_W'b00101
`define ADDI `OPCODE_W'b00110
`define ADD  `OPCODE_W'b01000
`define MUL  `OPCODE_W'b01001
`define AND  `OPCODE_W'b01010
`define ORR  `OPCODE_W'b01011
`define XOR  `OPCODE_W'b01100
`define NOT  `OPCODE_W'b01101
`define MOV  `OPCODE_W'b01110
`define CMP  `OPCODE_W'b01111
`define LDR  `OPCODE_W'b10000
`define STR  `OPCODE_W'b10001
`define PUSH `OPCODE_W'b10010
`define POP  `OPCODE_W'b10011
`define BLX  `OPCODE_W'b11000
`define BL   `OPCODE_W'b11001
`define B    `OPCODE_W'b11010
`define BEQ  `OPCODE_W'b11011
`define BNE  `OPCODE_W'b11100
`define BLT  `OPCODE_W'b11101
`define BLE  `OPCODE_W'b11110
