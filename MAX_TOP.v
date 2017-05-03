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
input [3 : 0]CS,
output [`MAX_NUM *16 - 1 : 0] pool_result
    );

reg [`MAX_NUM * 2 * 16 - 1 : 0]fm_in_1;
reg [`MAX_NUM * 2 * 16 - 1 : 0]fm_in_2;

always @ (*)
begin
    if (rst)
    begin
        fm_in_1 = 0;
        fm_in_2 = 0;
    end    
    else 
    begin
        case (CS) 
        `SPOOL_1: begin
            fm_in_1 = {32'h0,fm_in [0 +: 14 * 2 * 16]};
            fm_in_2 = {32'h0,fm_in [14 * 2 * 16 +: 14 * 2 * 16]};
        end
        endcase
    end
end
       
genvar i;
generate for (i = 0;i < `MAX_NUM;i = i + 1) 
begin: max_2x2_module
    MAX_2x2 u_max_2x2 (
    .clk    (clk),
    .rst    (rst),
    .max_en (max_en[i]),
    .A      (fm_in_1[i*32 +: 32]),
    .B      (fm_in_2[i*32 +: 32]),
    .max_out(pool_result[i*16 +: 16])
    );
end
endgenerate



endmodule
