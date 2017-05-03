`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2017 02:28:31 PM
// Design Name: 
// Module Name: bram_top
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


module bram_top(
input clk,
output a,
output b,
output c,
output d
    );

reg en = 0;
reg we = 0;    
reg [6:0] addra_1;
wire [31:0] douta_1;
reg [11:0] addra_2;
wire [15:0] douta_2;
reg [10:0] addra_3;
wire [479:0] douta_3;
reg [3:0] addra_4;
reg [1343:0] dina_4;
wire [1343:0] douta_4;
assign a=douta_1[0];
assign b=douta_2[0];
assign c=douta_3[0];
assign d=douta_4[0];
    
bias_bram bias_bram_inst (
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .addra(addra),  // input wire [6 : 0] addra
  .douta(douta)  // output wire [31 : 0] douta
);
          
conv_w_bram conv_w_bram_inst (
      .clka(clk),    // input wire clka
      .ena(en),      // input wire ena
      .addra(addra_2),  // input wire [11 : 0] addra
      .douta(douta_2),  // output wire [15 : 0] douta
      .clkb(clk),    // input wire clkb
      .enb(en),      // input wire enb
      .addrb(addra_2),  // input wire [11 : 0] addrb
      .doutb(douta_2)  // output wire [15 : 0] doutb
    );


fc_w_bram fc_w_bram_inst (
  .clka(clk),    // input wire clka
  .ena(en),      // input wire ena
  .addra(addra_3),  // input wire [9 : 0] addra
  .douta(douta_3),  // output wire [959 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(en),      // input wire enb
  .addrb(addra_3),  // input wire [9 : 0] addrb
  .doutb(douta_3)  // output wire [959 : 0] doutb
);

fm_bram fm_bram (
  .clka(clk),    // input wire clka
  .ena(en),      // input wire ena
  .wea(we),      // input wire [0 : 0] wea
  .addra(addra_4),  // input wire [3 : 0] addra
  .dina(dina_4),    // input wire [1343 : 0] dina
  .douta(douta_4),  // output wire [1343 : 0] douta
  .clkb(clk),    // input wire clkb
  .enb(en),      // input wire enb
  .web(we),      // input wire [0 : 0] web
  .addrb(addra_4),  // input wire [3 : 0] addrb
  .dinb(dina_4),    // input wire [1343 : 0] dinb
  .doutb(douta_4)  // output wire [1343 : 0] doutb
);  

endmodule
