// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


basic_do_new:	

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__basic_do_new
	jmp     map_NORMAL

basic_do_clr:

	jsr     map_BASIC_1
	jsr_ind VB1__basic_do_clr
	jmp     map_NORMAL

#else

	// Setup pointers to memory storage  XXX should depend on text start vector
	lda #<$0801
	sta TXTTAB+0
	lda #>$0801
	sta TXTTAB+1
	sta VARTAB+1
	lda #<$0803
	sta VARTAB+0

	// Zero line pointer
	// XXX - We should also zero $0800, i.e., TXTTAB - 1
	ldy #$00
	tya
	sta (TXTTAB),y
	iny
	sta (TXTTAB),y
	
	
	// Get top of memory.
	// If a cart is present, then it is $7FFF,
	// if not, then it is $F7FF, since we support having
	// programs and variables under ROM.
	// i.e., we support 56KB RAM for BASIC, keeping some space
	// free for some optimisation structures, e.g., FOR/NEXT loop
	// records (without them going on the stack), GOSUB stack
	// (same story), expression value cache?

	sec			// Read, not write value
	jsr JMEMTOP
	cpx #$80
	beq !+
#if CONFIG_MEMORY_MODEL_60K
	lda #>$F7FF
#else // CONFIG_MEMORY_MODEL_38K
	lda #>$A000
#endif
	.byte $2C
!:	
#if CONFIG_MEMORY_MODEL_60K
	lda #>$F7FF
#else // CONFIG_MEMORY_MODEL_38K
	lda #>$A000
#endif
	sta MEMSIZ+1
	sta FRETOP+1
#if CONFIG_MEMORY_MODEL_60K
	lda #<$F7FF
#else // CONFIG_MEMORY_MODEL_38K
	lda #<$A000
#endif
	sta MEMSIZ+0
	sta FRETOP+0

	// FALL THROUGH

basic_do_clr:

	// Clear variables, arrays and strings
	lda VARTAB+0
	sta ARYTAB+0
	sta STREND+0
	lda VARTAB+1
	sta ARYTAB+1
	sta STREND+1

	rts

#endif // ROM layout
