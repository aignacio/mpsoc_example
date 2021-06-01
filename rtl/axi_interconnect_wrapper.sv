module axi_interconnect_wrapper import ravenoc_pkg::*; #(
  parameter N_MASTERS   = 2,
  parameter N_SLAVES    = 2,
  parameter BASE_ADDR   = 0,
  parameter ADDR_WIDTH  = 0
)(
  input                                 clk,
  input                                 arst,
  // Master I/Fs
  input   s_axi_mosi_t  [N_MASTERS-1:0] masters_axi_mosi,
  output  s_axi_miso_t  [N_MASTERS-1:0] masters_axi_miso,
  // Slave I/Fs
  output  s_axi_mosi_t  [N_SLAVES-1:0]  slaves_axi_mosi,
  input   s_axi_miso_t  [N_SLAVES-1:0]  slaves_axi_miso
);
  // Configuration:
  // M_BASE_ADDR = Configures the base address of the AXI slaves
  // M_ADDR_WIDTH = Configures the length of the addressing of the slaves based on multiples of 4KB
  // for instance, if we consider 5x slave with MM below + 2x Masters:
  //    _______________________________
  //  | 0x2000-0x3FFF | slave # 0 - 8KB |
  //  | 0x4000-0x5FFF | slave # 1 - 8KB |
  //  | 0x6000-0x6FFF | slave # 2 - 4KB |
  //    ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻
  // .S_COUNT(2),
  // .M_COUNT(3),
  // .ADDR_WIDTH(16),
  // .M_REGIONS(1),
  // .M_BASE_ADDR({16'h6000, 16'h4000, 6'h2000}),
  // .M_ADDR_WIDTH({32'd12, 32'd13, 32'd13})
  //
  // More info:
  // https://github.com/alexforencich/verilog-axi/issues/16
  axi_interconnect #(
    .S_COUNT      (N_MASTERS),
    // Number of AXI outputs (master interfaces)
    .M_COUNT      (N_SLAVES),
    // Width of ID signal
    .ID_WIDTH     (1),
    // Number of regions per master interface
    .M_REGIONS    (1),
    // Width of address bus in bits
    .ADDR_WIDTH   (16),
    // Master interface base addresses
    // M_COUNT concatenated fields of M_REGIONS concatenated fields of ADDR_WIDTH bits
    // set to zero for default addressing based on M_ADDR_WIDTH
    .M_BASE_ADDR  (BASE_ADDR),
    // Master interface address widths
    // M_COUNT concatenated fields of M_REGIONS concatenated fields of 32 bits
    .M_ADDR_WIDTH (ADDR_WIDTH),
  ) u_axi_intcon (
    .clk          (clk),
    .rst          (arst),
    // Masters
    .s_axi_awid   (masters_axi_mosi.awid),
    .s_axi_awaddr (masters_axi_mosi.awaddr),
    .s_axi_awlen  (masters_axi_mosi.awlen),
    .s_axi_awsize (masters_axi_mosi.awsize),
    .s_axi_awburst(masters_axi_mosi.awburst),
    .s_axi_awlock (masters_axi_mosi.awlock),
    .s_axi_awcache(masters_axi_mosi.awcache),
    .s_axi_awprot (masters_axi_mosi.awprot),
    .s_axi_awqos  (masters_axi_mosi.awqos),
    .s_axi_awuser (masters_axi_mosi.awuser),
    .s_axi_awvalid(masters_axi_mosi.awvalid),
    .s_axi_awready(masters_axi_miso.awready),
    .s_axi_wdata  (masters_axi_mosi.wdata),
    .s_axi_wstrb  (masters_axi_mosi.wstrb),
    .s_axi_wlast  (masters_axi_mosi.wlast),
    .s_axi_wuser  (masters_axi_mosi.wuser),
    .s_axi_wvalid (masters_axi_mosi.wvalid),
    .s_axi_wready (masters_axi_miso.wready),
    .s_axi_bid    (masters_axi_miso.bid),
    .s_axi_bresp  (masters_axi_miso.bresp),
    .s_axi_buser  (masters_axi_miso.buser),
    .s_axi_bvalid (masters_axi_miso.bvalid),
    .s_axi_bready (masters_axi_mosi.bready),
    .s_axi_arid   (masters_axi_mosi.arid),
    .s_axi_araddr (masters_axi_mosi.araddr),
    .s_axi_arlen  (masters_axi_mosi.arlen),
    .s_axi_arsize (masters_axi_mosi.arsize),
    .s_axi_arburst(masters_axi_mosi.arburst),
    .s_axi_arlock (masters_axi_mosi.arlock),
    .s_axi_arcache(masters_axi_mosi.arcache),
    .s_axi_arprot (masters_axi_mosi.arprot),
    .s_axi_arvalid(masters_axi_mosi.arvalid),
    .s_axi_arready(masters_axi_miso.arready),
    .s_axi_rid    (masters_axi_miso.rid),
    .s_axi_rdata  (masters_axi_miso.rdata),
    .s_axi_rresp  (masters_axi_miso.rresp),
    .s_axi_rlast  (masters_axi_miso.rlast),
    .s_axi_ruser  (masters_axi_mosi.ruser),
    .s_axi_rvalid (masters_axi_miso.rvalid),
    .s_axi_rready (masters_axi_mosi.rready),
    // Slaves
    .m_axi_awid   (slaves_axi_mosi.awid),
    .m_axi_awaddr (slaves_axi_mosi.awaddr),
    .m_axi_awlen  (slaves_axi_mosi.awlen),
    .m_axi_awsize (slaves_axi_mosi.awsize),
    .m_axi_awburst(slaves_axi_mosi.awburst),
    .m_axi_awlock (slaves_axi_mosi.awlock),
    .m_axi_awcache(slaves_axi_mosi.awcache),
    .m_axi_awprot (slaves_axi_mosi.awprot),
    .m_axi_awqos  (slaves_axi_mosi.awqos),
    .m_axi_awuser (slaves_axi_mosi.awuser),
    .m_axi_awvalid(slaves_axi_mosi.awvalid),
    .m_axi_wdata  (slaves_axi_mosi.wdata),
    .m_axi_wstrb  (slaves_axi_mosi.wstrb),
    .m_axi_wlast  (slaves_axi_mosi.wlast),
    .m_axi_wuser  (slaves_axi_mosi.wuser),
    .m_axi_wvalid (slaves_axi_mosi.wvalid),
    .m_axi_bready (slaves_axi_mosi.bready),
    .m_axi_arid   (slaves_axi_mosi.arid),
    .m_axi_araddr (slaves_axi_mosi.araddr),
    .m_axi_arlen  (slaves_axi_mosi.arlen),
    .m_axi_arsize (slaves_axi_mosi.arsize),
    .m_axi_arburst(slaves_axi_mosi.arburst),
    .m_axi_arlock (slaves_axi_mosi.arlock),
    .m_axi_arcache(slaves_axi_mosi.arcache),
    .m_axi_arprot (slaves_axi_mosi.arprot),
    .m_axi_arvalid(slaves_axi_mosi.arvalid),
    .m_axi_rready (slaves_axi_mosi.rready),
    .m_axi_ruser  (slaves_axi_mosi.ruser),
    .m_axi_awready(slaves_axi_miso.awready),
    .m_axi_wready (slaves_axi_miso.wready),
    .m_axi_bid    (slaves_axi_miso.bid),
    .m_axi_bresp  (slaves_axi_miso.bresp),
    .m_axi_buser  (slaves_axi_miso.buser),
    .m_axi_bvalid (slaves_axi_miso.bvalid),
    .m_axi_arready(slaves_axi_miso.arready),
    .m_axi_rid    (slaves_axi_miso.rid),
    .m_axi_rdata  (slaves_axi_miso.rdata),
    .m_axi_rresp  (slaves_axi_miso.rresp),
    .m_axi_rlast  (slaves_axi_miso.rlast),
    .m_axi_rvalid (slaves_axi_miso.rvalid)
  );
endmodule
