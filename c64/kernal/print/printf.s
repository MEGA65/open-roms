#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// printf()-like routine for simplifying debugging

// Prints the literal zero-terminated string that follows,
// which may also include special tokens that allow
// printing of hex byte and word values stored at the indicated
// addresses.

// .byte 1,$byte = display byte as hex
// .byte 2,$low,$hi = display word as hex
// .byte $f0+n,$low,$hi = display byte at $hi$lo+n as hex

#if CONFIG_DBG_PRINTF

printf:
	// Temporary storage is between end of screen at $0400
	// and the sprite pointers at $7f8
	sta $7f0
	stx $7f1
	sty $7f2
	php
	pla
	sta $7f3
	
	// Set up read routine
	lda #$ad 		// LDA $nnnn
	sta $7f4
	lda #$60
	sta $7f7		// RTS
	
	// Get PC of caller from the stack, so that
	// we can parse through it
	pla
	clc
	adc #$01
	sta $7f5
	pla
	adc #$00
	sta $7f6

printf_loop:
	jsr $7f4
	cmp #$00
	bne printf_continues
	// Put return address on stack and restore
	// registers
	lda $7f6
	pha
	lda $7f5
	pha
	lda $7f3
	pha
	lda $7f0
	ldx $7f1
	ldy $7f2
	plp
	rts

printf_continues:
	cmp #$01
	bne not_hexbyte
	// Print a hex byte

	// Skip the token
	jsr printf_advance
	// Read the low byte
	jsr $7f4
	// Print as hex
	jsr print_hex_byte
	jmp printf_nextchar
	
not_hexbyte:
	cmp #$02
	bne not_hexword
	// Print a hex word

	// Skip the token
	jsr printf_advance
	jsr printf_advance
	// Read the high byte
	jsr $7f4
	// Print as hex
	jsr print_hex_byte
	// Skip the token
	jsr printf_retreat
	// Read the low byte
	jsr $7f4
	// Print as hex
	jsr print_hex_byte
	jsr printf_advance
	jmp printf_nextchar
	
not_hexword:
	cmp #$f0
	bcc not_pointer

	// Treat two-byte arg as base address
	// and lower 4 bits of token as offset from
	// that location.

	// Get offset
	and #$0f
	tay

	jsr printf_advance
	jsr $7f4
	sta $fd
	jsr printf_advance
	jsr $7f4
	sta $fe

	lda ($fd),y
	jsr print_hex_byte
	jmp printf_nextchar

not_pointer:	
	// Print character
	jsr JCHROUT

printf_nextchar:
	jsr printf_advance
	jmp printf_loop

printf_advance:
	// Advance pointer to next character
	inc $7f5
	bne !+
	inc $7f6
!:
	rts

printf_retreat:
	// Retreat pointer to previous char
	lda $7f5
	sec
	sbc #1
	sta $7f5
	lda $7f6
	sbc #0
	sta $7f6
	rts

#endif // CONFIG_DBG_PRINTF


#endif // ROM layout
