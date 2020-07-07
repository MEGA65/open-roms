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

	// Check whether we reached FRETOP

	lda TXTPTR+0
	cmp FRETOP+0
	bne varstr_garbage_collect_check_bptr
	lda TXTPTR+1
	cmp FRETOP+1
	bne varstr_garbage_collect_check_bptr

	// End of strings - nothing more to do

	// FALLTROUGH

varstr_garbage_collect_end:

	// Restore TXTPTR and quit

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
	sta DSCPNT+2
	iny
	jsr peek_under_roms
	ora DSCPNT+2 
#elif CONFIG_MEMORY_MODEL_46K || CONFIG_MEMORY_MODEL_50K
	// XXX consider optimized version without multiple JSRs
	jsr peek_under_roms_via_TXTPTR
	sta DSCPNT+2
	iny
	jsr peek_under_roms_via_TXTPTR
	ora DSCPNT+2 
#else // CONFIG_MEMORY_MODEL_38K
	lda (TXTPTR),y
	iny
	ora (TXTPTR),y 
#endif

	beq varstr_garbage_collect_unused 
	
	// The back-pointer is not NULL - string is used

	// XXX implement this

varstr_garbage_collect_unused:

	// The back-pointer is NULL - string is unused

	// XXX implement this

#if HAS_OPCODES_65C02
	bra varstr_garbage_collect_end
#else
	jmp varstr_garbage_collect_end
#endif






	// XXX move this routine to a separate file

varstr_TXTPTR_down_A:                  // .A - bytes to lower TXTPTR, uses DSCPNT+2

	sta DSCPNT+2 

	sec
	lda TXTPTR+0
	sbc DSCPNT+2 
	sta TXTPTR+0
	bcs !+
	dec TXTPTR+1
!:
	rts
