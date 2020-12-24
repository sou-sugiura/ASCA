`include "rtl/def.h"

module exec(
input clk,
input reset_n,
input [`DATA_W-1:0] lr_in,
input lr_seten,
input [`OPCODE_W-1:0] opcode_in,
input [`DATA_W-1:0] opdata_in,
input [`REG_N-1:0] nREGA_in,
input [`DATA_W-1:0] REGA_in,
input [`DATA_W-1:0] REGB_in,
input [`DATA_W-1:0] RAM_in,
output ram_wen,
output [`DATA_W-1:0] ram_data,
output [`DATA_W-1:0] REG0_OUT,
output [`DATA_W-1:0] REG1_OUT,
output [`DATA_W-1:0] REG2_OUT,
output [`DATA_W-1:0] REG3_OUT,
output [`DATA_W-1:0] REG4_OUT,
output [`DATA_W-1:0] REG5_OUT,
output [`DATA_W-1:0] REG6_OUT,
output [`DATA_W-1:0] REG7_OUT,
output [`DATA_W-1:0] REG8_OUT,
output [`DATA_W-1:0] REG9_OUT,
output [`DATA_W-1:0] REG10_OUT,
output [`DATA_W-1:0] REG11_OUT,
output [`DATA_W-1:0] REG12_OUT,
output [`DATA_W-1:0] REG13_OUT,
output [`DATA_W-1:0] REG14_OUT,
output [`DATA_W-1:0] REG15_OUT,
output [`DATA_W-1:0] sp_out);

integer i;

reg [`DATA_W-1:0] PSR, SP, LR;
reg [`DATA_W-1:0] reg_file [0:`REG_FILE-3];
wire [`DATA_W:0] cmp;

assign ram_data = (opcode_in==`STR || opcode_in==`PUSH) ? REGA_in : 
                  (lr_seten) ? LR : `DATA_W'h0000;
assign ram_wen  = (opcode_in==`STR || opcode_in==`PUSH || lr_seten ) ? 1 : 0;
assign cmp      = REGA_in - REGB_in;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        LR  <= `DATA_W'h0000;
        SP  <= `DATA_W'h0020;
        PSR <= `DATA_W'h0000;
    end else begin
        case(opcode_in)
            `CMP: begin
                PSR[15] <= (REGA_in - REGB_in) < 0;      //neg_flg
                PSR[14] <= (REGA_in - REGB_in)  == 0;    //zero_flg
                PSR[13] <= ~((REGA_in - REGB_in) == 0);  //non-zero_flg
                PSR[12] <= (cmp[16] == 1'b1);            //overflow_flg
                end
            `PUSH:
                SP <= REGB_in - `DATA_W'd1;
            `POP: begin
                SP <= REGB_in;
                if(nREGA_in==`REG_N'b1111) 
                    LR <= RAM_in;
                else if(nREGA_in==`REG_N'b1110)
                    PSR <= RAM_in;
                end
            `BL: begin
                LR <= lr_in;
                SP <= REGB_in - `DATA_W'd1;
                end
            `BLX: begin
                if(nREGA_in!=`REG_N'b1111) begin
                    LR <= lr_in;
                    SP <= REGB_in - `DATA_W'd1;
                end else begin
                    LR <= RAM_in;
                    SP <= REGB_in;
                end
                end
         //default:
        endcase
    end
end

always @ (posedge clk or negedge reset_n) begin 
    if(!reset_n) begin
        for ( i=0; i<`REG_FILE-2; i=i+1)
            reg_file[i] <= `DATA_W'h0000;
    end else begin
        case(opcode_in)
            `ADD: reg_file[nREGA_in] <= REGA_in + REGB_in; 
            `MUL: reg_file[nREGA_in] <= REGA_in * REGB_in;
            `AND: reg_file[nREGA_in] <= REGA_in & REGB_in;
            `ORR: reg_file[nREGA_in] <= REGA_in | REGB_in;
            `XOR: reg_file[nREGA_in] <= REGA_in ^ REGB_in;
            `NOT: reg_file[nREGA_in] <= ~REGA_in;
            `MOV: reg_file[nREGA_in] <= REGB_in;
            `LDR: reg_file[nREGA_in] <= RAM_in;
            `POP: if((nREGA_in!=`REG_N'b1111)||(nREGA_in!=`REG_N'b1110)) reg_file[nREGA_in] <= RAM_in;
            `ADDI:reg_file[nREGA_in] <= REGA_in + opdata_in;
            `LDRH:reg_file[nREGA_in][15:8] <= opdata_in;
            `LDRL:reg_file[nREGA_in][7:0]  <= opdata_in;
            `LSR: reg_file[nREGA_in] <= REGA_in >> opdata_in;
            `LSL: reg_file[nREGA_in] <= REGA_in << opdata_in;
         //default:
        endcase
    end
end

assign REG0_OUT  = reg_file[0];
assign REG1_OUT  = reg_file[1];
assign REG2_OUT  = reg_file[2];
assign REG3_OUT  = reg_file[3];
assign REG4_OUT  = reg_file[4];
assign REG5_OUT  = reg_file[5];
assign REG6_OUT  = reg_file[6];
assign REG7_OUT  = reg_file[7];
assign REG8_OUT  = reg_file[8];
assign REG9_OUT  = reg_file[9];
assign REG10_OUT = reg_file[10];
assign REG11_OUT = reg_file[11];
assign REG12_OUT = reg_file[12];
assign REG13_OUT = reg_file[13];
assign REG14_OUT = PSR;
assign REG15_OUT = LR;
assign sp_out    = SP;

endmodule
