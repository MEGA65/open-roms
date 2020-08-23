// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Print out the amount of free bytes - for the startup banner
//


initmsg_bytes_free:

	// Setup pointers to BASIC memory storage

	lda #<$0801
	sta TXTTAB+0
	lda #>$0801
	sta TXTTAB+1

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
#elif CONFIG_MEMORY_MODEL_50K
	lda #>$D000	
#elif CONFIG_MEMORY_MODEL_46K
	lda #>$C000
#else // CONFIG_MEMORY_MODEL_38K
	lda #>$A000
#endif
	skip_2_bytes_trash_nvz
!:	
	lda #>$8000
	sta MEMSIZ+1
#if CONFIG_MEMORY_MODEL_60K
	cpx #$80
	beq !+
	lda #$FF
	skip_2_bytes_trash_nvz
!:
	lda #<$00
#else // CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	lda #<$00
#endif
	sta MEMSIZ+0

	// Print number of bytes free

    sec
	lda MEMSIZ+0
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer

	ldx #IDX__STR_BYTES
	jmp print_packed_misc_str
