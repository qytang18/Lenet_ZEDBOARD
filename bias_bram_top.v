`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2017 10:29:04 PM
// Design Name: 
// Module Name: bias_bram_top
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


module bias_bram_top(
input clk,
input bias_bram_en,
input [6 : 0] bias_bram_addr,
output [31 : 0] bias_bram_dout,
output reg bias_bram_rd_vld
    );

always @ (posedge clk)
begin
   bias_bram_rd_vld <= bias_bram_en;
end
    
BIAS_BRAM u_bias_bram (
      .clka(clk),    // input wire clka
      .ena(bias_bram_en),      // input wire ena
      .addra(bias_bram_addr),  // input wire [6 : 0] addra
      .douta(bias_bram_dout)  // output wire [31 : 0] douta
    );
endmodule
