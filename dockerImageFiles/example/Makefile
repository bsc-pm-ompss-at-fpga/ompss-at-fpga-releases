.PHONY: design-p design-i design-d bitstream boot clean
all: help

PROGRAM_     = dotproduct

MCC         ?= fpgacc
MCC_         = $(CROSS_COMPILE)$(MCC)
GCC_         = $(CROSS_COMPILE)gcc
CFLAGS_      = $(CFLAGS) -O3
MCC_FLAGS_   = --ompss $(MCC_FLAGS)
MCC_FLAGS_I_ = $(MCC_FLAGS_) --instrument
MCC_FLAGS_D_ = $(MCC_FLAGS_) --debug -g
LDFLAGS_     = $(LDFLAGS)

# FPGA bitstream Variables
FPGA_HWRUNTIME ?= som
FPGA_CLOCK     ?= 100

FPGA_LINKER_FLAGS_ =--Wf,"--name=$(PROGRAM_),--board=$(BOARD),-c=$(FPGA_CLOCK),--hwruntime=$(FPGA_HWRUNTIME),--dir=${PWD}/$(BOARD)"
help:
	@echo 'Supported targets:      bitstream, design-p, design-i, design-d, boot, build, clean, $(PROGRAM_)-d, $(PROGRAM_)-i, $(PROGRAM_)-p, help'
	@echo 'Environment variables:  CFLAGS, CROSS_COMPILE, LDFLAGS, MCC, MCC_FLAGS'
	@echo 'FPGA env. variables:    BOARD, FPGA_HWRUNTIME, FPGA_CLOCK'

build: $(PROGRAM_)-p $(PROGRAM_)-i $(PROGRAM_)-d

$(PROGRAM_)-p: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $^ -o $@ $(LDFLAGS_)

$(PROGRAM_)-i: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $(MCC_FLAGS_I_) $^ -o $@ $(LDFLAGS_)

$(PROGRAM_)-d: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $(MCC_FLAGS_D_) $^ -o $@ $(LDFLAGS_)

design-p: ./src/$(PROGRAM_).c
	$(eval TMPFILE := $(shell mktemp))
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) --bitstream-generation $(FPGA_LINKER_FLAGS_) \
		--Wf,--to_step=design \
		$^ -o $(TMPFILE) $(LDFLAGS_)
	rm $(TMPFILE)

design-i: ./src/$(PROGRAM_).c
	$(eval TMPFILE := $(shell mktemp))
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_I_) --bitstream-generation $(FPGA_LINKER_FLAGS_) \
		--Wf,--to_step=design \
		$^ -o $(TMPFILE) $(LDFLAGS_)
	rm $(TMPFILE)

design-d: ./src/$(PROGRAM_).c
	$(eval TMPFILE := $(shell mktemp))
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_D_) --bitstream-generation $(FPGA_LINKER_FLAGS_) \
		--Wf,--to_step=design,--debug_intfs=both \
		$^ -o $(TMPFILE) $(LDFLAGS_)
	rm $(TMPFILE)

bitstream: ./src/$(PROGRAM_).c
	mkdir -p ${PWD}/$(BOARD)
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_I_) --bitstream-generation $(FPGA_LINKER_FLAGS_) \
	$^ -o $(PROGRAM_)-i $(LDFLAGS_)

boot: ./src/$(PROGRAM_).c
	mkdir -p ${PWD}/$(BOARD)
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_I_) --bitstream-generation $(FPGA_LINKER_FLAGS_) \
		--Wf,--from_step=boot,--to_step=boot \
	$^ -o $(PROGRAM_)-i $(LDFLAGS_)

clean:
	rm -fv *.o $(PROGRAM_)-? $(MCC_)_$(PROGRAM_)*.c *_ompss.cpp ait_$(PROGRAM_)*.json
	rm -fr $(PROGRAM_)_ait
