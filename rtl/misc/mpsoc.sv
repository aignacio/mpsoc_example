module mpsoc import ravenoc_pkg::*; (
  input   clk,
  input   arst_n,
  input   jtag_tms,
  input   jtag_tdi,
  output  jtag_tdo,
  input   jtag_tck
);
  logic arst;

  assign arst = ~arst_n;

  s_axi_mosi_t  [NoCSize-1:0] slaves_axi_mosi;
  s_axi_miso_t  [NoCSize-1:0] slaves_axi_miso;
  s_irq_ni_t    [NoCSize-1:0] irqs_noc;

  tile_master u_tile_master (
    .clk_core     (clk),
    .arst_core    (arst),
    .noc_axi_mosi (slaves_axi_mosi[0]),
    .noc_axi_miso (slaves_axi_miso[0]),
    .irqs_noc     (irqs_noc[0]),
    .jtag_tms     (jtag_tms),
    .jtag_tdi     (jtag_tdi),
    .jtag_tdo     (jtag_tdo),
    .jtag_tck     (jtag_tck)
  );

  for(genvar x=1;x<NoCSize;x++) begin : gen_tiles
    // gen_tiles__BRA__X__KET____DOT__u_tile;
    tile_slave u_tile (
      .clk_core     (clk),
      .arst_core    (arst),
      .noc_axi_mosi (slaves_axi_mosi[x]),
      .noc_axi_miso (slaves_axi_miso[x]),
      .irqs_noc     (irqs_noc[x])
    );
  end

  ravenoc #(
    .AXI_CDC_REQ('0) // Everything runs at the same clk
  ) u_noc (
    .clk_axi    ({NoCSize{clk}}),
    .clk_noc    (clk),
    .arst_axi   ({NoCSize{arst}}),
    .arst_noc   (arst),
    // NI interfaces
    .axi_mosi_if(slaves_axi_mosi),
    .axi_miso_if(slaves_axi_miso),
    // IRQs
    .irqs       (irqs_noc),
    // Used only in tb to bypass cdc module
    .bypass_cdc ('0)
  );
endmodule
