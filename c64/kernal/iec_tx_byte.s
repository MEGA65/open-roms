iec_tx_byte:	

	;; Do the actual transmission of 8 bits of data
	ldx #8

iec_tx_byte_nextbit:	
	;; Is next bit 0 or 1?
	lsr
	pha
	bcs +
	
	;; Setup 0
	jsr iec_assert_clk_release_data
	jmp iec_tx_byte_l1
*
	;; Setup 1
	jsr iec_assert_clk_and_data
iec_tx_byte_l1:
	;; Clock bit out
	jsr iec_wait20us
	jsr iec_release_clk
	jsr iec_wait20us

	;; More bits to send?
	pla
	dex
	bpl iec_tx_byte_nextbit

	;; Done sending bits. Wait for acknowledgement
	jsr iec_assert_clk_release_data

	;; Acknowledgement must happen within 1ms, else it
	;; is DEVICE NOT PRESENT
	;; We can't easily count rasters here, so we just
	;; try a set number of times
	ldx #$ff
*	lda $DD00
	bmi +
	dex
	bne -

	;; Timeout - DEVICE NOT PRESENT
	cli
	jmp kernalerror_DEVICE_NOT_FOUND
*
	;; All done.
	;; End state is TALKER is asserting CLK, and listener is asserting DATA
	;; until they are ready for the next byte.
	clc
	rts
