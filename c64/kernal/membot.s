; Function defined on pp272-273 of C64 Programmers Reference Guide
membot:
	; p287 C64 Programmers reference guide
	;;  http://unusedino.de/ec64/technical/project64/mapping_c64.html
	bcc membot_set
	
	LDX MEMSTR+0
	LDY MEMSTR+1
	rts
membot_set:
	stx MEMSTR+0
	stx MEMSTR+1
	
	rts
