`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2017 09:38:35 PM
// Design Name: 
// Module Name: input_buffer
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
`include "def_header.vh"

module input_buffer(
input clk,
input rst,
input en,
input [3 : 0] cur_state,
input [3 : 0] ker_row,
input [3 : 0] ker_col,
input [70 * 16 - 1 : 0] in_1,
input [70 * 16 - 1 : 0] in_2,
output reg [`MAC_NUM * 16 -1 : 0] input_buf
    );

reg [128 * 16 - 1 : 0] in_r; 
reg [3 : 0] ker_cnt;

always @ (posedge clk)
begin
    if (rst)
        ker_cnt <= 10;    
    else if (en && ker_cnt < 10)
        ker_cnt <= ker_cnt + 1; 
    else if (en && ker_cnt == 10)
        ker_cnt <= 1;
end


always @ (posedge clk)
begin
    if (rst)
        in_r <= 0;
    else 
        if (ker_cnt == 10 && en)
        begin
            case (cur_state)            
            3'b001:begin    
                if (ker_row[0])
                     in_r <= {in_r[32*3*16-1:0],in_2[32*16 +: 32*16]};
                else in_r <= {in_1[1023:0],in_2[1023:0]};
            end
            endcase
        end
        else in_r <= in_r;
end

always @ (*)//(posedge clk)
begin
    if (rst)
    begin
        input_buf = 0;
    end
    else 
    //begin
       // if (en_d)
        begin
            case (cur_state)
            3'b001: 
            begin
                case (ker_col)
                    6'd0: //ki,0
                        input_buf[112*16-1 : 0] = {in_r[100*16 +: 28*16], in_r[68*16 +: 28*16], in_r[36*16 +: 28*16], in_r[4*16 +: 28*16]};
                    6'd1: //ki,1
                        input_buf[112*16-1 : 0] = {in_r[99*16 +: 28*16], in_r[67*16 +: 28*16], in_r[35*16 +: 28*16], in_r[3*16 +: 28*16]}; 
                    6'd2: //ki,2
                        input_buf[112*16-1 : 0] = {in_r[98*16 +: 28*16], in_r[66*16 +: 28*16], in_r[34*16 +: 28*16], in_r[2*16 +: 28*16]};
                    6'd3: //ki,3
                        input_buf[112*16-1 : 0] = {in_r[97*16 +: 28*16], in_r[65*16 +: 28*16], in_r[33*16 +: 28*16], in_r[1*16 +: 28*16]}; 
                    6'd4: //ki,4
                        input_buf[112*16-1 : 0] = {in_r[96*16 +: 28*16], in_r[64*16 +: 28*16], in_r[32*16 +: 28*16], in_r[0*16 +: 28*16]};     
                endcase
             end
             endcase
        end
   // end
end
endmodule
