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

uint32_t data[63];
uint8_t indexT = 0;

void clean_prev_noc(){
  uint32_t pkt;
  while (*RaveNoC_buf_st != 0){
    pkt = *RaveNoC_rd_buffer;
  }
}

int main(void) {
  pkt.st.x_dest = 9;
  pkt.st.y_dest = 9;
  pkt.st.pkt_width = 0;
  pkt.st.message = 0;

  setup_irqs();
  clean_prev_noc();

  while(1) {
    //for (int x=0;x<8;x++){
    //  for (int y=0;y<8;y++){
    //    if ((x == 0) && (y == 0)) {
    //      pkt.st.x_dest = x;
    //      pkt.st.y_dest = y;
    //    }
    //    else {
    //      pkt.st.x_dest = x;
    //      pkt.st.y_dest = y;
    //      *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt.st);
    //    }
    //  }
    //}

    *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt.st);
    while(true);

  };
}

void irq_callback() {
  uint32_t buffer = *RaveNoC_rd_buffer;

  //x_src = (buffer >> 15) & 3;
  //y_src = (buffer >> 12) & 3;

  data[indexT] = buffer;
  //indexT = indexT + 1;

  /*temp.st.message = buffer & 0xFFF;*/
  /*data = temp.st.message;*/
  /*temp.st.x_dest = x_src;*/
  /*temp.st.y_dest = y_src;*/
  /*temp.st.pkt_width = 0;*/

  /**RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(temp.st);*/
}
