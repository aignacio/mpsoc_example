module vexriscv_wrapper import ravenoc_pkg::*; (
  input                 clk,
  input                 arst,
  // I-bus
  input   s_axi_miso_t  ibus_axi_miso,
  output  s_axi_mosi_t  ibus_axi_mosi,
  // D-bus
  input   s_axi_miso_t  dbus_axi_miso,
  output  s_axi_mosi_t  dbus_axi_mosi,
  // External IRQ
  input                 irq_i
);
  always_comb begin
    ibus_axi_mosi.arid      = '0;
    ibus_axi_mosi.arregion  = '0;
    ibus_axi_mosi.arlen     = '0;
    ibus_axi_mosi.arsize    = WORD;
    ibus_axi_mosi.arburst   = INCR;
    ibus_axi_mosi.arlock    = '0;
    ibus_axi_mosi.arqos     = '0;

    dbus_axi_mosi.awid      = '0;
    dbus_axi_mosi.awregion  = '0;
    dbus_axi_mosi.awsize    = WORD;
    dbus_axi_mosi.awburst   = INCR;
    dbus_axi_mosi.awlock    = '0;
    dbus_axi_mosi.awqos     = '0;
    dbus_axi_mosi.arid      = '0;
    dbus_axi_mosi.arregion  = '0;
    dbus_axi_mosi.arlen     = '0;
    dbus_axi_mosi.arsize    = WORD;
    dbus_axi_mosi.arburst   = INCR;
    dbus_axi_mosi.arlock    = '0;
    dbus_axi_mosi.arqos     = '0;
  end

  VexRiscvAxi4 u_vexrv_core(
    .timerInterrupt            ('0),
    .externalInterrupt         (irq_i),
    .softwareInterrupt         ('0),
    .iBusAxi_ar_valid          (ibus_axi_mosi.arvalid),
    .iBusAxi_ar_ready          (ibus_axi_miso.arready),
    .iBusAxi_ar_payload_addr   (ibus_axi_mosi.araddr),
    //.iBusAxi_ar_payload_id     (ibus_axi_mosi.arid),
    //.iBusAxi_ar_payload_region (ibus_axi_mosi.arregion),
    //.iBusAxi_ar_payload_len    (ibus_axi_mosi.arlen),
    //.iBusAxi_ar_payload_size   (ibus_axi_mosi.arsize),
    //.iBusAxi_ar_payload_burst  (ibus_axi_mosi.arburst),
    //.iBusAxi_ar_payload_lock   (ibus_axi_mosi.arlock),
    .iBusAxi_ar_payload_cache  (ibus_axi_mosi.arcache),
    //.iBusAxi_ar_payload_qos    (ibus_axi_mosi.arqos),
    .iBusAxi_ar_payload_prot   (ibus_axi_mosi.arprot),
    .iBusAxi_r_valid           (ibus_axi_miso.rvalid),
    .iBusAxi_r_ready           (ibus_axi_mosi.rready),
    .iBusAxi_r_payload_data    (ibus_axi_miso.rdata),
    //.iBusAxi_r_payload_id      (ibus_axi_miso.rid),
    .iBusAxi_r_payload_resp    (ibus_axi_miso.rresp),
    .iBusAxi_r_payload_last    (ibus_axi_miso.rlast),
    .dBusAxi_aw_valid          (dbus_axi_mosi.awvalid),
    .dBusAxi_aw_ready          (dbus_axi_miso.awready),
    .dBusAxi_aw_payload_addr   (dbus_axi_mosi.awaddr),
    //.dBusAxi_aw_payload_id     (dbus_axi_mosi.awid),
    //.dBusAxi_aw_payload_region (dbus_axi_mosi.awregion),
    //.dBusAxi_aw_payload_len    (dbus_axi_mosi.awlen),
    .dBusAxi_aw_payload_size   (dbus_axi_mosi.awsize),
    //.dBusAxi_aw_payload_burst  (dbus_axi_mosi.awburst),
    //.dBusAxi_aw_payload_lock   (dbus_axi_mosi.awlock),
    .dBusAxi_aw_payload_cache  (dbus_axi_mosi.awcache),
    //.dBusAxi_aw_payload_qos    (dbus_axi_mosi.awqos),
    .dBusAxi_aw_payload_prot   (dbus_axi_mosi.awprot),
    .dBusAxi_w_valid           (dbus_axi_mosi.wvalid),
    .dBusAxi_w_ready           (dbus_axi_miso.wready),
    .dBusAxi_w_payload_data    (dbus_axi_mosi.wdata),
    .dBusAxi_w_payload_strb    (dbus_axi_mosi.wstrb),
    .dBusAxi_w_payload_last    (dbus_axi_mosi.wlast),
    .dBusAxi_b_valid           (dbus_axi_miso.bvalid),
    .dBusAxi_b_ready           (dbus_axi_mosi.bready),
    //.dBusAxi_b_payload_id      (dbus_axi_miso.bid),
    .dBusAxi_b_payload_resp    (dbus_axi_miso.bresp),
    .dBusAxi_ar_valid          (dbus_axi_mosi.arvalid),
    .dBusAxi_ar_ready          (dbus_axi_miso.arready),
    .dBusAxi_ar_payload_addr   (dbus_axi_mosi.araddr),
    //.dBusAxi_ar_payload_id     (dbus_axi_mosi.arid),
    //.dBusAxi_ar_payload_region (dbus_axi_mosi.arregion),
    //.dBusAxi_ar_payload_len    (dbus_axi_mosi.arlen),
    .dBusAxi_ar_payload_size   (dbus_axi_mosi.arsize),
    //.dBusAxi_ar_payload_burst  (dbus_axi_mosi.arburst),
    //.dBusAxi_ar_payload_lock   (dbus_axi_mosi.arlock),
    .dBusAxi_ar_payload_cache  (dbus_axi_mosi.arcache),
    //.dBusAxi_ar_payload_qos    (dbus_axi_mosi.arqos),
    .dBusAxi_ar_payload_prot   (dbus_axi_mosi.arprot),
    .dBusAxi_r_valid           (dbus_axi_miso.rvalid),
    .dBusAxi_r_ready           (dbus_axi_mosi.rready),
    .dBusAxi_r_payload_data    (dbus_axi_miso.rdata),
    //.dBusAxi_r_payload_id      (dbus_axi_miso.rid),
    .dBusAxi_r_payload_resp    (dbus_axi_miso.rresp),
    .dBusAxi_r_payload_last    (dbus_axi_miso.rlast),
    .clk                       (clk),
    .reset                     (arst)
  );
endmodule
