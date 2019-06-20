all:	Ophis src/collect_data src/preprocess

Ophis:
	git submodule init
	git submodule update

src/pngprepare:	src/pngprepare.c Makefile
	$(CC) $(COPT) -I/usr/local/include -L/usr/local/lib -o src/pngprepare src/pngprepare.c -lpng

chargen:	src/pngprepare assets/8x8font.png
	src/pngprepare charrom assets/8x8font.png chargen

src/collect_data:	src/collect_data.c Makefile
	gcc -Wall -o src/collect_data src/collect_data.c

src/preprocess:	src/preprocess.c Makefile
	gcc -g -Wall -o src/preprocess src/preprocess.c

src/similarity:	src/similarity.c Makefile
	gcc -g -Wall -o src/similarity src/similarity.c

src/compress_text:	src/compress_text.c Makefile
	gcc -g -Wall -o src/compress_text src/compress_text.c -lm

newrom:	c64/kernal/OUT.BIN c64/basic/OUT.BIN
	cat c64/basic/OUT.BIN c64/kernal/OUT.BIN  >newrom

newkern:	newrom Makefile
	dd if=newrom bs=8192 count=1 skip=2 of=newkern

newbasic:	newrom Makefile
	dd if=newrom bs=8192 count=1 skip=0 of=newbasic

newc65:		newkern newbasic chargen Makefile
	dd if=/dev/zero bs=4096 count=10 of=newc65
	cat newbasic chargen chargen newkern >>newc65
	dd if=/dev/zero bs=65536 count=1 of=padding
	cat padding >>newc65


c64/basic/packed_messages.s:	Makefile src/compress_text
	src/compress_text > c64/basic/packed_messages.s

c64/kernal/OUT.BIN:	src/preprocess c64/kernal/*.s
	src/preprocess -d c64/kernal -l e4d3 -h ffff

c64/basic/OUT.BIN:	src/preprocess c64/basic/*.s c64/basic/packed_messages.s
	src/preprocess -d c64/basic -l a000 -h e4d2

testremote:	newkern newbasic
	x64 -kernal newkern -basic newbasic -remotemonitor

test:	newkern newbasic
	x64 -kernal newkern -basic newbasic -8 empty.d64

testm65:	newc65
	m65 -b ../mega65-core/bin/mega65r1.bit -k ../mega65-core/bin/KICKUP.M65 -R newc65 -4

testsimilarity:	newkern newbasic src/similarity
	src/similarity kernal newrom 
	src/similarity basic newrom 
