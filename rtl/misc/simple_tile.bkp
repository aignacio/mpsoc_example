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

  cv32e40p_core#(
    .PULP_XPULP       (0),  // PULP ISA Extension (incl. custom CSRs and hardware loop, excl. p.elw)
    .PULP_CLUSTER     (0),  // PULP Cluster interface (incl. p.elw)
    .FPU              (0),  // Floating Point Unit (interfaced via APU interface)
    .PULP_ZFINX       (0),  // Float-in-General Purpose registers
    .NUM_MHPMCOUNTERS (1)
  ) u_rv_core (
    // Clock and Reset
    .clk_i              (clk_core),
    .rst_ni             (arst_n),
    .pulp_clock_en_i    ('0),  // PULP clock enable (only used if PULP_CLUSTER = 1)
    .scan_cg_en_i       ('0),  // Enable all clock gates for testing
    // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
    .boot_addr_i        ('0),
    .mtvec_addr_i       ('0),
    .dm_halt_addr_i     ('0),
    .hart_id_i          ('0),
    .dm_exception_addr_i('0),
    // Instruction memory interface
    .instr_req_o        (inst_req),
    .instr_gnt_i        (inst_gnt),
    .instr_rvalid_i     (inst_rvalid),
    .instr_addr_o       (inst_addr),
    .instr_rdata_i      (inst_rdata),
    // Data memory interface
    .data_req_o         (data_req),
    .data_gnt_i         (data_gnt),
    .data_rvalid_i      (data_rvalid),
    .data_we_o          (data_we),
    .data_be_o          (data_be),
    .data_addr_o        (data_addr),
    .data_wdata_o       (data_wdata),
    .data_rdata_i       (data_rdata),
    // apu-interconnect
    // handshake signals
    .apu_req_o          (),
    .apu_gnt_i          ('0),
    // request channel
    .apu_operands_o     (),
    .apu_op_o           (),
    .apu_flags_o        (),
    // response channel
    .apu_rvalid_i       ('0),
    .apu_result_i       ('0),
    .apu_flags_i        ('0),
    // Interrupt inputs
    .irq_i              ('0),  // CLINT interrupts + CLINT extension interrupts
    .irq_ack_o          (),
    .irq_id_o           (),
    // Debug Interface
    .debug_req_i        ('0),
    .debug_havereset_o  (),
    .debug_running_o    (),
    .debug_halted_o     (),
    // CPU Control Signals
    .fetch_enable_i     ('0),
    .core_sleep_o       ()
  );

  inst_axi_if u_instr_rv_axi (
    // From RV core
    .req_i      (inst_req),
    .gnt_o      (inst_gnt),
    .rvalid_o   (inst_rvalid),
    .addr_i     (inst_addr),
    .rdata_o    (inst_rdata),
    // AXI M-I/F
    .m_axi_mosi (masters_axi_mosi[0]),
    .m_axi_miso (masters_axi_miso[0])
  );

  data_axi_if u_data_rv_axi (
    .clk        (clk_core),
    .arst       (arst_core),
    // From RV core
    .req_i      (data_req),
    .gnt_o      (data_gnt),
    .rvalid_o   (data_rvalid),
    .write_en_i (data_we),
    .byte_en_i  (data_be),
    .addr_i     (data_addr),
    .wdata_i    (data_wdata),
    .rdata_o    (data_rdata),
    // AXI M-I/F
    .m_axi_mosi (masters_axi_mosi[1]),
    .m_axi_miso (masters_axi_miso[1])
  );

  axi_interconnect_wrapper #(
    .N_MASTERS (2),
    .N_SLAVES  (3),
    .BASE_ADDR ({16'h6000, 16'h4000, 16'h2000}),
    .ADDR_WIDTH({32'd12, 32'd13, 32'd13})
  ) u_axi_intcon (
    .clk  (clk_core),
    .arst (arst_core),
    .*
  );
endmodule
