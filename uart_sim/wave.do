onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /uart_tb/clk
add wave -noupdate -expand -group tb /uart_tb/rst_n
add wave -noupdate -expand -group tb /uart_tb/cmd_valid
add wave -noupdate -expand -group tb /uart_tb/cmd_ready
add wave -noupdate -expand -group tb /uart_tb/cmd_addr
add wave -noupdate -expand -group tb /uart_tb/cmd_read
add wave -noupdate -expand -group tb /uart_tb/cmd_wdata
add wave -noupdate -expand -group tb /uart_tb/rsp_valid
add wave -noupdate -expand -group tb /uart_tb/rsp_ready
add wave -noupdate -expand -group tb /uart_tb/rsp_rdata
add wave -noupdate -expand -group tb /uart_tb/interrupts_0_0
add wave -noupdate -expand -group tb /uart_tb/port_txd
add wave -noupdate -expand -group tb /uart_tb/num_txd
add wave -noupdate -expand -group tb /uart_tb/num_rxd
add wave -noupdate -expand -group tb /uart_tb/error_index
add wave -noupdate -expand -group tb /uart_tb/error_cnt
add wave -noupdate -expand -group tb /uart_tb/i
add wave -noupdate -expand -group tb /uart_tb/j
add wave -noupdate -expand -group tb /uart_tb/k
add wave -noupdate -expand -group tb /uart_tb/m
add wave -noupdate -group top /uart_tb/uart_1/clk
add wave -noupdate -group top /uart_tb/uart_1/rst_n
add wave -noupdate -group top /uart_tb/uart_1/i_icb_cmd_valid
add wave -noupdate -group top /uart_tb/uart_1/i_icb_cmd_ready
add wave -noupdate -group top /uart_tb/uart_1/i_icb_cmd_addr
add wave -noupdate -group top /uart_tb/uart_1/i_icb_cmd_read
add wave -noupdate -group top /uart_tb/uart_1/i_icb_cmd_wdata
add wave -noupdate -group top /uart_tb/uart_1/i_icb_rsp_valid
add wave -noupdate -group top /uart_tb/uart_1/i_icb_rsp_ready
add wave -noupdate -group top /uart_tb/uart_1/i_icb_rsp_rdata
add wave -noupdate -group top /uart_tb/uart_1/io_interrupts_0_0
add wave -noupdate -group top /uart_tb/uart_1/io_port_txd
add wave -noupdate -group top /uart_tb/uart_1/io_port_rxd
add wave -noupdate -group top /uart_tb/uart_1/uart_csr
add wave -noupdate -group top /uart_tb/uart_1/uart_ctrl
add wave -noupdate -group top /uart_tb/uart_1/data_tx
add wave -noupdate -group top /uart_tb/uart_1/data_rx
add wave -noupdate -group top /uart_tb/uart_1/tx_ok
add wave -noupdate -group top /uart_tb/uart_1/rx_ok
add wave -noupdate -group top /uart_tb/uart_1/baudrate
add wave -noupdate -group top /uart_tb/uart_1/divisor
add wave -noupdate -group top /uart_tb/uart_1/baud_en
add wave -noupdate -group top /uart_tb/uart_1/tx_en
add wave -noupdate -group top /uart_tb/uart_1/rx_en
add wave -noupdate -group top /uart_tb/uart_1/cmd_valid
add wave -noupdate -group top /uart_tb/uart_1/cmd_ready
add wave -noupdate -group top /uart_tb/uart_1/cmd_addr
add wave -noupdate -group top /uart_tb/uart_1/cmd_read
add wave -noupdate -group top /uart_tb/uart_1/cmd_wdata
add wave -noupdate -group top /uart_tb/uart_1/rsp_ready
add wave -noupdate -group top /uart_tb/uart_1/rsp_valid
add wave -noupdate -group top /uart_tb/uart_1/rsp_rdata
add wave -noupdate -group top /uart_tb/uart_1/rd_rx_flag
add wave -noupdate -group top /uart_tb/uart_1/wr_tx_flag
add wave -noupdate -group top /uart_tb/uart_1/baud_clk
add wave -noupdate -group top /uart_tb/uart_1/sample_clk
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/parity_right
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/even_parity
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rst_n
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_en
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/sample_clk
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/RXD
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_ok
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rxd_out
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/mclk
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_cnt
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/sample_cnt
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rxd_out_r
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rxd_out_last_r
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/tmp_a
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/tmp_b
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/tmp_c
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/tmp_vote
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_state
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_next_state
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_on_flag
add wave -noupdate -expand -group rxd /uart_tb/uart_1/rxd/rx_ok_r
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/baud_clk
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/rst_n
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_en
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_start
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/txd_in
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_ok
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/TXD
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/mclk
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_cnt
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/txd_out_r
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/txd_out
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_state
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_next_state
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_on_flag
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/tx_ok_r
add wave -noupdate -expand -group txd /uart_tb/uart_1/txd/even_parity
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/clk
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/rst_n
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/baud_en
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/divisor
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/baud_clk
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/sample_clk
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/sample_cnt
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/baud_cnt
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/divisor_r
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/baud_clk_r
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/sample_clk_r
add wave -noupdate -group baud_gen /uart_tb/uart_1/baud_gen/mclk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29521021 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 273
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {66335288 ns}
