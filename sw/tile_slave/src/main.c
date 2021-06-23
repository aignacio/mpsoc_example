#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "tile_slave_utils.h"
#include "ravenoc_utils.h"
#include "encoding.h"

tile_coord tile_xy;

void setup_irqs(){
  uint32_t mstatus_csr = read_csr(mstatus);
  write_csr(mstatus, mstatus_csr | MSTATUS_MIE);
  write_csr(mie, (1 << IRQ_M_EXT));
}

int main(void) {
  uint8_t tile_row = *RaveNoC_Row;
  uint8_t tile_col = *RaveNoC_Col;

  tile_xy.x = tile_row;
  tile_xy.y = tile_col;

  setup_irqs();

  while(1);
}

void irq_callback() {
  uint32_t temp_rd = *RaveNoC_rd_buffer;
  noc_pkt reply_pkt;

  temp_rd &= 0xFFFFF; // We remove header flit info

  // Let's implement custom simple protocol
  reply_pkt.x_dest    = 0;
  reply_pkt.y_dest    = 0;
  reply_pkt.pkt_width = 0;
  reply_pkt.message   = (uint32_t)_slaveFmtProc(tile_xy,temp_rd);

  // Send it back to the master
  *RaveNoC_wr_buffer = (uint32_t)_asmPktNoC(reply_pkt);
}
