
# Test files

TESTDISK = testsuite/testdisk.d64
TESTTAPE = testsuite/testtape-c64-pal-turbo.tap

# Source files

SRCDIR_COMMON  = c64/aliases

SRCDIR_BASIC   = $(SRCDIR_COMMON) \
                 c64/basic \
                 c64/basic/,stubs \
                 c64/basic/,stubs_math \
                 c64/basic/board_m65 \
                 c64/basic/board_x16 \
                 c64/basic/commands \
                 c64/basic/init \
                 c64/basic/math \
                 c64/basic/math_consts \
                 c64/basic/rom_revision

SRCDIR_KERNAL  = $(SRCDIR_COMMON) \
                 c64/kernal \
                 c64/kernal/,stubs \
                 c64/kernal/assets \
                 c64/kernal/board_m65 \
                 c64/kernal/board_x16 \
                 c64/kernal/iec \
                 c64/kernal/iec_fast \
                 c64/kernal/init \
                 c64/kernal/interrupts \
                 c64/kernal/iostack \
                 c64/kernal/jumptable \
                 c64/kernal/keyboard \
                 c64/kernal/memory \
                 c64/kernal/print \
                 c64/kernal/rom_revision \
                 c64/kernal/rs232 \
                 c64/kernal/screen \
                 c64/kernal/tape \
                 c64/kernal/time

SRC_BASIC  = $(foreach dir,$(SRCDIR_BASIC),$(wildcard $(dir)/*.s))
SRC_KERNAL = $(foreach dir,$(SRCDIR_KERNAL),$(wildcard $(dir)/*.s))
SRC_TOOLS  = $(wildcard tools/*.c,tools/*.cc)

# Generated files

GEN_BASIC  = build/,generated/packed_messages.s build/,generated/float_constants.s
GEN_KERNAL =

# List of build directories

DIR_CUS = build/target_custom
DIR_GEN = build/target_generic
DIR_TST = build/target_testing
DIR_M65 = build/target_mega65
DIR_U64 = build/target_ultimate64
DIR_X16 = build/target_cx16

# List of config files

CFG_CUS    = c64/,,config_custom.s 
CFG_GEN    = c64/,,config_generic.s
CFG_TST    = c64/,,config_testing.s
CFG_M65    = c64/,,config_mega65.s
CFG_U64    = c64/,,config_ultimate64.s
CFG_X16    = c64/,,config_cx16.s

# Dependencies - helper variables

DEP_BASIC  = $(SRC_BASIC)  $(SRCDIR_BASIC)  $(GEN_BASIC)
DEP_KERNAL = $(SRC_KERNAL) $(SRCDIR_KERNAL) $(GEN_KERNAL)

# List of tools

TOOL_COLLECT_DATA       = build/tools/collect_data
TOOL_COMPRESS_TEXT      = build/tools/compress_text
TOOL_GENERATE_CONSTANTS = build/tools/generate_constants
TOOL_PNGPREPARE         = build/tools/pngprepare
TOOL_BUILD_SEGMENT      = build/tools/build_segment
TOOL_RELEASE            = build/tools/release
TOOL_SIMILARITY         = build/tools/similarity
TOOL_ASSEMBLER          = assembler/KickAss.jar

TOOLS_LIST = $(pathsubst tools/%,build/tools/%,$(basename $(SRC_TOOLS)))

# List of targets

TARGET_CUS_B    = build/basic_custom.rom
TARGET_GEN_B    = build/basic_generic.rom
TARGET_TST_B    = build/basic_testing.rom
TARGET_U64_B    = build/basic_ultimate64.rom

TARGET_CUS_K    = build/kernal_custom.rom
TARGET_GEN_K    = build/kernal_generic.rom
TARGET_TST_K    = build/kernal_testing.rom
TARGET_U64_K    = build/kernal_ultimate64.rom

TARGET_M65_x    = build/mega65.rom
TARGET_X16_x    = build/cx16-dummy.rom

TARGET_LIST_CUS = $(TARGET_CUS_B) $(TARGET_CUS_K)
TARGET_LIST_GEN = $(TARGET_GEN_B) $(TARGET_GEN_K)
TARGET_LIST_TST = $(TARGET_TST_B) $(TARGET_TST_K)
TARGET_LIST_U64 = $(TARGET_U64_B) $(TARGET_U64_K)

TARGET_LIST = build/chargen.rom \
                  $(TARGET_LIST_CUS) \
                  $(TARGET_LIST_GEN) \
                  $(TARGET_LIST_TST) \
                  $(TARGET_M65_x) \
                  $(TARGET_LIST_U64) \
                  $(TARGET_X16_x)

SEG_LIST_M65 =    $(DIR_M65)/basic.seg_0  \
                  $(DIR_M65)/basic.seg_1  \
				  $(DIR_M65)/kernal.seg_0 \
				  $(DIR_M65)/kernal.seg_1

SEG_LIST_X16 =    $(DIR_X16)/basic.seg_0  \
                  $(DIR_X16)/basic.seg_1  \
				  $(DIR_X16)/kernal.seg_0 \
				  $(DIR_X16)/kernal.seg_1

REL_TARGET_LIST = $(TARGET_LIST_GEN) $(TARGET_LIST_TST) $(TARGET_M65_x) $(TARGET_LIST_U64)

# Misc strings

HYBRID_WARNING = "*** WARNING *** Distributing kernal_hybrid.rom violates both original ROM copyright and Open ROMs license!"

# GIT commit

GIT_COMMIT:= $(shell git log -1 --pretty='%h' | tr '[:lower:]' '[:upper:]')

# Rules - main

.PHONY: all clean updatebin

all:
	$(MAKE) -j64 --output-sync=target $(TARGET_LIST) $(EXT_TARGET_LIST)

clean:
	@rm -rf build c64/basic/combined.s c64/kernal/combined.s

updatebin:
	$(MAKE) -j64 --output-sync=target $(TARGET_LIST) $(TOOL_RELEASE)
	$(TOOL_RELEASE) -i ./build -o ./bin $(patsubst build/%,%,$(REL_TARGET_LIST))
	cp build/chargen.rom bin/chargen.rom

# Rules - tools

$(TOOL_PNGPREPARE): tools/pngprepare.c
	@mkdir -p build/tools
	$(CC) -O2 -Wall -I/usr/local/include -L/usr/local/lib -o $@ $< -lpng

$(TOOL_COMPRESS_TEXT): tools/compress_text.c
	@mkdir -p build/tools
	$(CC) -O2 -Wall -I/usr/local/include -L/usr/local/lib -o $@ $< -lm

build/tools/%: tools/%.c
	@mkdir -p build/tools
	$(CC) -O2 -Wall -o $@ $<

build/tools/%: tools/%.cc tools/common.h
	@mkdir -p build/tools
	$(CXX) -O2 -Wall -o $@ $<

# Rules - CHARGEN

build/chargen.rom: $(TOOL_PNGPREPARE) assets/8x8font.png
	$(TOOL_PNGPREPARE) charrom assets/8x8font.png build/chargen.rom

# Dependencies - BASIC and KERNAL

$(DIR_CUS)/OUTB_x.BIN $(DIR_CUS)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_CUS) $(DIR_CUS)/KERNAL_combined.sym
$(DIR_GEN)/OUTB_x.BIN $(DIR_GEN)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_GEN) $(DIR_GEN)/KERNAL_combined.sym
$(DIR_TST)/OUTB_x.BIN $(DIR_TST)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_TST) $(DIR_TST)/KERNAL_combined.sym
$(DIR_U64)/OUTB_x.BIN $(DIR_U64)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_U64) $(DIR_U64)/KERNAL_combined.sym

$(DIR_CUS)/OUTK_x.BIN $(DIR_CUS)/KERNAL_combined.vs $(DIR_CUS)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_CUS)
$(DIR_GEN)/OUTK_x.BIN $(DIR_GEN)/KERNAL_combined.vs $(DIR_GEN)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_GEN)
$(DIR_TST)/OUTK_x.BIN $(DIR_TST)/KERNAL_combined.vs $(DIR_TST)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_TST)
$(DIR_U64)/OUTK_x.BIN $(DIR_U64)/KERNAL_combined.vs $(DIR_U64)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_U64)

$(DIR_M65)/OUTB_0.BIN $(DIR_M65)/BASIC_0_combined.vs  $(DIR_M65)/BASIC_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym
$(DIR_M65)/OUTK_0.BIN $(DIR_M65)/KERNAL_0_combined.vs $(DIR_M65)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_M65)

$(DIR_X16)/OUTB_0.BIN $(DIR_X16)/BASIC_0_combined.vs  $(DIR_X16)/BASIC_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_X16) $(DIR_X16)/KERNAL_0_combined.sym
$(DIR_X16)/OUTK_0.BIN $(DIR_X16)/KERNAL_0_combined.vs $(DIR_X16)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_X16)

$(DIR_M65)/basic.seg_1  $(DIR_M65)/BASIC_1_combined.vs  $(DIR_M65)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym $(DIR_M65)/BASIC_0_combined.sym
$(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1_combined.vs $(DIR_M65)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym

$(DIR_X16)/basic.seg_1  $(DIR_X16)/BASIC_1_combined.vs  $(DIR_X16)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_X16) $(DIR_M65)/KERNAL_0_combined.sym $(DIR_X16)/BASIC_0_combined.sym
$(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1_combined.vs $(DIR_X16)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_X16) $(DIR_X16)/KERNAL_0_combined.sym

$(DIR_CUS)/OUTx_x.BIN:  $(DIR_CUS)/OUTB_x.BIN  $(DIR_CUS)/OUTK_x.BIN
$(DIR_GEN)/OUTx_x.BIN:  $(DIR_GEN)/OUTB_x.BIN  $(DIR_GEN)/OUTK_x.BIN
$(DIR_TST)/OUTx_x.BIN:  $(DIR_TST)/OUTB_x.BIN  $(DIR_TST)/OUTK_x.BIN
$(DIR_M65)/OUTx_0.BIN:  $(DIR_M65)/OUTB_0.BIN  $(DIR_M65)/OUTK_0.BIN
$(DIR_U64)/OUTx_x.BIN:  $(DIR_U64)/OUTB_x.BIN  $(DIR_U64)/OUTK_x.BIN
$(DIR_X16)/OUTx_0.BIN:  $(DIR_X16)/OUTB_0.BIN  $(DIR_X16)/OUTK_0.BIN

$(TARGET_CUS_B):    $(DIR_CUS)/OUTx_x.BIN
$(TARGET_GEN_B):    $(DIR_GEN)/OUTx_x.BIN
$(TARGET_TST_B):    $(DIR_TST)/OUTx_x.BIN
$(TARGET_U64_B):    $(DIR_U64)/OUTx_x.BIN

$(TARGET_CUS_K):    $(DIR_CUS)/OUTx_x.BIN
$(TARGET_GEN_K):    $(DIR_GEN)/OUTx_x.BIN
$(TARGET_TST_K):    $(DIR_TST)/OUTx_x.BIN
$(TARGET_U64_K):    $(DIR_U64)/OUTx_x.BIN

build/symbols_custom.vs:          $(DIR_CUS)/BASIC_combined.vs    $(DIR_CUS)/KERNAL_combined.vs
build/symbols_generic.vs:         $(DIR_GEN)/BASIC_combined.vs    $(DIR_GEN)/KERNAL_combined.vs
build/symbols_testing.vs:         $(DIR_TST)/BASIC_combined.vs    $(DIR_TST)/KERNAL_combined.vs
build/symbols_ultimate64.vs:      $(DIR_U64)/BASIC_combined.vs    $(DIR_U64)/KERNAL_combined.vs

# Rules - BASIC and KERNAL intermediate files

build/,generated/packed_messages.s: $(TOOL_COMPRESS_TEXT)
	@mkdir -p build/,generated
	$(TOOL_COMPRESS_TEXT) > build/,generated/packed_messages.s

build/,generated/float_constants.s: $(TOOL_GENERATE_CONSTANTS)
	@mkdir -p build/,generated
	$(TOOL_GENERATE_CONSTANTS) -o build/,generated/float_constants.s

.PRECIOUS: build/target_%/OUTB_x.BIN build/target_%/BASIC_combined.vs
build/target_%/OUTB_x.BIN build/target_%/BASIC_combined.vs:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/BASIC*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r STD -s BASIC -i BASIC-$* -o OUTB_x.BIN -d build/target_$* -l a000 -h e4d2 c64/,,config_$*.s $(SRCDIR_BASIC) $(GEN_BASIC)

.PRECIOUS: build/target_%/OUTK_x.BIN build/target_%/KERNAL_combined.vs build/target_%/KERNAL_combined.sym
build/target_%/OUTK_x.BIN build/target_%/KERNAL_combined.vs build/target_%/KERNAL_combined.sym:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/KERNAL*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r STD -s KERNAL -i KERNAL-$* -o OUTK_x.BIN -d build/target_$* -l e4d3 -h ffff c64/,,config_$*.s $(SRCDIR_KERNAL) $(GEN_KERNAL)

# Rules - BASIC and KERNAL intermediate files, for Mega65

$(DIR_M65)/OUTB_0.BIN $(DIR_M65)/BASIC_0_combined.vs $(DIR_M65)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s BASIC_0 -i BASIC_0-mega65 -o OUTB_0.BIN -d $(DIR_M65) -l a000 -h e4d2 $(CFG_M65) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_M65)/OUTK_0.BIN $(DIR_M65)/KERNAL_0_combined.vs $(DIR_M65)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s KERNAL_0 -i KERNAL_0-mega65 -o OUTK_0.BIN -d $(DIR_M65) -l e4d3 -h ffff $(CFG_M65) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_M65)/basic.seg_1 $(DIR_M65)/BASIC_1_combined.vs $(DIR_M65)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/basic.seg_1 $(DIR_M65)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s BASIC_1 -i BASIC_1-mega65 -o basic.seg_1 -d $(DIR_M65) -l 4000 -h 5fff $(CFG_M65) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1_combined.vs $(DIR_M65)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s KERNAL_1 -i KERNAL_1-mega65 -o kernal.seg_1 -d $(DIR_M65) -l 4000 -h 5fff $(CFG_M65) $(SRCDIR_KERNAL) $(GEN_KERNAL)

# Rules - BASIC and KERNAL intermediate files, for Commander X16

$(DIR_X16)/OUTB_0.BIN $(DIR_X16)/BASIC_0_combined.vs $(DIR_X16)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s BASIC_0 -i BASIC_0-mega65 -o OUTB_0.BIN -d $(DIR_X16) -l c000 -h e4d2 $(CFG_X16) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_X16)/OUTK_0.BIN $(DIR_X16)/KERNAL_0_combined.vs $(DIR_X16)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s KERNAL_0 -i KERNAL_0-mega65 -o OUTK_0.BIN -d $(DIR_X16) -l e4d3 -h ffff $(CFG_X16) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_X16)/basic.seg_1 $(DIR_X16)/BASIC_1_combined.vs $(DIR_X16)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/basic.seg_1 $(DIR_X16)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s BASIC_1 -i BASIC_1-mega65 -o basic.seg_1 -d $(DIR_X16) -l a000 -h bfff $(CFG_X16) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1_combined.vs $(DIR_X16)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s KERNAL_1 -i KERNAL_1-mega65 -o kernal.seg_1 -d $(DIR_X16) -l a000 -h bfff $(CFG_X16) $(SRCDIR_KERNAL) $(GEN_KERNAL)

# Rules - BASIC and KERNAL

.PRECIOUS: build/target_%/OUTx_x.BIN
build/target_%/OUTx_x.BIN:
	cat build/target_$*/OUTB_x.BIN build/target_$*/OUTK_x.BIN > $@

.PRECIOUS: build/kernal_%.rom
build/kernal_%.rom:
	dd if=build/target_$*/OUTx_x.BIN bs=8192 count=1 skip=2 of=$@

.PRECIOUS: build/basic_%.rom
build/basic_%.rom:
	dd if=build/target_$*/OUTx_x.BIN bs=8192 count=1 skip=0 of=$@

.PRECIOUS: build/symbols_%.vs
build/symbols_%.vs:
	sort build/target_$*/BASIC_combined.vs build/target_$*/KERNAL_combined.vs | uniq | grep -v "__" > $@

$(DIR_M65)/OUTx_0.BIN:
	cat $(DIR_M65)/OUTB_0.BIN $(DIR_M65)/OUTK_0.BIN > $@

$(DIR_M65)/kernal.seg_0: $(DIR_M65)/OUTx_0.BIN
	dd if=$(DIR_M65)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@

$(DIR_M65)/basic.seg_0: $(DIR_M65)/OUTx_0.BIN
	dd if=$(DIR_M65)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@

$(DIR_X16)/OUTx_0.BIN:
	cat $(DIR_X16)/OUTB_0.BIN $(DIR_X16)/OUTK_0.BIN > $@

$(DIR_X16)/kernal.seg_0: $(DIR_X16)/OUTx_0.BIN
	dd if=$(DIR_X16)/OUTx_0.BIN bs=8192 count=1 skip=1 of=$@

$(DIR_X16)/basic.seg_0: $(DIR_X16)/OUTx_0.BIN
	dd if=$(DIR_X16)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@

build/kernal_hybrid.rom: kernal $(DIR_GEN)/OUTK_x.BIN
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	(dd if=kernal bs=1140 count=1 skip=0        ; \
	echo "    > HYBRID ROM, DON'T DISTRIBUTE <" ; \
	dd if=kernal bs=1 count=58 skip=1176        ; \
	cat $(DIR_GEN)/OUTK_x.BIN) > $@

build/symbols_hybrid.vs: $(DIR_GEN)/KERNAL_combined.vs
	sort $(DIR_GEN)/KERNAL_combined.vs | uniq | grep -v "__" > $@

# Rules - platform 'Mega65' specific

$(TARGET_M65_x): $(SEG_LIST_M65) build/chargen.rom
	dd if=/dev/zero bs=8192 count=1 of=build/m65_padding_08_KB
	dd if=/dev/zero bs=8192 count=8 of=build/m65_padding_64_KB
	cat build/m65_padding_08_KB              > $(TARGET_M65_x)
	cat build/m65_padding_08_KB             >> $(TARGET_M65_x)
	cat $(DIR_M65)/kernal.seg_1    >> $(TARGET_M65_x)
	cat $(DIR_M65)/basic.seg_1     >> $(TARGET_M65_x)
	cat build/m65_padding_08_KB             >> $(TARGET_M65_x)
	cat $(DIR_M65)/basic.seg_0     >> $(TARGET_M65_x)
	cat build/chargen.rom                   >> $(TARGET_M65_x)
	cat build/chargen.rom                   >> $(TARGET_M65_x)
	cat $(DIR_M65)/kernal.seg_0    >> $(TARGET_M65_x)
	cat build/m65_padding_64_KB             >> $(TARGET_M65_x)
	rm -f build/m65_padding_*

# Rules - platform 'Commander X16' specific

$(TARGET_X16_x): $(SEG_LIST_X16) build/chargen.rom
	dd if=/dev/zero bs=8192 count=1 of=build/x16_padding_08_KB
	dd if=/dev/zero bs=8192 count=8 of=build/x16_padding_64_KB
	cat $(DIR_X16)/basic.seg_0      > $(TARGET_X16_x)
	cat $(DIR_X16)/kernal.seg_0    >> $(TARGET_X16_x)
	cat build/chargen.rom                 >> $(TARGET_X16_x)
	cat $(DIR_X16)/basic.seg_1     >> $(TARGET_X16_x)
	cat $(DIR_X16)/kernal.seg_1    >> $(TARGET_X16_x)
	rm -f build/x16_padding_*

# Rules - tests

.PHONY: test test_generic test_generic_x128 test_hybrid test_testing \
        test_mega65 test_mega65_xemu test_m65 \
        test_ultimate64 \
        testremote testsimilarity

test: test_custom

test_custom: build/kernal_custom.rom build/basic_custom.rom build/symbols_custom.vs
	x64 -kernal build/kernal_custom.rom -basic build/basic_custom.rom -moncommands build/symbols_custom.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_generic: build/kernal_generic.rom build/basic_generic.rom build/symbols_generic.vs
	x64 -kernal build/kernal_generic.rom -basic build/basic_generic.rom -moncommands build/symbols_generic.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_generic_x128: build/kernal_generic.rom build/basic_generic.rom build/symbols_generic.vs
	x128 -go64 -kernal64 build/kernal_generic.rom -basic64 build/basic_generic.rom -moncommands build/symbols_generic.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_testing: build/kernal_testing.rom build/basic_testing.rom build/symbols_testing.vs
	x64 -kernal build/kernal_testing.rom -basic build/basic_testing.rom -moncommands build/symbols_testing.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_ultimate64: build/kernal_ultimate64.rom build/basic_ultimate64.rom build/symbols_ultimate64.vs
	x64 -kernal build/kernal_ultimate64.rom -basic build/basic_ultimate64.rom -moncommands build/symbols_ultimate64.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_mega65: $(TARGET_M65_x)
	../xemu/build/bin/xmega65.native -dmarev 2 -forcerom -loadrom $(TARGET_M65_x)

test_cx16: $(TARGET_X16_x)
	../x16-emulator/x16emu -rom $(TARGET_X16_x)

test_hybrid: build/kernal_hybrid.rom build/symbols_hybrid.vs
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	x64 -kernal build/kernal_hybrid.rom -moncommands build/symbols_hybrid.vs -1 $(TESTTAPE) -8 $(TESTDISK)
	@echo
	@echo $(HYBRID_WARNING)
	@echo

test_m65: build/mega65.rom
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R build/mega65.rom -4

testremote: build/kernal_custom.rom build/basic_custom.rom build/symbols_custom.vs
	x64 -kernal build/kernal_custom.rom -basic build/basic_custom.rom -moncommands build/symbols_custom.vs -remotemonitor

testsimilarity: $(TOOL_SIMILARITY) $(DIR_GEN)/OUTx_x.BIN kernal basic
	$(TOOL_SIMILARITY) kernal $(DIR_GEN)/OUTx_x.BIN
	$(TOOL_SIMILARITY) basic  $(DIR_GEN)/OUTx_x.BIN
