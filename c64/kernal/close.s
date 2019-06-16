; Function defined on pp272-273 of C64 Programmers Reference Guide
close:

	;; Implemented accorging to 'C64 Programmers Reference Guide', page 281

	;; XXX this needs more testing (opening 10 files at once, closing in various orders, etc) once the code is more mature
	
	;; Find the LAT / SAT / FAT entry which LAT corresponds to A
	
	ldy LDTND
	beq close_error_not_found ; table empty
*
	dey
	bmi close_error_not_found ; no more entries
	cmp LAT, y
	bne - ; does not match, try the next one
	
	;; We have the entry index in Y
	
	;; XXX some devices (like IEC) needs special support here, to free their internal resources!
	;; Just make sure the Y register value is kept, or redo ldy DFTLN
*
	iny
	cpy #$0A
	bpl +
	lda LAT, y
	sta LAT-1, y
	lda FAT, y
	sta FAT-1, y
	lda SAT, y
	sta SAT-1, y
	jmp -
*
	;; Decrement the list size variable
	dec LDTND
	;; FALLTHROUGH (for now) - success
	
close_error_not_found:
	
	;; XXX it seems that this function can't report errors, am I right?
	rts
