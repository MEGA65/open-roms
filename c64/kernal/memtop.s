; Function defined on pp272-273 of C64 Programmers Reference Guide
memtop:
	; p288 C64 Programmer's reference guide
	; but for now we only support reading it
	;;  http://unusedino.de/ec64/technical/project64/mapping_c64.html
	bcc memtop_set
	
	LDY MEMSIZ+1
	LDX MEMSIZ+0
	rts
memtop_set:
	sty MEMSIZ+1
	stx MEMSIZ+0
	
	rts
