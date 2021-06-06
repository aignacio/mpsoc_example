module simple_tile import ravenoc_pkg::*; (
  input clk_core,
  input arst_core
);
  s_axi_mosi_t  [1:0] masters_axi_mosi;
  s_axi_miso_t  [1:0] masters_axi_miso;

  s_axi_mosi_t  [2:0] slaves_axi_mosi;
  s_axi_miso_t  [2:0] slaves_axi_miso;

  logic [31:0]  inst_addr;
  logic         inst_req;
  logic         inst_gnt;
  logic         inst_rvalid;
  logic [31:0]  inst_rdata;

  logic [31:0]  data_addr;
  logic         data_req;
  logic         data_gnt;
  logic         data_rvalid;
  logic [31:0]  data_rdata;
  logic         data_we;
  logic         data_be;
  logic [31:0]  data_wdata;

  assign arst_n = ~arst_core;

  axi_mem_wrapper #(
    .MEM_KB(8)
  ) u_rom_rv (
    .clk      (clk_core),
    .arst     (arst_core),
    .axi_mosi (slaves_axi_mosi[0]),
    .axi_miso (slaves_axi_miso[0])
  );

  axi_mem_wrapper #(
    .MEM_KB(8)
  ) u_ram_rv (
    .clk      (clk_core),
    .arst     (arst_core),
    .axi_mosi (slaves_axi_mosi[1]),
    .axi_miso (slaves_axi_miso[1])
  );

  vexriscv_wrapper u_rv_core(
    .clk  (clk_core),
    .arst (arst_core)
  );

  axi_interconnect_wrapper #(
    .N_MASTERS (2),
    .N_SLAVES  (3),
    .M_BASE_ADDR ({16'h6000, 16'h4000, 16'h2000}),
    .M_ADDR_WIDTH({32'd12, 32'd13, 32'd13})
  ) u_axi_intcon (
    .clk  (clk_core),
    .arst (arst_core),
    .*
  );
endmodule
