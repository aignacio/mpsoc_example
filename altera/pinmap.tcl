#============================================================
# Global definitions for the IOBanks
#============================================================
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 1A
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 1B
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 2
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 3
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 4
set_global_assignment -name IOBANK_VCCIO 1.5V -section_id 5
set_global_assignment -name IOBANK_VCCIO 1.5V -section_id 6
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7
set_global_assignment -name IOBANK_VCCIO 1.2V -section_id 8

#============================================================
# disable config pin so bank8 can use 1.2V
#============================================================
set_global_assignment -name AUTO_RESTART_CONFIGURATION ON
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF

#============================================================
# CLK/ARST
#============================================================
set_location_assignment PIN_P11 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_location_assignment PIN_H21 -to arst_n
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to arst_n
#============================================================
# LEDs
#============================================================
#set_location_assignment PIN_C7 -to leds[0]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[0]
#set_location_assignment PIN_C8 -to leds[1]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[1]
#set_location_assignment PIN_A6 -to leds[2]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[2]
#set_location_assignment PIN_B7 -to leds[3]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[3]
#set_location_assignment PIN_C4 -to leds[4]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[4]
#set_location_assignment PIN_A5 -to leds[5]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[5]
#set_location_assignment PIN_B4 -to leds[6]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to leds[6]
#set_location_assignment PIN_C5 -to heartbeat[0]
#set_instance_assignment -name IO_STANDARD "1.2 V" -to heartbeat[0]
#============================================================
# UART TX/RX
#============================================================
#set_location_assignment PIN_W18 -to uart_rxd
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_rxd
#set_location_assignment PIN_Y19 -to uart_txd
#set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to uart_txd
#============================================================
# JTAG Pins
#============================================================
set_location_assignment PIN_Y5  -to jtag_tdi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdi
set_location_assignment PIN_W6  -to jtag_tdo
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdo
set_location_assignment PIN_W8  -to jtag_tck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tck
set_location_assignment PIN_AB8 -to jtag_tms
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tms

