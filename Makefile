
# Source files

SRC_COMMON            = $(wildcard c64/aliases/*.s)
SRC_BASIC_COMMON      = $(SRC_COMMON) $(wildcard c64/basic/*.s)
SRC_KERNAL_COMMON     = $(SRC_COMMON) $(wildcard c64/kernal/*.s)

SRC_BASIC_GENERIC     = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_generic/*.s)
SRC_BASIC_MEGA65      = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_mega65/*.s)
SRC_BASIC_ULTIMATE64  = $(SRC_BASIC_COMMON) $(wildcard c64/basic/,platform_ultimate64/*.s)

SRC_KERNAL_GENERIC    = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_generic/*.s)
SRC_KERNAL_MEGA65     = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_mega65/*.s)
SRC_KERNAL_ULTIMATE64 = $(SRC_KERNAL_COMMON) $(wildcard c64/kernal/,platform_ultimate64/*.s)

# List of tools

TOOLS_LIST = build/collect_data build/compress_text build/preprocess build/similarity

# Rules - maintainance

all: build/chargen build/newkern_generic build/newbasic_generic build/newc65 build/newkern_ultimate64 build/newbasic_ultimate64

clean:
	@rm -rf build
	@rm -f temp.s
	@rm -f temp.map
	@rm -f ophis.bin

Ophis:
	git submodule init
	git submodule update

# Rules - tools

build/pngprepare: src/pngprepare.c Makefile
	@mkdir -p build
	$(CC) $(COPT) -I/usr/local/include -L/usr/local/lib -o build/pngprepare src/pngprepare.c -lpng

build/collect_data: src/collect_data.c Makefile
	@mkdir -p build
	gcc -Wall -o build/collect_data src/collect_data.c

build/preprocess: src/preprocess.c Makefile
	@mkdir -p build
	gcc -g -Wall -o build/preprocess src/preprocess.c

build/similarity: src/similarity.c Makefile
	@mkdir -p build
	gcc -g -Wall -o build/similarity src/similarity.c

build/compress_text: src/compress_text.c Makefile
	@mkdir -p build
	gcc -g -Wall -o build/compress_text src/compress_text.c -lm

# Rules - chargen

build/chargen: build/pngprepare assets/8x8font.png
	build/pngprepare charrom assets/8x8font.png build/chargen

# Rules - platform 'generic'

build/basic_generic/OUT.BIN: $(TOOLS_LIST) $(SRC_BASIC_GENERIC) build/basic/packed_messages.s
	@echo
	@echo ### Building BASIC for generic systems
	@echo
	@mkdir -p build/basic_generic
	@rm -f build/basic_generic/*
	@for SRC in $(SRC_BASIC_GENERIC); do \
	    ln -s ../../$$SRC build/basic_generic/$$(basename $$SRC); \
	done
	@ln -s ../../build/basic/packed_messages.s build/basic_generic/packed_messages.s
	build/preprocess -d build/basic_generic -l a000 -h e4d2

build/kernal_generic/OUT.BIN: $(TOOLS_LIST) $(SRC_KERNAL_GENERIC)
	@echo
	@echo ### Building KERNAL for generic systems
	@echo
	@mkdir -p build/kernal_generic
	@rm -f build/kernal_generic/*
	@for SRC in $(SRC_KERNAL_GENERIC); do \
	    ln -s ../../$$SRC build/kernal_generic/$$(basename $$SRC); \
	done
	build/preprocess -d build/kernal_generic -l e4d3 -h ffff

build/newrom_generic: build/basic_generic/OUT.BIN build/kernal_generic/OUT.BIN
	cat build/basic_generic/OUT.BIN build/kernal_generic/OUT.BIN  > build/newrom_generic

build/newkern_generic: build/newrom_generic Makefile
	dd if=build/newrom_generic bs=8192 count=1 skip=2 of=build/newkern_generic

build/newbasic_generic: build/newrom_generic Makefile
	dd if=build/newrom_generic bs=8192 count=1 skip=0 of=build/newbasic_generic

# Rules - platform 'Mega 65'

build/basic_mega65/OUT.BIN: $(TOOLS_LIST) $(SRC_BASIC_MEGA65) build/basic/packed_messages.s
	@echo
	@echo ### Building BASIC for Mega65
	@echo
	@mkdir -p build/basic_mega65
	@rm -f build/basic_mega65/*
	@for SRC in $(SRC_BASIC_MEGA65); do \
	    ln -s ../../$$SRC build/basic_mega65/$$(basename $$SRC); \
	done
	@ln -s ../../build/basic/packed_messages.s build/basic_mega65/packed_messages.s
	build/preprocess -d build/basic_mega65 -l a000 -h e4d2

build/kernal_mega65/OUT.BIN: $(TOOLS_LIST) $(SRC_KERNAL_MEGA65)
	@echo
	@echo ### Building KERNAL for Mega65
	@echo
	@mkdir -p build/kernal_mega65
	@rm -f build/kernal_mega65/*
	@for SRC in $(SRC_KERNAL_MEGA65); do \
	    ln -s ../../$$SRC build/kernal_mega65/$$(basename $$SRC); \
	done
	build/preprocess -d build/kernal_mega65 -l e4d3 -h ffff

build/newrom_mega65: build/basic_mega65/OUT.BIN build/kernal_mega65/OUT.BIN
	cat build/basic_mega65/OUT.BIN build/kernal_mega65/OUT.BIN  > build/newrom_mega65

build/newkern_mega65: build/newrom_mega65 Makefile
	dd if=build/newrom_mega65 bs=8192 count=1 skip=2 of=build/newkern_mega65

build/newbasic_mega65: build/newrom_mega65 Makefile
	dd if=build/newrom_mega65 bs=8192 count=1 skip=0 of=build/newbasic_mega65

build/newc65: build/newkern_mega65 build/newbasic_mega65 build/chargen Makefile
	dd if=/dev/zero bs=4096 count=10 of=build/newc65
	cat build/newbasic_mega65 build/chargen build/chargen build/newkern_mega65 >>build/newc65
	dd if=/dev/zero bs=65536 count=1 of=build/padding
	cat build/padding >>build/newc65

# Rules - platform 'Ultimate 64'

build/basic_ultimate64/OUT.BIN: $(TOOLS_LIST) $(SRC_BASIC_ULTIMATE64) build/basic/packed_messages.s
	@echo
	@echo ### Building BASIC for Ultimate 64
	@echo
	@mkdir -p build/basic_ultimate64
	@rm -f build/basic_ultimate64/*
	@for SRC in $(SRC_BASIC_ULTIMATE64); do \
	    ln -s ../../$$SRC build/basic_ultimate64/$$(basename $$SRC); \
	done
	@ln -s ../../build/basic/packed_messages.s build/basic_ultimate64/packed_messages.s
	build/preprocess -d build/basic_ultimate64 -l a000 -h e4d2

build/kernal_ultimate64/OUT.BIN: $(TOOLS_LIST) $(SRC_KERNAL_ULTIMATE64)
	@echo
	@echo ### Building KERNAL for Ultimate 64
	@echo
	@mkdir -p build/kernal_ultimate64
	@rm -f build/kernal_ultimate64/*
	@for SRC in $(SRC_KERNAL_ULTIMATE64); do \
	    ln -s ../../$$SRC build/kernal_ultimate64/$$(basename $$SRC); \
	done
	build/preprocess -d build/kernal_ultimate64 -l e4d3 -h ffff

build/newrom_ultimate64: build/basic_ultimate64/OUT.BIN build/kernal_ultimate64/OUT.BIN
	cat build/basic_ultimate64/OUT.BIN build/kernal_ultimate64/OUT.BIN  > build/newrom_ultimate64

build/newkern_ultimate64: build/newrom_ultimate64 Makefile
	dd if=build/newrom_ultimate64 bs=8192 count=1 skip=2 of=build/newkern_ultimate64

build/newbasic_ultimate64: build/newrom_ultimate64 Makefile
	dd if=build/newrom_ultimate64 bs=8192 count=1 skip=0 of=build/newbasic_ultimate64

# Rules - misc

build/basic/packed_messages.s: Makefile build/compress_text
	@mkdir -p build/basic
	build/compress_text > build/basic/packed_messages.s

# Rules - tests

testremote: build/newkern_generic build/newbasic_generic
	x64 -kernal build/newkern-generic -basic build/newbasic-generic -remotemonitor

test: build/newkern_generic build/newbasic_generic
	x64 -kernal build/newkern_generic -basic build/newbasic_generic -8 empty.d64

testm65: build/newc65
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R build/newc65 -4

testsimilarity: build/newrom_generic src/similarity
	build/similarity kernal build/newrom_generic
	build/similarity basic build/newrom_generic
