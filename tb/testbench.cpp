#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <signal.h>
#include <cstdlib>

#include "elfio/elfio/elfio.hpp"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "verilated_fst_c.h"
#include "Vmpsoc.h"
#include "Vmpsoc__Syms.h"

#define STRINGIZE(x) #x
#define STRINGIZE_VALUE_OF(x) STRINGIZE(x)

using namespace std;

template<class module> class testbench {
  VerilatedFstC *trace = new VerilatedFstC;
  unsigned long tick_counter;
  bool getDataNextCycle;

  public:
    module *core = new module;
    bool loaded = false;

    testbench() {
      Verilated::traceEverOn(true);
      tick_counter = 0l;
    }

    ~testbench(void) {
      delete core;
      core = NULL;
    }

    virtual void reset(int rst_cyc) {
      for (int i=0;i<rst_cyc;i++) {
        core->arst_n = 0;
        this->tick();
      }
      core->arst_n = 1;
      this->tick();
    }

    virtual	void opentrace(const char *vcdname) {
      core->trace(trace, 99);
      trace->open(vcdname);
    }

    virtual void close(void) {
      if (trace) {
        trace->close();
        trace = NULL;
      }
    }

    virtual void tick(void) {
      if (getDataNextCycle) {
        getDataNextCycle = false;
        //printf("%c",core->mpsoc->getbufferReq());
      }

      //if (core->mpsoc->printfbufferReq())
        //getDataNextCycle = true;

      core->clk = 0;
      core->eval();
      tick_counter++;
      if(trace) trace->dump(tick_counter);

      core->clk = 1;
      core->eval();
      tick_counter++;
      if(trace) trace->dump(tick_counter);
    }

    virtual bool done(void) {
      return (Verilated::gotFinish());
    }
};

bool loadELF(Vmpsoc_tile_master *cpu, const char *program_path, const bool en_print){
  ELFIO::elfio program;

  program.load(program_path);

  if (program.get_class() != ELFCLASS32 ||
    program.get_machine() != 0xf3){
    cout << "\n[ERROR] Error loading ELF file, headers does not match with ELFCLASS32/RISC-V!" << endl;
    return false;
  }

  ELFIO::Elf_Half seg_num = program.segments.size();

  if (en_print){
    printf( "\n[ELF Loader]"        \
            "\nProgram path: %s"    \
            "\nNumber of segments (program headers): %d",program_path,seg_num);
  }

  for (uint8_t i = 0; i<seg_num; i++){
    const ELFIO::segment *p_seg = program.segments[i];
    const ELFIO::Elf64_Addr lma_addr = (uint32_t)p_seg->get_physical_address();
    const ELFIO::Elf64_Addr vma_addr = (uint32_t)p_seg->get_virtual_address();
    const uint32_t mem_size = (uint32_t)p_seg->get_memory_size();
    const uint32_t file_size = (uint32_t)p_seg->get_file_size();
    // const char *data_pointer = p_seg->get_data();

    if (en_print){
      printf("\nSegment [%d] - LMA[0x%x] VMA[0x%x]", i,(uint32_t)lma_addr,(uint32_t)vma_addr);
      printf("\nFile size [%d] - Memory size [%d]",file_size,mem_size);
    }

    // Notes about loading .data and .bss
    // > According to:
    // https://www.cs.bgu.ac.il/~caspl112/wiki.files/lab9/elf.pdf
    // Page 34:
    // The array element specifies a loadable segment, described by p_filesz and p_memsz.
    // The bytes from the file are mapped to the beginning of the memory segment. If the
    // segment’s memory size (p_memsz) is larger than the file size (p_filesz), the ‘‘extra’’
    // bytes are defined to hold the value 0 and to follow the segment’s initialized area. The file
    // size may not be larger than the memory size. Loadable segment entries in the program
    // header table appear in ascending order, sorted on the p_vaddr member.
    if (mem_size >= (IRAM_KB_SIZE*1024)){
      printf("\n\n[ELF Loader] ERROR:");
      printf("\nELF program: %d bytes", mem_size);
      printf("\nVerilator model memory size: %d bytes", (IRAM_KB_SIZE*1024));
      //if (lma_addr >= 0xA0000000 && lma_addr < 0xB0000000)
      //  printf("\nIncrease your verilator model IRAM by %d kb\n", (mem_size - (IRAM_KB_SIZE*1024))/1024);
      //else
      //  printf("\nIncrease your verilator model DRAM by %d kb\n", ((mem_size - (IRAM_KB_SIZE*1024))/1024)+1);
      //return false;
    }

    if (lma_addr >= 0x80000000 && lma_addr <0x80001FFF){
      int init_addr = (lma_addr-0x80000000);

      // IRAM Address
      if (en_print) printf("\nIRAM address space");
      for (uint32_t p = 0; p < mem_size; p+=4){
        uint32_t word_line = ((uint8_t)p_seg->get_data()[p+3]<<24)+((uint8_t)p_seg->get_data()[p+2]<<16)+
                             ((uint8_t)p_seg->get_data()[p+1]<<8)+(uint8_t)p_seg->get_data()[p];
        // If the whole word is zeroed, we don't write as it might overlap other regions
        if (word_line == 0x00) {
          printf("\nSkipping to write this word-line (all zeros) - IRAM = %8x - %8x", init_addr+p, word_line);
        }
        else {
          if (en_print)
            printf("\nIRAM = %8x - %8x", init_addr+p, word_line);
          cpu->writeWordIRAM((p+init_addr)/4,word_line);
        }
      }
    }
    else {
      // DRAM Address
      if (en_print) printf("\nDRAM address space");
        for (uint32_t p = 0; p < mem_size; p+=4){
          uint32_t word_line;
          if (p >= file_size) {
            word_line = 0;
          }
          else {
            word_line = ((uint8_t)p_seg->get_data()[p+3]<<24)+((uint8_t)p_seg->get_data()[p+2]<<16)+
                        ((uint8_t)p_seg->get_data()[p+1]<<8)+(uint8_t)p_seg->get_data()[p];
          }
          // if (en_print) printf("\nDRAM = %8x - %8x", p, word_line);
          cpu->writeWordDRAM(p/4,word_line);
      }
    }
  }

  ELFIO::Elf64_Addr entry_point = program.get_entry();

  if(en_print) printf("\nEntry point: %8x", (uint32_t) entry_point);

  cpu->writeRstAddr((uint32_t) entry_point);
  cout << endl << endl;
  return true;
}

int main(int argc, char** argv, char** env){
  Verilated::commandArgs(argc, argv);
  auto *dut = new testbench<Vmpsoc>;
  int test = atoi(argv[2]);
  //int tile = atoi(argv[3]);

  cout << "\n[RISCV SoC] Emulator started";

  if (EN_FST)
    dut->opentrace(STRINGIZE_VALUE_OF(WAVEFORM_FST));
  cout << "\n[Waveform File] " << STRINGIZE_VALUE_OF(WAVEFORM_FST) << "\n";

  dut->reset(1); // We wait some time for the initial inside the RAM to clear the memory

  //for (int i=0;i<4;i++) {
  //  switch(i) {
	//    case 0: loadELF(dut->core->mpsoc->gen_tiles__BRA__0__KET____DOT__u_tile_slave, argv[1], true);
	//    case 1: loadELF(dut->core->mpsoc->gen_tiles__BRA__1__KET____DOT__u_tile_slave, argv[1], true);
	//    case 2: loadELF(dut->core->mpsoc->gen_tiles__BRA__2__KET____DOT__u_tile_slave, argv[1], true);
  //    case 3: loadELF(dut->core->mpsoc->gen_tiles__BRA__3__KET____DOT__u_tile_slave, argv[1], true);
  //  }
  //}

  if (!loadELF(dut->core->mpsoc->u_tile_master, argv[1], true))
    exit(1);

  dut->reset(10);

  while(test--) {
	  dut->tick();
  }
  dut->close();
  exit(EXIT_SUCCESS);
}

static vluint64_t  cpuTime = 0;

double sc_time_stamp (){
    return cpuTime;
}
