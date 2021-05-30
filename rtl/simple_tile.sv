module simple_tile(
  input core_clk,
  input arst_n,
);

  cv32e40p_core#(
    .PULP_XPULP       (0),  // PULP ISA Extension (incl. custom CSRs and hardware loop, excl. p.elw)
    .PULP_CLUSTER     (0),  // PULP Cluster interface (incl. p.elw)
    .FPU              (0),  // Floating Point Unit (interfaced via APU interface)
    .PULP_ZFINX       (0),  // Float-in-General Purpose registers
    .NUM_MHPMCOUNTERS (1)
  ) u_rv_core (
    // Clock and Reset
    .clk_i              (core_clk),
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
    .instr_req_o        (),
    .instr_gnt_i        (),
    .instr_rvalid_i     (),
    .instr_addr_o       (),
    .instr_rdata_i      (),
    // Data memory interface
    .data_req_o         (),
    .data_gnt_i         (),
    .data_rvalid_i      (),
    .data_we_o          (),
    .data_be_o          (),
    .data_addr_o        (),
    .data_wdata_o       (),
    .data_rdata_i       (),
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

endmodule
