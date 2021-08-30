#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "tile_slave_utils.h"
#include "ravenoc_utils.h"
#include "encoding.h"

volatile uint32_t* const printf_buffer = (uint32_t*) VERILATOR_PRINT;

void setup_irqs(){
  uint32_t mstatus_csr = read_csr(mstatus); // @suppress("Symbol is not resolved")
  write_csr(mstatus, mstatus_csr | MSTATUS_MIE); // @suppress("Symbol is not resolved")
  write_csr(mie, (1 << IRQ_M_EXT)); // @suppress("Symbol is not resolved")
}

noc_pkt_u pkt;

uint32_t data[128];
uint8_t indexT = 0;
uint8_t lock = 0;
uint32_t payload;

void clean_prev_noc(){
  uint32_t pkt;
  while (*RaveNoC_buf_st != 0){
    pkt = *RaveNoC_rd_buffer;
  }
}

size_t _write(int fildes, const void *buf, size_t nbyte) {
    const uint8_t* cbuf = (const uint8_t*) buf;
    for (size_t i = 0; i < nbyte; ++i) {
      *printf_buffer = cbuf[i];
    }
    return nbyte;
}

int main(void) {
  setup_irqs();
  clean_prev_noc();

  while(1) {
    for (int y=0;y<4;y++){
      for (int x=0;x<4;x++){
        if ((x == 0) && (y == 0)) {
          pkt.st.x_dest = x;
          pkt.st.y_dest = y;
        }
        else {
          pkt.st.x_dest = x;
          pkt.st.y_dest = y;
          payload = (uint32_t) _asmPktNoC(pkt.st);
          *RaveNoC_wr_buffer = payload;
          lock = 1;
          /*while(lock);*/
        }
      }
    }
    while(1);
  }
}

void irq_callback() {
  uint32_t buffer = *RaveNoC_rd_buffer;

  printf("NoC pkt received: 0x%x\n", (unsigned int)buffer);
  data[indexT++] = buffer;
  lock = 0;
}
