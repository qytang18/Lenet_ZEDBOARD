`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2017 03:46:29 PM
// Design Name: 
// Module Name: conv_2
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


module conv_2(
input clk,
input rst,
input conv_2_en,
output reg bias_bram_en,
output reg [6 : 0] bias_bram_addr,
output reg fm_bram_ena,//read
output reg fm_bram_enb,
output reg [4 : 0] fm_bram_addra,
output reg [4 : 0] fm_bram_addrb,
output reg conv_w_bram_en,
output reg [11 : 0] conv_w_bram_addr,
output conv_2_finish
    );
    
reg [8 : 0] conv_w_cnt;
reg [3 : 0] fm_out;
reg finish;
reg conv_2_en_d;
wire conv_2_en_p;
always @ (posedge clk) begin
    conv_2_en_d <= conv_2_en;
end
assign conv_2_en_p = conv_2_en & ~conv_2_en_d;

always @ (posedge clk)
begin
    if (conv_2_en_p)
        conv_w_cnt <= 1;
    else if (conv_2_en && (~finish)) begin
        if (conv_w_cnt == 300)
            conv_w_cnt <= 1;
        else   
            conv_w_cnt <= conv_w_cnt + 1;
    end
end
 
always @ (posedge clk)
begin
    if (conv_2_en_p)
        fm_out <= 0;
    else if (conv_w_cnt == 300)
        fm_out <= fm_out + 1;
end

always @ (posedge clk)
begin
    if (rst)
        conv_w_bram_en <= 0;
    if (conv_2_en && ~finish)
        conv_w_bram_en <= 1;
end

always @ (posedge clk)
begin
    if (conv_2_en_p)
        conv_w_bram_addr <= 0;
    else if (conv_2_en && ~finish) begin
        if (conv_w_cnt[0])
            conv_w_bram_addr <= conv_w_bram_addr + 1200;
        else 
            conv_w_bram_addr <= conv_w_bram_addr - 1199;
    end        
end  
//fm_bram
always @ (posedge clk)
begin
    if (rst)
        fm_bram_ena <= 0;
    else if (conv_2_en_p)
        fm_bram_ena <= 1;
    else if (conv_w_cnt % 50 == 0 && ~finish)
        fm_bram_ena <= 1;
    else fm_bram_ena <= 0;    
end

always @ (posedge clk)
begin
    if (conv_2_en_p || conv_w_cnt == 300) begin
        fm_bram_addra <= 0;
        fm_bram_addrb <= 1;
    end
    else if (conv_w_cnt % 50 == 10)
        fm_bram_addrb <= fm_bram_addrb + 1;
    else if (conv_w_cnt % 50 == 0) begin
        fm_bram_addra <= fm_bram_addra + 3;
        fm_bram_addrb <= fm_bram_addrb + 2;
    end        
end

always @ (posedge clk)
begin
    if (rst)
        fm_bram_enb <= 0;
    else if (conv_2_en_p)
        fm_bram_enb <= 1;
    else if ((conv_w_cnt % 50 == 0 || conv_w_cnt % 50 == 10) && ~finish)
        fm_bram_enb <= 1;
    else fm_bram_enb <= 0;    
end

always @ (posedge clk)
begin
    if (conv_2_en_p)
        bias_bram_en <= 1;
    else bias_bram_en <= 0;
end

always @ (posedge clk)
begin
    if (conv_2_en_p)
        bias_bram_addra <= 4;
end

endmodule
