; Function defined on pp272-273 of C64 Programmers Reference Guide
stop:
	;; Bit 7 of BUCKYSTATUS contains the state of the STOP key
	;; (Compute's Mapping the 64, p27)

	;; Get it into the carry flag by rotating left
	lda BUCKYSTATUS
	rol
	rts
