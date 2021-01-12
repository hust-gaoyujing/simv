`include "uart_define.v"

`define NUM_MAX 10

module uart_tb();
	reg   							clk;
	reg   							rst_n;
	
	reg                      		cmd_valid;
	wire                     		cmd_ready;
	reg  [32-1:0]	    			cmd_addr; 
	reg                      		cmd_read; 
	reg  [31:0]            			cmd_wdata;
		
	wire                     		rsp_valid;
	wire                      		rsp_ready;
	wire [31:0]            			rsp_rdata;
	
	wire  							interrupts_0_0;                
	wire  							port_txd;
	//reg		   						port_rxd;
	
	reg [7:0] 	num_txd 	[0:`NUM_MAX-1];
	reg [7:0] 	num_rxd 	[0:`NUM_MAX-1];
	
	reg [7:0]	error_index [0:`NUM_MAX-1];
	reg [7:0]	error_cnt;
	//reg error_has;
	integer 	i;
	integer 	j;
	integer 	k;
	integer 	m;
	
	gjy_uart_top	uart_1(
	.clk					(clk				),
	.rst_n                  (rst_n              ),
												
	.i_icb_cmd_valid        (cmd_valid          ),
	.i_icb_cmd_ready        (cmd_ready          ),
	.i_icb_cmd_addr         (cmd_addr           ),
	.i_icb_cmd_read         (cmd_read           ),
	.i_icb_cmd_wdata        (cmd_wdata          ),
												
	.i_icb_rsp_valid        (rsp_valid          ),
	.i_icb_rsp_ready        (rsp_ready          ),
	.i_icb_rsp_rdata        (rsp_rdata          ),
												
	.io_interrupts_0_0      (interrupts_0_0     ),     
	.io_port_txd            (port_txd           ),
	.io_port_rxd            (port_txd           )
	);
	
	assign rsp_ready = rsp_valid ? 1'b1 : 1'b0;
	
	//INITIAL THE  MEMORY OF TB
	initial begin
		i = 0;
		j = 0;
		k = 0;
		m = 0;
		$readmemh("num_txd.list",num_txd);
		error_cnt = 0;
		for(k = 0;k < `NUM_MAX;k = k+1) begin 
			num_rxd[k] = 8'hff;
			error_index[k] = 8'h0; 
		end
	end 
	
	//CLOCK AND RESET
	initial begin
		clk  <=1'b0;
		rst_n <=1'b0;
		#2000 rst_n <=1'b1;
		#2000 rst_n <=1'b0;
		#2000 rst_n <=1'b1;
	end

	initial begin 
		forever #31 clk <= ~clk;
	end 
 	
	initial begin 
		#1000000000; 
		$finish;
	end 
	
	
	////VERIFICATION MAIN	
	initial begin 
		i = 0;
		cmd_valid = 0;
		cmd_read = 0;
		cmd_addr = 32'h0;
		cmd_wdata = 32'h0;
		
		
		#10000;
		read_register(`UART_CSR_ADDR,0);
		read_register(`UART_CTRL_ADDR,0);
		read_register(`DATA_TX_ADDR,0);
		read_register(`DATA_RX_ADDR,1);
		
		#10000;
		write_register(`UART_CTRL_ADDR,32'h0034_0110,0);
		write_register(`UART_CSR_ADDR,32'h0034_0111,0);
		write_register(`UART_CSR_ADDR,32'h0069_0111,0);
		write_register(`UART_CTRL_ADDR,32'h0034_0110,0);
		write_register(`UART_CTRL_ADDR,32'h0034_1111,1);
		
		//#1000;
		//write_register(`DATA_TX_ADDR,32'h11,0);
		
		#1000;
		write_register(`UART_CTRL_ADDR,32'h0034_1111,1);
		
		//#3000000;
		//write_register(`DATA_TX_ADDR,32'h23,1);
		
		for(i = 0;i < (`NUM_MAX-1);i= i+1) begin 
			write_register(`DATA_TX_ADDR,num_txd[i],1);
			#2500000;
			while(rsp_rdata[0] != 1'b1) begin 
				#5000;
				read_register(`UART_CSR_ADDR,1);
				#5;
				//$display("%t : %h",$realtime,rsp_rdata);
			end
			@(posedge clk)
				num_rxd[i] <= uart_1.data_rx; 	
			//write_register(`DATA_TX_ADDR,num_txd[i],1);	
		end
		
		#10000000;
		
		//MONITOR AND COMPARE
		for(m = 0;m < (`NUM_MAX-1);m = m+1) begin 
			if(num_rxd[m] != num_txd[m] ) begin 
				error_index[error_cnt] =  m;
				error_cnt = error_cnt + 1;
			end 
		end
		//SCOREBOARD
		if(error_cnt == 0) begin 
			$display("=========================================");
			$display("===============PASSED!!!=================");
			$display("=========================================");
		end
		else begin 			
			$display("=========================================");
			$display("===============FAILED!!!=================");
			$display("=======THERE ARE %d errors=============",error_cnt+1);
			$display("=======ERROR INDEX ARE : ==================");
			for(j = 0;j <= error_cnt;j = j+1) begin
				$display("=============    %d   ===============",error_index[j]);
				//$display("===THE NUM_TXD IS: %h ====",num_txd[j]);
				//$display("===THE NUM_RXD IS: %h ====",num_rxd[j]);
			end 
			$display("=========================================");
		end
		
		#500000;
		$finish;
	end
	
	
	task read_register;
		input  	[`UX607_PA_SIZE-1:0]	    addr;
		//output 	[31:0]						rdata;
		input 								over;
		
		begin
	//cmd
			@(posedge clk); 
			begin 
				cmd_valid 	<= 1;
				cmd_addr	<= addr;
				cmd_read 	<= 1;
				cmd_wdata	<= 32'h0;
			end
	//judge whether operate continuously		 	
			if(over) begin 
				@(posedge clk);
				begin 
					cmd_valid 	<= 0;
					cmd_addr	<= 0;
					cmd_read 	<= 0;
					cmd_wdata	<= 32'h0;
				end
			end 
			else begin  
			
			end 	
		end 
	endtask

	task write_register;
		input  	[`UX607_PA_SIZE-1:0]	    addr;
		input  	[31:0]            			wdata;
		input 								over;
		
		begin
	//cmd
			@(posedge clk); 
			begin 
				cmd_valid 	<= 1;
				cmd_addr	<= addr;
				cmd_read 	<= 0;
				cmd_wdata	<= wdata;
			end
	//judge whether operate continuously		 	
			if(over) begin 
				@(posedge clk); 
				begin 
					cmd_valid 	<= 0;
					cmd_addr	<= 32'h0;
					cmd_read 	<= 0;
					cmd_wdata	<= 8'h0;
				end
			end 
			else begin  
			
			end 	
		end 
	endtask



endmodule