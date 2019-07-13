; Function defined on pp272-273 of C64 Programmers Reference Guide
ciout:

	;; This routine is documented in 'Compute's Mapping the Commodore 64', page 224

	pha
	lda C3PO
	bne ciout_send_byte

	;; Nothing to send - set buffer as valid, store byte there
	inc C3PO

	;; Clear carry flag to indicate success
	clc
	
ciout_store_in_buffer:

	;; Store in the buffer data to be sent next, return
	pla
	sta BSOUR
	rts
	
ciout_send_byte:

	;; Send previous data
	lda BSOUR
	clc ; don't send with EOI
	jsr iec_tx_byte
	jmp ciout_store_in_buffer

