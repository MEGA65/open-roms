// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Refresh back-pointer to arrays
//


#if CONFIG_MEMORY_MODEL_38K // XXX! create versions for other memory models

helper_array_refresh_bptrs:

	// Refresh back-pointers to arrays

	lda ARYTAB+0
	sta INDEX+0
	lda ARYTAB+1
	sta INDEX+1

	// FALLTROUGH

helper_array_refresh_bptrs_loop_1:

	// Check if we reached end of arays

	lda INDEX+1
	cmp STREND+1
	bne !+
	lda INDEX+0
	cmp STREND+0
	beq helper_array_refresh_bptrs_end
!:
	// Calculate start address of the next array, store it in INDEX+2/+3

	ldy #$02

	lda (INDEX+0), y // XXX
	clc
	adc INDEX+0
	sta INDEX+2 
	iny
	lda (INDEX+0), y // XXX
	adc INDEX+1
	sta INDEX+3

	// Check if the current array is a string - if not, go to next array

	ldy #$00
	lda (INDEX+0), y // XXX
	bmi helper_array_refresh_bptrs_loop_next
	iny
	lda (INDEX+0), y // XXX
	bpl helper_array_refresh_bptrs_loop_next

	// It's a string array - scroll INDEX+0/+1 to the first descriptor

	ldy #$04
	lda (INDEX+0), y // XXX
	asl
	clc
	adc #$05
	jsr helper_INDEX_up_A

	// FALLTROUGH

helper_array_refresh_bptrs_loop_2:

	// Recreate the back-pointer

	ldy #$00
	lda (INDEX+0), y // XXX
	beq helper_array_refresh_bptrs_skip      // skip empty strings

	iny
	clc
	adc (INDEX+0), y // XXX
	sta INDEX+4
	iny
	lda #$00
	adc (INDEX+0), y // XXX
	sta INDEX+5

	ldy #$00
	lda INDEX+0
	sta (INDEX+4), y // XXX
	iny
	lda INDEX+1
	sta (INDEX+4), y // XXX

	// FALLTROUGH

helper_array_refresh_bptrs_skip:

	// Shift INDEX+0/+1 to the next string

	lda #$03
	jsr helper_INDEX_up_A

	// Check if this is the last string of the array

	lda INDEX+0
	cmp INDEX+2
	bne helper_array_refresh_bptrs_loop_2
	lda INDEX+1
	cmp INDEX+3
	bne helper_array_refresh_bptrs_loop_2

helper_array_refresh_bptrs_loop_next:

	lda INDEX+3
	sta INDEX+1
	lda INDEX+2
	sta INDEX+0

	jmp_8 helper_array_refresh_bptrs_loop_1

helper_array_refresh_bptrs_end:

	rts

#endif