`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2017 10:26:52 PM
// Design Name: 
// Module Name: lenet_top
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
module lenet_top(
input clk,
input rst,
input START,
//input pool_1_start,
input fc_3_start,
output conv_1_sig,
output pool_1_sig,
output fc_1_sig,
output [10*16-1:0] result_10x16
    );

reg conv_1_en;   
reg pool_1_en;
reg conv_2_en;
reg pool_2_en;
reg fc_1_en;
reg relu_1_en;
reg fc_2_en;
reg relu_2_en;
reg fc_3_en;
reg [3 : 0] CS; //current_state

//conv_1
wire            conv_1_fm_bram_ena;
wire            conv_1_fm_bram_enb;
wire   [4 : 0]  conv_1_fm_bram_addra;
wire   [4 : 0]  conv_1_fm_bram_addrb;
wire            conv_1_conv_w_bram_en;
wire   [11 : 0] conv_1_conv_w_bram_addr; 
wire            conv_1_bias_initial;
wire   [6 : 0]  conv_1_bias_bram_addr;
wire            conv_1_bias_bram_en;
wire            conv_1_fm_bram_wea;
wire   [6 : 0]  conv_1_fm_bram_waddr_a;
wire   [56 * 16 - 1 : 0] conv_1_fm_bram_wdata_a;
wire            conv_1_fm_bram_web;
wire   [6 : 0]  conv_1_fm_bram_waddr_b;
wire   [56 * 16 - 1 : 0] conv_1_fm_bram_wdata_b;
wire conv_1_finish;
wire conv_1_store_en;

//pool_1
wire            pool_1_fm_bram_1_ena;//read
wire            pool_1_fm_bram_1_enb;    
wire   [6 : 0]  pool_1_fm_bram_1_addra;
wire   [6 : 0]  pool_1_fm_bram_1_addrb;
wire            pool_1_fm_bram_wea;
wire            pool_1_fm_bram_web;
wire   [4 : 0]  pool_1_fm_bram_addra;
wire   [4 : 0]  pool_1_fm_bram_addrb;
wire   [70 * 16 - 1 : 0] pool_1_fm_bram_dina;
wire   [70 * 16 - 1 : 0] pool_1_fm_bram_dinb;
wire            pool_1_max_en;
wire pool_1_finish;

//conv_2
wire        conv_2_bias_bram_en;
wire [6:0]  conv_2_bias_bram_addr;
wire        conv_2_fm_bram_ena;
wire        conv_2_fm_bram_enb;
wire [4:0]  conv_2_fm_bram_addra;
wire [4:0]  conv_2_fm_bram_addrb;
wire        conv_2_conv_w_bram_en;
wire [11:0] conv_2_conv_w_bram_addr;
wire        conv_2_finish;
wire        conv_2_fm_bram_1_wea;
wire        conv_2_fm_bram_1_web;
wire [6:0]  conv_2_fm_bram_1_addra;
wire [6:0]  conv_2_fm_bram_1_addrb;
wire [895:0] conv_2_fm_bram_1_dina;
wire [895:0] conv_2_fm_bram_1_dinb;

//pool 2
wire            pool_2_fm_bram_1_ena;//read
wire            pool_2_fm_bram_1_enb;
wire [6 : 0]    pool_2_fm_bram_1_addra;
wire [6 : 0]    pool_2_fm_bram_1_addrb;
wire            pool_2_fm_bram_wea;
wire [4 : 0]    pool_2_fm_bram_addra;
wire [70 * 16 - 1 : 0] pool_2_fm_bram_dina;
wire            pool_2_finish;
wire            pool_2_max_en;

//fc 1
wire            fc_1_bias_bram_ena;
wire            fc_1_bias_bram_enb;
wire [6:0]      fc_1_bias_bram_addra;
wire [6:0]      fc_1_bias_bram_addrb;
wire            fc_1_fm_bram_ena;
wire [4:0]      fc_1_fm_bram_addra;
wire            fc_1_fm_bram_1_wea;
wire [6:0]      fc_1_fm_bram_1_addra;
wire [895:0]    fc_1_fm_bram_1_dina;
wire [4:0]      fc_1_init_bias;
wire [4:0]      fc_1_init_times;
wire [15:0]     fc_1_fm_node;
wire            fc_1_sum_en;
wire            fc_1_finish;

//relu 1
wire            relu_1_fm_bram_1_ena;
wire [6:0]      relu_1_fm_bram_1_addra;
wire            relu_1_fm_bram_wea;
wire [4:0]      relu_1_fm_bram_addra;
wire [70*16-1:0] relu_1_fm_bram_dina;
wire            relu_1_finish;
wire            relu_1_max_en;

//fc_2
wire            fc_2_bias_bram_ena;
wire            fc_2_bias_bram_enb;
wire [6:0]      fc_2_bias_bram_addra;
wire [6:0]      fc_2_bias_bram_addrb;
wire            fc_2_fm_bram_ena;
wire [4:0]      fc_2_fm_bram_addra;
wire            fc_2_fm_bram_1_wea;
wire [6:0]      fc_2_fm_bram_1_addra;
wire [895:0]    fc_2_fm_bram_1_dina;
wire [4:0]      fc_2_init_bias;
wire [4:0]      fc_2_init_times;
wire [15:0]     fc_2_fm_node;
wire            fc_2_sum_en;
wire            fc_2_finish;

//relu 2
wire            relu_2_fm_bram_1_ena;
wire [6:0]      relu_2_fm_bram_1_addra;
wire            relu_2_fm_bram_wea;
wire [4:0]      relu_2_fm_bram_addra;
wire [70*16-1:0] relu_2_fm_bram_dina;
wire            relu_2_finish;
wire            relu_2_max_en;

//fc3
wire            fc_3_bias_bram_ena;
wire            fc_3_bias_bram_enb;
wire [6:0]      fc_3_bias_bram_addra;
wire [6:0]      fc_3_bias_bram_addrb;
wire            fc_3_fm_bram_ena;
wire [4:0]      fc_3_fm_bram_addra;
wire [4:0]      fc_3_init_bias;
wire [4:0]      fc_3_init_times;
wire [15:0]     fc_3_fm_node;
wire            fc_3_sum_en;
wire            fc_3_finish;

//conv_w_bram control signals
reg             conv_w_bram_ena;
reg    [11 : 0] conv_w_bram_addra;
wire   [23 : 0] conv_w_bram_douta;
reg             conv_w_bram_enb;
reg    [11 : 0] conv_w_bram_addrb;
wire   [23 : 0] conv_w_bram_doutb;
reg             conv_w_bram_rd_vld;

//fm_bram control signals
reg             fm_bram_ena;
reg             fm_bram_enb;
reg             fm_bram_wea;
reg             fm_bram_web;
reg    [4 : 0]  fm_bram_addra; 
reg [1119 : 0]  fm_bram_dina;
reg    [4 : 0]  fm_bram_addrb;
reg [1119 : 0]  fm_bram_dinb;
wire [1119 : 0] fm_bram_douta;
wire [1119 : 0] fm_bram_doutb;
reg             fm_bram_rda_vld;
reg             fm_bram_rdb_vld;

//fm_bram_1 control signals
reg             fm_bram_1_ena;
reg             fm_bram_1_enb;
reg             fm_bram_1_wea;
reg             fm_bram_1_web;
reg    [6 : 0]  fm_bram_1_addra; 
reg [895 : 0]  fm_bram_1_dina;
reg    [6 : 0]  fm_bram_1_addrb;
reg [895 : 0]  fm_bram_1_dinb;
wire [895 : 0] fm_bram_1_douta;
wire [895 : 0] fm_bram_1_doutb;
reg            fm_bram_1_rda_vld;
reg            fm_bram_1_rdb_vld;

//bias_bram control signals
reg             bias_bram_ena;
reg    [6 : 0]  bias_bram_addra;
wire  [31 : 0]  bias_bram_douta;
reg             bias_bram_enb;
reg    [6 : 0]  bias_bram_addrb;
wire  [31 : 0]  bias_bram_doutb;
reg             bias_bram_rd_vld;

//fc1_w bram
wire            fc1_w_bram_ena;
wire [9:0]      fc1_w_bram_addra;
wire [959:0]    fc1_w_bram_douta;
wire            fc1_w_bram_enb;
wire [9:0]      fc1_w_bram_addrb;
wire [959:0]    fc1_w_bram_doutb; 
reg             fc1_w_bram_rd_vld;

//fc2_w bram
reg            fc23_w_bram_ena;
reg [8:0]      fc23_w_bram_addra;
wire [671:0]    fc23_w_bram_douta;
reg            fc23_w_bram_enb;
reg [8:0]      fc23_w_bram_addrb;
wire [671:0]    fc23_w_bram_doutb; 
reg             fc23_w_bram_rd_vld;

wire            fc2_w_bram_ena;
wire [8:0]      fc2_w_bram_addra;
wire            fc2_w_bram_enb;
wire [8:0]      fc2_w_bram_addrb;

wire            fc3_w_bram_ena;
wire [8:0]      fc3_w_bram_addra;

//for input buffer module
reg input_buffer_en;
reg [70*16-1:0] input_buf_in_1;
reg [70*16-1:0] input_buf_in_2;
wire [`MAC_NUM * 16 - 1 : 0] fm_in;

//for mac module
reg [`MAC_NUM - 1 : 0] mac_en;
reg [15 : 0] ker;
reg [20 * 16 - 1 : 0] ker_in; 
wire [`MAC_NUM * 33 - 1 : 0] mac_result;
wire  mac_result_vld;
wire output_en;

//for output buffer module
reg                        output_buffer_initial;
reg  [4 * 28 - 1 : 0]      bias_0;
reg                        store_en;
reg  [4 : 0]               bias_init_times;
wire [`MAC_NUM * 28-1 : 0] output_buffer_result;
wire [`MAC_NUM * 17-1 : 0] store_data;
reg                        sum_en;

// for max module
reg  [14 * 4 * 16 - 1 : 0]     max_fm_in_1;        
reg  [14- 1 : 0]              max_en_1;    
wire [14 * 16 - 1 : 0]         pool_max_result_1;

reg  [`MAX_NUM * 4 * 16 - 1 : 0]     max_fm_in_2;        
reg  [`MAX_NUM - 1 : 0]              max_en_2;    
wire [`MAX_NUM * 16 - 1 : 0]         pool_max_result_2;

//assign fm_bram_dinb_out = fm_bram_dinb;  
assign conv_1_sig = & mac_result;
assign pool_1_sig = (& pool_max_result_1) && (&pool_max_result_2);
assign fc_1_sig = & store_data;

always @ (posedge clk)
begin
   bias_bram_rd_vld <= bias_bram_ena;
end

always @ (posedge clk)
begin
   fm_bram_1_rda_vld <= fm_bram_1_ena;
   fm_bram_1_rdb_vld <= fm_bram_1_enb;
end

always @ (posedge clk)
begin
   fm_bram_rda_vld <= fm_bram_ena;
   fm_bram_rdb_vld <= fm_bram_enb;
end

always @ (posedge clk)
begin
   conv_w_bram_rd_vld <= conv_w_bram_ena;
end

always @ (posedge clk)
begin
   fc1_w_bram_rd_vld <= fc1_w_bram_ena;
end

always @ (posedge clk)
begin
   fc23_w_bram_rd_vld <= fc23_w_bram_ena;
end

/*************OVERALL FSM********************/
always @ (posedge clk)
begin
    if (rst)
    begin
        CS <= `IDLE;
        conv_1_en <= 0;
        pool_1_en <= 0;
        conv_2_en <= 0;
        pool_2_en <= 0;
        fc_1_en <= 0;
        relu_1_en <= 0;
        fc_2_en <= 0;
        relu_2_en <= 0;
        fc_3_en <= 0;
    end    
    else 
    begin
        case (CS)
            `IDLE: begin
                if (START)
                begin
                    CS <= `SCONV_1;
                    conv_1_en <= 1;
                end
               else if (fc_3_start)
                begin
                    CS <= `SFC_3;
                    fc_3_en <= 1;                    
                end
               // else CS <= CS;
            end
            `SCONV_1: begin
                if (conv_1_finish == 1)
                begin
                    CS <= `SPOOL_1;
                    conv_1_en <= 0;
                    pool_1_en <= 1;
                end
          //      else CS <= CS;
            end
            `SPOOL_1:begin
                if (pool_1_finish == 1)
                begin
                    CS <= `SCONV_2;
                    conv_2_en <= 1;
                    pool_1_en <= 0;
                end
            end
            `SCONV_2:begin
                if (conv_2_finish)
                begin
                    CS <= `SPOOL_2;
                    conv_2_en <= 0;
                    pool_2_en <= 1;
                end
            end
            `SPOOL_2: begin
                if (pool_2_finish)
                begin
                    CS <= `SFC_1;
                    pool_2_en <= 0;
                    fc_1_en <= 1;
                end
            end
            `SFC_1: begin
                if (fc_1_finish)
                begin
                    CS <= `SRELU_1;
                    fc_1_en <= 0;
                    relu_1_en <= 1;
                end
            end
            `SRELU_1: begin
                if (relu_1_finish)
                begin
                    CS <= `SFC_2;
                    fc_2_en <= 1;
                    relu_1_en <= 0;
                end
            end
            `SFC_2: begin
                if (fc_2_finish)
                begin
                    CS <= `SRELU_2;
                    fc_2_en <= 0;
                    relu_2_en <= 1;                    
                end
            end
            `SRELU_2: begin
                if (relu_2_finish)
                begin
                    CS <= `SFC_3;
                    fc_3_en <= 1;
                    relu_2_en <= 0;
                end
            end
            `SFC_3: begin
                if (fc_3_finish)
                begin
                    CS <= `IDLE;
                    fc_3_en <= 0;                   
                end
            end
            default: 
            begin
                CS <= CS;
                conv_1_en <= 0;
                pool_1_en <= 0;
                conv_2_en <= 0;
                pool_2_en <= 0;
                fc_1_en <= 0;
                relu_1_en <= 0;
                fc_2_en <= 0;
                relu_2_en <= 0;
                fc_3_en <= 0;
            end
        endcase
    end
end

//fm_bram_we/we/addra/addrb
always @ (*)begin
    if (rst)
    begin
       fm_bram_ena = 0;
       fm_bram_enb = 0;
       fm_bram_wea = 0;
       fm_bram_web = 0;
    end
    else 
    begin
        case (CS)
        `SCONV_1: begin
            fm_bram_ena = conv_1_fm_bram_ena;
            fm_bram_enb = conv_1_fm_bram_enb;
            fm_bram_wea = 0;
            fm_bram_web = 0;
            fm_bram_addra = conv_1_fm_bram_addra;
            fm_bram_addrb = conv_1_fm_bram_addrb;        
        end
        `SPOOL_1: begin
            fm_bram_ena = pool_1_fm_bram_wea;
            fm_bram_enb = pool_1_fm_bram_web;
            fm_bram_wea = pool_1_fm_bram_wea;
            fm_bram_web = pool_1_fm_bram_wea;
            fm_bram_addra = pool_1_fm_bram_addra;
            fm_bram_addrb = pool_1_fm_bram_addrb;  
			fm_bram_dina = pool_1_fm_bram_dina;
			fm_bram_dinb = pool_1_fm_bram_dinb;
	   end
	    `SCONV_2: begin
	        fm_bram_ena = conv_2_fm_bram_ena;
            fm_bram_enb = conv_2_fm_bram_enb;
            fm_bram_wea = 0;
            fm_bram_web = 0;
            fm_bram_addra = conv_2_fm_bram_addra;
            fm_bram_addrb = conv_2_fm_bram_addrb;   
        end
        `SPOOL_2: begin
            fm_bram_ena = pool_2_fm_bram_wea;
            fm_bram_enb = 0;
            fm_bram_wea = pool_2_fm_bram_wea;
            fm_bram_addra = pool_2_fm_bram_addra;  
            fm_bram_dina = pool_2_fm_bram_dina;
       end
       `SFC_1: begin
           fm_bram_ena = fc_1_fm_bram_ena;
           fm_bram_enb = 0;
           fm_bram_wea = 0;
           fm_bram_addra = fc_1_fm_bram_addra;  
      end
      `SRELU_1: begin
           fm_bram_ena = relu_1_fm_bram_wea;
           fm_bram_wea = relu_1_fm_bram_wea;
           fm_bram_enb = 0;
           fm_bram_addra = relu_1_fm_bram_addra;
           fm_bram_dina = relu_1_fm_bram_dina;
      end
     `SFC_2: begin
          fm_bram_ena = fc_2_fm_bram_ena;
          fm_bram_enb = 0;
          fm_bram_wea = 0;
          fm_bram_addra = fc_2_fm_bram_addra;  
      end
     `SRELU_2: begin
           fm_bram_ena = relu_2_fm_bram_wea;
           fm_bram_wea = relu_2_fm_bram_wea;
           fm_bram_enb = 0;
           fm_bram_addra = relu_2_fm_bram_addra;
           fm_bram_dina = relu_2_fm_bram_dina;
       end
      `SFC_3: begin
            fm_bram_ena = fc_3_fm_bram_ena;
            fm_bram_enb = 0;
            fm_bram_wea = 0;
            fm_bram_addra = fc_3_fm_bram_addra; 
       end 
       default: begin
            fm_bram_ena = 0;
            fm_bram_enb = 0;
        end
        endcase    
    end
end


//fm_bram_we/we/addra/addrb
always @ (*)begin
    if (rst)
    begin
       fm_bram_1_ena = 0;
       fm_bram_1_enb = 0;
       fm_bram_1_wea = 0;
       fm_bram_1_web = 0;
    end
    else 
    begin
        case (CS)
        `SCONV_1: begin
            fm_bram_1_ena = conv_1_fm_bram_wea;
            fm_bram_1_enb = conv_1_fm_bram_web;
            fm_bram_1_wea = conv_1_fm_bram_wea;
            fm_bram_1_web = conv_1_fm_bram_web;
            fm_bram_1_addra = conv_1_fm_bram_waddr_a;
            fm_bram_1_addrb = conv_1_fm_bram_waddr_b;
            fm_bram_1_dina = conv_1_fm_bram_wdata_a;  
            fm_bram_1_dinb = conv_1_fm_bram_wdata_b;        
        end
        `SPOOL_1: begin
            fm_bram_1_ena = pool_1_fm_bram_1_ena;
            fm_bram_1_enb = pool_1_fm_bram_1_enb;
            fm_bram_1_wea = 0;
            fm_bram_1_web = 0;
            fm_bram_1_addra = pool_1_fm_bram_1_addra;
            fm_bram_1_addrb = pool_1_fm_bram_1_addrb;                        
        end
        `SCONV_2: begin
            fm_bram_1_ena = conv_2_fm_bram_1_wea;
            fm_bram_1_enb = conv_2_fm_bram_1_web;
            fm_bram_1_wea = conv_2_fm_bram_1_wea;
            fm_bram_1_web = conv_2_fm_bram_1_web;
            fm_bram_1_addra = conv_2_fm_bram_1_addra;
            fm_bram_1_addrb = conv_2_fm_bram_1_addrb;
            fm_bram_1_dina = conv_2_fm_bram_1_dina;  
            fm_bram_1_dinb = conv_2_fm_bram_1_dinb;        
        end
        `SPOOL_2: begin
            fm_bram_1_ena = pool_2_fm_bram_1_ena;
            fm_bram_1_enb = pool_2_fm_bram_1_enb;
            fm_bram_1_wea = 0;
            fm_bram_1_web = 0;
            fm_bram_1_addra = pool_2_fm_bram_1_addra;
            fm_bram_1_addrb = pool_2_fm_bram_1_addrb;                        
        end
        `SFC_1: begin
            fm_bram_1_ena = fc_1_fm_bram_1_wea;
            fm_bram_1_wea = fc_1_fm_bram_1_wea;
            fm_bram_1_enb = 0;
            fm_bram_1_addra = fc_1_fm_bram_1_addra;
            fm_bram_1_dina = fc_1_fm_bram_1_dina;
        end
        `SRELU_1: begin
            fm_bram_1_ena = relu_1_fm_bram_1_ena;
            fm_bram_1_enb = 0;
            fm_bram_1_wea = 0;
            fm_bram_1_addra = relu_1_fm_bram_1_addra;            
        end
        `SFC_2: begin
            fm_bram_1_ena = fc_2_fm_bram_1_wea;
            fm_bram_1_wea = fc_2_fm_bram_1_wea;
            fm_bram_1_enb = 0;
            fm_bram_1_addra = fc_2_fm_bram_1_addra;
            fm_bram_1_dina = fc_2_fm_bram_1_dina;
        end
        `SRELU_2: begin
            fm_bram_1_ena = relu_2_fm_bram_1_ena;
            fm_bram_1_enb = 0;
            fm_bram_1_wea = 0;
            fm_bram_1_addra = relu_2_fm_bram_1_addra;            
        end
        default: begin
            fm_bram_1_ena = 0;
            fm_bram_1_enb = 0;
        end
        endcase    
    end
end

//conv_w_bram_ena/enb/addra/addrb
always @ (*)
begin
    if (rst)
    begin
        conv_w_bram_ena = 0;
        conv_w_bram_enb = 0;
    end
    else
    begin
        case (CS)
        `SCONV_1: begin
            conv_w_bram_ena = conv_1_conv_w_bram_en;        
            conv_w_bram_addra = conv_1_conv_w_bram_addr;
            conv_w_bram_enb = 0;
        end
        `SCONV_2: begin
            conv_w_bram_ena = conv_2_conv_w_bram_en;        
            conv_w_bram_addra = conv_2_conv_w_bram_addr;
            conv_w_bram_enb = 0;
        end
        default: begin
            conv_w_bram_ena = 0;
            conv_w_bram_enb = 0;
        end
        endcase
    end
end

//bias_bram en/addr
always @ (*)
begin
    if (rst)
    begin
        bias_bram_ena = 0;
    end
    else
    begin
        case (CS)
        `SCONV_1: begin
            bias_bram_ena = conv_1_bias_bram_en;        
            bias_bram_addra = conv_1_bias_bram_addr;
            bias_bram_enb = 0;
        end
        `SCONV_2: begin
            bias_bram_ena = conv_2_bias_bram_en;        
            bias_bram_addra = conv_2_bias_bram_addr;
            bias_bram_enb = 0;
        end    
        `SFC_1: begin
            bias_bram_ena = fc_1_bias_bram_ena;        
            bias_bram_addra = fc_1_bias_bram_addra;
            bias_bram_enb = fc_1_bias_bram_enb;
            bias_bram_addrb = fc_1_bias_bram_addrb;
        end   
        `SFC_2: begin
            bias_bram_ena = fc_2_bias_bram_ena;        
            bias_bram_addra = fc_2_bias_bram_addra;
            bias_bram_enb = fc_2_bias_bram_enb;
            bias_bram_addrb = fc_2_bias_bram_addrb;
        end    
        `SFC_3: begin
            bias_bram_ena = fc_3_bias_bram_ena;        
            bias_bram_addra = fc_3_bias_bram_addra;
            bias_bram_enb = fc_3_bias_bram_enb;
            bias_bram_addrb = fc_3_bias_bram_addrb;
        end         
        default: begin
            bias_bram_ena = 0;
            bias_bram_enb = 0;
        end
        endcase
    end
end

always @ (*)
begin
    case (CS)
    `SFC_2: begin
        fc23_w_bram_ena = fc2_w_bram_ena;
        fc23_w_bram_addra = fc2_w_bram_addra;
        fc23_w_bram_enb = fc2_w_bram_enb;
        fc23_w_bram_addrb = fc2_w_bram_addrb;
    end
    `SFC_3: begin
        fc23_w_bram_enb = 0;
        fc23_w_bram_ena = fc3_w_bram_ena;
        fc23_w_bram_addra = fc3_w_bram_addra;
    end
    endcase
end


//output buffer initial
always @ (posedge clk)
begin
    if (rst)
        output_buffer_initial <= 0;
    else
    begin
        case (CS)
           `SCONV_1: begin
              if (bias_bram_rd_vld)
              begin
                    output_buffer_initial <= 1;
                    bias_0 <= {56'h0,bias_bram_douta[31 : 16],12'b0,bias_bram_douta[15 : 0],12'b0};
               end
               else 
                    output_buffer_initial <= 0; 
           end
           `SCONV_2: begin
              if (bias_bram_rd_vld)
              begin
                    output_buffer_initial <= 1;
                    bias_0 <= {56'h0,bias_bram_douta[31 : 16],12'b0,bias_bram_douta[15 : 0],12'b0};
               end
               else 
                    output_buffer_initial <= 0; 
           end
           `SFC_1: begin
                if (bias_bram_rd_vld)
                begin
                    output_buffer_initial <= 1;
                    bias_0 <= {bias_bram_douta[31:16],12'b0,bias_bram_douta[15:0],12'b0,bias_bram_doutb[31:16],12'b0,bias_bram_doutb[15:0],12'b0};
                end
                else
                    output_buffer_initial <= 0;
           end
           `SFC_2: begin
                if (bias_bram_rd_vld)
                begin
                    output_buffer_initial <= 1;
                    bias_0 <= {bias_bram_douta[31:16],12'b0,bias_bram_douta[15:0],12'b0,bias_bram_doutb[31:16],12'b0,bias_bram_doutb[15:0],12'b0};
                end
                else
                    output_buffer_initial <= 0;
           end   
          `SFC_3: begin
                if (bias_bram_rd_vld)
                begin
                    output_buffer_initial <= 1;
                    bias_0 <= {bias_bram_douta[31:16],12'b0,bias_bram_douta[15:0],12'b0,bias_bram_doutb[31:16],12'b0,bias_bram_doutb[15:0],12'b0};
                end
                else
                    output_buffer_initial <= 0;
           end         
           default: begin
              output_buffer_initial <= 0;
           end
           endcase
    end
end

always @ (posedge clk)
begin
    case (CS)
        `SFC_1: bias_init_times <= fc_1_init_times;
        `SFC_2: bias_init_times <= fc_2_init_times;   
        `SFC_3: bias_init_times <= fc_3_init_times;       
    endcase
end


//ker_in pre-process
always @ (posedge clk)
begin
    if (rst) 
        ker_in <= 0;
    else
    begin 
        case (CS)
        `SCONV_1:begin
            if (conv_w_bram_rd_vld)
                ker_in <= {20{conv_w_bram_douta[23 : 8]}};
         end
        `SCONV_2:begin
             if (conv_w_bram_rd_vld)
                 ker_in <= {20{conv_w_bram_douta[23 : 8]}};
          end
        `SFC_1: begin
             ker_in <= {20{fc_1_fm_node}};
         end  
        `SFC_2: begin
              ker_in <= {20{fc_2_fm_node}};
         end  
         `SFC_3: begin
               ker_in <= {20{fc_3_fm_node}};
          end  
         default:
            ker_in <= 0;
        endcase
    end        
end

//input buffer en
always @ (posedge clk)
begin
    if (rst)
        input_buffer_en <= 0;
    else 
    case (CS) 
    `SCONV_1:
        input_buffer_en <= conv_1_conv_w_bram_en;
    `SCONV_2:
        input_buffer_en <= conv_2_conv_w_bram_en;
    `SFC_1:
        input_buffer_en <= fc1_w_bram_ena;    
    `SFC_2:
        input_buffer_en <= fc23_w_bram_ena;    
    `SFC_3:
        input_buffer_en <= fc23_w_bram_ena;           
    default:
        input_buffer_en <= 0;
    endcase
end

always @ (*)
begin
    case (CS)
    `SCONV_1:begin
        input_buf_in_1 = fm_bram_douta;
        input_buf_in_2 = fm_bram_doutb;    
    end
    `SCONV_2:begin
        input_buf_in_1 = fm_bram_douta;
        input_buf_in_2 = fm_bram_doutb;    
    end
    `SFC_1:begin
        input_buf_in_1[0+:60*16] = fc1_w_bram_douta;
        input_buf_in_2[0+:60*16] = fc1_w_bram_doutb;    
    end   
    `SFC_2:begin
        input_buf_in_1[0+:42*16] = fc23_w_bram_douta;
        input_buf_in_2[0+:42*16] = fc23_w_bram_doutb;    
    end
    `SFC_3:begin
        input_buf_in_2[0+:42*16] = fc23_w_bram_douta;   
    end
    default: begin
        input_buf_in_1 = 0;
        input_buf_in_2 = 0;  
    end
    endcase         
end

//mac_en
always @ (posedge clk)
begin
    case (CS)
    `SCONV_1: begin
        if (conv_w_bram_rd_vld)
            mac_en <= {8'h00, 112'hffff_ffff_ffff_ffff_ffff_ffff_ffff};        
        else 
            mac_en <= 0;
    end
   `SCONV_2: begin
        if (conv_w_bram_rd_vld)
            mac_en <= {20'h0, 100'hffff_ffff_ffff_ffff_ffff_ffff_f};        
        else 
            mac_en <= 0;
    end
    `SFC_1:begin
        if (fc1_w_bram_rd_vld)
            mac_en <= {120'hff_ffff_ffff_ffff_ffff_ffff_ffff_ffff};
        else 
            mac_en <= 0;
    end
    `SFC_2:begin
        if (fc23_w_bram_rd_vld)
            mac_en <= {36'h0, 84'hf_ffff_ffff_ffff_ffff_ffff};
        else 
            mac_en <= 0;
    end
    `SFC_3:begin
        if (fc23_w_bram_rd_vld)
            mac_en <= {110'h0, 10'h3ff};
        else 
            mac_en <= 0;
    end
    default: mac_en <= 0;
    endcase
end

always @ (*)
begin
    case (CS)
        `SCONV_1: store_en = conv_1_store_en; 
        `SCONV_2: store_en = conv_2_store_en;  
        default: store_en = 0;       
    endcase
end

always @ (*)
begin
    case (CS)
        `SFC_1: sum_en = fc_1_sum_en; 
        `SFC_2: sum_en = fc_2_sum_en; 
        `SFC_3: sum_en = fc_3_sum_en;
        default: sum_en = 0;
    endcase
end

//max_module
always @ (posedge clk)
begin
    if (rst) 
        max_en_1 <= 0;
    else begin
        case (CS) 
        `SPOOL_1: begin
            if (pool_1_max_en)
                max_en_1 <= 14'h3fff;
            else max_en_1 <= 0;
        end
        `SPOOL_2: begin
            if (pool_2_max_en)
                max_en_1 <= {4'b0, 10'h3ff};
            else max_en_1 <= 0;
        end
        `SRELU_1: begin
            if (relu_1_max_en)
                max_en_1 <= {4'b0,10'h3ff};
            else max_en_1 <= 0;
        end
        `SRELU_2: begin
            if (relu_2_max_en)
                max_en_1 <= {4'b0,10'h3ff};
            else max_en_1 <= 0;
        end
        default:
            max_en_1 <= 0;
        endcase
    end
end

always @ (posedge clk)
begin
    if (rst) 
        max_en_2 <= 0;
    else begin
        case (CS) 
        `SPOOL_1: begin
            if (pool_1_max_en)
                max_en_2 <= {1'b0,14'h3fff};
            else max_en_2 <= 0;
        end
        `SPOOL_2: begin
            if (pool_2_max_en)
                max_en_2 <= 15'h7fff;
            else max_en_2 <= 0;
        end        
        default:
            max_en_2 <= 0;
        endcase
    end
end

always @ (posedge clk)
begin
    case (CS)
    `SPOOL_1 : begin
        if (fm_bram_1_rda_vld)
            max_fm_in_1 <= fm_bram_1_douta[0 +: 896];
    end
   `SPOOL_2 : begin
        if (fm_bram_1_rda_vld)
            max_fm_in_1[0+:40*16] <= fm_bram_1_douta[10*16 +: 40*16];
    end
    `SRELU_1: begin
        if (fm_bram_1_rda_vld)
            max_fm_in_1[0+:10*16] <= fm_bram_1_douta[0+:10*16];  
    end
    `SRELU_2: begin
        if (fm_bram_1_rda_vld)
            max_fm_in_1[0+:10*16] <= fm_bram_1_douta[0+:10*16];  
    end
    default: max_fm_in_1 <= 0;
    endcase
end

always @ (posedge clk)
begin
    case (CS)
    `SPOOL_1 : begin
        if (fm_bram_1_rdb_vld)
            max_fm_in_2 <= {64'b0, fm_bram_1_doutb[0 +: 896]};
    end
    `SPOOL_2 : begin
        if (fm_bram_1_rdb_vld)
            max_fm_in_2 <= {fm_bram_1_doutb[0 +: 160], fm_bram_1_doutb[0 +: 800]};
    end
    default: max_fm_in_2 <= 0;
    endcase
end

conv_1 u_conv_1(
    .clk                (clk),
    .rst                (rst),
    .conv_1_en          (conv_1_en),
    .wr_data            (store_data[112*17-1:0]),
    .bias_bram_en       (conv_1_bias_bram_en),
    .bias_bram_addr     (conv_1_bias_bram_addr),
    .fm_bram_ena        (conv_1_fm_bram_ena),
    .fm_bram_enb        (conv_1_fm_bram_enb),
    .fm_bram_addra      (conv_1_fm_bram_addra),
    .fm_bram_addrb      (conv_1_fm_bram_addrb),
    .fm_bram_1_wea      (conv_1_fm_bram_wea),
    .fm_bram_1_addra    (conv_1_fm_bram_waddr_a),
    .fm_bram_1_dina     (conv_1_fm_bram_wdata_a),
    .fm_bram_1_web      (conv_1_fm_bram_web),
    .fm_bram_1_addrb    (conv_1_fm_bram_waddr_b),
    .fm_bram_1_dinb     (conv_1_fm_bram_wdata_b),
    .conv_w_bram_en     (conv_1_conv_w_bram_en),
    .conv_w_bram_addr   (conv_1_conv_w_bram_addr),
//    .output_layer       (conv_1_output_layer),
    .conv_1_finish      (conv_1_finish),
    .store_en           (conv_1_store_en)
    );

pool_1 u_pool_1(
    .clk                (clk),
    .rst                (rst),
    .pool_1_en          (pool_1_en),
    .pool_max_result_1  (pool_max_result_1[14*16-1:0]),
    .pool_max_result_2  (pool_max_result_2[14*16-1:0]),
    .max_en             (pool_1_max_en),
    .fm_bram_1_ena      (pool_1_fm_bram_1_ena),//read
    .fm_bram_1_enb      (pool_1_fm_bram_1_enb),    
    .fm_bram_1_addra    (pool_1_fm_bram_1_addra),
    .fm_bram_1_addrb    (pool_1_fm_bram_1_addrb),
    .fm_bram_wea        (pool_1_fm_bram_wea),
    .fm_bram_addra      (pool_1_fm_bram_addra),
    .fm_bram_dina       (pool_1_fm_bram_dina),
    .fm_bram_web        (pool_1_fm_bram_web),
    .fm_bram_addrb      (pool_1_fm_bram_addrb),
    .fm_bram_dinb       (pool_1_fm_bram_dinb),
    .pool_1_finish      (pool_1_finish)
    );

conv_2 u_conv_2(
    .clk            (clk),
    .rst            (rst),
    .conv_2_en      (conv_2_en),
    .wr_data        (store_data[100*17-1:0]),
    .bias_bram_en   (conv_2_bias_bram_en),
    .bias_bram_addr (conv_2_bias_bram_addr),
    .fm_bram_ena    (conv_2_fm_bram_ena),//read
    .fm_bram_enb    (conv_2_fm_bram_enb),
    .fm_bram_addra  (conv_2_fm_bram_addra),
    .fm_bram_addrb  (conv_2_fm_bram_addrb),
    .conv_w_bram_en (conv_2_conv_w_bram_en),
    .conv_w_bram_addr(conv_2_conv_w_bram_addr),
    .fm_bram_1_wea   (conv_2_fm_bram_1_wea),
    .fm_bram_1_web   (conv_2_fm_bram_1_web),
    .fm_bram_1_addra (conv_2_fm_bram_1_addra),
    .fm_bram_1_addrb (conv_2_fm_bram_1_addrb),
    .fm_bram_1_dina  (conv_2_fm_bram_1_dina),
    .fm_bram_1_dinb  (conv_2_fm_bram_1_dinb),
    .store_en       (conv_2_store_en),
    .conv_2_finish  (conv_2_finish)
    );     

pool_2 u_pool_2(
    .clk                (clk),
    .rst                (rst),
    .pool_2_en          (pool_2_en),
    .pool_max_result_1  (pool_max_result_1[10*16-1:0]),
    .pool_max_result_2  (pool_max_result_2[15*16-1:0]),
    .max_en             (pool_2_max_en),
    .fm_bram_1_ena      (pool_2_fm_bram_1_ena),//read
    .fm_bram_1_enb      (pool_2_fm_bram_1_enb),    
    .fm_bram_1_addra    (pool_2_fm_bram_1_addra),
    .fm_bram_1_addrb    (pool_2_fm_bram_1_addrb),
    .fm_bram_wea        (pool_2_fm_bram_wea),
    .fm_bram_addra      (pool_2_fm_bram_addra),
    .fm_bram_dina       (pool_2_fm_bram_dina),
    .pool_2_finish      (pool_2_finish)
    );

fc_1 u_fc_1(
    .clk                (clk),
    .rst                (rst),
    .fc_1_en            (fc_1_en),
    .bias_bram_rd_vld   (bias_bram_rd_vld),
    .fm_bram_douta      (fm_bram_douta[25*16-1:0]),
    .fm_bram_rda_vld    (fm_bram_rda_vld),
    .store_data         (store_data[10*17-1:0]),
    .fm_node            (fc_1_fm_node),
    .sum_en             (fc_1_sum_en),
    .bias_bram_ena      (fc_1_bias_bram_ena),
    .bias_bram_addra    (fc_1_bias_bram_addra),
    .bias_bram_enb      (fc_1_bias_bram_enb),
    .bias_bram_addrb    (fc_1_bias_bram_addrb),
    .fc1_w_bram_ena     (fc1_w_bram_ena),
    .fc1_w_bram_enb     (fc1_w_bram_enb),
    .fc1_w_bram_addra   (fc1_w_bram_addra),
    .fc1_w_bram_addrb   (fc1_w_bram_addrb),
    .fm_bram_ena        (fc_1_fm_bram_ena),
    .fm_bram_addra      (fc_1_fm_bram_addra),
    .fm_bram_1_wea      (fc_1_fm_bram_1_wea),
    .fm_bram_1_addra    (fc_1_fm_bram_1_addra),
    .fm_bram_1_dina     (fc_1_fm_bram_1_dina),    
    .init_times         (fc_1_init_times),
    .fc_1_finish        (fc_1_finish)
    );

relu_1 u_relu_1(
    .clk            (clk),
    .rst            (rst),
    .relu_1_en      (relu_1_en),
    .pool_max_result(pool_max_result_1[0+:160]),
    .fm_bram_1_ena  (relu_1_fm_bram_1_ena),
    .fm_bram_1_addra(relu_1_fm_bram_1_addra),
    .fm_bram_wea    (relu_1_fm_bram_wea),
    .fm_bram_addra  (relu_1_fm_bram_addra),
    .fm_bram_dina   (relu_1_fm_bram_dina),
    .relu_1_finish  (relu_1_finish),
    .max_en         (relu_1_max_en)
);

fc_2 u_fc_2(
    .clk                (clk),
    .rst                (rst),
    .fc_2_en            (fc_2_en),
    .bias_bram_rd_vld   (bias_bram_rd_vld),
    .fm_bram_douta      (fm_bram_douta[10*16-1:0]),
    .fm_bram_rda_vld    (fm_bram_rda_vld),
    .store_data         (store_data[10*17-1:0]),
    .fm_node            (fc_2_fm_node),
    .sum_en             (fc_2_sum_en),
    .bias_bram_ena      (fc_2_bias_bram_ena),
    .bias_bram_addra    (fc_2_bias_bram_addra),
    .bias_bram_enb      (fc_2_bias_bram_enb),
    .bias_bram_addrb    (fc_2_bias_bram_addrb),
    .fc2_w_bram_ena     (fc2_w_bram_ena),
    .fc2_w_bram_enb     (fc2_w_bram_enb),
    .fc2_w_bram_addra   (fc2_w_bram_addra),
    .fc2_w_bram_addrb   (fc2_w_bram_addrb),
    .fm_bram_ena        (fc_2_fm_bram_ena),
    .fm_bram_addra      (fc_2_fm_bram_addra),
    .fm_bram_1_wea      (fc_2_fm_bram_1_wea),
    .fm_bram_1_addra    (fc_2_fm_bram_1_addra),
    .fm_bram_1_dina     (fc_2_fm_bram_1_dina),    
    .init_times         (fc_2_init_times),
    .fc_2_finish        (fc_2_finish)
    );

relu_2 u_relu_2(
    .clk            (clk),
    .rst            (rst),
    .relu_2_en      (relu_2_en),
    .pool_max_result(pool_max_result_1[0+:160]),
    .fm_bram_1_ena  (relu_2_fm_bram_1_ena),
    .fm_bram_1_addra(relu_2_fm_bram_1_addra),
    .fm_bram_wea    (relu_2_fm_bram_wea),
    .fm_bram_addra  (relu_2_fm_bram_addra),
    .fm_bram_dina   (relu_2_fm_bram_dina),
    .relu_2_finish  (relu_2_finish),
    .max_en         (relu_2_max_en)
);

fc_3 u_fc_3(
    .clk                (clk),
    .rst                (rst),
    .fc_3_en            (fc_3_en),
    .bias_bram_rd_vld   (bias_bram_rd_vld),
    .fm_bram_douta      (fm_bram_douta[10*16-1:0]),
    .fm_bram_rda_vld    (fm_bram_rda_vld),
    .store_data         (store_data[10*17-1:0]),
    .fm_node            (fc_3_fm_node),
    .sum_en             (fc_3_sum_en),
    .bias_bram_ena      (fc_3_bias_bram_ena),
    .bias_bram_addra    (fc_3_bias_bram_addra),
    .bias_bram_enb      (fc_3_bias_bram_enb),
    .bias_bram_addrb    (fc_3_bias_bram_addrb),
    .fc3_w_bram_ena     (fc3_w_bram_ena),
    .fc3_w_bram_addra   (fc3_w_bram_addra),
    .fm_bram_ena        (fc_3_fm_bram_ena),
    .fm_bram_addra      (fc_3_fm_bram_addra),
    .result_10x16       (result_10x16),
    .init_times         (fc_3_init_times),
    .fc_3_finish        (fc_3_finish)
    );

FM_BRAM u_fm_bram (
      .clka (clk),    // input wire clka
      .ena  (fm_bram_ena),      // input wire ena
      .wea  (fm_bram_wea),      // input wire [0 : 0] wea
      .addra(fm_bram_addra),  // input wire [4 : 0] addra
      .dina (fm_bram_dina),    // input wire [1119 : 0] dina
      .douta(fm_bram_douta),  // output wire [1119 : 0] douta
      .clkb (clk),    // input wire clkb
      .enb  (fm_bram_enb),      // input wire enb
      .web  (fm_bram_web),      // input wire [0 : 0] web
      .addrb(fm_bram_addrb),  // input wire [4 : 0] addrb
      .dinb (fm_bram_dinb),    // input wire [1119 : 0] dinb
      .doutb(fm_bram_doutb)  // output wire [1119 : 0] doutb
);

FM_BRAM_1 fm_bram_1 (
      .clka     (clk),    // input wire clka
      .ena      (fm_bram_1_ena),      // input wire ena
      .wea      (fm_bram_1_wea),      // input wire [0 : 0] wea
      .addra    (fm_bram_1_addra),  // input wire [6 : 0] addra
      .dina     (fm_bram_1_dina),    // input wire [1023 : 0] dina
      .douta    (fm_bram_1_douta),  // output wire [1023 : 0] douta
      .clkb     (clk),    // input wire clkb
      .enb      (fm_bram_1_enb),      // input wire enb
      .web      (fm_bram_1_web),      // input wire [0 : 0] web
      .addrb    (fm_bram_1_addrb),  // input wire [6 : 0] addrb
      .dinb     (fm_bram_1_dinb),    // input wire [1023 : 0] dinb
      .doutb    (fm_bram_1_doutb)  // output wire [1023 : 0] doutb
    );

CONV_W_BRAM u_conv_w_bram (
      .clka (clk),    // input wire clka
      .ena  (conv_w_bram_ena),      // input wire ena
      .addra(conv_w_bram_addra),  // input wire [11 : 0] addra
      .douta(conv_w_bram_douta),  // output wire [23 : 0] douta
      .clkb (clk),
      .enb  (conv_w_bram_enb),      // input wire ena
      .addrb(conv_w_bram_addrb),  // input wire [11 : 0] addra
      .doutb(conv_w_bram_doutb)
    );  

FC1_W_BRAM u_fc1_w_bram (
  .clka     (clk),    // input wire clka
  .ena      (fc1_w_bram_ena),      // input wire ena
  .addra    (fc1_w_bram_addra),  // input wire [9 : 0] addra
  .douta    (fc1_w_bram_douta),  // output wire [959 : 0] douta
  .clkb     (clk),    // input wire clkb
  .enb      (fc1_w_bram_enb),      // input wire enb
  .addrb    (fc1_w_bram_addrb),  // input wire [9 : 0] addrb
  .doutb    (fc1_w_bram_doutb)  // output wire [959 : 0] doutb
);

FC2_W_BRAM u_fc23_w_bram (
  .clka     (clk),    // input wire clka
  .ena      (fc23_w_bram_ena),      // input wire ena
  .addra    (fc23_w_bram_addra),  // input wire [8 : 0] addra
  .douta    (fc23_w_bram_douta),  // output wire [671 : 0] douta
  .clkb     (clk),    // input wire clkb
  .enb      (fc23_w_bram_enb),      // input wire enb
  .addrb    (fc23_w_bram_addrb),  // input wire [8 : 0] addrb
  .doutb    (fc23_w_bram_doutb)  // output wire [671 : 0] doutb
);

BIAS_BRAM u_bias_bram (
      .clka (clk),    // input wire clka
      .ena  (bias_bram_ena),      // input wire ena
      .addra(bias_bram_addra),  // input wire [6 : 0] addra
      .douta(bias_bram_douta),
      .clkb (clk),    // input wire clka
      .enb  (bias_bram_enb),      // input wire ena
      .addrb(bias_bram_addrb),  // input wire [6 : 0] addra
      .doutb(bias_bram_doutb) // output wire [31 : 0] douta
    );
    
output_buffer u_output_buffer( 
    .clk                    (clk),
    .rst                    (rst),
    .en                     (output_en),
    .CS                     (CS),
    .output_buffer_initial  (output_buffer_initial),
    .result_33_vld          (mac_result_vld),
    .result_33              (mac_result),
    .bias_0                 (bias_0),
    .store_en               (store_en),
    .result_out_28          (output_buffer_result),
    .store_data_17_o          (store_data),
    .init_times             (bias_init_times),
    .sum_en                 (sum_en)
    ); 

input_buffer u_input_buffer(
    .clk        (clk),
    .rst        (rst),
    .en         (input_buffer_en),
    .cur_state  (CS),
    .ker_row    (conv_w_bram_douta[7 : 4]),
    .ker_col    (conv_w_bram_douta[3 : 0]),
    .in_1       (input_buf_in_1),
    .in_2       (input_buf_in_2),
    .input_buf  (fm_in)
    );
    
MAC u_mac(
    .clk            (clk),
    .rst            (rst),
//    .CS             (CS),
//    .mac_sel        (mac_sel),
    .mac_en         (mac_en),
    .img            (fm_in),
    .ker            (ker_in),
    .partial_output (output_buffer_result), 
    .result         (mac_result),
    .result_vld     (mac_result_vld),
    .partial_output_prepare (output_en)
        ); 

MAX_TOP_14 u_max_1(
    .clk      (clk),
    .rst      (rst),   
    .fm_in    (max_fm_in_1),
    .max_en   (max_en_1),
    .CS       (CS),
    .pool_result(pool_max_result_1)
    );

MAX_TOP_15 u_max_2(
    .clk      (clk),
    .rst      (rst),   
    .fm_in    (max_fm_in_2),
    .max_en   (max_en_2),
    .CS       (CS),
    .pool_result(pool_max_result_2)
    );
endmodule
