module mpsoc import ravenoc_pkg::*; (
  input clk,
  input arst
);
  s_axi_mosi_t  [NoCSize-1:0] slaves_axi_mosi;
  s_axi_miso_t  [NoCSize-1:0] slaves_axi_miso;

  for(genvar x=0;x<NoCSize;x++) begin : gen_tiles
    // gen_tiles__BRA__X__KET____DOT__u_tile;
    simple_tile u_tile (
      .clk_core     (clk),
      .arst_core    (arst),
      .noc_axi_mosi (slaves_axi_mosi[x]),
      .noc_axi_miso (slaves_axi_miso[x])
    );
  end

  ravenoc #(
    .AXI_CDC_REQ('0) // Everything runs at the same clk
  ) u_noc (
    .clk_axi({NoCSize{clk}}),
    .clk_noc(clk),
    .arst_axi({NoCSize{arst}}),
    .arst_noc(arst),
    // NI interfaces
    .axi_mosi_if(slaves_axi_mosi),
    .axi_miso_if(slaves_axi_miso),
    // IRQs
    .irqs(),
    // Used only in tb to bypass cdc module
    .bypass_cdc('0)
  );
endmodule
