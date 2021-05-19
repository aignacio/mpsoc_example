module mpsoc_top (
  input           arst,
  input           clk_50MHz,
  input           io_jtag_tms,
  input           io_jtag_tdi,
  output          io_jtag_tdo,
  input           io_jtag_tck,
  output  [14:0]  sdram_addr,
  output  [2:0]   sdram_bank_addr,
  output  [1:0]   sdram_dqm,
  output          sdram_CASn,
  output          sdram_CKE,
  output          sdram_CSn,
  output          sdram_RASn,
  output          sdram_WEn,
  inout   [15:0]  sdram_DQ,

);
  logic [14:0] sdram_addr;
  logic [2:0]  sdram_bank_addr;
  logic [1:0]  sdram_dqm;
  logic [15:0] sdram_WritEn;

  assign sdram_addr[14:13] = '0;
  assign sdram_bank_addr[2] = '0;
  assign sdram_DQ_read =
  assign sdram_DQ_write

  always_comb begin
    for (int i=0;i<16;i++) begin
      if ()
    end
  end

  Briey u_briey(
    .io_asyncReset          (arst),
    .io_axiClk              (clk_50MHz),
    .io_vgaClk              ('0),
    .io_jtag_tms            (io_jtag_tms),
    .io_jtag_tdi            (io_jtag_tdi),
    .io_jtag_tdo            (io_jtag_tdo),
    .io_jtag_tck            (io_jtag_tck),
    .io_sdram_ADDR          (sdram_addr[12:0]),
    .io_sdram_BA            (sdram_bank_addr[1:0]),
    .io_sdram_DQ_read       (sdram_DQ_read),
    .io_sdram_DQ_write      (sdram_DQ_write),
    .io_sdram_DQ_writeEnable(sdram_WritEn),
    .io_sdram_DQM           (sdram_dqm),
    .io_sdram_CASn          (sdram_CASn),
    .io_sdram_CKE           (sdram_CKE),
    .io_sdram_CSn           (sdram_CSn),
    .io_sdram_RASn          (sdram_RASn),
    .io_sdram_WEn           (sdram_WEn),
    .io_gpioA_read,
    .io_gpioA_write,
    .io_gpioA_writeEnable,
    .io_gpioB_read,
    .io_gpioB_write,
    .io_gpioB_writeEnable,
    .io_uart_txd,
    .io_uart_rxd,
    .io_vga_vSync,
    .io_vga_hSync,
    .io_vga_colorEn,
    .io_vga_color_r,
    .io_vga_color_g,
    .io_vga_color_b,
    .io_timerExternal_clear(),
    .io_timerExternal_tick,
    .io_coreInterrupt
  );
endmodule
