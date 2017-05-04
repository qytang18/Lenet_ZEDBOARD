`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2017 07:41:23 PM
// Design Name: 
// Module Name: pool_1
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
module pool_1(
input clk,
input rst,
input pool_1_en,
input [14 * 16 - 1 : 0] pool_max_result_1,
input [14 * 16 - 1 : 0] pool_max_result_2,
output reg fm_bram_1_ena,//read
output reg fm_bram_1_enb,
output reg [6 : 0] fm_bram_1_addra,
output reg [6 : 0] fm_bram_1_addrb,
output reg fm_bram_wea,
output reg fm_bram_web,
output reg [4 : 0] fm_bram_addra,
output reg [4 : 0] fm_bram_addrb,
output reg [70 * 16 - 1 : 0] fm_bram_dina,
output reg [70 * 16 - 1 : 0] fm_bram_dinb,
output pool_1_finish
    );
    
reg pool_1_en_d;
wire pool_1_en_p;
reg  [3 : 0] result_vld;
reg [2:0] buf_cnt;
reg [56 * 16 - 1 : 0] wdata_buf_a;
reg [56 * 16 - 1 : 0] wdata_buf_b;
reg finish;
reg [3 : 0] finish_d;
always @ (posedge clk)
begin
    if (rst)
        finish_d <= 0;
    else finish_d <= {finish_d[2:0],finish};
end
assign pool_1_finish = finish_d[3];

always @ (posedge clk)
    pool_1_en_d <= pool_1_en;
assign pool_1_en_p = pool_1_en & ~pool_1_en_d;

always @ (posedge clk)
begin
    if (rst)
        finish <= 0;
    else if (fm_bram_1_addrb == 83)
        finish <= 1;
end

always @ (posedge clk)
begin
    if (rst)
        result_vld <= 0;
    else 
        result_vld <= {result_vld[2:0],fm_bram_1_ena};
end

//fm_bram_1_ena/enb
always @ (posedge clk)
begin
    if (rst)
    begin
        fm_bram_1_ena <= 0;
        fm_bram_1_enb <= 0;
    end
    else if (pool_1_en && (finish == 0))
    begin
        fm_bram_1_ena <= 1;
        fm_bram_1_enb <= 1;
    end
    else
    begin
        fm_bram_1_ena <= 0;
        fm_bram_1_enb <= 0;
    end   
end

//fm_bram_1_addra
always @ (posedge clk)
begin
    if (pool_1_en_p) 
        fm_bram_1_addra <= 0;
    else if (pool_1_en && (finish == 0))
        fm_bram_1_addra <= fm_bram_1_addra + 1;       
end

//fm_bram_1_addrb
always @ (posedge clk)
begin
    if (pool_1_en_p) 
        fm_bram_1_addrb <= 42;
    else if (pool_1_en && (finish == 0))
        fm_bram_1_addrb <= fm_bram_1_addrb + 1;       
end

//buf_cnt
always @ (posedge clk)
begin
    if (rst) 
        buf_cnt <= 0;
    else if (result_vld[3])
    begin
       if (buf_cnt == 4) begin
            if (fm_bram_addra % 3 == 1)
                buf_cnt <= 1;
            else
                buf_cnt <= 0;     
       end
       else     
            buf_cnt <= buf_cnt + 1;
    end
end


always @ (posedge clk)
begin
    if (result_vld[3]) begin
        case (buf_cnt)
            3'd0: begin
                wdata_buf_a[42*16 +: 14*16] <= pool_max_result_1;
                wdata_buf_b[42*16 +: 14*16] <= pool_max_result_2;
            end
            3'd1: begin
                wdata_buf_a[28*16 +: 14*16] <= pool_max_result_1;
                wdata_buf_b[28*16 +: 14*16] <= pool_max_result_2;
            end
            3'd2: begin
                wdata_buf_a[14*16 +: 14*16] <= pool_max_result_1;
                wdata_buf_b[14*16 +: 14*16] <= pool_max_result_2;
            end
            3'd3:begin
                wdata_buf_a[0 +: 14*16] <= pool_max_result_1;
                wdata_buf_b[0 +: 14*16] <= pool_max_result_2;                
            end
        endcase
    end
    end

//fm_bram write wea/web
always @ (posedge clk)
begin
    if (pool_1_en_p) begin
        fm_bram_wea <= 0;
        fm_bram_web <= 0;
    end
    else if (buf_cnt == 4) begin
        fm_bram_wea <= 1;
        fm_bram_web <= 1;    
    end
    else begin
        fm_bram_wea <= 0;
        fm_bram_web <= 0;
    end     
end
//fm_bram write addra, addrb
always @ (posedge clk)
begin
    if (pool_1_en_p) begin
        fm_bram_addra <= 0;
        fm_bram_addrb <= 9;
    end
    else 
    begin
        if (fm_bram_wea)
            fm_bram_addra <= fm_bram_addra + 1; 
        if (fm_bram_web)
            fm_bram_addrb <= fm_bram_addrb + 1;   
    end  
end

always @ (posedge clk)
begin
    if (buf_cnt == 4) begin
        fm_bram_dina <= {wdata_buf_a, pool_max_result_1};
        fm_bram_dinb <= {wdata_buf_b, pool_max_result_2};
    end
end


endmodule