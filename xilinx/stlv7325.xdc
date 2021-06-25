set_property PACKAGE_PIN F17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict {PACKAGE_PIN C24  IOSTANDARD LVCMOS33} [get_ports arst_n]

#set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS15} [get_ports {leds[0]}]
#set_property -dict {PACKAGE_PIN AD5  IOSTANDARD LVCMOS15} [get_ports {leds[1]}]
#set_property -dict {PACKAGE_PIN W10  IOSTANDARD LVCMOS15} [get_ports {leds[2]}]
#set_property -dict {PACKAGE_PIN Y10  IOSTANDARD LVCMOS15} [get_ports {leds[3]}]
#set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports {leds[4]}]
#set_property -dict {PACKAGE_PIN W11  IOSTANDARD LVCMOS15} [get_ports {leds[5]}]
#set_property -dict {PACKAGE_PIN V11  IOSTANDARD LVCMOS15} [get_ports {leds[6]}]
#set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS15} [get_ports {heartbeat[0]}]
#
#set_property -dict {PACKAGE_PIN M25  IOSTANDARD LVCMOS33} [get_ports {uart_txd}]
#set_property -dict {PACKAGE_PIN L25  IOSTANDARD LVCMOS33} [get_ports {uart_rxd}]
#
#set_property -dict {PACKAGE_PIN F24  IOSTANDARD LVCMOS33} [get_ports {heartbeat[1]}]
#set_property -dict {PACKAGE_PIN F20  IOSTANDARD LVCMOS33} [get_ports {heartbeat[2]}]

set_property -dict {PACKAGE_PIN J20  IOSTANDARD LVCMOS33} [get_ports {jtag_tdi}]
set_property -dict {PACKAGE_PIN G20  IOSTANDARD LVCMOS33} [get_ports {jtag_tdo}]
set_property -dict {PACKAGE_PIN L20  IOSTANDARD LVCMOS33} [get_ports {jtag_tck}]
set_property -dict {PACKAGE_PIN E20  IOSTANDARD LVCMOS33} [get_ports {jtag_tms}]
#set_property -dict {PACKAGE_PIN H18  IOSTANDARD LVCMOS33} [get_ports {uart_tx_mirror}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck]
