module data_axi_if import ravenoc_pkg::*; (
  input                 clk,
  input                 arst,
  // From RV core
  input                 req_i,
  output                gnt_o,
  output                rvalid_o,
  input                 write_en_i,
  input   [3:0]         byte_en_i,
  input   [31:0]        addr_i,
  input   [31:0]        wdata_i,
  output  [31:0]        rdata_o,
  // AXI M-I/F
  output  s_axi_mosi_t  m_axi_mosi,
  input   s_axi_miso_t  m_axi_miso
);
  logic wvalid_ff, wvalid_next;

  always_comb begin
    m_axi_mosi  = '0;
    rdata_o     = '0;
    rvalid_o    = '0;
    gnt_o       = '0;

    if (req_i) begin
      if (write_en_i) begin
        m_axi_mosi.awaddr   = addr_i;
        m_axi_mosi.awvalid  = req_i;
        m_axi_mosi.awlen    = '0;
        m_axi_mosi.awburst  = INCR;
        m_axi_mosi.awsize   = 2;
      end
      else begin
        m_axi_mosi.araddr   = addr_i;
        m_axi_mosi.arvalid  = req_i;
        m_axi_mosi.arlen    = '0;
        m_axi_mosi.arburst  = INCR;
        m_axi_mosi.arsize   = 2;
      end
    end

    if (write_en_i) begin
      gnt_o = m_axi_miso.awready;
    end
    else begin
      gnt_o = m_axi_miso.arready;
    end

    m_axi_mosi.wdata  = wdata_i;
    m_axi_mosi.wstrb  = byte_en_i;
    m_axi_mosi.wvalid = wvalid_ff;

    rvalid_o = m_axi_miso.rvalid;
    if (m_axi_miso.rvalid) begin
      rdata_o = m_axi_miso.rdata;
    end

    if (wvalid_ff == '0) begin
      wvalid_next = m_axi_mosi.awvalid &
                    m_axi_miso.awready;
    end
    else begin
      wvalid_next = ~m_axi_miso.wready;
    end
  end

  always_ff @ (posedge clk or posedge arst) begin
    if (arst) begin
      wvalid_ff <= '0;
    end
    else begin
      wvalid_ff <= wvalid_next;
    end
  end
endmodule
