
`include "uart_define.v"

module uart_rx(
	input 			sample_clk,
	input 			rst_n,
	input 			rx_en,
	input 			RXD,
		
	output 			rx_ok,
	output [7:0]	rxd_out
);
	
	`define RX_IDLE 	2'b00
	`define RX_DATA 	2'b01
	`define RX_PARITY 	2'b10
	`define RX_STOP 	2'b11
	

	wire 		mclk;
	
	reg [2:0] 	rx_cnt; 	//counter for 8_bit_data
	reg [3:0]	sample_cnt;	//counter for sample clock 
	reg [7:0]	rxd_out_r; 	//store data of rxd_out temporarily
	reg [7:0]	rxd_out_last_r; 	//store last data of rxd_out temporarily
	
	
	//get true data by majority voting
	reg 		tmp_a;	
	reg 		tmp_b;	
	reg 		tmp_c;	
	reg 		tmp_vote;
	
	reg [1:0]	rx_state;
	reg	[1:0]	rx_next_state;
	
	reg 		rx_on_flag;
	reg			rx_ok_r;
	
	wire even_parity;
	reg parity_right;
	
	assign rx_ok = rx_ok_r;
	assign mclk = rx_en ? sample_clk : 1'b0;
	assign rxd_out = rx_ok_r ? rxd_out_r : rxd_out_last_r;
	
	assign even_parity = rxd_out_r[7] ^ rxd_out_r[6] ^ rxd_out_r[5] ^ rxd_out_r[4]
						^rxd_out_r[3] ^ rxd_out_r[2] ^ rxd_out_r[1] ^ rxd_out_r[0];	
						
	//FSM
	always @(*)
		rx_state <= rx_next_state;
	
	always @(posedge mclk or negedge rst_n)
		if(!rst_n) begin 
			rx_next_state <= `RX_IDLE;
			rx_cnt <= 4'b0;
			sample_cnt <= 4'b0;
			rxd_out_r <= `DATA_RX_DEF;
			rx_ok_r <= `RX_OK_DEF;
			rxd_out_last_r <= `DATA_RX_DEF;
			rx_on_flag <= 1'b0;
			tmp_a	<= 1'b1;
			tmp_b	<= 1'b1;
			tmp_c	<= 1'b1;
			tmp_vote <= 1'b1; 
			parity_right <= 1'b0;
		end 
		else  
			case(rx_state) 
				`RX_IDLE: begin 
					//if((sample_cnt == 4'd15) && (!rx_ok_r) && !tmp_vote)begin 
					rx_ok_r <= 1'b0;
					rxd_out_last_r <= rxd_out_r;  //store rxd_out_r 
					if((sample_cnt == 4'd15) && !tmp_vote)begin 
						sample_cnt <= 4'b0;
						rx_cnt <= 3'b0;
						rx_on_flag <= 1'b1;
						rx_next_state <= `RX_DATA;
					end
					else if((sample_cnt == 4'd0) && RXD) begin 
						sample_cnt <= 4'd0;
					end 
					else if(sample_cnt == 4'd7) begin     					//collect tmp_data_a 
						sample_cnt <= sample_cnt + 1;
						tmp_a <= RXD;
					end
					else if(sample_cnt == 4'd8) begin     					//collect tmp_data_b 
						sample_cnt <= sample_cnt + 1;
						tmp_b <= RXD;
					end
					else if(sample_cnt == 4'd9) begin     					//collect tmp_data_c 
						sample_cnt <= sample_cnt + 1;
						tmp_c <= RXD;
					end
					else if(sample_cnt == 4'd10) begin						//majority voting
						sample_cnt <= sample_cnt + 1;
						tmp_vote <= tmp_a&tmp_b || tmp_a&&tmp_c || tmp_b&&tmp_c;
					end 
					else if(sample_cnt == 4'd11)begin 
						if(tmp_vote == 1'b1) begin 
							sample_cnt <= 4'd0;
							rx_next_state <= `RX_IDLE;
						end
						else 
							sample_cnt <= sample_cnt + 1;
					end 
					else 
						sample_cnt <= sample_cnt + 1;
				end 
				`RX_DATA: begin 
					rx_ok_r <= 1'b0;
					if((rx_cnt == 3'd7) && (sample_cnt == 4'd15)) begin 
						sample_cnt <= 4'b0;
					    //rx_cnt <= 3'b0;
					    rx_next_state <= `RX_PARITY;
					end 
					else if((rx_cnt != 3'd7) && (sample_cnt == 4'd15)) begin 
						sample_cnt <= 4'b0;
						rx_cnt <= rx_cnt + 1;
						rx_next_state <= `RX_DATA;
					end 
					else if(sample_cnt == 4'd7) begin     					//collect tmp_data_a 
						sample_cnt <= sample_cnt + 1;
						tmp_a <= RXD;
					end
					else if(sample_cnt == 4'd8) begin     					//collect tmp_data_b 
						sample_cnt <= sample_cnt + 1;
						tmp_b <= RXD;
					end
					else if(sample_cnt == 4'd9) begin     					//collect tmp_data_c 
						sample_cnt <= sample_cnt + 1;
						tmp_c <= RXD;
					end
					else if(sample_cnt == 4'd10) begin
						sample_cnt <= sample_cnt + 1;
						tmp_vote <= tmp_a&tmp_b || tmp_a&&tmp_c || tmp_b&&tmp_c;
					end 
					else if(sample_cnt == 4'd11)begin 
						sample_cnt <= sample_cnt + 1;
						rxd_out_r <= {tmp_vote,rxd_out_r[7:1]};
					end 
					else 
						sample_cnt <= sample_cnt + 1;
				end 
				`RX_PARITY: begin 
					rx_ok_r <= 1'b0;
					if(sample_cnt == 4'd15) begin  
						sample_cnt <= 4'd0;
						parity_right <= 1'b0;
						rx_next_state <= `RX_STOP;
					end 
					else if(sample_cnt == 4'd7) begin     					//collect tmp_data_a 
						sample_cnt <= sample_cnt + 1;
						tmp_a <= RXD;
					end
					else if(sample_cnt == 4'd8) begin     					//collect tmp_data_b 
						sample_cnt <= sample_cnt + 1;
						tmp_b <= RXD;
					end
					else if(sample_cnt == 4'd9) begin     					//collect tmp_data_c 
						sample_cnt <= sample_cnt + 1;
						tmp_c <= RXD;
					end
					else if(sample_cnt == 4'd10) begin
						sample_cnt <= sample_cnt + 1;
						tmp_vote <= tmp_a&tmp_b || tmp_a&&tmp_c || tmp_b&&tmp_c;
					end 
					else if(sample_cnt == 4'd11)begin 
						if(tmp_vote == even_parity) begin  
							sample_cnt <= sample_cnt + 1;
							parity_right <= 1'b1;
						end 
						else begin 
							sample_cnt <= 4'd0;
							parity_right <= 1'b0;
							rx_next_state <= `RX_IDLE;
						end 
					end 
					else 
						sample_cnt <= sample_cnt + 1;
				end 
				`RX_STOP: begin 
					if(sample_cnt == 4'd13) begin 
						sample_cnt <= 4'd0;
						rx_next_state <= `RX_IDLE;
					end
					else if(sample_cnt == 4'd7) begin     					//collect tmp_data_a 
						sample_cnt <= sample_cnt + 1;
						tmp_a <= RXD;
					end
					else if(sample_cnt == 4'd8) begin     					//collect tmp_data_b 
						sample_cnt <= sample_cnt + 1;
						tmp_b <= RXD;
					end
					else if(sample_cnt == 4'd9) begin     					//collect tmp_data_c 
						sample_cnt <= sample_cnt + 1;
						tmp_c <= RXD;
					end
					else if(sample_cnt == 4'd10) begin						//majority voting 
						sample_cnt <= sample_cnt + 1;
						tmp_vote <= tmp_a&tmp_b || tmp_a&&tmp_c || tmp_b&&tmp_c;
					end 
					else if(sample_cnt == 4'd11)begin 
						if(tmp_vote == 1'b1)  								//jduging tmp_vote whether stop bit
							sample_cnt <= sample_cnt + 1;
						else begin 
							sample_cnt <= 4'd0;
							rx_next_state <= `RX_STOP;
						end 
					end 
					else if(sample_cnt == 4'd12) begin 
						sample_cnt <= sample_cnt + 1;
						rx_on_flag <= 1'b0;
						rx_ok_r <= 1'b1;
					end 	
					else 
						sample_cnt <= sample_cnt + 1;
				end
			
			endcase

endmodule





