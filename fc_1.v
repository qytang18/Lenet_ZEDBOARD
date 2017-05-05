`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2017 04:16:47 PM
// Design Name: 
// Module Name: fc_1
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

`define L_IDLE 0
`define BIAS_INIT 1
`define FC 2
module fc_1(
input clk,
input rst,
input fc_1_en,
input bias_bram_rd_vld,
output reg bias_bram_ena,
output reg [6:0] bias_bram_addra,
output reg bias_bram_enb,
output reg [6:0] bias_bram_addrb,
output reg fc1_w_bram_ena,
output reg fc1_w_bram_enb,
output reg [9:0] fc1_w_bram_addra,
output reg [9:0] fc1_w_bram_addrb,
output reg fm_bram_ena,
output reg [4:0] fm_bram_addra,
output reg [4:0] init_times,
output fc_1_finish
    );

reg [1:0] state;
reg fc_1_en_d;
wire fc_1_en_p;
reg finish;

always @ (posedge clk)
    fc_1_en_d <= fc_1_en;
assign fc_1_en_p = fc_1_en & ~fc_1_en_d;

always @ (posedge clk)    
begin
    if (~fc_1_en)
        state <= `L_IDLE;
    else begin
        case (state) 
            `L_IDLE:    state <= `BIAS_INIT;
            `BIAS_INIT: begin
               if (init_times == 29)     
                state <= `FC;
            end
            `FC: begin
                if (finish)
                    state <= `L_IDLE;
            end    
        endcase
    end
end    

always @ (posedge clk)
begin
    if (state == `BIAS_INIT) begin
        bias_bram_ena <= 1;
        bias_bram_enb <= 1;
    end
    else begin
        bias_bram_ena <= 0;
        bias_bram_enb <= 0;
    end    
end

always @ (posedge clk)
begin
    if (fc_1_en_p) begin
        bias_bram_addra <= 11;
        bias_bram_addrb <= 12;
    end
    else if (bias_bram_enb)begin
        bias_bram_ena <= bias_bram_ena + 2;
        bias_bram_enb <= bias_bram_enb + 2;
    end    
end

always @ (posedge clk) begin
    if (bias_bram_addra == 13)
        init_times <= 0;
    else if (bias_bram_rd_vld)
        init_times <= init_times + 1;
end        
endmodule
