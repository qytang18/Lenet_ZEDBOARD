`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2017 12:14:23 AM
// Design Name: 
// Module Name: conv_1
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
module conv_1(
input clk,
input rst,
input conv_1_en,
input conv_w_bram_rd_vld, //conv_1_en_2
output reg bias_bram_en,
output reg [6 : 0]bias_bram_addr,
output reg fm_bram_ena,
output reg fm_bram_enb,
output reg fm_bram_wea,
output reg fm_bram_web,
output reg [6 : 0] fm_bram_addra,
output reg [6 : 0] fm_bram_addrb,
output reg conv_w_bram_en,
output [11 : 0] conv_w_bram_addr,
output reg [2 : 0] output_layer
//output reg input_buffer_en,
//output reg [`MAC_NUM - 1 : 0]mac_en
    );


reg conv_1_en_d;
wire conv_1_en_p;
assign conv_1_en_p = conv_1_en & ~conv_1_en_d;
always @ (posedge clk)
begin
    conv_1_en_d <= conv_1_en;
end

reg [4 : 0] ker_num; // 0-24 [0] service_bit

reg cnt_1;
reg [12 : 0] conv_w_bram_addr_aux;
assign conv_w_bram_addr = conv_w_bram_addr_aux[12 : 1];
reg [6 : 0] fm_bram_rd_addr;
reg [6 : 0] fm_bram_wr_addr;

//output_layer
always @ (posedge clk)
begin
    if (rst)
        output_layer <= 0;
    else if (conv_1_en_p)
        output_layer <= 0;
end

//bias_bram_en / addr
always @ (posedge clk)
begin
    if (rst)
        bias_bram_en <= 0;
    else if (conv_1_en_p)
    begin
        cnt_1 <= 0;
        bias_bram_en <= 1;
        bias_bram_addr <= output_layer / 2;
    end
    else if ((bias_bram_en == 1) && (cnt_1 < 1))
    begin
        bias_bram_en <= 1;
        cnt_1 <= cnt_1 + 1;
    end
    else 
        bias_bram_en <= 0;
end

//fm_bram_ena/enb
always @ (posedge clk)
begin
    if (rst) 
    begin
        fm_bram_ena <= 0;
        fm_bram_enb <= 0;
    end
    else 
    begin
        fm_bram_ena <= conv_1_en;
        fm_bram_enb <= conv_1_en;
    end
end

//fm_bram_wea
always @ (posedge clk)
begin
    if (rst)
        fm_bram_wea <= 0;
//    else if (ker_num == 25)
//        fm_bram_wea <= 1;
    else fm_bram_wea <= 0;
end

//fm_bram_web
always @ (posedge clk)
begin
    if (rst)
        fm_bram_web <= 0;
//    else if (ker_num == 25)
//        fm_bram_web <= 1;
    else fm_bram_web <= 0;
end

//fm_bram_addra
always @ (posedge clk)
begin
    if (rst)
        fm_bram_addra <= 7'd0;
    else if (conv_1_en_p == 1)
        fm_bram_addra <= 7'd0;
    else if ((ker_num == 5) && (fm_bram_addra < 14))
        fm_bram_addra <= fm_bram_addra + 7'd2;    
end

//fm_bram_addrb
always @ (posedge clk)
begin
    if (rst)
        fm_bram_addrb <= 7'd0;
    else if (conv_1_en_p == 1)
        fm_bram_addrb <= 7'd1;
    else if ((ker_num == 5) & (fm_bram_addrb < 15))
        fm_bram_addrb <= fm_bram_addrb + 7'd2;    
end

//conv_w_bram_en
always @ (posedge clk)
begin
    if (rst) 
        conv_w_bram_en <= 0;
    else  
        conv_w_bram_en <= conv_1_en;
end

//conv_w_bram_addra
always @ (posedge clk)
begin
    if (rst)
        conv_w_bram_addr_aux <= 13'd0;
    else if (conv_1_en_p) 
        conv_w_bram_addr_aux <= 13'd0;    
    else if ((conv_1_en) && ker_num < 24)
        conv_w_bram_addr_aux <= conv_w_bram_addr_aux + 1;
end

//ker_num
//cautious for being zero again
always @ (posedge clk)
begin
    if (rst)
        ker_num <= 0;
    else if (conv_1_en_p == 1)
        ker_num <= 0;
    else if (ker_num == 25)
        ker_num <= 0;
    else if (conv_1_en && (ker_num < 25) && conv_w_bram_addr_aux[0])
        ker_num <= ker_num + 1;
end

endmodule
