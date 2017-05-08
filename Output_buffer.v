`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2017 10:18:45 PM
// Design Name: 
// Module Name: Output_buffer
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
module output_buffer(
input clk,
input rst,
input [3 : 0] CS,
input output_buffer_initial,
input en,
input result_33_vld,
input [`MAC_NUM * 33-1 : 0] result_33,
input [4 * 28 - 1 : 0] bias_0,
input store_en,
input [4:0] init_times,
input sum_en,
output [`MAC_NUM * 28-1 : 0] result_out_28,
output [`MAC_NUM * 17-1 : 0] store_data_17_o
    );

reg [`MAC_NUM * 17-1 : 0] store_data_17;
reg [`MAC_NUM * 28 - 1 : 0] out_buf [0 : 1];
wire [10*17-1:0] sum_17;
reg buf_num;
reg sum_vld;
assign result_out_28 = out_buf[buf_num];
reg output_buffer_initial_d;
integer j;
assign store_data_17_o[10*17-1:0] = (sum_vld)? sum_17 : store_data_17[10*17-1:0];
assign store_data_17_o[`MAC_NUM * 17-1 : 10*17] = store_data_17[`MAC_NUM * 17-1 : 10*17];

always @ (posedge clk)
begin
    sum_vld <= sum_en;
end

always @ (posedge clk)
begin
    output_buffer_initial_d <= output_buffer_initial;
end

always @ (posedge clk)
begin
    if (store_en) 
    begin
        for (j = 0; j < `MAC_NUM; j = j + 1)
        begin
        if (result_33_vld)
        begin
            store_data_17[j*17 +: 13] <= result_33[j*33+11 +: 13];
            if  (result_33[j*33+32] == 0)
            begin
                if (result_33[j*33+24 +: 8] > 7)
                    store_data_17[j*17+13 +: 4] <= 4'b0111;
                else 
                    store_data_17[j*17+13 +: 4] <= {1'b0, result_33[j*33+24 +: 3]};
            end
            else
            begin
                if (result_33[j*33+24 +: 8] < 248)
                    store_data_17[j*17+13 +: 4] <= 4'b1000;
                else 
                    store_data_17[j*17+13 +: 4] <= {1'b1, result_33[j*33+24 +: 3]};
            end
        end
        end        
    end
end



always @ (posedge clk)
begin
    if (rst | ~en) begin
        buf_num <= 0;
    end
    else if (en)
        buf_num <= ~buf_num ;
end


always @ (posedge clk)
begin
    if (output_buffer_initial) begin    
        case (CS)
        `SCONV_1: begin
            out_buf[0][0 +: 112*28] <= {112{bias_0[28 +: 28]}};
        end
        `SCONV_2: begin  
            out_buf[0][0 +: 100*28] <= {112{bias_0[28 +: 28]}};                           
        end
        `SFC_1: begin
            out_buf[0][init_times*4*28 +: 4*28] <= bias_0;
        end
        `SFC_2: begin
            out_buf[0][init_times*4*28 +: 4*28] <= bias_0;
        end
        `SFC_3: begin
            out_buf[0][init_times*4*28 +: 4*28] <= bias_0;
        end
        endcase 
    end
    else if (sum_en)
        out_buf[0] <= out_buf[0] >> 280;                                  
    else if (buf_num == 1) //cast the result to 28 bit
    begin
        for (j = 0; j < `MAC_NUM; j = j + 1)
        begin
            if (result_33_vld)
            begin
                out_buf[0][j*28 +: 24] <= result_33[j*33 +: 24];
                if  (result_33[j*33+32] == 0)
                begin
                    if (result_33[j*33+24 +: 8] > 7)
                        out_buf[0][j*28+24 +: 4] <= 4'b0111;
                    else 
                        out_buf[0][j*28+24 +: 4] <= {1'b0, result_33[j*33+24 +: 3]};
                end
                else
                begin
                    if (result_33[j*33+24 +: 8] < 248)
                        out_buf[0][j*28+24 +: 4] <= 4'b1000;
                    else 
                        out_buf[0][j*28+24 +: 4] <= {1'b1, result_33[j*33+24 +: 3]};
                end
            end
        end        
    end
end
    

always @ (posedge clk)
begin
    if (output_buffer_initial_d)
    case (CS)
        `SCONV_1: begin
            out_buf[1][0 +: 112*28] <= {112{bias_0[0 +: 28]}};
        end
        `SCONV_2: begin
            out_buf[1][0 +: 100*28] <= {112{bias_0[0 +: 28]}};                      
        end
        default: begin
            out_buf[1] <= 0;
        end
    endcase    
    else if (sum_en)
        out_buf[1] <= out_buf[1] >> 280;
    else if (buf_num == 0)//cast the result to 28 bit
    begin
        for (j = 0; j < `MAC_NUM; j = j + 1)
        begin
            if (result_33_vld)
            begin
                out_buf[1][j*28 +: 24] <= result_33[j*33 +: 24];
                if  (result_33[j*33+32] == 0)
                begin
                    if (result_33[j*33+24 +: 8] > 7)
                        out_buf[1][j*28+24 +: 4] <= 4'b0111;
                    else 
                        out_buf[1][j*28+24 +: 4] <= {1'b0, result_33[j*33+24 +: 3]};
                end
                else
                begin
                    if (result_33[j*33+24 +: 8] < 248)
                        out_buf[1][j*28+24 +: 4] <= 4'b1000;
                    else 
                        out_buf[1][j*28+24 +: 4] <= {1'b1, result_33[j*33+24 +: 3]};
                end
            end
        end        
    end
end



genvar k;
generate for (k = 0; k < 10; k=k+1) begin :add_up
    ADD_UP u_add_up (
      .CLK(clk),          // input wire CLK
      .CE(sum_en),            // input wire CE
      .SCLR(rst),        // input wire SCLR
      .CARRYIN(out_buf[0][28*k+11]||out_buf[1][28*k+11]),  // input wire CARRYIN
      .A(out_buf[0][28*k+12 +: 16]),              // input wire [15 : 0] A
      .C(out_buf[1][28*k+12 +: 16]),              // input wire [15 : 0] C
      .P(sum_17[k*17 +: 17])              // output wire [16 : 0] P
    );
end
endgenerate 

endmodule
