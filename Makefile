
# Source files

SRCDIR_COMMON            = c64/aliases
SRCDIR_BASIC_COMMON      = $(SRCDIR_COMMON) c64/basic
SRCDIR_KERNAL_COMMON     = $(SRCDIR_COMMON) c64/kernal c64/kernal/jumptable c64/kernal/iec c64/kernal/interrupts

SRCDIR_BASIC_generic     = $(SRCDIR_BASIC_COMMON) c64/basic/,target_generic
SRCDIR_BASIC_mega65      = $(SRCDIR_BASIC_COMMON) c64/basic/,target_mega65
SRCDIR_BASIC_ultimate64  = $(SRCDIR_BASIC_COMMON) c64/basic/,target_ultimate64

SRCDIR_KERNAL_generic    = $(SRCDIR_KERNAL_COMMON) c64/kernal/,target_generic
SRCDIR_KERNAL_mega65     = $(SRCDIR_KERNAL_COMMON) c64/kernal/,target_mega65
SRCDIR_KERNAL_ultimate64 = $(SRCDIR_KERNAL_COMMON) c64/kernal/,target_ultimate64

SRC_TOOLS  = $(wildcard src/tools/*.c,src/tools/*.cc)

# Generated files

GEN_BASIC  = build/,generated/packed_messages.s
GEN_KERNAL =

# List of tools

TOOL_COLLECT_DATA   = build/tools/collect_data
TOOL_COMPRESS_TEXT  = build/tools/compress_text
TOOL_PNGPREPARE     = build/tools/pngprepare
TOOL_BUILD_SEGMENT  = build/tools/build_segment
TOOL_SIMILARITY     = build/tools/similarity
TOOL_ASSEMBLER      = assembler/KickAss.jar

TOOLS_LIST = $(pathsubst src/tools/%,build/tools/%,$(basename $(SRC_TOOLS)))

# List of targets

STD_TARGET_LIST = build/kernal_generic.rom build/basic_generic.rom \
                  build/kernal_mega65.rom build/basic_mega65.rom \
                  build/kernal_ultimate64.rom build/basic_ultimate64.rom \
                  build/chargen.rom

EXT_TARGET_LIST = build/newc65.rom

REL_TARGET_LIST = $(pathsubst build/%,bin/%, $(STD_TARGET_LIST))

# GIT commit

GIT_COMMIT:= $(shell git log -1 --pretty='%h' | tr '[:lower:]' '[:upper:]')

# Rules - main

.PHONY: all clean updatebin

all: $(STD_TARGET_LIST) $(EXT_TARGET_LIST)

clean:
	@rm -rf build

updatebin: $(STD_TARGET_LIST)
	cp build/chargen.rom              bin/chargen.rom
	cp build/basic_generic.rom        bin/basic_generic.rom
	cp build/kernal_generic.rom       bin/kernal_generic.rom
	cp build/basic_mega65.rom         bin/basic_mega65.rom
	cp build/kernal_mega65.rom        bin/kernal_mega65.rom
	cp build/basic_ultimate64.rom     bin/basic_ultimate64.rom
	cp build/kernal_ultimate64.rom    bin/kernal_ultimate64.rom

# Rules - tools

$(TOOL_PNGPREPARE): src/pngprepare.c Makefile
	@mkdir -p build/tools
	$(CC) -O2 -Wall -I/usr/local/include -L/usr/local/lib -o $@ $< -lpng

$(TOOL_COMPRESS_TEXT): src/compress_text.c Makefile
	@mkdir -p build/tools
	$(CC) -O2 -Wall -I/usr/local/include -L/usr/local/lib -o $@ $< -lm

build/tools/%: src/%.c Makefile
	@mkdir -p build/tools
	$(CC) -O2 -Wall -o $@ $<

build/tools/%: src/%.cc Makefile
	@mkdir -p build/tools
	$(CXX) -O2 -Wall -o $@ $<

# Rules - CHARGEN

build/chargen.rom: $(TOOL_PNGPREPARE) assets/8x8font.png
	$(TOOL_PNGPREPARE) charrom assets/8x8font.png build/chargen.rom

# Dependencies - BASIC and KERNAL

build/target_generic/OUTB.BIN    build/target_generic/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_BASIC)  $(SRCDIR_BASIC_generic) \
    c64/,,config_generic.s    $(foreach dir,$(SRCDIR_BASIC_generic),$(wildcard $(dir)/*.s))
build/target_mega65/OUTB.BIN     build/target_mega65/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_BASIC)  $(SRCDIR_BASIC_mega65) \
    c64/,,config_mega65.s     $(foreach dir,$(SRCDIR_BASIC_mega65),$(wildcard $(dir)/*.s))
build/target_ultimate64/OUTB.BIN build/target_ultimate64/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_BASIC)  $(SRCDIR_BASIC_ultimate64) \
    c64/,,config_ultimate64.s $(foreach dir,$(SRCDIR_BASIC_ultimate64),$(wildcard $(dir)/*.s))

build/target_generic/OUTK.BIN    build/target_generic/KERNAL_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_KERNAL) $(SRCDIR_KERNAL_generic) \
    c64/,,config_generic.s    $(foreach dir,$(SRCDIR_KERNAL_generic),$(wildcard $(dir)/*.s))
build/target_mega65/OUTK.BIN     build/target_mega65/KERNAL_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_KERNAL) $(SRCDIR_KERNAL_mega65) \
    c64/,,config_mega65.s     $(foreach dir,$(SRCDIR_KERNAL_mega65),$(wildcard $(dir)/*.s))
build/target_ultimate64/OUTK.BIN build/target_ultimate64/KERNAL_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(GEN_KERNAL) $(SRCDIR_KERNAL_ultimate64) \
    c64/,,config_ultimate64.s $(foreach dir,$(SRCDIR_KERNAL_ultimate64),$(wildcard $(dir)/*.s))

build/target_generic/newrom:      build/target_generic/OUTB.BIN     build/target_generic/OUTK.BIN
build/target_mega65/newrom:       build/target_mega65/OUTB.BIN      build/target_mega65/OUTK.BIN
build/target_ultimate64/newrom:   build/target_ultimate64/OUTB.BIN  build/target_ultimate64/OUTK.BIN

build/kernal_generic.rom:         build/target_generic/newrom
build/kernal_mega65.rom:          build/target_mega65/newrom
build/kernal_ultimate64.rom:      build/target_ultimate64/newrom

build/basic_generic.rom:          build/target_generic/newrom
build/basic_mega65.rom:           build/target_mega65/newrom
build/basic_ultimate64.rom:       build/target_ultimate64/newrom

build/symbols_generic.vs:         build/target_generic/BASIC_combined.vs    build/target_generic/KERNAL_combined.vs
build/symbols_mega65.vs:          build/target_generic/BASIC_mega65.vs      build/target_generic/KERNAL_mega65.vs
build/symbols_ultimate64.vs:      build/target_ultimate64/BASIC_combined.vs build/target_ultimate64/KERNAL_combined.vs

# Rules - BASIC and KERNAL

build/,generated/packed_messages.s: $(TOOL_COMPRESS_TEXT)
	@mkdir -p build/,generated
	$(TOOL_COMPRESS_TEXT) > build/,generated/packed_messages.s

.PRECIOUS: build/target_%/OUTB.BIN build/target_%/BASIC_combined.vs
build/target_%/OUTB.BIN build/target_%/BASIC_combined.vs:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/BASIC*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -s BASIC -i BASIC-$* -o OUTB.BIN -d build/target_$* -l a000 -h e4d2 c64/,,config_$*.s $(SRCDIR_BASIC_$*) $(GEN_BASIC)

.PRECIOUS: build/target_%/OUTK.BIN build/target_%/KERNAL_combined.vs
build/target_%/OUTK.BIN build/target_%/KERNAL_combined.vs:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/KERNAL*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -s KERNAL -i KERNAL-$* -o OUTK.BIN -d build/target_$* -l e4d3 -h ffff c64/,,config_$*.s $(SRCDIR_KERNAL_$*) $(GEN_KERNAL)

.PRECIOUS: build/target_%/newrom
build/target_%/newrom:
	cat build/target_$*/OUTB.BIN build/target_$*/OUTK.BIN > $@

.PRECIOUS: build/kernal_%.rom
build/kernal_%.rom:
	dd if=build/target_$*/newrom bs=8192 count=1 skip=2 of=$@

.PRECIOUS: build/basic_%.rom
build/basic_%.rom:
	dd if=build/target_$*/newrom bs=8192 count=1 skip=0 of=$@

.PRECIOUS: build/symbols_%.vs
build/symbols_%.vs:
	sort build/target_$*/BASIC_combined.vs build/target_$*/KERNAL_combined.vs | uniq > $@

# Rules - platform 'Mega 65' specific

build/newc65.rom: build/kernal_mega65.rom build/basic_mega65.rom build/chargen.rom Makefile
	dd if=/dev/zero bs=4096 count=10 of=build/newc65.rom
	cat build/basic_mega65.rom build/chargen.rom build/chargen.rom build/kernal_mega65.rom >> build/newc65.rom
	dd if=/dev/zero bs=65536 count=1 of=build/padding
	cat build/padding >> build/newc65.rom
	rm -f build/padding

# Rules - tests

.PHONY: test test_generic test_mega65 test_ultimate64 test_m65 testremote testsimilarity

test: test_generic

test_generic: build/kernal_generic.rom build/basic_generic.rom build/symbols_generic.vs
	x64 -kernal build/kernal_generic.rom -basic build/basic_generic.rom -moncommands build/symbols_generic.vs -8 empty.d64

test_mega65: build/kernal_mega65.rom build/basic_mega65.rom build/symbols_mega65.vs
	x64 -kernal build/kernal_mega65.rom -basic build/basic_mega65.rom -moncommands build/symbols_mega65.vs -8 empty.d64

test_ultimate64: build/kernal_ultimate64.rom build/basic_ultimate64.rom build/symbols_ultimate64.vs
	x64 -kernal build/kernal_ultimate64.rom -basic build/basic_ultimate64.rom -moncommands build/symbols_ultimate64.vs -8 empty.d64

test_m65: build/newc65
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R build/newc65.rom -4

testremote: build/kernal_generic.rom build/basic_generic.rom build/symbols_generic.vs
	x64 -kernal build/kernal_generic.rom -basic build/basic_generic.rom -moncommands build/symbols_generic.vs -remotemonitor

testsimilarity: build/target_generic/newrom $(TOOL_SIMILARITY)
	$(TOOL_SIMILARITY) kernal build/target_generic/newrom
	$(TOOL_SIMILARITY) basic  build/target_generic/newrom
