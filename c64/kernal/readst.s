; Function defined on pp272-273 of C64 Programmers Reference Guide

readst:

	;; Check the current device number

	lda DFLTN
	cmp #$02
	bne +
	
	;; This is RS-232 device - according to 'Compute's Mapping the Commodore 64' page 239
	;; it reads status from RSSTAT
	lda RSSTAT
	rts
*
	;; According to 'Compute's Mapping the Commodore 64' page 239, it usually retrieves
	;; status from IOSTATUS
	
	;; XXX is it always the case if device is not RS-232 ?

	lda IOSTATUS
	rts
