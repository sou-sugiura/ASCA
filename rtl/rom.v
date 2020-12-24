`include "rtl/def.h"

module rom(
input ren,
input [`DATA_W-1:0] addr,
output reg [`DATA_W-1:0] data);

reg [`DATA_W-1:0] rom [0:`MEM_DEPTH-1];

always @ (ren or addr) begin
    data <= (ren==1) ? rom[addr] : `DATA_W'hzzzz;
end

endmodule
