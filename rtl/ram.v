`include "rtl/def.h"

module ram(
input clk,
input reset_n,
input wen,
input cen,
input [`DATA_W-1:0] addr,
input [`DATA_W-1:0] data_in,
output [`DATA_W-1:0] data_out);

reg [`DATA_W-1:0] ram [0:`MEM_DEPTH-1];
wire WRITE, READ;

assign WRITE = (wen==1'b1) && (cen==1'b1);
assign READ  = (wen==1'b0) && (cen==1'b1);

always @ (negedge clk) begin
    if(WRITE)
        ram[addr] = data_in;
end

assign data_out =  (READ) ? ram[addr] : `DATA_W'hzzzz;

endmodule
