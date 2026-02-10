# FPGA variables
PROJECT = fpga/vga_test
SOURCES= src/project.v src/hvsync_generator.v
ICEBREAKER_DEVICE = up5k
ICEBREAKER_PIN_DEF = fpga/icebreaker.pcf
ICEBREAKER_PACKAGE = sg48
SEED = 1

# FPGA recipes
%.json: $(SOURCES)
	yosys -l fpga/yosys.log -p 'synth_ice40 -top tt_um_mattvenn_vgatest -json $(PROJECT).json' $(SOURCES)

%.asc: %.json $(ICEBREAKER_PIN_DEF) 
	nextpnr-ice40 -l fpga/nextpnr.log --seed $(SEED) --freq 20 --package $(ICEBREAKER_PACKAGE) --$(ICEBREAKER_DEVICE) --asc $@ --pcf $(ICEBREAKER_PIN_DEF) --json $<

%.bin: %.asc
	icepack $< $@

prog: $(PROJECT).bin
	iceprog $<

# general recipes

clean:
	rm -rf fpga/*log fpga/*bin

.PHONY: clean
