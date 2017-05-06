`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2017 02:48:25 PM
// Design Name: 
// Module Name: MAX_30
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

module MAX_2x2(
input clk,
input rst,
input max_en,
input [15 : 0] A,
input [15 : 0] B,
input [15 : 0] C,
input [15 : 0] D,
output reg [15 : 0] max_out
    );
    
reg [15 : 0] max_1;
reg [15 : 0] max_2;
reg max_en_d;  

always @ (posedge clk)
begin
    max_en_d <= max_en;
end    

always @ (posedge clk)
begin
   if (max_en) 
   begin
      if (((A[15] == 1) && (B[15] == 0)) || ((A[15 == B[15]]) && (A[0 +: 15] < B[0 +: 15])))
           max_1 <= B;
      else max_1 <= A;
   end
end

always @ (posedge clk)
begin
   if (max_en) 
   begin
      if (((C[15] == 1) && (D[15] == 0)) || ((C[15 == D[15]]) && (C[0 +: 15] < D[0 +: 15])))
           max_2 <= D;
      else max_2 <= B;
   end
end

always @ (posedge clk)
begin
    if (rst)
        max_out <= 0;
    else 
    begin
        if (max_en_d) 
        begin
            if (((max_1[15] == 1) && (max_2[15] == 0)) || ((max_1[15 == max_2[15]]) && (max_1[0 +: 15] < max_2[0 +: 15])))
                max_out <= max_2;
            else max_out <= max_1;                
        end
    end
end
endmodule
