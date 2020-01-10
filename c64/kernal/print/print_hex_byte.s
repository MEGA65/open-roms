#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Print the hex value in .A as two digits
//

print_hex_byte:

#if HAS_BCD_SAFE_INTERRUPTS

	// Idea by Haubitze

	sed
	pha
	lsr
	lsr
	lsr
	lsr
	cmp #$0A
	adc #$30
	cld
	jsr JCHROUT
	sed
	pla
	and #$0F
	cmp #$0A
	adc #$30
	cld
	jmp JCHROUT

#else

	pha
	lsr
	lsr
	lsr
	lsr
	ora #$30
	cmp #$3A
	bcc !+
	adc #6
!:	jsr JCHROUT
	pla
	and #$0f
	ora #$30
	cmp #$3A
	bcc !+
	adc #6
!:	jmp JCHROUT

#endif


#endif // ROM layout
