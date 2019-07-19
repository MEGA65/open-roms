
# Source files

SRC_COMMON            = $(wildcard c64/aliases/*.s)
SRC_BASIC_COMMON      = $(SRC_COMMON) $(wildcard c64/basic/*.s)
SRC_KERNAL_COMMON     = $(SRC_COMMON) $(wildcard c64/kernal/*.s)

SRC_BASIC_generic     = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_generic/*.s)
SRC_BASIC_mega65      = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_mega65/*.s)
SRC_BASIC_ultimate64  = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_ultimate64/*.s)

SRC_KERNAL_generic    = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_generic/*.s)
SRC_KERNAL_mega65     = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_mega65/*.s)
SRC_KERNAL_ultimate64 = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_ultimate64/*.s)

# List of tools

TOOL_COLLECT_DATA  = build/tools/collect_data
TOOL_COMPRESS_TEXT = build/tools/compress_text
TOOL_PNGPREPARE    = build/tools/pngprepare
TOOL_PREPROCESS    = build/tools/preprocess
TOOL_SIMILARITY    = build/tools/similarity

TOOLS_LIST = $(TOOL_COLLECT_DATA) $(TOOL_COMPRESS_TEXT) $(TOOL_PNGPREPARE) $(TOOL_PREPROCESS) $(TOOL_SIMILARITY)

# Rules - main

.PHONY: all clean

all: build/chargen build/newkern_generic build/newbasic_generic build/newc65 build/newkern_ultimate64 build/newbasic_ultimate64

Ophis:
	git submodule init
	git submodule update

clean:
	@rm -rf build
	@rm -f temp.s
	@rm -f temp.map
	@rm -f ophis.bin

# Rules - tools

$(TOOL_COLLECT_DATA): src/collect_data.c Makefile
	@mkdir -p build/tools
	gcc -Wall -o $(TOOL_COLLECT_DATA) src/collect_data.c

$(TOOL_COMPRESS_TEXT): src/compress_text.c Makefile
	@mkdir -p build/tools
	gcc -g -Wall -o $(TOOL_COMPRESS_TEXT) src/compress_text.c -lm

$(TOOL_PNGPREPARE): src/pngprepare.c Makefile
	@mkdir -p build/tools
	$(CC) $(COPT) -I/usr/local/include -L/usr/local/lib -o $(TOOL_PNGPREPARE) src/pngprepare.c -lpng

$(TOOL_PREPROCESS): src/preprocess.c Makefile
	@mkdir -p build/tools
	gcc -g -Wall -o $(TOOL_PREPROCESS) src/preprocess.c

$(TOOL_SIMILARITY): src/similarity.c Makefile
	@mkdir -p build/tools
	gcc -g -Wall -o $(TOOL_SIMILARITY) src/similarity.c

# Rules - CHARGEN

build/chargen: $(TOOL_PNGPREPARE) assets/8x8font.png
	$(TOOL_PNGPREPARE) charrom assets/8x8font.png build/chargen

# Dependencies - XXX, why they need to be stated separately?

build/basic_generic/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_BASIC_generic) build/basic/packed_messages.s
build/kernal_generic/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_KERNAL_generic)
build/newrom_generic: build/basic_generic/OUT.BIN build/kernal_generic/OUT.BIN
build/newkern_generic: build/newrom_generic Makefile
build/newbasic_generic: build/newrom_generic Makefile

build/basic_mega65/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_BASIC_mega65) build/basic/packed_messages.s
build/kernal_mega65/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_KERNAL_mega65)
build/newrom_mega65: build/basic_mega65/OUT.BIN build/kernal_mega65/OUT.BIN
build/newkern_mega65: build/newrom_mega65 Makefile
build/newbasic_mega65: build/newrom_mega65 Makefile

build/basic_ultimate64/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_BASIC_ultimate64) build/basic/packed_messages.s
build/kernal_ultimate64/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_KERNAL_ultimate64)
build/newrom_ultimate64: build/basic_ultimate64/OUT.BIN build/kernal_ultimate64/OUT.BIN
build/newkern_ultimate64: build/newrom_ultimate64 Makefile
build/newbasic_ultimate64: build/newrom_ultimate64 Makefile


# Rules - BASIC and KERNAL

build/basic/packed_messages.s: $(TOOL_COMPRESS_TEXT)
	@mkdir -p build/basic
	$(TOOL_COMPRESS_TEXT) > build/basic/packed_messages.s

.PRECIOUS: build/basic_%/OUT.BIN
build/basic_%/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_BASIC_$*) build/basic/packed_messages.s
	@mkdir -p build/basic_$*
	@rm -f build/basic_$*/*
	@for SRC in $(SRC_BASIC_$*); do \
	    ln -s ../../$$SRC build/basic_$*/$$(basename $$SRC); \
	done
	@ln -s ../../build/basic/packed_messages.s build/basic_$*/packed_messages.s
	$(TOOL_PREPROCESS) -d build/basic_$* -l a000 -h e4d2

.PRECIOUS: build/kernal_%/OUT.BIN
build/kernal_%/OUT.BIN: Ophis $(TOOLS_LIST) $(SRC_KERNAL_$*)
	@mkdir -p build/kernal_$*
	@rm -f build/kernal_$*/*
	@for SRC in $(SRC_KERNAL_$*); do \
	    ln -s ../../$$SRC build/kernal_$*/$$(basename $$SRC); \
	done
	$(TOOL_PREPROCESS) -d build/kernal_$* -l e4d3 -h ffff

.PRECIOUS: build/newrom_%
build/newrom_%: build/basic_%/OUT.BIN build/kernal_%/OUT.BIN
	cat build/basic_$*/OUT.BIN build/kernal_$*/OUT.BIN  > build/newrom_$*

.PRECIOUS: build/newkern_%
build/newkern_%: build/newrom_% Makefile
	dd if=build/newrom_$* bs=8192 count=1 skip=2 of=build/newkern_$*

.PRECIOUS: build/newbasic_%
build/newbasic_%: build/newrom_% Makefile
	dd if=build/newrom_$* bs=8192 count=1 skip=0 of=build/newbasic_$*

# Rules - platform 'Mega 65' specific

build/newc65: build/newkern_mega65 build/newbasic_mega65 build/chargen Makefile
	dd if=/dev/zero bs=4096 count=10 of=build/newc65
	cat build/newbasic_mega65 build/chargen build/chargen build/newkern_mega65 >> build/newc65
	dd if=/dev/zero bs=65536 count=1 of=build/basic/padding
	cat build/basic/padding >> build/newc65

# Rules - tests

test: build/newkern_generic build/newbasic_generic
	x64 -kernal build/newkern_generic -basic build/newbasic_generic -8 empty.d64

testremote: build/newkern_generic build/newbasic_generic
	x64 -kernal build/newkern-generic -basic build/newbasic-generic -remotemonitor

testm65: build/newc65
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R build/newc65 -4

testsimilarity: build/newrom_generic src/similarity
	$(TOOL_SIMILARITY) kernal build/newrom_generic
	$(TOOL_SIMILARITY) basic build/newrom_generic
