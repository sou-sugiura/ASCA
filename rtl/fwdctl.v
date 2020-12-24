`include "rtl/def.h"

module fwdctl(
input clk,
input reset_n,
input [`OPCODE_W-1:0] opcode,
input [`REG_N-1:0] nREGA,
input [`REG_N-1:0] nREGB,
output fwd_en);

reg fwd_en;
reg fwd_1dly;
reg [`REG_N-1:0] distReg;
reg [`REG_N-1:0] distReg_1dly;
reg [`REG_N-1:0] srcReg1;
reg [`REG_N-1:0] srcReg2;
reg [1:0] src_sel;

always @ (opcode or nREGA or nREGB) begin
    distReg = nREGA;
    srcReg1 = nREGA;
    srcReg2 = nREGB;
    if(opcode==`ADD || opcode==`MUL || opcode==`AND || 
       opcode==`ORR || opcode==`XOR ) begin
        distReg = nREGA;
        srcReg1 = nREGA;
        srcReg2 = nREGB;
        src_sel = 2'b00;
    end else if(opcode==`STR || opcode==`CMP) begin
        srcReg1 = nREGA;
        srcReg2 = nREGB;
        src_sel = 2'b00;
    end else if(opcode==`MOV || opcode==`LDR) begin
        distReg = nREGA;
        srcReg1 = nREGB;
        src_sel = 2'b01;
    end else if(opcode==`NOT) begin
        distReg = nREGA;
        srcReg1 = nREGA;
        src_sel = 2'b01;
    end else if(opcode==`BLX) begin
        distReg = `REG_N'b1111;
        srcReg1 = nREGA;
        src_sel = 2'b01;
    end else if(opcode==`PUSH) begin
        srcReg1 = nREGA;
        src_sel = 2'b01;
    end else if(opcode==`ADDI || opcode==`LSR  || 
                opcode==`LSL  || opcode==`ASR) begin
        distReg = nREGA;
        srcReg1 = nREGA;
        src_sel = 2'b01;
    end else if(opcode==`POP || opcode==`LDRL || opcode==`LDRH) begin
        distReg = nREGA;
        src_sel = 2'b10;
    end else
        src_sel =  2'b11;
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) distReg_1dly <= `REG_N'b0000;
    else distReg_1dly <= distReg;
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        fwd_1dly <= 1'b0;
        fwd_en   <= 1'b0;
    end else begin
        fwd_1dly <= ((src_sel==2'b00) && ((srcReg1==distReg_1dly) || (srcReg2==distReg_1dly))) ||
                    ((src_sel==2'b01) && (srcReg1==distReg_1dly));
        fwd_en   <= fwd_1dly;
    end    
end

endmodule
