#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "tile_slave_utils.h"
#include "encoding.h"

#define _asmPktNoC(x)   (x.x_dest<<31 | x.y_dest<<30 | x.pkt_width<<22 | x.message)

volatile uint32_t* const RaveNoC_wr_buffer  = (uint32_t *)RAVENOC_WR_BUFFER;
volatile uint32_t* const RaveNoC_rd_buffer  = (uint32_t *)RAVENOC_RD_BUFFER;
volatile uint32_t* const RaveNoC_Version    = (uint32_t *)RAVENOC_CSR_VERS;
volatile uint32_t* const RaveNoC_Row        = (uint32_t *)RAVENOC_CSR_ROW;
volatile uint32_t* const RaveNoC_Col        = (uint32_t *)RAVENOC_CSR_COL;

uint8_t tile_row = *RaveNoC_Row;
uint8_t tile_col = *RaveNoC_Col;

typedef struct noc_pkt {
  unsigned int x_dest  : 1;
  unsigned int y_dest  : 1;
  unsigned int pkt_width : 8;
  unsigned int message : 22;
} noc_pkt;

void setup_irqs(){
  uint32_t mstatus_csr = read_csr(mstatus);
  write_csr(mstatus, mstatus_csr | MSTATUS_MIE);
  write_csr(mie, (1 << IRQ_M_EXT));
}

int main(void) {
  setup_irqs();

  while(1);
}

void irq_callback() {
  noc_pkt temp;
  temp.x_dest = 0;
  temp.y_dest = 0;
  temp.pkt_width = 0;
  temp.message = *RaveNoC_rd_buffer;
  temp.message = temp.message+1;
  //if (finished == false){
  *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(temp);
  //}
  //finished = true;
}
