#============================================================
# CLK/ARST
#============================================================
set_location_assignment PIN_P11 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_50MHz
set_location_assignment PIN_H21 -to arst_n
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to arst_n
#============================================================
# LEDs
#============================================================
set_location_assignment PIN_C7 -to leds[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[0]
set_location_assignment PIN_C8 -to leds[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[1]
set_location_assignment PIN_A6 -to leds[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[2]
set_location_assignment PIN_B7 -to leds[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[3]
set_location_assignment PIN_C4 -to leds[4]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[4]
set_location_assignment PIN_A5 -to leds[5]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[5]
set_location_assignment PIN_B4 -to leds[6]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[6]
set_location_assignment PIN_C5 -to leds[7]
set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[7]
#============================================================
# UART TX/RX
#============================================================
set_location_assignment PIN_W18 -to uart_rxd
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_rxd
set_location_assignment PIN_Y18 -to uart_txd
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_txd
#============================================================
# JTAG Pins
#============================================================
set_location_assignment PIN_W18 -to jtag_tms
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tms
set_location_assignment PIN_Y18 -to jtag_tdi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdi
set_location_assignment PIN_Y18 -to jtag_tdo
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdo
set_location_assignment PIN_Y18 -to jtag_tck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tck
