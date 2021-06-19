//#include "stddefs.h"
#include <stdint.h>

volatile uint32_t *RaveNoC          = (uint32_t *)0xA0000000;
volatile uint32_t *RaveNoC_Version  = (uint32_t *)0xA0003000;
volatile uint32_t *RaveNoC_Row      = (uint32_t *)0xA0003004;
volatile uint32_t *RaveNoC_Col      = (uint32_t *)0xA0003008;
volatile uint32_t *RaveNoC_IRQ_st   = (uint32_t *)0xA000300c;
volatile uint32_t *RaveNoC_IRQ_mux  = (uint32_t *)0xA0003010;
volatile uint32_t *RaveNoC_IRQ_mask = (uint32_t *)0xA0003014;

void main() {
  int temp;
  const int nloops = 100;

  while(1){
    temp = *RaveNoC_Version;
    temp = *RaveNoC_Row;
    temp = *RaveNoC_Col;
    temp = *RaveNoC_IRQ_st;
    temp = *RaveNoC_IRQ_mux;
    temp = *RaveNoC_IRQ_mask;
  }
}

void irqCallback(){
}
