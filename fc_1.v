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
`define SUM_UP 3
module fc_1(
input clk,
input rst,
input fc_1_en,
input bias_bram_rd_vld,
input [25*16-1:0] fm_bram_douta,
input fm_bram_rda_vld,
input [10*17-1:0] store_data,
output [15:0] fm_node,
output reg sum_en,
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
output reg  fm_bram_1_wea,
output reg [6:0] fm_bram_1_addra,
output reg [56*16-1:0] fm_bram_1_dina,
output reg [4:0] init_times,
output reg fc_1_finish
    );

reg [1:0] state;
reg fc_1_en_d;
wire fc_1_en_p;
reg fc_finish;
reg [4:0] fc_finish_d;
reg fc_start_d;
reg [4 : 0] cnt;
reg [25*16-1:0] fm_vector;
reg [3 : 0] sum_times;
reg sum_en_d;

assign fm_node = fm_vector [24*16 +: 16];

always @ (posedge clk)
begin
    fc_start_d <= (state == `FC);
end

always @ (posedge clk)
    fc_1_en_d <= fc_1_en;
assign fc_1_en_p = fc_1_en & ~fc_1_en_d;

always @ (posedge clk)
begin
    if (fc_1_en_p)
        fc_finish <= 0;
    else if (fc1_w_bram_addrb == 797)
        fc_finish <= 1;
end

always @ (posedge clk)
begin
    fc_finish_d <= {fc_finish_d[3:0],fc_finish};
end

always @ (posedge clk)
    sum_en_d <= sum_en;

always @ (posedge clk)
begin
    if (fc_1_en_p)
        cnt <= 0;
    else if (state == `FC && ~fc_finish) begin
        if (cnt == 25)
            cnt <= 1;
        else 
            cnt <= cnt + 1;
        
    end        
end

always @ (posedge clk)    
begin
    if (~fc_1_en)
        state <= `L_IDLE;
    else begin
        case (state) 
            `L_IDLE:    state <= `BIAS_INIT;
            `BIAS_INIT: begin
               if (init_times == 0)     
                state <= `FC;
            end
            `FC: begin
                if (fc_finish)
                    state <= `SUM_UP;
            end    
            `SUM_UP: begin
                if (fm_bram_1_addra == 0) 
                    state <= `L_IDLE;
            end
        endcase
    end
end    

always @ (posedge clk)
begin
    if (fc_1_en_p) 
        fc_1_finish <= 0;
    else if (fm_bram_1_addra == 0)
        fc_1_finish <= 1;
end

always @ (posedge clk)
begin
    if (state == `BIAS_INIT && bias_bram_addrb < 70) begin
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
        bias_bram_addra <= bias_bram_addra + 2;
        bias_bram_addrb <= bias_bram_addrb + 2;
    end    
end

always @ (posedge clk) begin
    if (bias_bram_addra == 11)
        init_times <= 29;
    else if (bias_bram_ena)
        init_times <= init_times - 1;
end      

always @ (posedge clk) 
begin
    if (state == `FC && ~fc_finish) 
    begin
        if (cnt == 0)
            fm_bram_ena <= 1;
        else if (cnt == 24)
            fm_bram_ena <= 1;
        else fm_bram_ena <= 0;
    end
    else fm_bram_ena <= 0;         
end

always @ (posedge clk)
begin
    if (state == `FC && cnt == 0)
        fm_bram_addra <= 0;
    else if (fm_bram_ena)
        fm_bram_addra <= fm_bram_addra + 1;
end

always @ (posedge clk)
begin
    if (fc_start_d && ~fc_finish) 
    begin
        fc1_w_bram_ena <= 1;
        fc1_w_bram_enb <= 1;
    end
    else begin
        fc1_w_bram_ena <= 0;
        fc1_w_bram_enb <= 0;        
    end    
end

always @ (posedge clk)
begin
    if (fc_1_en_p) 
    begin
        fc1_w_bram_addra <= 0;
        fc1_w_bram_addrb <= 1;
    end
    else if (fc1_w_bram_ena)
    begin
        fc1_w_bram_addra <= fc1_w_bram_addra + 2;
        fc1_w_bram_addrb <= fc1_w_bram_addrb + 2;
    end
end
  
always @ (posedge clk)
begin
    if (state == `FC && ~fc_finish) begin
        if (fm_bram_rda_vld)
            fm_vector <= fm_bram_douta;
        else 
            fm_vector <= fm_vector << 16;
    end
end  
  
always @ (posedge clk)
begin
    if (fc_finish_d[4] && sum_times < 12)
        sum_en <= 1;
    else sum_en <= 0;    
end

always @ (posedge clk)
begin
    if (fc_finish && ~fc_finish_d[0])
        sum_times<=0;
    else if (fc_finish_d[4] && sum_times < 13)
        sum_times <= sum_times + 1;
end

always @ (posedge clk)
begin
    fm_bram_1_wea <= sum_en_d;
end

always @ (posedge clk)
begin
    if (fc_finish_d[3] && ~fc_finish_d[4])
        fm_bram_1_addra <= 12;
    else if (sum_en_d)
        fm_bram_1_addra<= fm_bram_1_addra - 1;
end

integer i;
always @ (posedge clk)
begin
    if (sum_en_d) begin
        fm_bram_1_dina[56*16-1 : 10*16] <= 0;    
        for (i= 0;i<10;i=i+1)
            fm_bram_1_dina[i*16 +: 16] <= store_data[i*17+1 +: 16] + store_data[i*17];
    end
end

endmodule
