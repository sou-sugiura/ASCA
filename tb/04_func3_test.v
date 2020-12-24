`timescale 1ns /  1ns 

module func3_test();

reg clk;
reg reset_n;
reg rom_en;
reg ram_cen;
wire [15:0] pc_out;
wire [15:0] op;
wire ram_wen;
wire [15:0] ram_addr;
wire [15:0] ram_data;
wire [15:0] ram_out;

wire is_branch;
wire n_is_branch;
wire [5:0] branch_sel;
wire [15:0] R0;
wire [15:0] R1;
wire [15:0] R2;
wire [15:0] R3;
wire fwd_en;
wire nop_en;
wire [15:0] PSR;
wire [15:0] REGA;
wire [15:0] offsaddr16;
wire [15:0] bx_addr;

top i_top(
.clk(clk),
.reset_n(reset_n),
.rom_en(rom_en),
.ram_cen(ram_cen),
.pc_out(pc_out),
.op(op),
.ram_wen(ram_wen),
.ram_addr(ram_addr),
.ram_data(ram_data),
.ram_out(ram_out));

//assign is_branch = i_top.i_asca16core.i_instrctl.i_bctl.is_branch;
//assign n_is_branch = i_top.i_asca16core.i_instrctl.i_bctl.n_is_branch;
assign branch_sel = i_top.i_asca16core.i_instrctl.i_bctl.branch_sel;
assign R0 = i_top.i_asca16core.REG_0;
assign R1 = i_top.i_asca16core.REG_1;
assign R2 = i_top.i_asca16core.REG_2;
assign R3 = i_top.i_asca16core.REG_3;
assign PSR = i_top.i_asca16core.REG_14;
assign fwd_en = i_top.i_asca16core.fwd_en;
assign nop_en = i_top.i_asca16core.nop_en;
//assign opaddr = i_top.i_asca16core.i_instrctl.opaddr;
assign bx_addr = i_top.i_asca16core.i_instrctl.i_bctl.bx_addr;
assign REGA = i_top.i_asca16core.i_instrctl.i_bctl.REGA;
assign offsaddr16 = i_top.i_asca16core.i_instrctl.i_bctl.offsaddr16;

initial begin
 $dumpfile("func3_test.vcd");
 $dumpvars(0, func3_test);
 $monitor("clk=%b, reset_n=%b, op=%h, pc_out=%h, fwd_en=%b, nop_en=%b, bx_addr=%h, REGA=%h, offsaddr16=%h, R0=%h, R1=%h, R2=%h, R3=%h, PSR=%h",clk,reset_n,op,pc_out,fwd_en,nop_en,bx_addr,REGA,offsaddr16,R0,R1,R2,R3,PSR);
end

always begin
    clk =       1'b0;
    clk = #25   1'b1;
          #25;
end

initial begin
    $readmemb("tb/data/04_rom_func3_test.binary", i_top.i_rom.rom, 16'd0,16'd65535);
    #0      rom_en  = 1'b0;
            ram_cen = 1'b0;
            reset_n = 1'b1;
    #50     reset_n = 1'b0;
    #150    reset_n = 1'b1;
            rom_en  = 1'b1;
            ram_cen = 1'b1;
    #6800;
    $writememb("tb/data/04_ram_func3_test.binary", i_top.i_ram.ram, 16'd0,16'd65535);
    $finish;
end

endmodule
