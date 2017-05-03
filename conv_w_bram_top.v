`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2017 10:40:19 PM
// Design Name: 
// Module Name: conv_w_bram_top
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


module conv_w_bram_top(
    input           clk,
    input           conv_w_bram_ena,
    input  [11 : 0] conv_w_bram_addra,
    output [23 : 0] conv_w_bram_douta,
    output   reg    conv_w_bram_rd_vld,
    output   reg    en_d,
    input           conv_w_bram_enb,
    input  [11 : 0] conv_w_bram_addrb,
    output [23 : 0] conv_w_bram_doutb
    );

always @ (posedge clk)
begin
   conv_w_bram_rd_vld <= conv_w_bram_ena;
end
    
CONV_W_BRAM u_conv_w_bram (
      .clka (clk),    // input wire clka
      .ena  (conv_w_bram_ena),      // input wire ena
      .addra(conv_w_bram_addra),  // input wire [11 : 0] addra
      .douta(conv_w_bram_douta),  // output wire [23 : 0] douta
      .clkb (clk),
      .enb  (conv_w_bram_enb),      // input wire ena
      .addrb(conv_w_bram_addrb),  // input wire [11 : 0] addra
      .doutb(conv_w_bram_doutb)
    );  

endmodule
