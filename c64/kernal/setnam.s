; Function defined on pp272-273 of C64 Programmers Reference Guide

setnam:

	;; There are 6 sane ways to implement this routine,
	;; I hope this one won't cause similarity to CBM code

	sta current_filename_length
	sty current_filename_ptr + 1
	stx current_filename_ptr + 0

	rts
