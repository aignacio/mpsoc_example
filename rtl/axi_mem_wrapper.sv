module axi_mem_wrapper import ravenoc_pkg::*; #(
  parameter MEM_KB = 4
)(
  input                 clk,
  input                 arst,
  input   s_axi_mosi_t  axi_mosi,
  output  s_axi_miso_t  axi_miso
);
  localparam ADDR_RAM = clog2((MEM_KB*1024)/4);

  axi_ram #(
    // Width of data bus in bits
    .DATA_WIDTH(32),
    // Width of address bus in bits
    .ADDR_WIDTH(ADDR_RAM),
    // Width of ID signal
    .ID_WIDTH(1),
    // Extra pipeline register on output
    .PIPELINE_OUTPUT(1)
  ) u_ram (
    .clk          (clk),
    .rst          (arst),
    .s_axi_awid   (axi_mosi.awid),
    .s_axi_awaddr (axi_mosi.awaddr),
    .s_axi_awlen  (axi_mosi.awlen),
    .s_axi_awsize (axi_mosi.awsize),
    .s_axi_awburst(axi_mosi.awburst),
    .s_axi_awlock (axi_mosi.awlock),
    .s_axi_awcache(axi_mosi.awcache),
    .s_axi_awprot (axi_mosi.awprot),
    .s_axi_awvalid(axi_mosi.awvalid),
    .s_axi_awready(axi_miso.awready),
    .s_axi_wdata  (axi_mosi.wdata),
    .s_axi_wstrb  (axi_mosi.wstrb),
    .s_axi_wlast  (axi_mosi.wlast),
    .s_axi_wvalid (axi_mosi.wvalid),
    .s_axi_wready (axi_miso.wready),
    .s_axi_bid    (axi_miso.bid),
    .s_axi_bresp  (axi_miso.bresp),
    .s_axi_bvalid (axi_miso.bvalid),
    .s_axi_bready (axi_mosi.bready),
    .s_axi_arid   (axi_mosi.arid),
    .s_axi_araddr (axi_mosi.araddr),
    .s_axi_arlen  (axi_mosi.arlen),
    .s_axi_arsize (axi_mosi.arsize),
    .s_axi_arburst(axi_mosi.arburst),
    .s_axi_arlock (axi_mosi.arlock),
    .s_axi_arcache(axi_mosi.arcache),
    .s_axi_arprot (axi_mosi.arprot),
    .s_axi_arvalid(axi_mosi.arvalid),
    .s_axi_arready(axi_miso.arready),
    .s_axi_rid    (axi_miso.rid),
    .s_axi_rdata  (axi_miso.rdata),
    .s_axi_rresp  (axi_miso.rresp),
    .s_axi_rlast  (axi_miso.rlast),
    .s_axi_rvalid (axi_miso.rvalid),
    .s_axi_rready (axi_mosi.rready)
  );
endmodule
