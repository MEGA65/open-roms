; Function defined on pp272-273 of C64 Programmers Reference Guide
memtop:
	; p288 C64 Programmer's reference guide
	; but for now we only support reading it
	LDX #<$9FFF
	LDY #>$9FFF
	rts
