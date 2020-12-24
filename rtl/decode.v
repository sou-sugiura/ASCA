`include "rtl/def.h"

module decode(
input clk,
input reset_n,
input [`OPCODE_W-1:0] opcode_in,
input [`OPDATA_W-1:0] opdata_in,
input [`REG_N-1:0] nREGA_in,
input [`REG_N-1:0] nREGB_in,
input [`DATA_W-1:0] REG0_IN,
input [`DATA_W-1:0] REG1_IN,
input [`DATA_W-1:0] REG2_IN,
input [`DATA_W-1:0] REG3_IN,
input [`DATA_W-1:0] REG4_IN,
input [`DATA_W-1:0] REG5_IN,
input [`DATA_W-1:0] REG6_IN,
input [`DATA_W-1:0] REG7_IN,
input [`DATA_W-1:0] REG8_IN,
input [`DATA_W-1:0] REG9_IN,
input [`DATA_W-1:0] REG10_IN,
input [`DATA_W-1:0] REG11_IN,
input [`DATA_W-1:0] REG12_IN,
input [`DATA_W-1:0] REG13_IN,
input [`DATA_W-1:0] REG14_IN,
input [`DATA_W-1:0] REG15_IN,
output reg [`OPCODE_W-1:0] opcode_out,
output reg [`OPDATA_W-1:0] opdata_out,
output reg [`REG_N-1:0] nREGA_out,
output reg [`REG_N-1:0] nREGB_out,
output reg [`DATA_W-1:0] REGA_out,
output reg [`DATA_W-1:0] REGB_out);

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        opcode_out <= `OPCODE_W'b00000;
        opdata_out <= `OPDATA_W'b00000000;
        nREGB_out  <= `REG_N'b0000;
        nREGA_out  <= `REG_N'b0000;
    end else begin
        opcode_out <= opcode_in;
        opdata_out <= opdata_in;
        nREGB_out  <= nREGB_in;
        if(opcode_in==`ADDI || opcode_in==`LDRH || opcode_in==`LDRL ||
           opcode_in==`LSR  || opcode_in==`LSL  || opcode_in==`ASR)
            nREGA_out  <= {{1'b0},nREGA_in[3:1]};
        else
            nREGA_out  <= nREGA_in;
    end
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        REGA_out   <= `DATA_W'h0000;
    end else begin
        if(opcode_in==`ADDI || opcode_in==`LDRH || opcode_in==`LDRL ||
           opcode_in==`LSR  || opcode_in==`LSL  || opcode_in==`ASR) begin
	        case({{1'b0},nREGA_in[3:1]})
	            `REG_N'b0000: REGA_out <= REG0_IN;
	            `REG_N'b0001: REGA_out <= REG1_IN;
	            `REG_N'b0010: REGA_out <= REG2_IN;
	            `REG_N'b0011: REGA_out <= REG3_IN;
	            `REG_N'b0100: REGA_out <= REG4_IN;
	            `REG_N'b0101: REGA_out <= REG5_IN;
	            `REG_N'b0110: REGA_out <= REG6_IN;
	            `REG_N'b0111: REGA_out <= REG7_IN;
	             default: REGA_out <= 16'h0000;
            endcase
        end else begin   
	        case(nREGA_in)
	            `REG_N'b0000: REGA_out <= REG0_IN;
	            `REG_N'b0001: REGA_out <= REG1_IN;
	            `REG_N'b0010: REGA_out <= REG2_IN;
	            `REG_N'b0011: REGA_out <= REG3_IN;
	            `REG_N'b0100: REGA_out <= REG4_IN;
	            `REG_N'b0101: REGA_out <= REG5_IN;
	            `REG_N'b0110: REGA_out <= REG6_IN;
	            `REG_N'b0111: REGA_out <= REG7_IN;
		        `REG_N'b1000: REGA_out <= REG8_IN;
		        `REG_N'b1001: REGA_out <= REG9_IN;
		        `REG_N'b1010: REGA_out <= REG10_IN;
		        `REG_N'b1011: REGA_out <= REG11_IN;
		        `REG_N'b1100: REGA_out <= REG12_IN;
		        `REG_N'b1101: REGA_out <= REG13_IN;
		        `REG_N'b1110: REGA_out <= REG14_IN;
		        `REG_N'b1111: REGA_out <= REG15_IN;
	             default: REGA_out <= 16'h0000;
            endcase
        end
    end
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        REGB_out   <= `DATA_W'h0000;
    end else begin
        case(nREGB_in)
            `REG_N'b0000: REGB_out <= REG0_IN;
            `REG_N'b0001: REGB_out <= REG1_IN;
            `REG_N'b0010: REGB_out <= REG2_IN;
            `REG_N'b0011: REGB_out <= REG3_IN;
            `REG_N'b0100: REGB_out <= REG4_IN;
            `REG_N'b0101: REGB_out <= REG5_IN;
            `REG_N'b0110: REGB_out <= REG6_IN;
            `REG_N'b0111: REGB_out <= REG7_IN;
	        `REG_N'b1000: REGB_out <= REG8_IN;
	        `REG_N'b1001: REGB_out <= REG9_IN;
	        `REG_N'b1010: REGB_out <= REG10_IN;
	        `REG_N'b1011: REGB_out <= REG11_IN;
	        `REG_N'b1100: REGB_out <= REG12_IN;
	        `REG_N'b1101: REGB_out <= REG13_IN;
	        `REG_N'b1110: REGB_out <= REG14_IN;
	        `REG_N'b1111: REGB_out <= REG15_IN;
             default: REGB_out <= 16'h0000;
        endcase
    end
end

endmodule
