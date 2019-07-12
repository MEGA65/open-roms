; Function defined on pp272-273 of C64 Programmers Reference Guide

unlsn:

	;; This routine is documented in 'Compute's Mapping the Commodore 64', page 224
	
	;; First check whether we have something to be sent in the buffer
	lda C3PO
	beq +
	lda BSOUR
	sec ; send it with EOI
	jsr iec_tx_byte		; XXX what about the status of this operation?
	;; Mark the buffer as invalid
	lda #$00
	sta C3PO
*
	;; Buffer empty send the command
	lda #$3F
	jmp iec_tx_command


