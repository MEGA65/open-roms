
// Flush the IEC output buffer (if not empty) - send byte with EOI
//
// Preserves .X, .Y and .A registers

iec_tx_flush:

	pha
	lda C3PO
	beq !+
	sec // send it with EOI
	jsr iec_tx_byte // send the command regardless of the status
!:
	pla
	rts
