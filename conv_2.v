`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2017 03:46:29 PM
// Design Name: 
// Module Name: conv_2
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


module conv_2(
input clk,
input rst,
output reg bias_bram_en,
output reg [6 : 0] bias_bram_addr,
output reg fm_bram_ena,//read
output reg fm_bram_enb,
output reg [4 : 0] fm_bram_addra,
output reg [4 : 0] fm_bram_addrb,
output conv_2_finish
    );
endmodule
