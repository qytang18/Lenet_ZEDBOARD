`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2017 06:38:00 PM
// Design Name: 
// Module Name: relu_1
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


module relu_1(
input clk,
input rst,
input relu_1_en,
input [10*16-1:0] pool_max_result,
output max_en,
output reg fm_bram_1_ena, 
output reg [6:0] fm_bram_1_addra,
output reg fm_bram_wea,
output reg [4:0] fm_bram_addra,
output reg [70*16-1:0] fm_bram_dina,
output reg relu_1_finish
    );
    
reg [4:0] result_vld;
reg finish;
reg relu_1_en_d;
wire relu_1_en_p;
assign relu_1_en_p = relu_1_en & ~relu_1_en_d;

assign max_en = result_vld[1];


always @ (posedge clk)
begin
    relu_1_en_d <= relu_1_en;
end

always @ (posedge clk)
begin
    if (rst) 
        finish <= 0;
    if (fm_bram_1_addra == 10)
        finish <= 1;
end

always @ (posedge clk)
begin
    if (rst)
        relu_1_finish <= 0;
    else if (fm_bram_addra == 11)
        relu_1_finish <= 1;
end

always @ (posedge clk)
begin
    if (rst)
        result_vld <= 0;
    else 
        result_vld <= {result_vld[3:0],fm_bram_1_ena};
end

always @ (posedge clk)
begin
    if (relu_1_en && ~finish)
        fm_bram_1_ena <= 1;
    else 
        fm_bram_1_ena <= 0;
end

always @ (posedge clk)
begin
    if (relu_1_en_p)
        fm_bram_1_addra <= 0;
    else if (fm_bram_1_ena)
        fm_bram_1_addra <= fm_bram_1_addra + 1;
end
    
always @ (posedge clk)
begin
    if (result_vld[4])
        fm_bram_wea <= 1;
    else fm_bram_wea <= 0;
end

always @ (posedge clk)
begin
    if (relu_1_en_p)
        fm_bram_addra <= 0;
    else if (fm_bram_wea)
        fm_bram_addra <= fm_bram_addra + 1;
end

always @ (posedge clk)
begin
    fm_bram_dina[70*16-1:10*16] <= 0;
    if (result_vld[4])
        fm_bram_dina[10*16-1:0] <= pool_max_result; 
end


endmodule
