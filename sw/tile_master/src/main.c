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

  pkt.st.pkt_width = 0;
  pkt.st.message = 22;

  setup_irqs();

  while(1) {
    for (int x=0;x<4;x++){
      for (int y=0;y<4;y++){
        if ((x == 0) && (y == 0)) {
          pkt.st.x_dest = x;
          pkt.st.y_dest = y;
        }
        else {
          pkt.st.x_dest = x;
          pkt.st.y_dest = y;
          *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt.st);
        }
      }
    }
    while(true);
  };
}

void irq_callback() {
  noc_pkt_u temp;
  uint32_t buffer = *RaveNoC_rd_buffer;
  uint8_t x_src, y_src;

  x_src = (buffer >> 18) & 3;
  y_src = (buffer >> 16) & 3;

  temp.st.message = buffer & 0xFFFF;
  temp.st.x_dest = x_src;
  temp.st.y_dest = y_src;
  temp.st.pkt_width = 0;
  //*RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(temp.st);
}
