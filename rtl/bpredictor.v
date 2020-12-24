`include "rtl/def.h"

module bpredictor (
input clk,
input reset_n,
input [`OPCODE_W-1:0] opcode,
input [`DATA_W-1:0] opaddr,
input N,
input Z,
input NZ,
input V,
output is_branch,
output n_is_branch,
output predict_branch
);

reg [`OPCODE_W-1:0] opcode_1dly;
reg [`OPCODE_W-1:0] opcode_2dly;
reg is_beq_1dly;
reg is_beq_2dly;
reg is_bne_1dly;
reg is_bne_2dly;
reg is_blt_1dly;
reg is_blt_2dly;
reg is_ble_1dly;
reg is_ble_2dly;

wire is_beq;
wire is_bne;
wire is_blt;
wire is_ble;
wire predict_branch; 

assign is_beq = (opcode==`BEQ) && (opaddr[15]==1'b1);
assign is_bne = (opcode==`BNE) && (opaddr[15]==1'b1);
assign is_blt = (opcode==`BLT) && (opaddr[15]==1'b1);
assign is_ble = (opcode==`BLE) && (opaddr[15]==1'b1);
assign predict_branch = is_beq | is_bne | is_blt | is_ble;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        opcode_1dly <= `OPCODE_W'b00000;
        opcode_2dly <= `OPCODE_W'b00000;
        is_beq_1dly <= 1'b0;
        is_beq_2dly <= 1'b0;
        is_bne_1dly <= 1'b0;
        is_bne_2dly <= 1'b0;
        is_blt_1dly <= 1'b0;
        is_blt_2dly <= 1'b0;
        is_ble_1dly <= 1'b0;
        is_ble_2dly <= 1'b0;
    end else begin
        opcode_1dly <= opcode;
        opcode_2dly <= opcode_1dly;
        is_beq_1dly <= is_beq;
        is_beq_2dly <= is_beq_1dly;
        is_bne_1dly <= is_bne;
        is_bne_2dly <= is_bne_1dly;
        is_blt_1dly <= is_blt;
        is_blt_2dly <= is_blt_1dly;
        is_ble_1dly <= is_ble;
        is_ble_2dly <= is_ble_1dly;
    end
end

assign is_branch   = (Z & ~is_beq_2dly)         & (opcode_2dly==`BEQ) |
                     (NZ & ~is_bne_2dly)        & (opcode_2dly==`BNE) |
                     (N^V & ~is_blt_2dly)       & (opcode_2dly==`BLT) |
                     ((Z|(N^V)) & ~is_ble_2dly) & (opcode_2dly==`BLE);

assign n_is_branch = (~Z & is_beq_2dly)         & (opcode_2dly==`BEQ) |
                     (~NZ & is_bne_2dly)        & (opcode_2dly==`BNE) |
                     (~(N^V) & is_blt_2dly)     & (opcode_2dly==`BLT) |
                     (~(Z|(N^V)) & is_ble_2dly) & (opcode_2dly==`BLE);
 
endmodule 
