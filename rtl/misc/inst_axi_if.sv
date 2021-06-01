module inst_axi_if import ravenoc_pkg::*; (
  // From RV core
  input   [31:0]        addr_i,
  input                 req_i,
  output                gnt_o,
  output                rvalid_o,
  output  [31:0]        rdata_o,
  // AXI M-I/F
  output  s_axi_mosi_t  m_axi_mosi,
  input   s_axi_miso_t  m_axi_miso
);
  always_comb begin
    m_axi_mosi = '0;
    gnt_o = m_axi_miso.arready;

    m_axi_mosi.araddr   = addr_i;
    m_axi_mosi.arvalid  = req_i;

    if (req_i) begin
      m_axi_mosi.arlen    = '0;
      m_axi_mosi.arburst  = INCR;
      m_axi_mosi.arsize   = 2; // 4-bytes
    end

    rvalid_o = m_axi_miso.rvalid;
    rdata_o = m_axi_miso.rdata;
    m_axi_mosi.rready = 'd1;
  end
endmodule
