.PHONY: bitstream boot clean
all: help


MCC         ?= fpgacc
MCC_         = $(CROSS_COMPILE)$(MCC)
GCC_         = $(CROSS_COMPILE)gcc
CFLAGS_      = $(CFLAGS) -O3
MCC_FLAGS_   = --ompss $(MCC_FLAGS)
MCC_FLAGS_I_ = --instrument
MCC_FLAGS_D_ = --debug -g
LDFLAGS_     = $(LDFLAGS)

PROGRAM_     = dotproduct
FPGA_CLOCK  ?= 100

help:
	@echo 'Supported targets:      bitstream, boot, build, clean, $(PROGRAM_)-d, $(PROGRAM_)-i, $(PROGRAM_)-p, help'
	@echo 'Environment variables:  BOARD, CFLAGS, CROSS_COMPILE, FPGA_CLOCK, LDFLAGS, MCC, MCC_FLAGS'

build: $(PROGRAM_)-p $(PROGRAM_)-i $(PROGRAM_)-d

$(PROGRAM_)-p: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $^ -o $@ $(LDFLAGS_)

$(PROGRAM_)-i: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $(MCC_FLAGS_I_) $^ -o $@ $(LDFLAGS_)

$(PROGRAM_)-d: ./src/$(PROGRAM_).c
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $(MCC_FLAGS_D_) $^ -o $@ $(LDFLAGS_)

bitstream: ./src/$(PROGRAM_).c
	mkdir -p ${PWD}/$(BOARD)
	$(MCC_) $(CFLAGS_) $(MCC_FLAGS_) $(MCC_FLAGS_I_) --bitstream-generation \
	--Wf,"--name=$(PROGRAM_),--dir=${PWD}/$(BOARD),--board=$(BOARD),--hwruntime=som,--clock=$(FPGA_CLOCK)" \
	$^ -o $(PROGRAM_)-i $(LDFLAGS_)

boot:
	ait --name=$(PROGRAM_) --dir=${PWD}/$(BOARD) --board=$(BOARD) --hwruntime=som --clock=$(FPGA_CLOCK) --from_step=boot --to_step=boot

clean:
	rm -f *.o $(PROGRAM_)-? *:*_hls_automatic_mcxx.cpp
