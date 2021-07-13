module tile_slave import ravenoc_pkg::*; (
  input                 clk_core,
  input                 arst_core,
  output  s_axi_mosi_t  noc_axi_mosi,
  input   s_axi_miso_t  noc_axi_miso,
  input   s_irq_ni_t    irqs_noc
);
  s_axi_mosi_t  [1:0] masters_axi_mosi;
  s_axi_miso_t  [1:0] masters_axi_miso;

  s_axi_mosi_t  [2:0] slaves_axi_mosi;
  s_axi_miso_t  [2:0] slaves_axi_miso;

  logic boot_ff;

  always_comb begin
    noc_axi_mosi       = slaves_axi_mosi[2];
    slaves_axi_miso[2] = noc_axi_miso;
  end

  axi_rom_wrapper u_rom_rv (
    .clk      (clk_core),
    .arst     (arst_core),
    .axi_mosi (slaves_axi_mosi[0]),
    .axi_miso (slaves_axi_miso[0])
  );

  axi_mem_wrapper #(
    .MEM_KB(1)
  ) u_ram_rv (
    .clk      (clk_core),
    .arst     (arst_core),
    .axi_mosi (slaves_axi_mosi[1]),
    .axi_miso (slaves_axi_miso[1])
  );

  vexriscv_smallest_wrapper u_riscv_core (
    .clk              (clk_core),
    .arst             (arst_core),
    .ibus_axi_miso    (masters_axi_miso[0]),
    .ibus_axi_mosi    (masters_axi_mosi[0]),
    .dbus_axi_miso    (masters_axi_miso[1]),
    .dbus_axi_mosi    (masters_axi_mosi[1]),
    .irq_i            (irqs_noc.irq_trig)
  );

  axi_interconnect_wrapper #(
    .N_MASTERS (2),
    .N_SLAVES  (3),
    .M_BASE_ADDR ({32'hA000_0000, 32'h9000_0000, 32'h8000_0000}),
    .M_ADDR_WIDTH({32'd14, 32'd12, 32'd12})
  ) u_axi_intcon (
    .clk  (clk_core),
    .arst (arst_core),
    .*
  );
  // synthesis translate_off
  function automatic void writeWordIRAM(addr_val, word_val);
    /* verilator public */
    logic [31:0] addr_val;
    logic [31:0] word_val;
    //u_rom_rv.u_ram.mem[addr_val] = word_val;
  endfunction

  function automatic void writeWordDRAM(addr_val, word_val);
    /* verilator public */
    logic [31:0] addr_val;
    logic [31:0] word_val;
    u_ram_rv.u_ram.mem[addr_val] = word_val;
  endfunction

  function automatic void writeRstAddr(boot_addr);
    /* verilator public */
    logic [31:0] boot_addr;
    boot_ff = boot_addr;
  endfunction
  // synthesis translate_on
endmodule
