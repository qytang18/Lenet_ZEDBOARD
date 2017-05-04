`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2017 10:40:00 AM
// Design Name: 
// Module Name: pool_2
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


module pool_2(
input clk,
input rst,
input pool_2_en,
input [10 * 16 - 1 : 0] pool_max_result_1,
input [15 * 16 - 1 : 0] pool_max_result_2,
output reg fm_bram_1_ena,//read
output reg fm_bram_1_enb,
output reg [6 : 0] fm_bram_1_addra,
output reg [6 : 0] fm_bram_1_addrb,
output reg fm_bram_wea,
//output reg fm_bram_web,
output reg [4 : 0] fm_bram_addra,
//output reg [4 : 0] fm_bram_addrb,
output reg [70 * 16 - 1 : 0] fm_bram_dina,
//output reg [70 * 16 - 1 : 0] fm_bram_dinb,
output reg pool_2_finish
    );

reg finish;
reg pool_2_en_d;
reg  [3 : 0] result_vld;
wire pool_2_en_p;

always @ (posedge clk)
    pool_2_finish <= (fm_bram_addra == 15);

always @ (posedge clk)
    pool_2_en_d <= pool_2_en;
assign pool_2_en_p = pool_2_en & ~pool_2_en_d;

always @ (posedge clk)
begin
    if (rst)
        finish <= 0;
    else if (fm_bram_1_addrb == 31)
        finish <= 1;
end

always @ (posedge clk)
begin
    if (rst)
        result_vld <= 0;
    else 
        result_vld <= {result_vld[2:0],fm_bram_1_ena};
end

always @ (posedge clk)
begin
    if (rst) begin
        fm_bram_1_ena <= 0;
        fm_bram_1_enb <= 0;
    end    
    else if (pool_2_en && ~finish) begin
        fm_bram_1_ena <= 1;
        fm_bram_1_enb <= 1;
    end    
    else begin
        fm_bram_1_ena <= 0;
        fm_bram_1_enb <= 0;
    end
end

always @ (posedge clk)
begin
    if (pool_2_en_p) begin
        fm_bram_1_addra <= 0;
        fm_bram_1_addrb <= 1;
    end
    else if (pool_2_en && ~finish) begin
        fm_bram_1_addra <= fm_bram_1_addra + 2;
        fm_bram_1_addrb <= fm_bram_1_addrb + 2;
    end
end

always @ (posedge clk)
begin
    if (result_vld[3]) begin
        fm_bram_wea <= 1;
    end
    else fm_bram_wea <= 0;
end

always @ (posedge clk)
begin
    if (pool_2_en_p)
        fm_bram_addra <= 0;
    else if (fm_bram_wea)
        fm_bram_addra <= fm_bram_addra + 1;
end

always @ (posedge clk)
begin
    if (result_vld[3])
        fm_bram_dina <= {720'h0,pool_max_result_1, pool_max_result_2};
end

endmodule
