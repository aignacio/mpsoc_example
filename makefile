RTL_FOLDERS	= cv32e40p		\
							ravenoc			\
							verilog-axi	\
							misc

#SRC_VERILOG ?=	$(shell find rtl/cv32e40p/rtl/include	-type f -name *.sv)
#SRC_VERILOG +=	$(shell find rtl/cv32e40p/bhv/include	-type f -name *.sv)
#SRC_VERILOG +=	$(shell find rtl/cv32e40p/rtl					-type f -name *.sv)
# Adding custom NoC cfg
SRC_VERILOG ?=	rtl/misc/ravenoc_defines.svh
# We need to manually add this seq. of files due to verilator order enforcement for
# compiling all together
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_structs.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_axi_structs.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_axi_fnc.svh
SRC_VERILOG +=	rtl/ravenoc/src/include/ravenoc_pkg.sv
SRC_VERILOG +=	$(shell find rtl/ravenoc/src								-type f -iname *.sv)
SRC_VERILOG +=	$(shell find rtl/verilog-axi/rtl						-type f -iname *.v)
SRC_VERILOG	+=	$(shell find rtl/misc												-type f -iname *.sv)
SRC_VERILOG	+=	$(shell find rtl/misc												-type f -iname *.v)
SRC_VERILOG	+=	$(shell find sw/tile_slave/									-type f -iname *.sv)

INC_VLOG		:=	rtl/ravenoc/src/include
INCS_VLOG		:=	$(addprefix -I,$(INC_VLOG))

##### Verilator configuration stuff
VERILATOR_TB	:=	tb
TB_VERILATOR	:=	$(VERILATOR_TB)/testbench.cpp
IRAM_KB_SIZE	?=	8
DRAM_KB_SIZE	?=	8
OUT_VERILATOR	:=	output_verilator
ROOT_MOD_VERI	:=	mpsoc
VERILATOR_EXE	:=	$(OUT_VERILATOR)/$(ROOT_MOD_VERI)
WAVEFORM_FST	?=	/tmp/waves.fst
EN_FST				?=	1
SRC_CPP				:=	$(wildcard $(VERILATOR_TB)/*.cpp)
INC_CPP				:=	../tb/elfio
INCS_CPP			:=	$(addprefix -I,$(INC_CPP))
VERIL_FLAGS		:=	-O3 										\
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
									-Wno-UNOPTTHREADS				\
									--coverage							\
									--exe										\
									--threads 4							\
									--trace 								\
									--trace-depth			10000	\
									--trace-structs					\
									--trace-fst							\
									--trace-max-array	10000	\
									--trace-max-width 10000	\
									--cc
									#--debug
CPPFLAGS_VERI	:=	"$(INCS_CPP) -O3 -g3 -Wall 						\
									-Werror																\
									-DIRAM_KB_SIZE=\"$(IRAM_KB_SIZE)\"		\
									-DDRAM_KB_SIZE=\"$(DRAM_KB_SIZE)\"		\
									-DWAVEFORM_FST=\"$(WAVEFORM_FST)\" 		\
									-DEN_FST=\"$(EN_FST)\"								\
									-Wunknown-warning-option"
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

.PHONY: fpga program_fpga add_lib verilator clean help
help:
	@echo "Rules list:"
	@echo "all					- build MPSoC"
	@echo "wave					- waveform vcd open"
	@echo "fpga					- generate fpga bitstream through fusesoc"
	@echo "program_fpga - run fusesoc only to pgm the board"

wave: $(WAVEFORM_FST)
	/Applications/gtkwave.app/Contents/Resources/bin/gtkwave $(WAVEFORM_FST) tmpl.gtkw

clean:
	rm -rf $(OUT_VERILATOR)

all: $(VERILATOR_EXE)
	$(VERILATOR_EXE)

verilator: $(VERILATOR_EXE)
	@echo "\n"
	@echo "Emulator builded, for usage please follow:"
	@echo "\033[96m\e[1m./$(VERILATOR_EXE) myprogram.elf\033[0m"
	@echo "\n"

$(VERILATOR_EXE): $(OUT_VERILATOR)/V$(ROOT_MOD_VERI).mk
	+@make -C $(OUT_VERILATOR) -f V$(ROOT_MOD_VERI).mk VM_PARALLEL_BUILDS=1

$(OUT_VERILATOR)/V$(ROOT_MOD_VERI).mk: $(SRC_VERILOG) $(SRC_CPP) $(TB_VERILATOR)
	verilator $(VERIL_ARGS)

fpga:
	fusesoc run --target=stl example:mpsoc:1.0.0

program_fpga:
	fusesoc run --target=stl --run example:mpsoc:1.0.0

add_lib:
	fusesoc library add example:mpsoc:1.0.0 .

ctags:
	ctags --extras=+q --fields=+i -n -R --exclude=.git --exclude=build --exclude=output_verilator
