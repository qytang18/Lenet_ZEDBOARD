`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2017 09:30:45 PM
// Design Name: 
// Module Name: fm_bram_top
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


module fm_bram_top(
    input clk,
    input fm_bram_ena,
    input fm_bram_enb,    
    input fm_bram_wea,
    input fm_bram_web,
    input [4 : 0] fm_bram_addra,
    input [1023 : 0] fm_bram_dina,
    input [4 : 0] fm_bram_addrb,
    input [1023 : 0] fm_bram_dinb,
    output [1023 : 0] fm_bram_douta,
    output [1023 : 0] fm_bram_doutb,
    output reg fm_bram_rda_vld,
    output reg fm_bram_rdb_vld
    );
    
always @ (posedge clk)
begin
   fm_bram_rda_vld <= fm_bram_ena;
   fm_bram_rdb_vld <= fm_bram_enb;
end
    
FM_BRAM u_fm_bram (
      .clka (clk),    // input wire clka
      .ena  (fm_bram_ena),      // input wire ena
      .wea  (fm_bram_wea),      // input wire [0 : 0] wea
      .addra(fm_bram_addra),  // input wire [6 : 0] addra
      .dina (fm_bram_dina),    // input wire [1023 : 0] dina
      .douta(fm_bram_douta),  // output wire [1023 : 0] douta
      .clkb (clk),    // input wire clkb
      .enb  (fm_bram_enb),      // input wire enb
      .web  (fm_bram_web),      // input wire [0 : 0] web
      .addrb(fm_bram_addrb),  // input wire [6 : 0] addrb
      .dinb (fm_bram_dinb),    // input wire [1023 : 0] dinb
      .doutb(fm_bram_doutb)  // output wire [1023 : 0] doutb
);


endmodule
