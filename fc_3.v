`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2017 08:26:43 PM
// Design Name: 
// Module Name: fc_3
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
module fc_3(
input clk,
input rst,
input fc_3_en,
input bias_bram_rd_vld,
input [10*16-1:0] fm_bram_douta,
input fm_bram_rda_vld,
input [10*17-1:0] store_data,
output [15:0] fm_node,
output reg sum_en,
output reg bias_bram_ena,
output reg [6:0] bias_bram_addra,
output reg bias_bram_enb,
output reg [6:0] bias_bram_addrb,
output reg fc3_w_bram_ena,
output reg [8:0] fc3_w_bram_addra,
output reg fm_bram_ena,
output reg [4:0] fm_bram_addra,
output reg [10*16-1:0] result_10x16,
output reg [4:0] init_times,
output reg fc_3_finish
    );
    
reg [1:0] state;
reg fc_3_en_d;
wire fc_3_en_p;
reg fc_finish;
reg [4:0] fc_finish_d;
reg fc_start_d;
reg [4 : 0] cnt;
reg [25*16-1:0] fm_vector;
reg [3 : 0] sum_times;
reg sum_en_d;

assign fm_node = fm_vector [9*16 +: 16];

always @ (posedge clk)
begin
    fc_start_d <= (state == `FC);
end

always @ (posedge clk)
    fc_3_en_d <= fc_3_en;
assign fc_3_en_p = fc_3_en & ~fc_3_en_d;

always @ (posedge clk)
begin
    if (fc_3_en_p)
        fc_finish <= 0;
    else if (fc3_w_bram_addra == 327)
        fc_finish <= 1;
end

always @ (posedge clk)
begin
    fc_finish_d <= {fc_finish_d[3:0],fc_finish};
end

always @ (posedge clk) begin
    sum_en_d <= sum_en;
end

always @ (posedge clk)
begin
    if (fc_3_en_p)
        cnt <= 0;
    else if (state == `FC && ~fc_finish) begin
        if (cnt == 10)
            cnt <= 1;
        else 
            cnt <= cnt + 1;        
    end        
end

always @ (posedge clk)    
begin
    if (~fc_3_en)
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
                if (sum_times == 1) 
                    state <= `L_IDLE;
            end
        endcase
    end
end    

always @ (posedge clk)
begin
    if (fc_3_en_p) 
        fc_3_finish <= 0;
    else if (sum_times == 1)
        fc_3_finish <= 1;
end

always @ (posedge clk)
begin
    if (state == `BIAS_INIT && bias_bram_addrb < 118) begin
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
    if (fc_3_en_p) begin
        bias_bram_addra <= 113;
        bias_bram_addrb <= 114;
    end
    else if (bias_bram_enb)begin
        bias_bram_addra <= bias_bram_addra + 2;
        bias_bram_addrb <= bias_bram_addrb + 2;
    end    
end

always @ (posedge clk) begin
    if (bias_bram_addra == 113)
        init_times <= 2;
    else if (bias_bram_ena)
        init_times <= init_times - 1;
end      

always @ (posedge clk) 
begin
    if (state == `FC && ~fc_finish) 
    begin
        if (cnt == 0)
            fm_bram_ena <= 1;
        else if (cnt == 9)
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
        fc3_w_bram_ena <= 1;
    end
    else begin
        fc3_w_bram_ena <= 0;        
    end    
end

always @ (posedge clk)
begin
    if (fc_3_en_p) 
    begin
        fc3_w_bram_addra <= 241;
    end
    else if (fc3_w_bram_ena)
    begin
        fc3_w_bram_addra <= fc3_w_bram_addra + 1;
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
    if (fc_finish_d[4] && sum_times < 1)
        sum_en <= 1;
    else sum_en <= 0;    
end

always @ (posedge clk)
begin
    if (fc_finish && ~fc_finish_d[0])
        sum_times<=0;
    else if (fc_finish_d[4] && sum_times < 2)
        sum_times <= sum_times + 1;
end


integer i;
always @ (posedge clk)
begin
    if (sum_en_d) begin  
        for (i= 0;i<10;i=i+1)
            result_10x16[i*16 +: 16] <= store_data[i*17+1 +: 16] + store_data[i*17];
    end
end

endmodule



