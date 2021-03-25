
# Test files

TESTDISK = testsuite/testdisk.d64
TESTTAPE = testsuite/testtape-c64-pal-turbo.tap

# Source files

SRCDIR_COMMON  = src/aliases

SRCDIR_BASIC   = $(SRCDIR_COMMON) \
                 src/basic \
                 src/basic/,stubs \
                 src/basic/,stubs_math \
                 src/basic/assets \
                 src/basic/basic_commands \
                 src/basic/basic_commands_01 \
                 src/basic/basic_commands_04 \
                 src/basic/basic_operators \
                 src/basic/basic_functions \
                 src/basic/basic_functions_06 \
                 src/basic/board_crt \
                 src/basic/board_m65 \
                 src/basic/board_x16 \
                 src/basic/engine_editor \
                 src/basic/engine_runtime \
                 src/basic/engine_variables \
                 src/basic/init \
                 src/basic/math \
                 src/basic/math_consts \
                 src/basic/math_mov \
                 src/basic/memory \
                 src/basic/print \
                 src/basic/rom_revision \
                 src/basic/wedge

SRCDIR_KERNAL  = $(SRCDIR_COMMON) \
                 src/kernal \
                 src/kernal/,stubs \
                 src/kernal/assets \
                 src/kernal/board_crt \
                 src/kernal/board_m65 \
                 src/kernal/board_u64 \
                 src/kernal/board_x16 \
                 src/kernal/iec \
                 src/kernal/iec_fast \
                 src/kernal/init \
                 src/kernal/interrupts \
                 src/kernal/iostack \
                 src/kernal/jumptable \
                 src/kernal/jumptable_m65 \
                 src/kernal/keyboard \
                 src/kernal/keyboard_m65 \
                 src/kernal/memory \
                 src/kernal/print \
                 src/kernal/rom_revision \
                 src/kernal/rs232 \
                 src/kernal/screen \
                 src/kernal/screen_m65 \
                 src/kernal/tape \
                 src/kernal/time

SRCDIR_DOS_M65 = $(SRCDIR_COMMON) \
                 src/dos_m65 \
                 src/dos_m65/assets \
                 src/dos_m65/filesystem_cbm \
                 src/dos_m65/filesystem_vfs \
                 src/dos_m65/lowlevel \
                 src/dos_m65/pseudoiec \
                 src/dos_m65/unit_floppy \
                 src/dos_m65/unit_ramdisk \
                 src/dos_m65/unit_sdcard \
                 src/dos_m65/utils

SRCDIR_MON_M65 = $(SRCDIR_COMMON) \
                 src/mon_m65

SRCDIR_ZVM_M65 = $(SRCDIR_COMMON) \
                 src/zvm_m65

SRC_BASIC      = $(foreach dir,$(SRCDIR_BASIC),$(wildcard $(dir)/*.s))
SRC_KERNAL     = $(foreach dir,$(SRCDIR_KERNAL),$(wildcard $(dir)/*.s))
SRC_DOS_M65    = $(foreach dir,$(SRCDIR_DOS_M65),$(wildcard $(dir)/*.s))
SRC_MON_M65    = $(foreach dir,$(SRCDIR_MON_M65),$(wildcard $(dir)/*.s))
SRC_ZVM_M65    = $(foreach dir,$(SRCDIR_ZVM_M65),$(wildcard $(dir)/*.s))
SRC_TOOLS      = $(wildcard tools/*.c,tools/*.cc)

DIR_ACME       = 3rdparty/acme/src
HDR_ACME       = $(filter-out $(wildcard $(DIR_ACME)/_*.h),$(wildcard $(DIR_ACME)/*.h))
SRC_ACME       = $(DIR_ACME)/acme.c $(DIR_ACME)/platform.c $(DIR_ACME)/alu.c $(DIR_ACME)/typesystem.c \
                 $(DIR_ACME)/cliargs.c $(DIR_ACME)/global.c $(DIR_ACME)/output.c $(DIR_ACME)/flow.c \
                 $(DIR_ACME)/macro.c $(DIR_ACME)/cpu.c $(DIR_ACME)/encoding.c $(DIR_ACME)/pseudoopcodes.c \
                 $(DIR_ACME)/dynabuf.c $(DIR_ACME)/mnemo.c $(DIR_ACME)/input.c $(DIR_ACME)/section.c \
                 $(DIR_ACME)/symbol.c $(DIR_ACME)/tree.c

CRT_BIN_LIST   = assets/cartridge/header-cart.bin \
                 assets/cartridge/header-seg0.bin \
                 assets/cartridge/header-seg1.bin \
                 assets/cartridge/header-seg2.bin \
                 assets/cartridge/header-seg3.bin

ROM_CBM_BASIC  = 3rdparty/ROMs/basic
ROM_CBM_KERNAL = 3rdparty/ROMs/kernal

# Generated files

GEN_BASIC      = build/,generated/,float_constants.s
GEN_KERNAL     =
GEN_ZVM        = build/,generated/,z80_tables.s

# Z80 part

DIR_ZMAC       = 3rdparty/zmac/src
DIR_ZMAC_TMP   = build/,tmp_zmac
HDR_ZMAC       = $(filter-out $(wildcard $(DIR_ZMAC)/_*.h),$(wildcard $(DIR_ZMAC)/*.h))
SRC_ZMAC       = $(DIR_ZMAC)/mio.c $(DIR_ZMAC)/doc.c $(DIR_ZMAC)/zi80dis.cpp
SRC_Z80TEST    = 3rdparty/z80exer/cpm/zexdoc.src

GEN_ZMAC_C     = $(DIR_ZMAC_TMP)/zmac.c
GEN_ZMAC_H     = $(DIR_ZMAC_TMP)/doc.inl

# List of build directories

DIR_CUS        = build/target_custom
DIR_GEN        = build/target_generic
DIR_GENCRT     = build/target_generic_crt
DIR_TST        = build/target_testing
DIR_M65        = build/target_mega65
DIR_U64        = build/target_ultimate64
DIR_U64CRT     = build/target_ultimate64_crt
DIR_X16        = build/target_cx16

# List of config files

CFG_CUS        = src/,,config_custom.s 
CFG_GEN        = src/,,config_generic.s
CFG_GENCRT     = src/,,config_generic_crt.s
CFG_TST        = src/,,config_testing.s
CFG_M65        = src/,,config_mega65.s
CFG_U64        = src/,,config_ultimate64.s
CFG_X16        = src/,,config_cx16.s
CFG_U64CRT     = src/,,config_ultimate64_crt.s

# List of files with generated strings

GEN_STR_CUS    = $(DIR_CUS)/,generated/,packed_strings.s
GEN_STR_GEN    = $(DIR_GEN)/,generated/,packed_strings.s
GEN_STR_GENCRT = $(DIR_GENCRT)/,generated/,packed_strings.s
GEN_STR_TST    = $(DIR_TST)/,generated/,packed_strings.s
GEN_STR_M65    = $(DIR_M65)/,generated/,packed_strings.s
GEN_STR_U64    = $(DIR_U64)/,generated/,packed_strings.s
GEN_STR_U64CRT = $(DIR_U64CRT)/,generated/,packed_strings.s
GEN_STR_X16    = $(DIR_X16)/,generated/,packed_strings.s

# Dependencies - helper variables

DEP_BASIC      = $(SRC_BASIC)   $(SRCDIR_BASIC)   $(GEN_BASIC)
DEP_KERNAL     = $(SRC_KERNAL)  $(SRCDIR_KERNAL)  $(GEN_KERNAL)
DEP_DOS_M65    = $(SRC_DOS_M65) $(SRCDIR_DOS_M65)
DEP_MON_M65    = $(SRC_MON_M65) $(SRCDIR_MON_M65)
DEP_ZVM_M65    = $(SRC_ZVM_M65) $(SRCDIR_ZVM_M65) $(GEN_ZVM)

# List of tools

TOOL_GENERATE_CONSTANTS  = build/tools/generate_constants
TOOL_GENERATE_STRINGS    = build/tools/generate_strings
TOOL_GENERATE_Z80_TABLES = build/tools/generate_z80_tables
TOOL_PATCH_CHARGEN       = build/tools/patch_chargen
TOOL_PNGPREPARE          = build/tools/pngprepare
TOOL_BUILD_SEGMENT       = build/tools/build_segment
TOOL_RELEASE             = build/tools/release
TOOL_SIMILARITY          = build/tools/similarity
TOOL_ASSEMBLER           = build/tools/acme
TOOL_ASSEMBLER_Z80       = build/tools/zmac

TOOLS_LIST = $(TOOL_GENERATE_CONSTANTS) \
             $(TOOL_GENERATE_STRINGS) \
             $(TOOL_GENERATE_Z80_TABLES) \
             $(TOOL_PATCH_CHARGEN) \
             $(TOOL_PNGPREPARE) \
             $(TOOL_BUILD_SEGMENT) \
             $(TOOL_RELEASE) \
             $(TOOL_SIMILARITY) \
             $(TOOL_ASSEMBLER) \
             $(TOOL_ASSEMBLER_Z80)

# List of targets

TARGET_CHR_ORF     = build/chargen_openroms.rom 
TARGET_CHR_PXL     = build/chargen_pxlfont.rom 

TARGET_CUS_B       = build/basic_custom.rom
TARGET_GEN_B       = build/basic_generic.rom
TARGET_GENCRT_B    = build/basic_generic_crt.rom
TARGET_TST_B       = build/basic_testing.rom
TARGET_U64_B       = build/basic_ultimate64.rom
TARGET_U64CRT_B    = build/basic_ultimate64_crt.rom

TARGET_CUS_K       = build/kernal_custom.rom
TARGET_GEN_K       = build/kernal_generic.rom
TARGET_GENCRT_K    = build/kernal_generic_crt.rom
TARGET_TST_K       = build/kernal_testing.rom
TARGET_U64_K       = build/kernal_ultimate64.rom
TARGET_U64CRT_K    = build/kernal_ultimate64_crt.rom

TARGET_GENCRT_X    = build/extrom_generic_crt.crt 
TARGET_U64CRT_X    = build/extrom_ultimate64_crt.crt 

TARGET_M65_x_ORF   = build/mega65_orfont.rom
TARGET_M65_x_PXL   = build/mega65.rom
TARGET_X16_x       = build/cx16-dummy.rom

TARGET_LIST_CUS    = $(TARGET_CUS_B) $(TARGET_CUS_K)
TARGET_LIST_GEN    = $(TARGET_GEN_B) $(TARGET_GEN_K)
TARGET_LIST_GENCRT = $(TARGET_GENCRT_B) $(TARGET_GENCRT_K) $(TARGET_GENCRT_X)
TARGET_LIST_TST    = $(TARGET_TST_B) $(TARGET_TST_K)
TARGET_LIST_U64    = $(TARGET_U64_B) $(TARGET_U64_K)
TARGET_LIST_U64CRT = $(TARGET_U64CRT_B) $(TARGET_U64CRT_K) $(TARGET_U64CRT_X)

TARGET_Z80TEST     = ./build/cpm/Z80TEST.COM

TARGET_LIST        = $(TARGET_CHR_ORF)     \
                     $(TARGET_LIST_CUS)    \
                     $(TARGET_LIST_GEN)    \
                     $(TARGET_LIST_GENCRT) \
                     $(TARGET_LIST_TST)    \
                     $(TARGET_M65_x_ORF)   \
                     $(TARGET_M65_x_PXL)   \
                     $(TARGET_LIST_U64)    \
                     $(TARGET_LIST_U64CRT) \
                     $(TARGET_X16_x)

SEG_LIST_GENCRT    = $(DIR_GENCRT)/basic.seg_1  \
                     $(DIR_GENCRT)/kernal.seg_1

SEG_LIST_U64CRT    = $(DIR_U64CRT)/basic.seg_1  \
                     $(DIR_U64CRT)/kernal.seg_1

SEG_LIST_M65       = $(DIR_M65)/basic.seg_0  \
                     $(DIR_M65)/basic.seg_1  \
                     $(DIR_M65)/kernal.seg_0 \
                     $(DIR_M65)/kernal.seg_C \
                     $(DIR_M65)/kernal.seg_1 \
                     $(DIR_M65)/dos.seg_1    \
                     $(DIR_M65)/mon.seg_1    \
                     $(DIR_M65)/zvm.seg_1

SEG_LIST_X16       = $(DIR_X16)/basic.seg_0  \
                     $(DIR_X16)/basic.seg_1  \
                     $(DIR_X16)/kernal.seg_0 \
                     $(DIR_X16)/kernal.seg_1

REL_TARGET_LIST    = $(TARGET_LIST_GEN)    \
                     $(TARGET_LIST_GENCRT) \
                     $(TARGET_M65_x_ORF)   \
                     $(TARGET_M65_x_PXL)   \
                     $(TARGET_LIST_U64)

# Misc strings

HYBRID_WARNING = "*** WARNING *** Distributing kernal_hybrid.rom violates both original ROM copyright and Open ROMs license!"

# GIT commit

GIT_COMMIT:= $(shell git log -1 --pretty='%h' | tr '[:lower:]' '[:upper:]')

# Rules - main - XXX building ROMs in parallel sometimes fails - most likely due to rules producing multiple targets

.PHONY: all clean updatebin

all:
	@$(MAKE) -s $(DIR_ACME) $(SRC_ACME)
	@$(MAKE) -s -j`nproc` --output-sync=target $(TOOLS_LIST)
	@$(MAKE) -s --output-sync=target $(TARGET_LIST) $(EXT_TARGET_LIST)

clean:
	@rm -rf build src/basic/combined.s src/kernal/combined.s

updatebin:
	@$(MAKE) -s $(DIR_ACME) $(SRC_ACME)
	@$(MAKE) --output-sync=target $(TARGET_LIST) $(TOOL_RELEASE)
	@$(TOOL_RELEASE) -i ./build -o ./bin $(patsubst build/%,%,$(REL_TARGET_LIST))
	@cp build/chargen_openroms.rom bin/chargen_openroms.rom

# Rules - external blobs

$(ROM_CBM_KERNAL):
	@echo
	@echo Please copy \'kernal\' file from the original ROM set to the \'3rdparty/ROMs\' directory
	@echo
	@exit 1

$(ROM_CBM_BASIC):
	@echo
	@echo Please copy \'basic\' file from the original ROM set to the \'3rdparty/ROMs\' directory
	@echo
	@exit 1

# Rules - tools

$(DIR_ACME) $(SRC_ACME) $(DIR_ZMAC) $(SRC_ZMAC) $(SRC_Z80TEST):
	@echo
	@echo Fetching 3rd party source code...
	@git submodule init
	@git submodule update

$(TOOL_ASSEMBLER): $(DIR_ACME) $(SRC_ACME) $(HDR_ACME)
	@echo
	@echo Compiling tool $@ ...
	@mkdir -p build/tools
	@$(CC) -o $(TOOL_ASSEMBLER) $(SRC_ACME) -lm -w -I./3rdparty/acme/src

$(TOOL_PNGPREPARE): tools/pngprepare.c
	@echo
	@echo Compiling tool $@ ...
	@mkdir -p build/tools
	@$(CC) -O2 -Wall -I/usr/local/include -L/usr/local/lib -o $@ $< -lpng

build/tools/%: tools/%.c
	@echo
	@echo Compiling tool $@ ...
	@mkdir -p build/tools
	@$(CC) -O2 -Wall -o $@ $<

build/tools/%: tools/%.cc tools/common.h
	@echo
	@echo Compiling tool $@ ...
	@mkdir -p build/tools
	@$(CXX) -O2 -Wall -o $@ $<

# Rules - CHARGEN

$(TARGET_CHR_ORF): $(TOOL_PNGPREPARE) assets/8x8font.png
	@$(TOOL_PNGPREPARE) charrom assets/8x8font.png $@ 1>/dev/null

$(TARGET_CHR_PXL): bin/chargen_pxlfont_2.3.rom
	@cp $< $@

build/patched_chargen/openroms.pcg: $(TOOL_PATCH_CHARGEN) $(TARGET_CHR_ORF)
	@mkdir -p build/patched_chargen
	@$(TOOL_PATCH_CHARGEN) -i $(TARGET_CHR_ORF) -o $@ -n 7px-OpenROMs

build/patched_chargen/pxlfont.pcg: $(TOOL_PATCH_CHARGEN) $(TARGET_CHR_PXL)
	@mkdir -p build/patched_chargen
	@$(TOOL_PATCH_CHARGEN) -i $(TARGET_CHR_PXL) -o $@ -n 6px-PXLfont

# Dependencies - BASIC, DOS, and KERNAL

$(DIR_CUS)/OUTB_x.BIN $(DIR_CUS)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_CUS) $(GEN_STR_CUS) $(DIR_CUS)/KERNAL_combined.sym
$(DIR_GEN)/OUTB_x.BIN $(DIR_GEN)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_GEN) $(GEN_STR_GEN) $(DIR_GEN)/KERNAL_combined.sym
$(DIR_TST)/OUTB_x.BIN $(DIR_TST)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_TST) $(GEN_STR_TST) $(DIR_TST)/KERNAL_combined.sym
$(DIR_U64)/OUTB_x.BIN $(DIR_U64)/BASIC_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_U64) $(GEN_STR_U64) $(DIR_U64)/KERNAL_combined.sym

$(DIR_CUS)/OUTK_x.BIN $(DIR_CUS)/KERNAL_combined.vs $(DIR_CUS)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_CUS) $(GEN_STR_CUS)
$(DIR_GEN)/OUTK_x.BIN $(DIR_GEN)/KERNAL_combined.vs $(DIR_GEN)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_GEN) $(GEN_STR_GEN)
$(DIR_TST)/OUTK_x.BIN $(DIR_TST)/KERNAL_combined.vs $(DIR_TST)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_TST) $(GEN_STR_TST)
$(DIR_U64)/OUTK_x.BIN $(DIR_U64)/KERNAL_combined.vs $(DIR_U64)/KERNAL_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_U64) $(GEN_STR_U64)

$(DIR_GENCRT)/OUTB_0.BIN $(DIR_GENCRT)/BASIC_0_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_GENCRT) $(CRT_STR_GENCRT) $(DIR_GENCRT)/KERNAL_0_combined.sym
$(DIR_GENCRT)/OUTK_0.BIN $(DIR_GENCRT)/KERNAL_0_combined.vs $(DIR_GENCRT)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_GENCRT) $(GEN_STR_GENCRT)

$(DIR_U64CRT)/OUTB_0.BIN $(DIR_U64CRT)/BASIC_0_combined.vs: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_U64CRT) $(CRT_STR_U64CRT) $(DIR_U64CRT)/KERNAL_0_combined.sym
$(DIR_U64CRT)/OUTK_0.BIN $(DIR_U64CRT)/KERNAL_0_combined.vs $(DIR_U64CRT)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_U64CRT) $(GEN_STR_U64CRT)

$(DIR_M65)/OUTB_0.BIN $(DIR_M65)/BASIC_0_combined.vs  $(DIR_M65)/BASIC_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_M65) $(GEN_STR_M65) $(DIR_M65)/KERNAL_0_combined.sym
$(DIR_M65)/OUTK_0.BIN $(DIR_M65)/KERNAL_0_combined.vs $(DIR_M65)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_M65) $(GEN_STR_M65)

$(DIR_X16)/OUTB_0.BIN $(DIR_X16)/BASIC_0_combined.vs  $(DIR_X16)/BASIC_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_X16) $(GEN_STR_X16) $(DIR_X16)/KERNAL_0_combined.sym
$(DIR_X16)/OUTK_0.BIN $(DIR_X16)/KERNAL_0_combined.vs $(DIR_X16)/KERNAL_0_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_X16) $(GEN_STR_X16)

$(DIR_GENCRT)/basic.seg_1  $(DIR_GENCRT)/BASIC_1_combined.vs  $(DIR_GENCRT)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_GENCRT) $(GEN_STR_GENCRT) $(DIR_GENCRT)/KERNAL_0_combined.sym $(DIR_GENCRT)/BASIC_0_combined.sym
$(DIR_GENCRT)/kernal.seg_1 $(DIR_GENCRT)/KERNAL_1_combined.vs $(DIR_GENCRT)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_GENCRT) $(GEN_STR_GENCRT) $(DIR_GENCRT)/KERNAL_0_combined.sym

$(DIR_U64CRT)/basic.seg_1  $(DIR_U64CRT)/BASIC_1_combined.vs  $(DIR_U64CRT)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_U64CRT) $(GEN_STR_U64CRT) $(DIR_U64CRT)/KERNAL_0_combined.sym $(DIR_U64CRT)/BASIC_0_combined.sym
$(DIR_U64CRT)/kernal.seg_1 $(DIR_U64CRT)/KERNAL_1_combined.vs $(DIR_U64CRT)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_U64CRT) $(GEN_STR_U64CRT) $(DIR_U64CRT)/KERNAL_0_combined.sym

$(DIR_M65)/basic.seg_1  $(DIR_M65)/BASIC_1_combined.vs  $(DIR_M65)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_M65) $(GEN_STR_M65) $(DIR_M65)/KERNAL_0_combined.sym $(DIR_M65)/BASIC_0_combined.sym
$(DIR_M65)/kernal.seg_C $(DIR_M65)/KERNAL_C_combined.vs $(DIR_M65)/KERNAL_C_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_M65) $(GEN_STR_M65) $(DIR_M65)/KERNAL_0_combined.sym
$(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1_combined.vs $(DIR_M65)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_M65) $(GEN_STR_M65) $(DIR_M65)/KERNAL_0_combined.sym
$(DIR_M65)/dos.seg_1    $(DIR_M65)/DOS_1_combined.vs    $(DIR_M65)/DOS_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_DOS_M65) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym
$(DIR_M65)/mon.seg_1    $(DIR_M65)/MON_1_combined.vs    $(DIR_M65)/MON_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_MON_M65) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym $(DIR_M65)/BASIC_1_combined.sym
$(DIR_M65)/zvm.seg_1    $(DIR_M65)/ZVM_1_combined.vs    $(DIR_M65)/ZVM_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_ZVM_M65) $(CFG_M65) $(DIR_M65)/KERNAL_0_combined.sym $(DIR_M65)/KERNAL_C_combined.sym

$(DIR_X16)/basic.seg_1  $(DIR_X16)/BASIC_1_combined.vs  $(DIR_X16)/BASIC_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_BASIC) $(CFG_X16) $(GEN_STR_X16) $(DIR_X16)/KERNAL_0_combined.sym $(DIR_X16)/BASIC_0_combined.sym
$(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1_combined.vs $(DIR_X16)/KERNAL_1_combined.sym: \
    $(TOOL_ASSEMBLER) $(TOOL_BUILD_SEGMENT) $(DEP_KERNAL) $(CFG_X16) $(GEN_STR_X16) $(DIR_X16)/KERNAL_0_combined.sym

$(DIR_CUS)/OUTx_x.BIN:     $(DIR_CUS)/OUTB_x.BIN     $(DIR_CUS)/OUTK_x.BIN
$(DIR_GEN)/OUTx_x.BIN:     $(DIR_GEN)/OUTB_x.BIN     $(DIR_GEN)/OUTK_x.BIN
$(DIR_GENCRT)/OUTx_0.BIN:  $(DIR_GENCRT)/OUTB_0.BIN  $(DIR_GENCRT)/OUTK_0.BIN
$(DIR_TST)/OUTx_x.BIN:     $(DIR_TST)/OUTB_x.BIN     $(DIR_TST)/OUTK_x.BIN
$(DIR_M65)/OUTx_0.BIN:     $(DIR_M65)/OUTB_0.BIN     $(DIR_M65)/OUTK_0.BIN
$(DIR_U64)/OUTx_x.BIN:     $(DIR_U64)/OUTB_x.BIN     $(DIR_U64)/OUTK_x.BIN
$(DIR_U64CRT)/OUTx_0.BIN:  $(DIR_U64CRT)/OUTB_0.BIN  $(DIR_U64CRT)/OUTK_0.BIN
$(DIR_X16)/OUTx_0.BIN:     $(DIR_X16)/OUTB_0.BIN     $(DIR_X16)/OUTK_0.BIN

$(TARGET_CUS_B):    $(DIR_CUS)/OUTx_x.BIN
$(TARGET_GEN_B):    $(DIR_GEN)/OUTx_x.BIN
$(TARGET_TST_B):    $(DIR_TST)/OUTx_x.BIN
$(TARGET_U64_B):    $(DIR_U64)/OUTx_x.BIN

$(TARGET_CUS_K):    $(DIR_CUS)/OUTx_x.BIN
$(TARGET_GEN_K):    $(DIR_GEN)/OUTx_x.BIN
$(TARGET_TST_K):    $(DIR_TST)/OUTx_x.BIN
$(TARGET_U64_K):    $(DIR_U64)/OUTx_x.BIN

build/symbols_custom.vs:          $(DIR_CUS)/BASIC_combined.vs       $(DIR_CUS)/KERNAL_combined.vs
build/symbols_generic.vs:         $(DIR_GEN)/BASIC_combined.vs       $(DIR_GEN)/KERNAL_combined.vs
build/symbols_generic_crt.vs:     $(DIR_GENCRT)/BASIC_0_combined.vs  $(DIR_GENCRT)/KERNAL_0_combined.vs
build/symbols_testing.vs:         $(DIR_TST)/BASIC_combined.vs       $(DIR_TST)/KERNAL_combined.vs
build/symbols_ultimate64.vs:      $(DIR_U64)/BASIC_combined.vs       $(DIR_U64)/KERNAL_combined.vs
build/symbols_ultimate64_crt.vs:  $(DIR_U64CRT)/BASIC_0_combined.vs  $(DIR_U64CRT)/KERNAL_0_combined.vs

# Rules - BASIC and KERNAL intermediate files

$(GEN_STR_CUS): $(TOOL_GENERATE_STRINGS) $(CFG_CUS)
	@mkdir -p $(DIR_CUS)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_CUS)

$(GEN_STR_GEN): $(TOOL_GENERATE_STRINGS) $(CFG_GEN)
	@mkdir -p $(DIR_GEN)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_GEN)

$(GEN_STR_GENCRT): $(TOOL_GENERATE_STRINGS) $(CFG_GENCRT)
	@mkdir -p $(DIR_GENCRT)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_GENCRT)

$(GEN_STR_TST): $(TOOL_GENERATE_STRINGS) $(CFG_TST)
	@mkdir -p $(DIR_TST)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_TST)

$(GEN_STR_M65): $(TOOL_GENERATE_STRINGS) $(CFG_M65)
	@mkdir -p $(DIR_M65)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_M65)

$(GEN_STR_U64): $(TOOL_GENERATE_STRINGS) $(CFG_U64)
	@mkdir -p $(DIR_U64)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_U64)

$(GEN_STR_U64CRT): $(TOOL_GENERATE_STRINGS) $(CFG_U64CRT)
	@mkdir -p $(DIR_U64CRT)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_U64CRT)

$(GEN_STR_X16): $(TOOL_GENERATE_STRINGS) $(CFG_X16)
	@mkdir -p $(DIR_X16)/,generated
	$(TOOL_GENERATE_STRINGS) -o $@ -c $(CFG_X16)

build/,generated/,float_constants.s: $(TOOL_GENERATE_CONSTANTS)
	@mkdir -p build/,generated
	$(TOOL_GENERATE_CONSTANTS) -o build/,generated/,float_constants.s

build/,generated/,z80_tables.s: $(TOOL_GENERATE_Z80_TABLES)
	@mkdir -p build/,generated
	$(TOOL_GENERATE_Z80_TABLES) -o build/,generated/,z80_tables.s

GEN_STR_custom         = $(GEN_STR_CUS)
GEN_STR_generic        = $(GEN_STR_GEN)
GEN_STR_generic_crt    = $(GEN_STR_GENCRT)
GEN_STR_testing        = $(GEN_STR_TST)
GEN_STR_mega65         = $(GEN_STR_M65)
GEN_STR_ultimate64     = $(GEN_STR_U64)
GEN_STR_ultimate64_crt = $(GEN_STR_U64CRT)
GEN_STR_cx16           = $(GEN_STR_X16)

.PRECIOUS: build/target_%/OUTB_x.BIN build/target_%/BASIC_combined.vs
build/target_%/OUTB_x.BIN build/target_%/BASIC_combined.vs:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/BASIC*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r STD -s BASIC -i BASIC-$* -o OUTB_x.BIN -d build/target_$* -l a000 -h e4d2 src/,,config_$*.s $(SRCDIR_BASIC) $(GEN_BASIC) $(GEN_STR_$*)

.PRECIOUS: build/target_%/OUTK_x.BIN build/target_%/KERNAL_combined.vs build/target_%/KERNAL_combined.sym
build/target_%/OUTK_x.BIN build/target_%/KERNAL_combined.vs build/target_%/KERNAL_combined.sym:
	@mkdir -p build/target_$*
	@rm -f $@* build/target_$*/KERNAL*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r STD -s KERNAL -i KERNAL-$* -o OUTK_x.BIN -d build/target_$* -l e4d3 -h ffff src/,,config_$*.s $(SRCDIR_KERNAL) $(GEN_KERNAL) $(GEN_STR_$*)

# Rules - BASIC and KERNAL intermediate files, for ROM with external cartridge

$(DIR_GENCRT)/OUTB_0.BIN $(DIR_GENCRT)/BASIC_0_combined.vs $(DIR_GENCRT)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_GENCRT)
	@rm -f $@* $(DIR_GENCRT)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s BASIC_0 -i BASIC_0-generic-crt -o OUTB_0.BIN -d $(DIR_GENCRT) -l a000 -h e4d2 $(CFG_GENCRT) $(GEN_STR_GENCRT) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_GENCRT)/OUTK_0.BIN $(DIR_GENCRT)/KERNAL_0_combined.vs $(DIR_GENCRT)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_GENCRT)
	@rm -f $@* $(DIR_GENCRT)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s KERNAL_0 -i KERNAL_0-generic-crt -o OUTK_0.BIN -d $(DIR_GENCRT) -l e4d3 -h ffff $(CFG_GENCRT) $(GEN_STR_GENCRT) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_GENCRT)/basic.seg_1 $(DIR_GENCRT)/BASIC_1_combined.vs $(DIR_GENCRT)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_GENCRT)
	@rm -f $@* $(DIR_GENCRT)/basic.seg_1 $(DIR_GENCRT)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s BASIC_1 -i BASIC_1-generic-crt -o basic.seg_1 -d $(DIR_GENCRT) -l 8000 -h 9fff $(CFG_GENCRT) $(GEN_STR_GENCRT) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_GENCRT)/kernal.seg_1 $(DIR_GENCRT)/KERNAL_1_combined.vs $(DIR_GENCRT)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_GENCRT)
	@rm -f $@* $(DIR_GENCRT)/kernal.seg_1 $(DIR_GENCRT)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s KERNAL_1 -i KERNAL_1-generic-crt -o kernal.seg_1 -d $(DIR_GENCRT) -l 8000 -h 9fff $(CFG_GENCRT) $(GEN_STR_GENCRT) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_U64CRT)/OUTB_0.BIN $(DIR_U64CRT)/BASIC_0_combined.vs $(DIR_U64CRT)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_U64CRT)
	@rm -f $@* $(DIR_U64CRT)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s BASIC_0 -i BASIC_0-ultimate64-crt -o OUTB_0.BIN -d $(DIR_U64CRT) -l a000 -h e4d2 $(CFG_U64CRT) $(GEN_STR_U64CRT) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_U64CRT)/OUTK_0.BIN $(DIR_U64CRT)/KERNAL_0_combined.vs $(DIR_U64CRT)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_U64CRT)
	@rm -f $@* $(DIR_U64CRT)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s KERNAL_0 -i KERNAL_0-ultimate64-crt -o OUTK_0.BIN -d $(DIR_U64CRT) -l e4d3 -h ffff $(CFG_U64CRT) $(GEN_STR_U64CRT) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_U64CRT)/basic.seg_1 $(DIR_U64CRT)/BASIC_1_combined.vs $(DIR_U64CRT)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_U64CRT)
	@rm -f $@* $(DIR_U64CRT)/basic.seg_1 $(DIR_U64CRT)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s BASIC_1 -i BASIC_1-ultimate64-crt -o basic.seg_1 -d $(DIR_U64CRT) -l 8000 -h 9fff $(CFG_U64CRT) $(GEN_STR_U64CRT) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_U64CRT)/kernal.seg_1 $(DIR_U64CRT)/KERNAL_1_combined.vs $(DIR_U64CRT)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_U64CRT)
	@rm -f $@* $(DIR_U64CRT)/kernal.seg_1 $(DIR_U64CRT)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r CRT -s KERNAL_1 -i KERNAL_1-ultimate64-crt -o kernal.seg_1 -d $(DIR_U64CRT) -l 8000 -h 9fff $(CFG_U64CRT) $(GEN_STR_U64CRT) $(SRCDIR_KERNAL) $(GEN_KERNAL)

# Rules - BASIC, KERNAL, DOS, MON, and ZVM  intermediate files, for MEGA65

$(DIR_M65)/OUTB_0.BIN $(DIR_M65)/BASIC_0_combined.vs $(DIR_M65)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s BASIC_0 -i BASIC_0-mega65 -o OUTB_0.BIN -d $(DIR_M65) -l a000 -h e4d2 $(CFG_M65) $(GEN_STR_M65) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_M65)/OUTK_0.BIN $(DIR_M65)/KERNAL_0_combined.vs $(DIR_M65)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s KERNAL_0 -i KERNAL_0-mega65 -o OUTK_0.BIN -d $(DIR_M65) -l e4d3 -h ffff $(CFG_M65) $(GEN_STR_M65) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_M65)/basic.seg_1 $(DIR_M65)/BASIC_1_combined.vs $(DIR_M65)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/basic.seg_1 $(DIR_M65)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s BASIC_1 -i BASIC_1-mega65 -o basic.seg_1 -d $(DIR_M65) -l 4000 -h 6fff $(CFG_M65) $(GEN_STR_M65) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_M65)/kernal.seg_C $(DIR_M65)/KERNAL_C_combined.vs $(DIR_M65)/KERNAL_C_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/kernal.seg_C $(DIR_M65)/KERNAL_C*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s KERNAL_C -i KERNAL_C-mega65 -o kernal.seg_C -d $(DIR_M65) -l c000 -h cfff $(CFG_M65) $(GEN_STR_M65) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1_combined.vs $(DIR_M65)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/kernal.seg_1 $(DIR_M65)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s KERNAL_1 -i KERNAL_1-mega65 -o kernal.seg_1 -d $(DIR_M65) -l 4000 -h 5fff $(CFG_M65) $(GEN_STR_M65) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_M65)/dos.seg_1 $(DIR_M65)/DOS_1_combined.vs $(DIR_M65)/DOS_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/dos.seg_1 $(DIR_M65)/DOS_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s DOS_1 -i DOS_1-mega65 -o dos.seg_1 -d $(DIR_M65) -l 4000 -h 7fff $(CFG_M65) $(SRCDIR_DOS_M65)

$(DIR_M65)/mon.seg_1 $(DIR_M65)/MON_1_combined.vs $(DIR_M65)/MON_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/mon.seg_1 $(DIR_M65)/MON_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s MON_1 -i MON_1-mega65 -o mon.seg_1 -d $(DIR_M65) -l 4000 -h 5fff $(CFG_M65) $(SRCDIR_MON_M65)

$(DIR_M65)/zvm.seg_1 $(DIR_M65)/ZVM_1_combined.vs $(DIR_M65)/ZVM_1_combined.sym:
	@mkdir -p $(DIR_M65)
	@rm -f $@* $(DIR_M65)/zvm.seg_1 $(DIR_M65)/ZVM_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r M65 -s ZVM_1 -i ZVM_1-mega65 -o zvm.seg_1 -d $(DIR_M65) -l 2000 -h 7fff $(CFG_M65) $(SRCDIR_ZVM_M65) $(GEN_ZVM)

# Rules - BASIC and KERNAL intermediate files, for Commander X16

$(DIR_X16)/OUTB_0.BIN $(DIR_X16)/BASIC_0_combined.vs $(DIR_X16)/BASIC_0_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/BASIC_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s BASIC_0 -i BASIC_0-x16 -o OUTB_0.BIN -d $(DIR_X16) -l c000 -h e4d2 $(CFG_X16) $(GEN_STR_X16) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_X16)/OUTK_0.BIN $(DIR_X16)/KERNAL_0_combined.vs $(DIR_X16)/KERNAL_0_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/KERNAL_0*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s KERNAL_0 -i KERNAL_0-x16 -o OUTK_0.BIN -d $(DIR_X16) -l e4d3 -h ffff $(CFG_X16) $(GEN_STR_X16) $(SRCDIR_KERNAL) $(GEN_KERNAL)

$(DIR_X16)/basic.seg_1 $(DIR_X16)/BASIC_1_combined.vs $(DIR_X16)/BASIC_1_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/basic.seg_1 $(DIR_X16)/BASIC_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s BASIC_1 -i BASIC_1-x16 -o basic.seg_1 -d $(DIR_X16) -l a000 -h bfff $(CFG_X16) $(GEN_STR_X16) $(SRCDIR_BASIC) $(GEN_BASIC)

$(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1_combined.vs $(DIR_X16)/KERNAL_1_combined.sym:
	@mkdir -p $(DIR_X16)
	@rm -f $@* $(DIR_X16)/kernal.seg_1 $(DIR_X16)/KERNAL_1*
	@$(TOOL_BUILD_SEGMENT) -a ../../$(TOOL_ASSEMBLER) -r X16 -s KERNAL_1 -i KERNAL_1-x16 -o kernal.seg_1 -d $(DIR_X16) -l a000 -h bfff $(CFG_X16) $(GEN_STR_X16) $(SRCDIR_KERNAL) $(GEN_KERNAL)

# Rules - BASIC and KERNAL

.PRECIOUS: build/target_%/OUTx_x.BIN
build/target_%/OUTx_x.BIN:
	@cat build/target_$*/OUTB_x.BIN build/target_$*/OUTK_x.BIN > $@

.PRECIOUS: build/kernal_%.rom
build/kernal_%.rom:
	@dd if=build/target_$*/OUTx_x.BIN bs=8192 count=1 skip=2 of=$@ status=none

.PRECIOUS: build/basic_%.rom
build/basic_%.rom:
	@dd if=build/target_$*/OUTx_x.BIN bs=8192 count=1 skip=0 of=$@ status=none

.PRECIOUS: build/symbols_%.vs
build/symbols_%.vs:
	@sort build/target_$*/BASIC_combined.vs build/target_$*/KERNAL_combined.vs | uniq | grep -v "__" > $@

$(DIR_GENCRT)/OUTx_0.BIN:
	@cat $(DIR_GENCRT)/OUTB_0.BIN $(DIR_GENCRT)/OUTK_0.BIN > $@

$(DIR_GENCRT)/kernal.seg_0: $(DIR_GENCRT)/OUTx_0.BIN
	@dd if=$(DIR_GENCRT)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@ status=none

$(DIR_GENCRT)/basic.seg_0: $(DIR_GENCRT)/OUTx_0.BIN
	@dd if=$(DIR_GENCRT)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

$(DIR_U64CRT)/OUTx_0.BIN:
	@cat $(DIR_U64CRT)/OUTB_0.BIN $(DIR_U64CRT)/OUTK_0.BIN > $@

$(DIR_U64CRT)/kernal.seg_0: $(DIR_U64CRT)/OUTx_0.BIN
	@dd if=$(DIR_U64CRT)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@ status=none

$(DIR_U64CRT)/basic.seg_0: $(DIR_U64CRT)/OUTx_0.BIN
	@dd if=$(DIR_U64CRT)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

$(DIR_M65)/OUTx_0.BIN:
	@cat $(DIR_M65)/OUTB_0.BIN $(DIR_M65)/OUTK_0.BIN > $@

$(DIR_M65)/kernal.seg_0: $(DIR_M65)/OUTx_0.BIN
	@dd if=$(DIR_M65)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@ status=none

$(DIR_M65)/basic.seg_0: $(DIR_M65)/OUTx_0.BIN
	@dd if=$(DIR_M65)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

$(DIR_X16)/OUTx_0.BIN:
	@cat $(DIR_X16)/OUTB_0.BIN $(DIR_X16)/OUTK_0.BIN > $@

$(DIR_X16)/kernal.seg_0: $(DIR_X16)/OUTx_0.BIN
	@dd if=$(DIR_X16)/OUTx_0.BIN bs=8192 count=1 skip=1 of=$@ status=none

$(DIR_X16)/basic.seg_0: $(DIR_X16)/OUTx_0.BIN
	@dd if=$(DIR_X16)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

$(TARGET_GENCRT_K): $(DIR_GENCRT)/OUTx_0.BIN 
	@dd if=$(DIR_GENCRT)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@ status=none

$(TARGET_GENCRT_B): $(DIR_GENCRT)/OUTx_0.BIN 
	@dd if=$(DIR_GENCRT)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

$(TARGET_U64CRT_K): $(DIR_U64CRT)/OUTx_0.BIN 
	@dd if=$(DIR_U64CRT)/OUTx_0.BIN bs=8192 count=1 skip=2 of=$@ status=none

$(TARGET_U64CRT_B): $(DIR_U64CRT)/OUTx_0.BIN 
	@dd if=$(DIR_U64CRT)/OUTx_0.BIN bs=8192 count=1 skip=0 of=$@ status=none

build/symbols_generic_crt.vs:
	@sort $(DIR_GENCRT)/BASIC_0_combined.vs $(DIR_GENCRT)/KERNAL_0_combined.vs | uniq | grep -v "__" > $@

build/symbols_ultimate64_crt.vs:
	@sort $(DIR_U64CRT)/BASIC_0_combined.vs $(DIR_U64CRT)/KERNAL_0_combined.vs | uniq | grep -v "__" > $@

build/kernal_hybrid.rom: $(ROM_CBM_KERNAL) $(DIR_GEN)/OUTK_x.BIN
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	(dd if=$(ROM_CBM_KERNAL) bs=1140 count=1 skip=0  ; \
	echo "    > HYBRID ROM, DON'T DISTRIBUTE <"      ; \
	dd if=$(ROM_CBM_KERNAL) bs=1 count=58 skip=1176  ; \
	cat $(DIR_GEN)/OUTK_x.BIN) > $@

build/symbols_hybrid.vs: $(DIR_GEN)/KERNAL_combined.vs
	@sort $(DIR_GEN)/KERNAL_combined.vs | uniq | grep -v "__" > $@

build/kernal_hybrid_u64.rom: kernal $(DIR_U64)/OUTK_x.BIN
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	(dd if=kernal bs=1140 count=1 skip=0        ; \
	echo "    > HYBRID ROM, DON'T DISTRIBUTE <" ; \
	dd if=kernal bs=1 count=58 skip=1176        ; \
	cat $(DIR_U64)/OUTK_x.BIN) > $@

build/symbols_hybrid_u64.vs: $(DIR_U64)/KERNAL_combined.vs
	@sort $(DIR_U64)/KERNAL_combined.vs | uniq | grep -v "__" > $@

# Rules - padding files

build/padding/4_KB:
	@mkdir -p build/padding
	@dd if=/dev/zero bs=4096 count=1 of=$@ status=none

build/padding/8_KB:
	@mkdir -p build/padding
	@dd if=/dev/zero bs=8192 count=1 of=$@ status=none

build/padding/16_KB:
	@mkdir -p build/padding
	@dd if=/dev/zero bs=8192 count=2 of=$@ status=none

# Rules - external CRT images

$(TARGET_GENCRT_X): $(SEG_LIST_GENCRT) $(CRT_BIN_LIST) build/padding/8_KB
	@echo
	@echo
	@echo
	@echo //-------------------------------------------------------------------------------------------
	@echo // Making external CRT ROM image - generic
	@echo //-------------------------------------------------------------------------------------------
	@cat assets/cartridge/header-cart.bin    > $@
	@cat assets/cartridge/header-seg0.bin   >> $@
	@cat $(DIR_GENCRT)/basic.seg_1          >> $@
	@cat assets/cartridge/header-seg1.bin   >> $@
	@cat build/padding/8_KB                 >> $@
	@cat assets/cartridge/header-seg2.bin   >> $@
	@cat $(DIR_GENCRT)/kernal.seg_1         >> $@
	@cat assets/cartridge/header-seg3.bin   >> $@
	@cat build/padding/8_KB                 >> $@
	@echo

$(TARGET_U64CRT_X): $(SEG_LIST_U64CRT) $(CRT_BIN_LIST) build/padding/8_KB
	@echo
	@echo
	@echo
	@echo //-------------------------------------------------------------------------------------------
	@echo // Making external CRT ROM image - Ultimate 64
	@echo //-------------------------------------------------------------------------------------------
	@cat assets/cartridge/header-cart.bin    > $@
	@cat assets/cartridge/header-seg0.bin   >> $@
	@cat $(DIR_U64CRT)/basic.seg_1          >> $@
	@cat assets/cartridge/header-seg1.bin   >> $@
	@cat build/padding/8_KB                 >> $@
	@cat assets/cartridge/header-seg2.bin   >> $@
	@cat $(DIR_U64CRT)/kernal.seg_1         >> $@
	@cat assets/cartridge/header-seg3.bin   >> $@
	@cat build/padding/8_KB                 >> $@
	@echo

# Rules - MEGA65 platform specific

# $0:$0000 - 16 KB - Computer Based DOS
# $0:$4000 -  8 KB - KERNAL segment 1
# $0:$6000 - 12 KB - BASIC  segment 1
# $0:$9000 -  4 KB - native mode chargen
# $0:$A000 -  8 KB - BASIC  segment 0
# $0:$C000 -  4 KB - KERNAL segment C
# $0:$D000 -  4 KB - legacy mode chargen
# $0:$E000 -  8 KB - KERNAL segment 0
# $1:$0000 -  8 KB - Machine Language MONITOR
# $1:$2000 - 24 KB - Z80 Virtual Machine for CP/M
# $1:$8000 - 32 KB - unused for now, padding; most likely will be used for BASIC extensions

$(TARGET_M65_x_ORF) $(TARGET_M65_x_PXL): $(SEG_LIST_M65) build/padding/16_KB $(TARGET_CHR_ORF) build/patched_chargen/openroms.pcg $(TARGET_CHR_PXL) build/patched_chargen/pxlfont.pcg
	@echo
	@echo
	@echo
	@echo //-------------------------------------------------------------------------------------------
	@echo // Making ROM image for MEGA65 - with Open ROMs chargen
	@echo //-------------------------------------------------------------------------------------------
	@cat $(DIR_M65)/dos.seg_1                > $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/kernal.seg_1            >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/basic.seg_1             >> $(TARGET_M65_x_ORF)
	@cat build/patched_chargen/openroms.pcg >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/basic.seg_0             >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/kernal.seg_C            >> $(TARGET_M65_x_ORF)
	@cat $(TARGET_CHR_ORF)                  >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/kernal.seg_0            >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/mon.seg_1               >> $(TARGET_M65_x_ORF)
	@cat $(DIR_M65)/zvm.seg_1               >> $(TARGET_M65_x_ORF)
	@cat build/padding/16_KB                >> $(TARGET_M65_x_ORF)
	@cat build/padding/16_KB                >> $(TARGET_M65_x_ORF)
	@echo
	@echo
	@echo
	@echo //-------------------------------------------------------------------------------------------
	@echo // Making ROM image for MEGA65 - with PXL font chargen
	@echo //-------------------------------------------------------------------------------------------
	@cat $(DIR_M65)/dos.seg_1                > $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/kernal.seg_1            >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/basic.seg_1             >> $(TARGET_M65_x_PXL)
	@cat build/patched_chargen/pxlfont.pcg  >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/basic.seg_0             >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/kernal.seg_C            >> $(TARGET_M65_x_PXL)
	@cat $(TARGET_CHR_PXL)                  >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/kernal.seg_0            >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/mon.seg_1               >> $(TARGET_M65_x_PXL)
	@cat $(DIR_M65)/zvm.seg_1               >> $(TARGET_M65_x_PXL)
	@cat build/padding/16_KB                >> $(TARGET_M65_x_PXL)
	@cat build/padding/16_KB                >> $(TARGET_M65_x_PXL)
	@echo

# Rules - platform 'Commander X16' specific

$(TARGET_X16_x): $(SEG_LIST_X16) build/chargen_openroms.rom
	@echo
	@echo
	@echo
	@echo //-------------------------------------------------------------------------------------------
	@echo // Making ROM image for Commander X16 - with Open ROMs chargen
	@echo //-------------------------------------------------------------------------------------------
	@cat $(DIR_X16)/basic.seg_0      > $(TARGET_X16_x)
	@cat $(DIR_X16)/kernal.seg_0    >> $(TARGET_X16_x)
	@cat build/chargen_openroms.rom        >> $(TARGET_X16_x)
	@cat $(DIR_X16)/basic.seg_1     >> $(TARGET_X16_x)
	@cat $(DIR_X16)/kernal.seg_1    >> $(TARGET_X16_x)
	@echo

# Rules - tests

.PHONY: test test_crt test_generic test_generic_x128 test_generic_crt test_hybrid test_testing \
        test_mega65 test_mega65_xemu test_m65 test_ultimate64 \
        testremote testsimilarity

test:     test_custom
test_crt: test_generic_crt

test_custom: $(TARGET_LIST_CUS) $(TARGET_CHR_PXL) build/symbols_custom.vs
	x64 -kernal $(TARGET_CUS_K) -basic $(TARGET_CUS_B) -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_custom.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_generic: $(TARGET_LIST_GEN)$(TARGET_CHR_PXL) build/symbols_generic.vs
	x64 -kernal $(TARGET_GEN_K) -basic $(TARGET_GEN_B) -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_generic.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_generic_x128: $(TARGET_LIST_GEN) $(TARGET_CHR_PXL) build/symbols_generic.vs
	x128 -go64 -kernal64 $(TARGET_GEN_K) -basic64 $(TARGET_GEN_B) -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_generic.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_generic_crt: $(TARGET_LIST_GENCRT) $(TARGET_CHR_PXL) build/symbols_generic_crt.vs
	x64 -kernal $(TARGET_GENCRT_K) -basic $(TARGET_GENCRT_B) -chargen $(TARGET_CHR_PXL) -cartcrt $(TARGET_GENCRT_X) -moncommands build/symbols_generic_crt.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_testing: $(TARGET_LIST_TST) $(TARGET_CHR_PXL) build/symbols_testing.vs
	x64 -kernal $(TARGET_TST_K) -basic $(TARGET_TST_B) -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_testing.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_ultimate64: $(TARGET_LIST_U64) $(TARGET_CHR_PXL) build/symbols_ultimate64.vs
	x64 -kernal $(TARGET_U64_K) -basic $(TARGET_U64_B) -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_ultimate64.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_ultimate64_crt: $(TARGET_LIST_U64CRT) $(TARGET_CHR_PXL) build/symbols_ultimate64_crt.vs
	x64 -kernal $(TARGET_U64CRT_K) -basic $(TARGET_U64CRT_B) -chargen $(TARGET_CHR_PXL) -cartcrt $(TARGET_U64CRT_X) -moncommands build/symbols_ultimate64_crt.vs -1 $(TESTTAPE) -8 $(TESTDISK)

test_mega65: $(TARGET_M65_x_ORF) $(TARGET_M65_x_PXL)
	../xemu/build/bin/xmega65.native -dmarev 2 -besure -fontrefresh -forcerom -loadrom $(TARGET_M65_x_PXL)

test_cx16: $(TARGET_X16_x)
	../x16-emulator/x16emu -rom $(TARGET_X16_x)

test_hybrid: build/kernal_hybrid.rom $(TARGET_CHR_PXL) build/symbols_hybrid.vs
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	x64 -kernal build/kernal_hybrid.rom -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_hybrid.vs -1 $(TESTTAPE) -8 $(TESTDISK)
	@echo
	@echo $(HYBRID_WARNING)
	@echo

test_hybrid_u64: build/kernal_hybrid_u64.rom $(TARGET_CHR_PXL) build/symbols_hybrid_u64.vs
	@echo
	@echo $(HYBRID_WARNING)
	@echo
	x64 -kernal build/kernal_hybrid_u64.rom -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_hybrid_u64.vs -1 $(TESTTAPE) -8 $(TESTDISK)
	@echo
	@echo $(HYBRID_WARNING)
	@echo

test_m65: build/mega65.rom
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R build/mega65.rom -4

testremote: build/kernal_custom.rom build/basic_custom.rom $(TARGET_CHR_PXL) build/symbols_custom.vs
	x64 -kernal build/kernal_custom.rom -basic build/basic_custom.rom -chargen $(TARGET_CHR_PXL) -moncommands build/symbols_custom.vs -remotemonitor

testsimilarity: $(TOOL_SIMILARITY) $(DIR_GEN)/OUTx_x.BIN $(ROM_CBM_KERNAL) $(ROM_CBM_BASIC)
	$(TOOL_SIMILARITY) $(ROM_CBM_KERNAL) $(DIR_GEN)/OUTx_x.BIN
	$(TOOL_SIMILARITY) $(ROM_CBM_BASIC)  $(DIR_GEN)/OUTx_x.BIN

#
# Z80 part
#


.PHONY: cpm
cpm: $(TOOL_ASSEMBLER_Z80) $(TARGET_Z80TEST)

$(DIR_ZMAC_TMP)/doc: $(SRC_ZMAC)
	@mkdir -p $(DIR_ZMAC_TMP)
	@$(CC) -Wall -DMK_DOC -o $@ $(DIR_ZMAC)/doc.c

$(DIR_ZMAC_TMP)/doc.txt : $(DIR_ZMAC)/doc.txt
	@mkdir -p $(DIR_ZMAC_TMP)
	@cp -f $< $@

$(DIR_ZMAC_TMP)/doc.inl: $(DIR_ZMAC_TMP)/doc.txt $(DIR_ZMAC_TMP)/doc
	@(cd $(DIR_ZMAC_TMP); ./doc > /dev/null)

$(DIR_ZMAC_TMP)/zmac.c : $(SRC_ZMAC) $(DIR_ZMAC)/zmac.y
	@mkdir -p $(DIR_ZMAC_TMP)
	@bison -y $(DIR_ZMAC)/zmac.y -o $@

$(TOOL_ASSEMBLER_Z80): $(DIR_ZMAC) $(SRC_ZMAC) $(GEN_ZMAC_C) $(GEN_ZMAC_H) $(HDR_ZMAC)
	@echo
	@echo Compiling tool $@ ...
	@mkdir -p build/tools
	@$(CC) -o $(TOOL_ASSEMBLER_Z80) $(SRC_ZMAC) $(GEN_ZMAC_C) -lm -w -I$(DIR_ZMAC) -I$(DIR_ZMAC_TMP)

$(TARGET_Z80TEST) : $(TOOL_ASSEMBLER_Z80) $(SRC_Z80TEST)
	@echo
	@echo Compiling Z80 CPU tester ...
	@mkdir -p build/cpm
	@rm -f $(TARGET_Z80TEST).CIM $(TARGET_Z80TEST)
	@$(TOOL_ASSEMBLER_Z80) -o $(TARGET_Z80TEST).CIM $(SRC_Z80TEST)
	@mv -f $(TARGET_Z80TEST).CIM $(TARGET_Z80TEST)
