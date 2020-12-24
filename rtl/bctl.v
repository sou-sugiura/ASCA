`include "rtl/def.h"

module bctl(
input clk,
input reset_n,
input [`OPCODE_W-1:0] opcode,
input [`DATA_W-1:0] opaddr,
input [`OPDATA_W-2:0] offsaddr,
input [`REG_N-1:0] nREGA,
input N,
input Z,
input NZ,
input V,
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
input [`DATA_W-1:0] pc_in,
output [`DATA_W-1:0] pc_bout,
output nop_en);

reg [`DATA_W-1:0] pc_plus1_1dly;
reg [`DATA_W-1:0] pc_plus1_2dly;
reg [`DATA_W-1:0] b_addr_1dly;
reg [`DATA_W-1:0] b_addr_2dly;
reg predict_fault_1dly;

wire is_branch;
wire n_is_branch;
wire [5:0] branch_sel;
wire predict_fault;
wire [`DATA_W-1:0] REGA;
wire [`DATA_W-1:0] offsaddr16;
wire [`DATA_W-1:0] b_addr;
wire [`DATA_W-1:0] bx_addr;
wire [`DATA_W-1:0] pc_plus1;
wire [`DATA_W-1:0] next_pc1;
wire [`DATA_W-1:0] next_pc2;

bpredictor i_bpredictor(
.clk(clk),
.reset_n(reset_n),
.opcode(opcode),
.opaddr(opaddr),
.N(N),
.Z(Z),
.NZ(NZ),
.V(V),
.is_branch(is_branch),
.n_is_branch(n_is_branch),
.predict_branch(predict_branch));

assign branch_sel = {predict_branch, opcode};
assign predict_fault = is_branch | n_is_branch;
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) predict_fault_1dly <= 1'b0;
    else predict_fault_1dly <= predict_fault;
end
assign nop_en = predict_fault | predict_fault_1dly; 

function [`DATA_W-1:0] dec_reg;
    input [`REG_N-1:0] nREG;
    input [`DATA_W-1:0] R0;
    input [`DATA_W-1:0] R1;
    input [`DATA_W-1:0] R2;
    input [`DATA_W-1:0] R3;
    input [`DATA_W-1:0] R4;
    input [`DATA_W-1:0] R5;
    input [`DATA_W-1:0] R6;
    input [`DATA_W-1:0] R7;
    input [`DATA_W-1:0] R8;
    input [`DATA_W-1:0] R9;
    input [`DATA_W-1:0] R10;
    input [`DATA_W-1:0] R11;
    input [`DATA_W-1:0] R12;
    input [`DATA_W-1:0] R13;
    input [`DATA_W-1:0] R14;
    input [`DATA_W-1:0] R15;
    case(nREG)
        `REG_N'b0000: dec_reg = R0;
        `REG_N'b0001: dec_reg = R1;
        `REG_N'b0010: dec_reg = R2;
        `REG_N'b0011: dec_reg = R3;
        `REG_N'b0100: dec_reg = R4;
        `REG_N'b0101: dec_reg = R5;
        `REG_N'b0110: dec_reg = R6;
        `REG_N'b0111: dec_reg = R7;
        `REG_N'b1000: dec_reg = R8;
        `REG_N'b1001: dec_reg = R9;
        `REG_N'b1010: dec_reg = R10;
        `REG_N'b1011: dec_reg = R11;
        `REG_N'b1100: dec_reg = R12;
        `REG_N'b1101: dec_reg = R13;
        `REG_N'b1110: dec_reg = R14;
        `REG_N'b1111: dec_reg = R15;
        default: dec_reg = 16'h0000;
    endcase
endfunction

assign REGA     = dec_reg(nREGA,R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15);
assign offsaddr16 = {{9{offsaddr[`OPDATA_W-2]}}, offsaddr[`OPDATA_W-2:0]};
assign b_addr   = pc_in + opaddr;
assign bx_addr  = REGA + offsaddr16; 
assign pc_plus1 = pc_in + `DATA_W'd1;

function [`DATA_W-1:0] dec_pc;
input [5:0] branch_sel;
input [`DATA_W-1:0] b_addr;
input [`DATA_W-1:0] bx_addr;
input [`DATA_W-1:0] pc_plus1;
    if(branch_sel[5]==1'b1) dec_pc = b_addr;
    else begin
        case(branch_sel[4:0])
            `BLX: dec_pc = bx_addr;
            `BL : dec_pc = b_addr;
            `B  : dec_pc = b_addr;
            default : dec_pc = pc_plus1;
        endcase
    end
endfunction

assign next_pc1 = dec_pc(branch_sel,b_addr,bx_addr,pc_plus1);

always @ (posedge clk or negedge reset_n) begin
   if(!reset_n) begin
        pc_plus1_1dly <= 1'b0;
        pc_plus1_2dly <= 1'b0;
        b_addr_1dly   <= 1'b0;
        b_addr_2dly   <= 1'b0;
   end else begin
        pc_plus1_1dly <= pc_plus1;
        pc_plus1_2dly <= pc_plus1_1dly;
        b_addr_1dly   <= b_addr;
        b_addr_2dly   <= b_addr_1dly;
   end
end

assign next_pc2 = (n_is_branch)? pc_plus1_2dly : next_pc1;
assign pc_bout = (is_branch)? b_addr_2dly : next_pc2;

endmodule
