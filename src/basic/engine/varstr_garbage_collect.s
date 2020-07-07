// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

// XXX test this routine

varstr_garbage_collect:

	// The routine utilizes the 'shift_mem_up' - which leaves INDEX+0 and INDEX+1
	// free to be used, but INDEX+2 and beyond would be overwritten

	// We will reuse TXTPTR as the moving pointer, so store it on the stack

	lda TXTPTR+0
	pha
	lda TXTPTR+1
	pha

	// Similarly, we will reuse OLDTXT as the pointer to string descriptor

	lda OLDTXT+0
	pha
	lda OLDTXT+1
	pha	

	// INDEX+0 and INDEX+1 will be our cumulative shift counter

	lda #$00
	sta INDEX+0
	sta INDEX+1

	// Start from the highest string and go downwards

	lda MEMSIZ+0
	sta TXTPTR+0
	lda MEMSIZ+1
	sta TXTPTR+1

varstr_garbage_collect_loop:

	// Check if this was the last string
	// XXX instead check if FRETOP+INDEX == TXTPTR

	lda TXTPTR+0
	cmp FRETOP+0
	bne varstr_garbage_collect_check_bptr
	lda TXTPTR+1
	cmp FRETOP+1
	bne varstr_garbage_collect_check_bptr

	// End of strings - nothing more to do

	// FALLTROUGH

varstr_garbage_collect_end:

	// Restore OLDTXT and TXTPTR, and quit

	pla
	sta OLDTXT+1
	pla
	sta OLDTXT+0
	pla
	sta TXTPTR+1
	pla
	sta TXTPTR+0

	rts

varstr_garbage_collect_check_bptr:

	// Decrement TXTPTR by 2, so that it points to the back-pointer

#if !HAS_OPCODES_65CE02
	lda #$02
	jsr varstr_TXTPTR_down_A
#else // HAS_OPCODES_65CE02
	dew TXTPTR
	dew TXTPTR
#endif

	// Check whether the back-pointer is NULL

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<TXTPTR
	jsr peek_under_roms
	sta OLDTXT+0
	iny
	jsr peek_under_roms
	sta OLDTXT+1
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs
	jsr peek_under_roms_via_TXTPTR
	sta OLDTXT+0
	iny
	jsr peek_under_roms_via_TXTPTR
	sta OLDTXT+1
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
	sta OLDTXT+0
	iny
	lda (TXTPTR),y
	sta OLDTXT+1
#endif

	ora OLDTXT+0
	beq varstr_garbage_collect_unused 
	
	// The back-pointer is not NULL - string is used
	// Increase the string descriptor pointer by INDEX

	// XXX implement this

	// Move string memory up by INDEX

	// XXX

	// Update TXTPTR

	// XXX

	// Next iteration

#if HAS_OPCODES_65C02
	bra varstr_garbage_collect_loop
#else
	jmp varstr_garbage_collect_loop
#endif

varstr_garbage_collect_unused:

	// The back-pointer is NULL - string is a garbage to collect
	// Fetch the string length

#if !HAS_OPCODES_65CE02
	lda #$01
	jsr varstr_TXTPTR_down_A
#else // HAS_OPCODES_65CE02
	dew TXTPTR
#endif

	ldy #$00
	lda (TXTPTR), y

	// Decrement string length by 1, it will be easier to perform calculations

	tax
	dex

	// Increase INDEX (shift offset) by string length + back-pointer length

	lda #$03
	jsr varstr_INDEX_up_A
	txa
	jsr varstr_INDEX_up_A

	// Decrease TXTPTR by unused string length-1

	tax
	jsr varstr_TXTPTR_down_A

	// Next iteration

#if HAS_OPCODES_65C02
	bra varstr_garbage_collect_loop
#else
	jmp varstr_garbage_collect_loop
#endif






	// XXX move these routines to separate files

varstr_TXTPTR_down_A:                  // .A - bytes to decrease TXTPTR, uses DSCPNT+2

	sta DSCPNT+2 

	sec
	lda TXTPTR+0
	sbc DSCPNT+2 
	sta TXTPTR+0
	bcs !+
	dec TXTPTR+1
!:
	rts


varstr_INDEX_up_A:                     // .A - bytes to increase TXTPTR, uses DSCPNT+2

	sta DSCPNT+2 

	clc
	lda INDEX+0
	adc DSCPNT+2 
	sta INDEX+0
	bcc !+
	dec INDEX+1
!:
	rts
