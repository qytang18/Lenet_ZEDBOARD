`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2017 11:32:05 PM
// Design Name: 
// Module Name: MAC
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

//MAC_NUM=120
`include "def_header.vh"
module MAC(
input clk,
input rst,
input [`MAC_NUM - 1 : 0] mac_en, 
input [`MAC_NUM * 16 - 1 : 0] img,
input [20 * 16 - 1 : 0] ker,
input [`MAC_NUM * 28 - 1 : 0] partial_output, 
//input [3 : 0] CS,
//input mac_sel,
output [`MAC_NUM * 33 - 1 : 0] result, 
output reg result_vld,
output partial_output_prepare
    );

integer j;
genvar i;
reg [1 : 0] mac_en_d [0:119];

always @ (posedge clk)
begin
    if (rst)
    for (j=0;j<120;j=j+1)
        mac_en_d[j] <= 0;
    else
    for (j=0;j<120;j=j+1)
        mac_en_d[j] <= {mac_en_d[j][0],mac_en[j]};
end 

//always @ (posedge clk)
//begin
//    if (CS == `SCONV_1 || CS == `SCONV_2)
//        sel <= 0;
//    else if (CS == `SFC_1 || CS == `SFC_2 || CS == `SFC_3)
//        sel <= mac_sel;
//    else 
//        sel <= mac_sel;
//end

assign partial_output_prepare = mac_en_d[0][1];
always @ (posedge clk)
begin
    result_vld <= mac_en_d[0][1];
end

generate for (i = 0; i < `MAC_NUM; i=i+1) begin :mult_add
    mult_add u_mult_add (
      .CLK(clk),    // input wire CLK
      .CE(mac_en[i]||mac_en_d[i][1]),      // input wire CE
      .SCLR(rst),  // input wire SCLR
      .A(img[i * 16 +: 16]),        // input wire [15 : 0] A
      .B(ker[(i/8) *16 +: 16]),        // input wire [15 : 0] B
      .C({partial_output[i*28 +: 28]}),        // input wire [27 : 0] C
      .P(result[i*33 +: 33])        // output wire [32 : 0] P
    );
end
endgenerate 

endmodule
