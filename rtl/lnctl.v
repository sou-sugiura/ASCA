`include "rtl/def.h"

module lnctl(
input clk,
input reset_n,
input [`OPCODE_W-1:0] opcode,
input [`REG_N-1:0] nREGA,
input [`DATA_W-1:0] pc_in,
output reg [`DATA_W-1:0] set_lr,
output reg lr_seten,
output reg lr_recoven
);

reg lr_sel_1dly;
reg lr_recov_1dly;
reg [`DATA_W-1:0] pc_1dly;
reg [`DATA_W-1:0] pc_in3;

wire is_blx;
wire is_lr;
wire is_bl;
wire lr_sel;
wire lr_recov;
wire [`DATA_W-1:0] pc_in2;

assign is_blx   = (opcode==`BLX);
assign is_lr    = (nREGA==4'b1111);
assign is_bl    = (opcode==`BL);
assign lr_sel   = (is_blx & ~is_lr) | is_bl;
assign lr_recov = (is_blx & is_lr);

assign pc_in2 = (lr_sel) ? pc_in+`DATA_W'd1 : set_lr;
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) pc_in3  <= `DATA_W'd0;
    else pc_in3  <= pc_in2;
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        lr_sel_1dly   <= 1'b0;
        lr_recov_1dly <= 1'b0;
        lr_seten      <= 1'b0;
        lr_recoven    <= 1'b0;
    end else begin
        lr_sel_1dly   <= lr_sel;
        lr_recov_1dly <= lr_recov;
        lr_seten      <= lr_sel_1dly;
        lr_recoven    <= lr_recov_1dly;
    end
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) pc_1dly <= `DATA_W'd0;
    else if(lr_sel) pc_1dly <= pc_in2;
    else if(lr_sel_1dly) pc_1dly <= pc_in3;
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) set_lr <= `DATA_W'd0;
    else set_lr <= pc_1dly;
end

endmodule
