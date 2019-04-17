all:	src/collect_data

src/collect_data:	src/collect_data.c Makefile
	gcc -Wall -o src/collect_data src/collect_data.c
