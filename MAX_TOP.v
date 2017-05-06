`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2017 06:52:05 PM
// Design Name: 
// Module Name: MAX_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "def_header.vh"
module MAX_TOP(
input clk,
input rst,
input [`MAX_NUM * 4 * 16 - 1 : 0] fm_in,
input [`MAX_NUM - 1 : 0] max_en,
input [3 : 0] CS,
output [`MAX_NUM *16 - 1 : 0] pool_result
    );

reg [`MAX_NUM * 2 * 16 - 1 : 0]fm_in_1;
reg [`MAX_NUM * 2 * 16 - 1 : 0]fm_in_2;

integer j;
always @ (posedge clk)
begin
    case (CS) 
    `SPOOL_1: begin
        fm_in_1 <= {32'h0,fm_in [0 +: 28 * 16]};//line 0
        fm_in_2 <= {32'h0,fm_in [28 * 16 +: 28 * 16]}; //line 1
    end
    `SPOOL_2: begin
        fm_in_1 <= {fm_in[800+:160],fm_in[480+:160],fm_in[160+:160]};
        fm_in_2 <= {fm_in[640+:160],fm_in[320+:160],fm_in[0+:160]};
    end
    default: begin
        for (j = 0;j < 15;j=j+1) begin
            fm_in_1[j*32 +: 16] <= fm_in[j*16 +: 16];
            fm_in_1[j*32+16 +: 16] <= 0;
        end
        fm_in_2 <= 0;
    end
    endcase
end
       
genvar i;
generate for (i = 0;i < `MAX_NUM;i = i + 1) 
    begin: max_2x2_module
        MAX_2x2 u_max_2x2 (
        .clk    (clk),
        .rst    (rst),
        .max_en (max_en[i]),
        .A      (fm_in_1[i*32 +: 16]),
        .B      (fm_in_1[i*32+16 +: 16]),
        .C      (fm_in_2[i*32 +: 16]),
        .D      (fm_in_2[i*32+16 +: 16]),
        .max_out(pool_result[i*16 +: 16])
        );
    end
endgenerate



endmodule
