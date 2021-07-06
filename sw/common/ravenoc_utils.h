#ifndef TILE_MASTER_UTILS_H
#define TILE_MASTER_UTILS_H

#define RAVENOC_BASE_ADDR         0xA0000000
#define VERILATOR_PRINT           0xB0000000

#define RAVENOC_WR_BUFFER         (RAVENOC_BASE_ADDR + 0x1000)
#define RAVENOC_RD_BUFFER         (RAVENOC_BASE_ADDR + 0x2000)
#define RAVENOC_CSR_BASE          (RAVENOC_BASE_ADDR + 0x3000)

#define RAVENOC_CSR_VERS          (RAVENOC_CSR_BASE + 0x00)
#define RAVENOC_CSR_ROW           (RAVENOC_CSR_BASE + 0x04)
#define RAVENOC_CSR_COL           (RAVENOC_CSR_BASE + 0x08)
#define RAVENOC_CSR_IRQ_RD_ST     (RAVENOC_CSR_BASE + 0x0c)
#define RAVENOC_CSR_IRQ_RD_MUX    (RAVENOC_CSR_BASE + 0x10)
#define RAVENOC_CSR_IRQ_RD_MASK   (RAVENOC_CSR_BASE + 0x14)

#define _asmPktNoC(x)             (x.x_dest<<29 | x.y_dest<<25 | x.pkt_width<<17 | x.message)
#define _slaveFmtProc(coord,msg)  (((msg+1) & 0x3FF) | (coord.x << 14) | (coord.y << 10))

volatile uint32_t* const RaveNoC_wr_buffer  = (uint32_t *)RAVENOC_WR_BUFFER;
volatile uint32_t* const RaveNoC_rd_buffer  = (uint32_t *)RAVENOC_RD_BUFFER;
volatile uint32_t* const RaveNoC_Version    = (uint32_t *)RAVENOC_CSR_VERS;
volatile uint32_t* const RaveNoC_Row        = (uint32_t *)RAVENOC_CSR_ROW;
volatile uint32_t* const RaveNoC_Col        = (uint32_t *)RAVENOC_CSR_COL;
volatile uint32_t* const RaveNoC_buf_st     = (uint32_t *)RAVENOC_CSR_IRQ_RD_ST;

typedef struct noc_pkt {
  unsigned int x_dest    : 3;
  unsigned int y_dest    : 4;
  unsigned int pkt_width : 8;
  unsigned int message   : 10;
} noc_pkt;

typedef union noc_pkt_u {
  noc_pkt   st;
  uint32_t  u32;
} noc_pkt_u;

typedef struct tile_coord {
  uint8_t x:3;
  uint8_t y:4;
} tile_coord;

#endif
