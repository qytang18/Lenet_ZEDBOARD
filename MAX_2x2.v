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
input [2 * 16 - 1 : 0] A,
input [2 * 16 - 1 : 0] B,
output reg [15 : 0] max_out
    );
    
reg [2 * 16  - 1 : 0] max_2;
reg max_en_d;  
integer i;

always @ (posedge clk)
begin
    max_en_d <= max_en;
end    

always @ (posedge clk)
begin
    if (rst)
        max_2 <= 0;
    else 
    begin
        for (i = 0; i < 2; i = i + 1)begin
            if (max_en) 
            begin
                if ((A[i*16+15] == 1) && (B[i*16+15] == 0))
                    max_2[i*16 +: 16] <= B[i*16 +: 16];
                else if ((A[i*16+15] == 0) && (B[i*16+15] == 1))
                    max_2[i*16 +: 16] <= A[i*16 +: 16];
                else if (A[i*16 +: 15] < B[i*16 +: 15])
                    max_2[i*16 +: 16] <= B[i*16 +: 16];
                else max_2[i*16 +: 16] <= A[i*16 +: 16];
            end
        end
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
            if ((max_2[15] == 1) && (max_2[31] == 0))
                max_out[0 +: 16] <= max_2[16 +: 16];
            else if ((max_2[15] == 0) && (max_2[31] == 1))
                max_out[0 +: 16] <= max_2[0 +: 16];
            else if (max_2[0 +: 15] < max_2[16 +: 15])//A,B have the same sign.
                max_out[0 +: 16] <= max_2[16 +: 16];
            else max_out[0 +: 16] <= max_2[0 +: 16];                
            end
    end
end
endmodule
