all:	src/collect_data src/preprocess

src/collect_data:	src/collect_data.c Makefile
	gcc -Wall -o src/collect_data src/collect_data.c

src/preprocess:	src/preprocess.c Makefile
	gcc -g -Wall -o src/preprocess src/preprocess.c


c64/kernal-disasembly.html:
	wget -O c64/kernal-disassembly.html http://www.ffd2.com/fridge/docs/c64-diss.html

newkern:	c64/kernal/OUT.BIN
	cat e000-e4d2 c64/kernal/OUT.BIN  >newkern

c64/kernal/OUT.BIN:	src/preprocess c64/kernal/*.s
	src/preprocess -d c64/kernal

test:	newkern
	x64 -kernal newkern -remotemonitor
