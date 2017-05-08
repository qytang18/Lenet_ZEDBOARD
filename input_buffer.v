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

reg [140 * 16 - 1 : 0] in_r; 
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
        if (en)
        begin
            case (cur_state)            
            `SCONV_1:begin  
                if (ker_cnt == 10) begin                 
                    if (ker_row[0])
                         in_r[128*16-1:0] <= {in_r[32*3*16-1:0],in_2[32*16 +: 32*16]};
                    else in_r[128*16-1:0] <= {in_1[1023:0],in_2[1023:0]};
                end
            end
            `SCONV_2:begin
                if (ker_cnt == 10) begin
                    if (ker_row == 0)
                        in_r <= {in_1,in_2};
                    else begin
                        in_r[140*16-1 : 14*16] <= in_r [126*16-1:0];
                        if (ker_row == 1)
                            in_r[0+:14*16] <= in_2 [42*16+:14*16];
                        else if (ker_row == 2) 
                            in_r[0+:14*16] <= in_2 [28*16+:14*16];
                        else if (ker_row == 3) 
                            in_r[0+:14*16] <= in_2 [14*16+:14*16];
                        else if (ker_row == 4) 
                            in_r[0+:14*16] <= in_2 [0+:14*16];                                                               
                    end   
                end             
            end
            `SFC_1: in_r[120*16-1:0] <= {in_1[60*16-1:0],in_2[60*16-1:0]};
            `SFC_2: in_r[84*16-1:0] <= {in_1[42*16-1:0],in_2[42*16-1:0]};               
            `SFC_3: in_r[84*16-1:0] <= {in_1[42*16-1:0],in_2[42*16-1:0]};   
            endcase
        end
        else in_r <= in_r;
end

always @ (*)//(posedge clk)
begin
    case (cur_state)
    `SCONV_1: 
    begin
        case (ker_col)
            4'd0: //ki,0
                input_buf[112*16-1 : 0] = {in_r[100*16 +: 28*16], in_r[68*16 +: 28*16], in_r[36*16 +: 28*16], in_r[4*16 +: 28*16]};
            4'd1: //ki,1
                input_buf[112*16-1 : 0] = {in_r[99*16 +: 28*16], in_r[67*16 +: 28*16], in_r[35*16 +: 28*16], in_r[3*16 +: 28*16]}; 
            4'd2: //ki,2
                input_buf[112*16-1 : 0] = {in_r[98*16 +: 28*16], in_r[66*16 +: 28*16], in_r[34*16 +: 28*16], in_r[2*16 +: 28*16]};
            4'd3: //ki,3
                input_buf[112*16-1 : 0] = {in_r[97*16 +: 28*16], in_r[65*16 +: 28*16], in_r[33*16 +: 28*16], in_r[1*16 +: 28*16]}; 
            4'd4: //ki,4
                input_buf[112*16-1 : 0] = {in_r[96*16 +: 28*16], in_r[64*16 +: 28*16], in_r[32*16 +: 28*16], in_r[0*16 +: 28*16]};     
        endcase
     end
     `SCONV_2:
     begin
        case (ker_col)
         4'd0: //ki,0
             input_buf[100*16-1 : 0] = {in_r[130*16 +: 10*16], in_r[116*16 +: 10*16], in_r[102*16 +: 10*16], in_r[88*16 +: 10*16], in_r[74*16 +: 10*16], in_r[60*16 +: 10*16], in_r[46*16 +: 10*16], in_r[32*16 +: 10*16], in_r[18*16 +: 10*16], in_r[4*16 +: 10*16]};
         4'd1: //ki,1
             input_buf[100*16-1 : 0] = {in_r[129*16 +: 10*16], in_r[115*16 +: 10*16], in_r[101*16 +: 10*16], in_r[87*16 +: 10*16], in_r[73*16 +: 10*16], in_r[59*16 +: 10*16], in_r[45*16 +: 10*16], in_r[31*16 +: 10*16], in_r[17*16 +: 10*16], in_r[3*16 +: 10*16]}; 
         4'd2: //ki,2
             input_buf[100*16-1 : 0] = {in_r[128*16 +: 10*16], in_r[114*16 +: 10*16], in_r[100*16 +: 10*16], in_r[86*16 +: 10*16], in_r[72*16 +: 10*16], in_r[58*16 +: 10*16], in_r[44*16 +: 10*16], in_r[30*16 +: 10*16], in_r[16*16 +: 10*16], in_r[2*16 +: 10*16]};
         4'd3: //ki,3
            input_buf[100*16-1 : 0] = {in_r[127*16 +: 10*16], in_r[113*16 +: 10*16], in_r[99*16 +: 10*16], in_r[85*16 +: 10*16], in_r[71*16 +: 10*16], in_r[57*16 +: 10*16], in_r[43*16 +: 10*16], in_r[29*16 +: 10*16], in_r[15*16 +: 10*16], in_r[1*16 +: 10*16]};
         4'd4: //ki,4
            input_buf[100*16-1 : 0] = {in_r[126*16 +: 10*16], in_r[112*16 +: 10*16], in_r[98*16 +: 10*16], in_r[84*16 +: 10*16], in_r[70*16 +: 10*16], in_r[56*16 +: 10*16], in_r[42*16 +: 10*16], in_r[28*16 +: 10*16], in_r[14*16 +: 10*16], in_r[0*16 +: 10*16]};
        endcase
     end
     default:input_buf = in_r[120*16-1:0];
     endcase
end
endmodule
