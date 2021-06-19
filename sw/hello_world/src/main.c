//#include "stddefs.h"
#include <stdint.h>

#include "murax.h"

int test2 = 0;
volatile uint32_t *dram = (uint32_t *)0x90000000;

void delay(uint32_t loops){
	for(int i=0;i<loops;i++){
    test2++;
    *(dram) = (uint32_t)test2;
	}
}

void main() {
  //println("hello world arty a7 v1");
  const int nleds = 4;
  const int nloops = 2000000;

  while(1){
    for(unsigned int i=0;i<nleds-1;i++){
      delay(nloops);
      *(dram) = (uint32_t)test2;
    }
  }
}

void irqCallback(){
}
