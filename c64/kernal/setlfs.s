; Function defined on pp272-273 of C64 Programmers Reference Guide

setlfs:

	;; There are 6 sane ways to implement this routine,
	;; I hope this one won't cause similarity to CBM code
	
	sta current_logical_filenum
	sty current_secondary_address
	stx current_device_number
	
	rts
