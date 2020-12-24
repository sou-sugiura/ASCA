`include "rtl/def.h"

module fetch(
input clk,
input reset_n,
input [`OP_W-1:0] op_in,
output reg [`OPCODE_W-1:0] opcode_out,
output reg [`OPDATA_W-1:0] opdata_out,
output reg [`REG_N-1:0] nREGA_out,
output reg [`REG_N-1:0] nREGB_out);

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        opcode_out <= `OPCODE_W'b00000;
        nREGA_out  <= `REG_N'b0000;
        nREGB_out  <= `REG_N'b0000;
        opdata_out <= `OPDATA_W'b00000000;
    end else begin
        opcode_out <= op_in[15:11];
        nREGA_out  <= op_in[10:7];
        nREGB_out  <= op_in[6:3];
        opdata_out <= op_in[7:0];
    end
end

endmodule
