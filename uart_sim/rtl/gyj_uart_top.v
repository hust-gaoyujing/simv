
`include "uart_define.v"


module gjy_uart_top(
	input   clk,
	input   rst_n,

	input                      i_icb_cmd_valid,
	output                     i_icb_cmd_ready,
	input  [`UX607_PA_SIZE-1:0]            i_icb_cmd_addr, 
	input                      i_icb_cmd_read, 
	input  [31:0]    	       i_icb_cmd_wdata,
  
	output                     i_icb_rsp_valid,
	input                      i_icb_rsp_ready,
	output [31:0] 	           i_icb_rsp_rdata,

	output  io_interrupts_0_0,                
	output  io_port_txd,
	input   io_port_rxd
);
	
	//registers of uart
	reg [31:0] 	uart_csr;		//csr register of uart
	reg [31:0] 	uart_ctrl;		//ctrl register of uart
	reg [7:0] 	data_tx;		//data register for uart tx
	wire [7:0] 	data_rx;		//data register for uart rx
 
	//signals of uart_csr register	
	wire 		tx_ok;			//uart_csr[0] but just for R 
	wire 		rx_ok;			//uart_csr[4] but just for R
	wire [1:0]	baudrate = uart_csr[9:8];	//2'b00 for 4800bps,2'b01 for 9600bps, others for reserved
	wire [15:0]	divisor = uart_csr[31:16];
	
	//signals of uart_csr register	
	wire 		baud_en = uart_ctrl[0];		//enable signal for baudrate_generator
	wire 		tx_en = uart_ctrl[4];		//enable signal for uart_tx
	wire 		rx_en = uart_ctrl[8];		//enable signal for uart_rx
 
	//signals for interfaces simplify
	wire 		cmd_valid = i_icb_cmd_valid;
	wire 		cmd_ready;
	wire [`UX607_PA_SIZE-1:0]	cmd_addr = i_icb_cmd_addr;
	wire 		cmd_read = i_icb_cmd_read;
	wire [31:0] cmd_wdata = i_icb_cmd_wdata;
	
	wire 		rsp_ready = i_icb_rsp_ready;
	reg 		rsp_valid;
	reg	[31:0]	rsp_rdata;
	
	
	//declare to  	
	reg rd_rx_flag;					//flag signal for data_rx registers read
	reg wr_tx_flag;					//flag signal for data_tx registers write 
	
	//clock signals
	wire baud_clk;
	wire sample_clk;
 
	//assginment of io_interrupts_0_0,TODO
	assign io_interrupts_0_0 = 0;
	assign i_icb_cmd_ready = cmd_ready;
	assign i_icb_rsp_valid = rsp_valid;
	assign i_icb_rsp_rdata = rsp_rdata;
	
	assign cmd_ready = (~cmd_valid) ? 1'b0 :
					   //(cmd_addr == `DATA_TX_ADDR) ? (tx_ok ? 1'b1 : 1'b0) :
					   //(cmd_addr == `DATA_RX_ADDR) ? (rx_ok ? 1'b1 : 1'b0) :
					   (cmd_addr == `DATA_TX_ADDR) ? 1'b1 :	
					   (cmd_addr == `DATA_RX_ADDR) ? 1'b1 :
					   (cmd_addr == `UART_CSR_ADDR) ? 1'b1 :
					   (cmd_addr == `UART_CTRL_ADDR) ? 1'b1 : 1'b0; 
					   //(cmd_addr == `UART_CSR_ADDR) ? ((tx_ok && rx_ok) ? 1'b1 : 1'b0) :
					   //(cmd_addr == `UART_CTRL_ADDR) ? ((tx_ok && rx_ok) ? 1'b1 : 1'b0) : 1'b0; 
					   

	//read or write registers of uart
	//assginment for rep_valid
	always @(posedge clk or negedge rst_n) 
		if(!rst_n) begin 
			rsp_valid <= 1'b0;
			rsp_rdata <= 32'h0;			
			data_tx <= `DATA_TX_DEF;
			//data_rx <= `DATA_RX_DEF;
			uart_csr  <= `UART_CSR_DEF;
			uart_ctrl <= `UART_CTRL_DEF;
		end 
		else begin
			if(cmd_valid && cmd_ready) begin 
				if(cmd_read) begin 
					rsp_valid <= 1'b1;
					case(cmd_addr) 
						`DATA_TX_ADDR	: rsp_rdata <= data_tx;
						`DATA_RX_ADDR	: rsp_rdata <= data_rx;
						`UART_CSR_ADDR 	: rsp_rdata <= {uart_csr[31:8],3'b0,rx_ok,3'b0,tx_ok};
						`UART_CTRL_ADDR : rsp_rdata <= uart_ctrl;
						default			: rsp_rdata <= 32'h0;
					endcase
				end 
				else begin 
					rsp_valid <= 1'b1;
					case(cmd_addr) 
						`DATA_TX_ADDR	: data_tx <= cmd_wdata;
                        //`DATA_RX_ADDR	: data_rx <= cmd_wdata;	
                        `UART_CSR_ADDR 	: uart_csr <= cmd_wdata;
                        `UART_CTRL_ADDR : uart_ctrl <= cmd_wdata;
						default			: ;
					endcase
				end 
			end 
			else begin 
				rsp_valid <= 1'b0;
				rsp_rdata <= 32'h0;
			end 
		end 

	//assginment for flag signals
	always @(posedge clk or negedge rst_n) 
		if(!rst_n) begin 
			//tx_ok <= `TX_OK_DEF;
			//rx_ok <= `RX_OK_DEF;
			rd_rx_flag <= 1'b0;
			wr_tx_flag <= 1'b0;
		end 
		else begin 
			if(cmd_valid && cmd_ready && cmd_read) begin 
				if(cmd_addr == `DATA_RX_ADDR) begin 
					rd_rx_flag <= 1'b1;
					wr_tx_flag <= 1'b0;
					//rx_ok <= 1'b0;
				end 
				else begin 
					rd_rx_flag <= 1'b0;
					wr_tx_flag <= 1'b0;
				end
			end 
			else if(cmd_valid && cmd_ready && !cmd_read) begin	
				if(cmd_addr == `DATA_TX_ADDR) begin 	
					rd_rx_flag <= 1'b0;
					wr_tx_flag <= 1'b1;
					//tx_ok <= 1'b0;
				end 
				else begin 
					rd_rx_flag <= 1'b0;
					wr_tx_flag <= 1'b0;					
				end 
			end 
			else begin 
					rd_rx_flag <= 1'b0;
					wr_tx_flag <= 1'b0;
			end 
		end 
			
		
	baudrate_generator baud_gen( 
		.clk				(clk				),		
		.rst_n              (rst_n				),	
		.baud_en            (baud_en			),		
		.divisor            (divisor			),		
		
		.baud_clk           (baud_clk			),		
		.sample_clk         (sample_clk			)		
	);		
	
	uart_tx txd(
		.baud_clk			(baud_clk			),
		.rst_n              (rst_n              ),
		.tx_en              (tx_en              ),
		.tx_start           (wr_tx_flag         ),
		.txd_in	        	(data_tx            ),
												
		.tx_ok              (tx_ok              ),
		.TXD	            (io_port_txd        )
	);
	
	uart_rx rxd(
		.sample_clk			(sample_clk		    ),
	    .rst_n              (rst_n              ),
		.rx_en              (rx_en              ),
	    .RXD                (io_port_rxd        ),
												
		.rx_ok				(rx_ok              ),
	    .rxd_out            (data_rx			)
	);  

endmodule			
			
			
	