iec_tx_byte:	

	pha
	
	jsr iec_assert_clk_release_data

	;; Give devices time to respond
	jsr wait1ms

	;; Did a device respond? (DATA will be pulled if so)
	lda $DD00
	sta $0418
	bpl +

	;; No devices present, so we can immediately return with device not found
	pla
	inc $420
	jmp kernalerror_DEVICE_NOT_FOUND
*

	;; Release CLK and wait for DATA to release.
	jsr iec_release_clk_and_data
	
	;; Wait for DATA to be released
	;; Listener is allowed to hold DATA for as long as they want.
	;; i.e., this is the part of the protocol where the listener indicates
	;; that they are busy doing something, like processing the previous
	;; character.
	jsr iec_wait_for_data_release

	;; We then wait for 60 usec (less than 200usec so we don't
	;; signal EOI), before asserting CLK again.
	jsr iec_wait60us

	;; Do the actual transmission of 8 bits of data
	ldx #8

	pla
	
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
	bne iec_tx_byte_nextbit

	;; Done sending bits. Assert CLK and wait for acknowledgement
	jsr iec_assert_clk_release_data

	;; Acknowledgement must happen within 1ms, else it
	;; is DEVICE NOT PRESENT
	;; We can't easily count rasters here, so we just
	;; try a set number of times
	ldx #$ff
*	lda $DD00
	bpl +
	dex
	bne -

	;; Timeout - DEVICE NOT PRESENT
	inc $421
	jmp kernalerror_DEVICE_NOT_FOUND
*
	;; All done.
	;; End state is TALKER is asserting CLK, and listener is asserting DATA
	;; until they are ready for the next byte.
	inc $044f
	clc
	rts
