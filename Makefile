all:	src/collect_data

src/collect_data:	src/collect_data.c Makefile
	gcc -Wall -o src/collect_data src/collect_data.c

c64/kernal-disasembly.html:
	wget -O c64/kernal-disassembly.html http://www.ffd2.com/fridge/docs/c64-diss.html
