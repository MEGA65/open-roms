// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


// Kernal status codes are described in 'Commodore 64 Programmers Reference Guide', page 292

kernalstatus_reset:
	lda #$00
	beq kernalstatus_end               // branch always

// The following two statuses are currently not implemented - and most likely not really needed

// kernalstatus_TIMEOUT_WRITE:
//
//	lda IOSTATUS
//	ora #K_STS_TIMEOUT_WRITE
//	bne kernalstatus_end               // branch always

// kernalstatus_TIMEOUT_READ:
//
//	lda IOSTATUS
//	ora #K_STS_TIMEOUT_READ
//	bne kernalstatus_end               // branch always

kernalstatus_EOI:

	lda IOSTATUS
	ora #K_STS_EOI
	bne kernalstatus_end               // branch always

kernalstatus_DEVICE_NOT_FOUND:

	lda IOSTATUS
	ora #K_STS_DEVICE_NOT_FOUND

	// FALLTROUGH

kernalstatus_end:

	sta IOSTATUS
	rts
