`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2017 03:41:52 PM
// Design Name: 
// Module Name: pool_2
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


module pool_2(
input clk,
input rst,
input pool_2_en,
input [`MAX_NUM * 16 - 1 : 0] pool_max_result_1,
input [`MAX_NUM * 16 - 1 : 0] pool_max_result_2,
output reg fm_bram_1_ena,//read
output reg fm_bram_1_enb,
output reg [6 : 0] fm_bram_1_addra,
output reg [6 : 0] fm_bram_1_addrb,
output reg fm_bram_0_wea,
output reg [5 : 0] fm_bram_0_addra,
output reg [1023 : 0] fm_bram_0_dina,
output pool_1_finish
    );

endmodule
