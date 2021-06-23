//#include "stddefs.h"
#include <stdint.h>
#include <stdbool.h>

#define write_csr(reg, val) ({ \
  if (__builtin_constant_p(val) && (unsigned long)(val) < 32) \
    asm volatile ("csrw " #reg ", %0" :: "i"(val)); \
  else \
    asm volatile ("csrw " #reg ", %0" :: "r"(val)); })

#define RAVENOC_BASE_ADDR   0xA0000000
#define VERILATOR_PRINT     0xB0000000

#define RAVENOC_WR_BUFFER   (RAVENOC_BASE_ADDR + 0x1000)
#define RAVENOC_RD_BUFFER   (RAVENOC_BASE_ADDR + 0x2000)
#define RAVENOC_CSR_BASE    (RAVENOC_BASE_ADDR + 0x3000)

#define RAVENOC_CSR_VERS    (RAVENOC_CSR_BASE + 0x00)
#define RAVENOC_CSR_ROW     (RAVENOC_CSR_BASE + 0x04)
#define RAVENOC_CSR_COL     (RAVENOC_CSR_BASE + 0x08)

volatile uint32_t* const RaveNoC_wr_buffer  = (uint32_t *)RAVENOC_WR_BUFFER;
volatile uint32_t* const RaveNoC_rd_buffer  = (uint32_t *)RAVENOC_RD_BUFFER;
volatile uint32_t* const RaveNoC_Version    = (uint32_t *)RAVENOC_CSR_VERS;
volatile uint32_t* const RaveNoC_Row        = (uint32_t *)RAVENOC_CSR_ROW;
volatile uint32_t* const RaveNoC_Col        = (uint32_t *)RAVENOC_CSR_COL;

#define _asmPktNoC(x)   (x.x_dest<<31 | x.y_dest<<30 | x.pkt_width<<22 | x.message)

bool finished = false;

typedef struct noc_pkt {
  unsigned int x_dest  : 1;
  unsigned int y_dest  : 1;
  unsigned int pkt_width : 8;
  unsigned int message : 22;
} noc_pkt;

void main() {
  uint8_t tile_row = *RaveNoC_Row;
  uint8_t tile_col = *RaveNoC_Col;

  noc_pkt pkt;

  while(1){
    pkt.x_dest = 1;
    pkt.y_dest = 1;
    pkt.pkt_width = 0;
    pkt.message = 22;

    for(int i=0;i<100;i++) {
    pkt.x_dest = 1;
    pkt.y_dest = 1;
    pkt.pkt_width = 0;
    pkt.message = i;

    }

    if (tile_row == 0 && tile_col == 0){
      *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt);
      *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt);
      *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(pkt);
    }
    //write_csr(mtvec,0x80000020);
    //temp = *RaveNoC_Version;
    //temp = *RaveNoC_Row;
    //temp = *RaveNoC_Col;
    //temp = *RaveNoC_IRQ_st;
    //temp = *RaveNoC_IRQ_mux;
    //temp = *RaveNoC_IRQ_mask;
  }
}

void irqCallback(){
  noc_pkt temp;

  temp.message = *RaveNoC_rd_buffer;
  temp.message = temp.message+1;
  //if (finished == false){
  //  *RaveNoC_wr_buffer = (uint32_t) _asmPktNoC(temp);
  //}
  finished = true;
}
