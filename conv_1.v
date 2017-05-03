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
    input [112*17-1 : 0] wr_data,
    output reg bias_bram_en,
    output reg [6 : 0]bias_bram_addr,
    output reg fm_bram_ena,//read
    output reg fm_bram_enb,
    output reg [4 : 0] fm_bram_addra,
    output reg [4 : 0] fm_bram_addrb,
    output reg fm_bram_1_wea,
    output reg fm_bram_1_web,
    output reg [6:0] fm_bram_1_addra,
    output reg [6:0] fm_bram_1_addrb,
    output reg [56 * 16-1 : 0] fm_bram_1_dina,
    output reg [56 * 16-1 : 0] fm_bram_1_dinb,
    output reg conv_w_bram_en,
    output reg [11 : 0] conv_w_bram_addr,
//    output reg [2 : 0] output_layer,
    output conv_1_finish,
    output reg store_en
    //output reg input_buffer_en,
    //output reg [`MAC_NUM - 1 : 0]mac_en
    );

    
reg finish;
reg [5 : 0] finish_d;
reg [5 : 0] conv_w_cnt;
reg [2 : 0] output_layer;
reg conv_1_en_d;
reg [4 : 0] store_en_pre;
reg [1 : 0] store_en_d;
wire conv_1_en_p;
reg [4 : 0] fm_row;
reg [4 : 0] once_finish;

assign conv_1_finish = finish_d[5];

always @ (posedge clk)
begin
    conv_1_en_d <= conv_1_en;
end
assign conv_1_en_p = conv_1_en & ~conv_1_en_d;

always @ (posedge clk)
begin
    if (rst)
        finish <= 0;
    else if (fm_row == 28 && output_layer[2:1] == 2)
        finish <= 1;
end

always @ (posedge clk)
begin
    if (rst) 
        finish_d <= 0;
    else 
        finish_d <= {finish_d[4:0],finish};
end


always @ (posedge clk)
begin
    if (rst)
        conv_w_cnt <= 0;
    else if (conv_1_en && (finish == 0))
    begin
        if (conv_w_cnt < 50)
            conv_w_cnt <= conv_w_cnt + 1;
        else if (conv_w_cnt ==50)
            conv_w_cnt <= 1;    
    end   
    else 
       conv_w_cnt <= 0;
end

always @ (posedge clk)
begin
    if (rst)
        fm_row <= 0;
    else if (fm_row == 28)
        fm_row <= 0;
    else if (conv_w_cnt == 50) begin
        if (fm_row < 28)
            fm_row <= fm_row + 4;
        else 
            fm_row <= 0;
    end
end

always @ (posedge clk)
begin
    if (rst)
        output_layer <= 0;
    else if (conv_1_en)
    begin
        if (conv_1_en_p)
            output_layer <= 0;
        else if (fm_row == 28)
        begin
            output_layer[2:1] <= output_layer[2:1] + 1;
            output_layer[0] <= 0;
        end
        else 
            output_layer[0] <= ~output_layer[0];
    end    
end

always @ (posedge clk)
begin
    store_en_pre[0] <= (conv_w_cnt == 50);
    store_en_pre[4:1] <= store_en_pre[3:0];
end

always @ (posedge clk)
begin
    store_en <= store_en_pre[3] || store_en_pre[2];
end

always @ (posedge clk)
begin
    store_en_d <= {store_en_d[0],store_en};
end

//conv_w_bram_en 
always @ (posedge clk)
begin
    if (rst)
        conv_w_bram_en <= 0;
    else if (conv_1_en && ~finish)
        conv_w_bram_en <= 1;
    else
        conv_w_bram_en <= 0;
end

always @ (posedge clk)
begin
    if (conv_1_en_p)
        conv_w_bram_addr <= 0;
    else if (conv_1_en && ~finish) begin
        if (conv_w_cnt[0])
            conv_w_bram_addr <= conv_w_bram_addr + 75;
        else conv_w_bram_addr <= conv_w_bram_addr - 74;
    end
end

//fm_bram read
always @ (posedge clk)
begin
    if (rst)
    begin
        fm_bram_ena <= 0;
        fm_bram_enb <= 0;
    end
    else if (conv_1_en_p || (conv_w_cnt == 50))
    begin
        fm_bram_ena <= 1;
        fm_bram_enb <= 1;
    end    
    else if ( (conv_w_cnt == 10) || (conv_w_cnt == 30) )
        fm_bram_enb <= 1;
    else begin
        fm_bram_ena <= 0;
        fm_bram_enb <= 0;
    end
end

always @ (posedge clk)
begin
    if (conv_1_en_p)
    begin
        fm_bram_addra <= 0;
        fm_bram_addrb <= 1;
    end
    else if (conv_w_cnt == 50) begin
        fm_bram_addra <= fm_bram_addra + 2;
    end
    else if (conv_w_cnt == 10 || conv_w_cnt == 30)
        fm_bram_addrb <= fm_bram_addrb + 1;   
end

//bias bram
always @ (posedge clk)
begin
    if (conv_1_en && conv_1_en_d == 0) begin
        bias_bram_en <= 1;
    end
    else if (conv_1_en && store_en_pre[0] ) begin
        bias_bram_en <= 1;
    end         
    else begin
        bias_bram_en <= 0;
    end
end

always @ (posedge clk) begin
    if (conv_1_en_p)
        bias_bram_addr <= 0;
    else if (store_en_pre[1] && ~finish)
        case (output_layer[2:1])
            2'b00: bias_bram_addr <= 0;
            2'b01: bias_bram_addr <= 1;
            2'b10: bias_bram_addr <= 2;
        endcase
end


//fm_bram_1_wea
always @ (posedge clk) begin
    if (rst)
        fm_bram_1_wea <= 0;        
    else 
        fm_bram_1_wea <= store_en_d[0];
end
//fm_bram_1_addra
always @ (posedge clk) begin
    if (conv_1_en_p)
        fm_bram_1_addra <= 0;
    else if (store_en && store_en_d[0])
        fm_bram_1_addra <= fm_bram_1_addra + 42;
    else if (~store_en && store_en_d[0])
        fm_bram_1_addra <= fm_bram_1_addra - 41;
end
integer i;
//fm_bram_1_dina
always @ (posedge clk) begin
    if (store_en_d[0])
    for (i = 0; i < 56 ;i = i + 1)
        fm_bram_1_dina[i*16 +: 16]  <= wr_data[17*56+i*17+1 +: 16] + wr_data[17*56+i*17] ;      
end

//fm_bram_1_web
always @ (posedge clk) begin
    if (rst)
        fm_bram_1_web <= 0;        
    else 
        fm_bram_1_web <= store_en_d[0];
end
//fm_bram_1_addrb
always @ (posedge clk) begin
    if (conv_1_en_p)
        fm_bram_1_addrb <= 1;
    else if (store_en && store_en_d[0])
        fm_bram_1_addrb <= fm_bram_1_addrb + 42;
    else if (~store_en && store_en_d[0])
        fm_bram_1_addrb <= fm_bram_1_addrb - 41;
end
//fm_bram_1_dinb
always @ (posedge clk) begin
    if (store_en_d[0])
    for (i = 0;i<56;i=i+1)
       fm_bram_1_dinb[i*16 +: 16] <= wr_data[i*17+1 +: 16] + wr_data[i*17];
end


endmodule
