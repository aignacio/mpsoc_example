#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "tile_slave_utils.h"
#include "ravenoc_utils.h"
#include "encoding.h"

void setup_irqs(){
  uint32_t mstatus_csr = read_csr(mstatus);
  write_csr(mstatus, mstatus_csr | MSTATUS_MIE);
  write_csr(mie, (1 << IRQ_M_EXT));
}

noc_pkt_u pkt;

int main(void) {

  pkt.st.x_dest = 3;
  pkt.st.y_dest = 3;
  pkt.st.pkt_width = 0;
  pkt.st.message = 22;

  setup_irqs();

  while(1) {
    *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt.st);

    while(true);
  };
}

void irq_callback() {
  noc_pkt_u temp;

  temp.st.message = *RaveNoC_rd_buffer & 0xFFFF;
  temp.st.x_dest = 3;
  temp.st.y_dest = 3;
  temp.st.pkt_width = 0;
  *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(temp.st);
}
