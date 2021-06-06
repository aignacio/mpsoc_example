module vexriscv_wrapper(
  input     clk,
  input     arst
);
  VexRiscv u_rv_core(
    .clk                      (clk),
    .reset                    (reset),
    .iBus_cmd_valid           (),
    .iBus_cmd_ready           (),
    .iBus_cmd_payload_pc      (),
    .iBus_rsp_valid           (),
    .iBus_rsp_payload_error   (),
    .iBus_rsp_payload_inst    (),
    .timerInterrupt           (),
    .externalInterrupt        (),
    .softwareInterrupt        (),
    .dBus_cmd_valid           (),
    .dBus_cmd_ready           (),
    .dBus_cmd_payload_wr      (),
    .dBus_cmd_payload_address (),
    .dBus_cmd_payload_data    (),
    .dBus_cmd_payload_size    (),
    .dBus_rsp_ready           (),
    .dBus_rsp_error           (),
    .dBus_rsp_data            ()
  );
endmodule
