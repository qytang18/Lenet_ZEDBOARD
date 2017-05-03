`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2017 10:52:28 PM
// Design Name: 
// Module Name: fc_w_bram_top
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


module fc_w_bram_top(
input clk,
input fc_w_bram_ena,
input [9 : 0] fc_w_bram_addra,
output [959 : 0] fc_w_bram_douta,
input fc_w_bram_enb,
input [9: 0] fc_w_bram_addrb,
output [959 : 0] fc_w_bram_doutb
    );
    
FC_W_BRAM u_fc_w_bram (
      .clka(clk),    // input wire clka
      .ena(fc_w_bram_ena),      // input wire ena
      .addra(fc_w_bram_addra),  // input wire [9 : 0] addra
      .douta(fc_w_bram_douta),  // output wire [959 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(fc_w_bram_enb),      // input wire enb
      .addrb(fc_w_bram_addrb),  // input wire [9 : 0] addrb
      .doutb(fc_w_bram_doutb)  // output wire [959 : 0] doutb
    );
    
endmodule
