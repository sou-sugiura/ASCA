`include "rtl/def.h"

module top(
input clk,
input reset_n,
input rom_en,
input ram_cen,
output [`DATA_W-1:0] pc_out,
output [`DATA_W-1:0] op,
output ram_wen,
output [`DATA_W-1:0] ram_addr,
output [`DATA_W-1:0] ram_data,
output [`DATA_W-1:0] ram_out);

wire [`DATA_W-1:0] op;
wire ram_wen; //0:read 1:write
wire [`DATA_W-1:0] ram_addr;
wire [`DATA_W-1:0] ram_data;
wire [`DATA_W-1:0] ram_out;
wire [`DATA_W-1:0] pc_out;

//CPU CORE
asca16core i_asca16core(
.clk(clk),
.reset_n(reset_n),
.op(op),
.ram_in(ram_out),
.pc_out(pc_out),
.ram_wen(ram_wen),
.ram_addr(ram_addr),
.ram_data(ram_data));

//EXCEPTION CONTROLER (NOT YET IMPLEMENTED)
//expctl i_expctl(
//.clk(clk),
//.reset_n(reset_n),
//.ir_op(),
//.irq());

//SUBSYSTEM CONTROLER (NOT YET IMPLEMENTED)
//subsysctl i_subsysctl(
//.clk(clk),
//.reset_n(reset_n)
//)

//ROM
rom i_rom(
.ren(rom_en),
.addr(pc_out),
.data(op));

//RAM
ram i_ram(
.clk(clk),
.reset_n(reset_n),
.wen(ram_wen),
.cen(ram_cen),
.addr(ram_addr),
.data_in(ram_data),
.data_out(ram_out));

endmodule
