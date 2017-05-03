`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2017 05:39:03 PM
// Design Name: 
// Module Name: fm_bram_1_top
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


module fm_bram_1_top(
    input clk,
    input fm_bram_1_ena,
    input fm_bram_1_enb,    
    input fm_bram_1_wea,
    input fm_bram_1_web,
    input [6 : 0] fm_bram_1_addra,
    input [1023 : 0] fm_bram_1_dina,
    input [6 : 0] fm_bram_1_addrb,
    input [1023 : 0] fm_bram_1_dinb,
    output [1023 : 0] fm_bram_1_douta,
    output [1023 : 0] fm_bram_1_doutb,
    output reg fm_bram_1_rda_vld,
    output reg fm_bram_1_rdb_vld
    );

reg ena_d;
reg enb_d;
always @ (posedge clk)
begin
   fm_bram_1_rda_vld <= fm_bram_1_ena;
   fm_bram_1_rdb_vld <= fm_bram_1_enb;
end

FM_BRAM_1 fm_bram_1 (
      .clka(clk),    // input wire clka
      .ena(fm_bram_1_ena),      // input wire ena
      .wea(fm_bram_1_wea),      // input wire [0 : 0] wea
      .addra(fm_bram_1_addra),  // input wire [6 : 0] addra
      .dina(fm_bram_1_dina),    // input wire [1023 : 0] dina
      .douta(fm_bram_1_douta),  // output wire [1023 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(fm_bram_1_enb),      // input wire enb
      .web(fm_bram_1_web),      // input wire [0 : 0] web
      .addrb(fm_bram_1_addrb),  // input wire [6 : 0] addrb
      .dinb(fm_bram_1_dinb),    // input wire [1023 : 0] dinb
      .doutb(fm_bram_1_doutb)  // output wire [1023 : 0] doutb
    );

endmodule
