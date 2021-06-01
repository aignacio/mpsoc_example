RTL_FOLDERS	= cv32e40p		\
							ravenoc			\
							verilog-axi	\
							misc

SRC_VERILOG ?=	$(shell find rtl/cv32e40p/rtl/include	-type f -name *.sv)
SRC_VERILOG +=	$(shell find rtl/cv32e40p/rtl					-type f -name *.sv)
#SRC_VERILOG +=	$(shell find rtl/ravenoc/src/include	-type f -name *.svh)
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_defines.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_structs.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_axi_structs.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_pkg.sv
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_axi_fnc.svh
SRC_VERILOG +=	$(shell find rtl/ravenoc/src					-type f -name *.sv)
SRC_VERILOG +=	$(shell find rtl/verilog-axi/rtl			-type f -name *.v)
SRC_VERILOG	+=	$(shell find rtl/misc									-type f -name *.sv)

INC_VLOG		:=	rtl/cv32e40p/rtl/include	\
								rtl/ravenoc/src/include
INCS_VLOG		:=	$(addprefix +incdir+,$(INC_VLOG))

##### Verilator configuration stuff
VERILATOR_TB	:=	tb
TB_VERILATOR	:=	$(VERILATOR_TB)/testbench.cpp
IRAM_KB_SIZE	?=	8
DRAM_KB_SIZE	?=	8
OUT_VERILATOR	:=	output_verilator
ROOT_MOD_VERI	:=	simple_tile
VERILATOR_EXE	:=	$(OUT_VERILATOR)/$(ROOT_MOD_VERI)
SRC_CPP				:=	$(wildcard $(VERILATOR_TB)/*.cpp)
INC_CPP				:=	../tb/elfio
INCS_CPP			:=	$(addprefix -I,$(INC_CPP))
VERIL_FLAGS		:=	-O1 										\
									-Wno-CASEINCOMPLETE 		\
									-Wno-WIDTH							\
									-Wno-COMBDLY						\
									-Wno-UNOPTFLAT					\
									-Wno-LITENDIAN					\
									-Wno-UNSIGNED						\
									-Wno-IMPLICIT						\
									-Wno-CASEWITHX					\
									-Wno-CASEX							\
									-Wno-TIMESCALEMOD 			\
									-Wno-BLKANDNBLK					\
									-Wno-CMPCONST						\
									-Wno-MODDUP							\
									--exe										\
									--threads 4							\
									--trace 								\
									--trace-depth			10000	\
									--trace-max-array	10000	\
									--trace-max-width 10000	\
									--cc										\
									--debug
CPPFLAGS_VERI	:=	"$(INCS_CPP) -O3 -g3 -Wall 						\
									-Werror -Wno-aligned-new 							\
									-DIRAM_KB_SIZE=\"$(IRAM_KB_SIZE)\"		\
									-DDRAM_KB_SIZE=\"$(DRAM_KB_SIZE)\""
# WARN: rtls order matters in verilator compilation seq.
VERIL_ARGS		:=	-CFLAGS $(CPPFLAGS_VERI) 			\
									--top-module $(ROOT_MOD_VERI) \
									--Mdir $(OUT_VERILATOR)				\
									$(VERIL_FLAGS)								\
									$(INCS_CPP)										\
									$(INCS_VLOG)									\
									$(SRC_VERILOG) 								\
									$(SRC_CPP) 										\
									-o 														\
									$(ROOT_MOD_VERI)

.PHONY: fpga program_fpga add_lib verilator clean

all: $(VERILATOR_EXE)
	$(VERILATOR_EXE)

verilator: $(VERILATOR_EXE)
	@echo "\n"
	@echo "Emulator builded, for usage please follow:"
	@echo "\033[96m\e[1m./$(VERILATOR_EXE) myprogram.elf\033[0m"
	@echo "\n"

$(VERILATOR_EXE): $(OUT_VERILATOR)/V$(ROOT_MOD_VERI).mk
	+@make -C $(OUT_VERILATOR) -f V$(ROOT_MOD_VERI).mk

$(OUT_VERILATOR)/V$(ROOT_MOD_VERI).mk: $(SRC_VERILOG) $(SRC_CPP) $(TB_VERILATOR)
	verilator $(VERIL_ARGS)

fpga:
	fusesoc run --target=stl example:mpsoc:1.0.0

program_fpga:
	fusesoc run --target=stl --run example:mpsoc:1.0.0

add_lib:
	fusesoc library add example:mpsoc:1.0.0 .

