module top (
  input               arst_n,
  input               clk_50MHz,
  input               jtag_tms,
  input               jtag_tdi,
  output              jtag_tdo,
  input               jtag_tck,
  output logic [7:0]  leds,
  input               uart_rxd,
  output              uart_txd
);
  logic [31:0]  gpio_write;
  logic         arst;

  assign arst = ~arst_n;
  assign leds = gpio_write[7:0]

  Murax u_murax(
    .io_asyncReset        (arst),
    .io_mainClk           (clk_50MHz),
    .io_jtag_tms          (jtag_tms),
    .io_jtag_tdi          (jtag_tdi),
    .io_jtag_tdo          (jtag_tdo),
    .io_jtag_tck          (jtag_tck),
    .io_gpioA_read        ('0),
    .io_gpioA_write       (gpio_write),
    .io_gpioA_writeEnable (),
    .io_uart_txd          (uart_txd),
    .io_uart_rxd          (uart_rxd)
  );
endmodule
