`include "rtl/def.h"

module asca16core(
input clk,
input reset_n,
input [`OP_W-1:0] op,
input [`DATA_W-1:0] ram_in,
output [`DATA_W-1:0] pc_out,
output ram_wen,
output [`DATA_W-1:0] ram_addr,
output [`DATA_W-1:0] ram_data);

wire [`OPCODE_W-1:0] opcode_f;
wire [`OPCODE_W-1:0] opcode_f2;
wire [`OPCODE_W-1:0] opcode_d;
wire [`OPDATA_W-1:0] opdata_f;
wire [`OPDATA_W-1:0] opdata_d1;
wire [`DATA_W-1:0] opdata_d2;
wire [`REG_N-1:0] nREGA_f;
wire [`REG_N-1:0] nREGA_d;
wire [`REG_N-1:0] nREGB_f;
wire [`REG_N-1:0] nREGB_d;
wire [`DATA_W-1:0] REGA_d1;
wire [`DATA_W-1:0] REGA_d2;
wire [`DATA_W-1:0] REGA_d3;
wire [`DATA_W-1:0] REGB_d1;
wire [`DATA_W-1:0] REGB_d2;
wire [`DATA_W-1:0] REGB_d3;
wire [`DATA_W-1:0] REGB_d4;
wire [`DATA_W-1:0] REG_0;
wire [`DATA_W-1:0] REG_1;
wire [`DATA_W-1:0] REG_2;
wire [`DATA_W-1:0] REG_3;
wire [`DATA_W-1:0] REG_4;
wire [`DATA_W-1:0] REG_5;
wire [`DATA_W-1:0] REG_6;
wire [`DATA_W-1:0] REG_7;
wire [`DATA_W-1:0] REG_8;
wire [`DATA_W-1:0] REG_9;
wire [`DATA_W-1:0] REG_10;
wire [`DATA_W-1:0] REG_11;
wire [`DATA_W-1:0] REG_12;
wire [`DATA_W-1:0] REG_13;
wire [`DATA_W-1:0] REG_14;
wire [`DATA_W-1:0] REG_15;

wire [`DATA_W-1:0] pc_out;
wire [`DATA_W-1:0] sp_out;
wire [`DATA_W-1:0] lr_out;
wire lr_seten;
wire lr_recoven;
wire nop_en;
wire fwd_en;
wire push_en;
wire pop_en;

//Instruction Control Unit
instrctl i_instrctl(
.clk(clk),
.reset_n(reset_n),
.op(op),
.R0(REG_0),
.R1(REG_1),
.R2(REG_2),
.R3(REG_3),
.R4(REG_4),
.R5(REG_5),
.R6(REG_6),
.R7(REG_7),
.R8(REG_8),
.R9(REG_9),
.R10(REG_10),
.R11(REG_11),
.R12(REG_12),
.R13(REG_13),
.R14(REG_14),
.R15(REG_15),
.pc_out(pc_out),
.set_lr(lr_out),
.lr_seten(lr_seten),
.lr_recoven(lr_recoven),
.nop_en(nop_en),
.fwd_en(fwd_en));

//Fetch Block
fetch i_fetch(
.clk(clk),
.reset_n(reset_n),
.op_in(op),
.opcode_out(opcode_f),
.opdata_out(opdata_f),
.nREGA_out(nREGA_f),
.nREGB_out(nREGB_f));

//Insert NOP Instruction if nop_en is "High"
assign opcode_f2 = (nop_en) ? `NOP : opcode_f;

//Decode Block
decode i_decode(
.clk(clk),
.reset_n(reset_n),
.opcode_in(opcode_f2),
.opdata_in(opdata_f),
.nREGA_in(nREGA_f),
.nREGB_in(nREGB_f),
.REG0_IN(REG_0),
.REG1_IN(REG_1),
.REG2_IN(REG_2),
.REG3_IN(REG_3),
.REG4_IN(REG_4),
.REG5_IN(REG_5),
.REG6_IN(REG_6),
.REG7_IN(REG_7),
.REG8_IN(REG_8),
.REG9_IN(REG_9),
.REG10_IN(REG_10),
.REG11_IN(REG_11),
.REG12_IN(REG_12),
.REG13_IN(REG_13),
.REG14_IN(REG_14),
.REG15_IN(REG_15),
.opcode_out(opcode_d),
.opdata_out(opdata_d1),
.nREGA_out(nREGA_d),
.nREGB_out(nREGB_d),
.REGA_out(REGA_d1),
.REGB_out(REGB_d1));

function [`DATA_W-1:0] dec_reg;
input [`REG_N-1:0] nREG;
input [`DATA_W-1:0] REG0_IN;
input [`DATA_W-1:0] REG1_IN;
input [`DATA_W-1:0] REG2_IN;
input [`DATA_W-1:0] REG3_IN;
input [`DATA_W-1:0] REG4_IN;
input [`DATA_W-1:0] REG5_IN;
input [`DATA_W-1:0] REG6_IN;
input [`DATA_W-1:0] REG7_IN;
input [`DATA_W-1:0] REG8_IN;
input [`DATA_W-1:0] REG9_IN;
input [`DATA_W-1:0] REG10_IN;
input [`DATA_W-1:0] REG11_IN;
input [`DATA_W-1:0] REG12_IN;
input [`DATA_W-1:0] REG13_IN;
input [`DATA_W-1:0] REG14_IN;
input [`DATA_W-1:0] REG15_IN;
    case(nREG)
        `REG_N'b0000: dec_reg = REG0_IN;
        `REG_N'b0001: dec_reg = REG1_IN;
        `REG_N'b0010: dec_reg = REG2_IN;
        `REG_N'b0011: dec_reg = REG3_IN;
        `REG_N'b0100: dec_reg = REG4_IN;
        `REG_N'b0101: dec_reg = REG5_IN;
        `REG_N'b0110: dec_reg = REG6_IN;
        `REG_N'b0111: dec_reg = REG7_IN;
        `REG_N'b1000: dec_reg = REG8_IN;
        `REG_N'b1001: dec_reg = REG9_IN;
        `REG_N'b1010: dec_reg = REG10_IN;
        `REG_N'b1011: dec_reg = REG11_IN;
        `REG_N'b1100: dec_reg = REG12_IN;
        `REG_N'b1101: dec_reg = REG13_IN;
        `REG_N'b1110: dec_reg = REG14_IN;
        `REG_N'b1111: dec_reg = REG15_IN;
             default: dec_reg = 16'h0000;
    endcase
endfunction

//forwarding
assign REGA_d2 = dec_reg(nREGA_d, REG_0, REG_1, REG_2, REG_3, REG_4,
                          REG_5,REG_6, REG_7, REG_8, REG_9, REG_10,
                          REG_11, REG_12, REG_13, REG_14, REG_15);

assign REGB_d2 = dec_reg(nREGB_d, REG_0, REG_1, REG_2, REG_3, REG_4,
                          REG_5,REG_6, REG_7, REG_8, REG_9, REG_10,
                          REG_11, REG_12, REG_13, REG_14, REG_15);

assign REGA_d3 = (fwd_en) ? REGA_d2 : REGA_d1;
assign REGB_d3 = (fwd_en) ? REGB_d2 : REGB_d1;

//sign or zero extention
function [`DATA_W-1:0] ext;
input [`OPCODE_W-1:0] opcode_in;
input [`OPDATA_W-1:0] opdata_in;
    if(opcode_in==`LSL || opcode_in==`LSL || opcode_in==`ASR)
        ext = {{8{1'b0}}, opdata_in};
    else
        ext = {{8{opdata_in[`OPDATA_W-1]}}, opdata_in};
endfunction
assign opdata_d2 = ext(opcode_d,opdata_d1);

//push or pop
assign push_en   = (opcode_d==`PUSH || lr_seten);
assign pop_en    = (opcode_d==`POP  || lr_recoven);
assign REGB_d4   = (push_en) ? sp_out : (pop_en) ? sp_out+`DATA_W'd1 : REGB_d3;
assign ram_addr  = REGB_d4;

//Exec Block
exec i_exec(
.clk(clk),
.reset_n(reset_n),
.lr_in(lr_out),
.lr_seten(lr_seten),
.opcode_in(opcode_d),
.opdata_in(opdata_d2),
.nREGA_in(nREGA_d),
.REGA_in(REGA_d3),
.REGB_in(REGB_d4),
.RAM_in(ram_in),
.ram_wen(ram_wen),
.ram_data(ram_data),
.REG0_OUT(REG_0),
.REG1_OUT(REG_1),
.REG2_OUT(REG_2),
.REG3_OUT(REG_3),
.REG4_OUT(REG_4),
.REG5_OUT(REG_5),
.REG6_OUT(REG_6),
.REG7_OUT(REG_7),
.REG8_OUT(REG_8),
.REG9_OUT(REG_9),
.REG10_OUT(REG_10),
.REG11_OUT(REG_11),
.REG12_OUT(REG_12),
.REG13_OUT(REG_13),
.REG14_OUT(REG_14),
.REG15_OUT(REG_15),
.sp_out(sp_out));

endmodule
