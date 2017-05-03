`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2017 04:07:15 PM
// Design Name: 
// Module Name: mult_add_top
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


module mult_add_test(
    clk, en, rst, A, B, C, P
    );
    
    input clk;
    input en;
    input rst;
    input [15 : 0] A;
    input [15 : 0] B;
    input [27 : 0] C;
    output [32 : 0] P;
    
mult_add mult_add_inst (
      .CLK(clk),    // input wire CLK
      .CE(en),      // input wire CE
      .SCLR(rst),  // input wire SCLR
      .A(A),        // input wire [15 : 0] A
      .B(B),        // input wire [15 : 0] B
      .C(C),        // input wire [15 : 0] C
      .P(P)        // output wire [31 : 0] P
    );  
    
endmodule
