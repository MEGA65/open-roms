; Function defined on p295 of C64 Programmers Reference Guide

screen:

	;; There are only 2 sane ways to implement this routine,
	;; I hope this one is different than what Commodore picked :)

	ldy #25 ; 25 columns
	ldx #40 ; 40 rows

	rts
