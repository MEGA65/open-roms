; Function defined on pp272-273 of C64 Programmers Reference Guide
membot:
	; p287 C64 Programmers reference guide
	; For now, we only read it, not allow setting it
	LDX #<$0800
	LDY #>$0800
	rts
