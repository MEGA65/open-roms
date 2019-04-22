all:	src/collect_data src/preprocess

src/collect_data:	src/collect_data.c Makefile
	gcc -Wall -o src/collect_data src/collect_data.c

src/preprocess:	src/preprocess.c Makefile
	gcc -g -Wall -o src/preprocess src/preprocess.c


newrom:	c64/kernal/OUT.BIN c64/basic/OUT.BIN
	cat c64/basic/OUT.BIN c64/kernal/OUT.BIN  >newrom

newkern:	newrom Makefile
	dd if=newrom bs=8192 count=1 skip=1 of=newkern

newbasic:	newrom Makefile
	dd if=newrom bs=8192 count=1 skip=0 of=newbasic


c64/kernal/OUT.BIN:	src/preprocess c64/kernal/*.s
	src/preprocess -d c64/kernal -l e4d3 -h ffff

c64/basic/OUT.BIN:	src/preprocess c64/basic/*.s
	src/preprocess -d c64/basic -l a000 -h e4d2

test:	newkern newbasic
	x64 -kernal newkern -basic newbasic -remotemonitor
