`include "rtl/def.h"

module instrctl(
input clk,
input reset_n,
input [`OP_W-1:0] op,
input [`DATA_W-1:0] R0,
input [`DATA_W-1:0] R1,
input [`DATA_W-1:0] R2,
input [`DATA_W-1:0] R3,
input [`DATA_W-1:0] R4,
input [`DATA_W-1:0] R5,
input [`DATA_W-1:0] R6,
input [`DATA_W-1:0] R7,
input [`DATA_W-1:0] R8,
input [`DATA_W-1:0] R9,
input [`DATA_W-1:0] R10,
input [`DATA_W-1:0] R11,
input [`DATA_W-1:0] R12,
input [`DATA_W-1:0] R13,
input [`DATA_W-1:0] R14,
input [`DATA_W-1:0] R15,
output [`DATA_W-1:0] pc_out,
output [`DATA_W-1:0] set_lr,
output lr_seten,
output lr_recoven,
output nop_en,
output fwd_en);

reg [`DATA_W-1:0] PC;
wire [`OPCODE_W-1:0] opcode;
wire [`DATA_W-1:0] opaddr;
wire [`OPDATA_W-2:0] offsaddr;
wire [`REG_N-1:0] nREGA, nREGB;
wire [`DATA_W-1:0] pc_bout;

assign opcode = op[15:11];
assign opaddr = {{5{op[`OPADDR_W-1]}},op[`OPADDR_W-1:0]};
assign offsaddr = op[`OPDATA_W-2:0];
assign nREGB  = op[6:3];
assign nREGA  = (opcode==`ADDI || opcode==`LDRH || opcode==`LDRL ||
                 opcode==`LSR  || opcode==`LSL  || opcode==`ASR) ?
                {{1'b0},op[10:8]} : op[10:7];

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) PC <= 16'h0000;
    else PC <= pc_bout;
end

assign pc_out = PC;

//branch control unit
bctl i_bctl(
.clk(clk),
.reset_n(reset_n),
.opcode(opcode),
.opaddr(opaddr),
.offsaddr(offsaddr),
.nREGA(nREGA),
.N(R14[15]),
.Z(R14[14]),
.NZ(R14[13]),
.V(R14[12]),
.R0(R0),
.R1(R1),
.R2(R2),
.R3(R3),
.R4(R4),
.R5(R5),
.R6(R6),
.R7(R7),
.R8(R8),
.R9(R9),
.R10(R10),
.R11(R11),
.R12(R12),
.R13(R13),
.R14(R14),
.R15(R15),
.pc_in(PC),
.pc_bout(pc_bout),
.nop_en(nop_en));

//link instruction control unit
lnctl i_lnctl(
.clk(clk),
.reset_n(reset_n),
.opcode(opcode),
.nREGA(nREGA),
.pc_in(PC),
.set_lr(set_lr),
.lr_seten(lr_seten),
.lr_recoven(lr_recoven));

//forwarding control unit
fwdctl i_fwdctl(
.clk(clk),
.reset_n(reset_n),
.opcode(opcode),
.nREGA(nREGA),
.nREGB(nREGB),
.fwd_en(fwd_en));

endmodule
