// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Keyboard part of the CHRIN routine - programmable keys support
// Output: if Carry clear, programmable key was handled
//


#if CONFIG_PROGRAMMABLE_KEYS

chrin_programmable_keys:

	// Check if the key is programmable

	ldx #(__programmable_keys_codes_end - programmable_keys_codes - 1)
!:
	cmp programmable_keys_codes, x
	beq !+
	dex
	bpl !-

	// This is not a programmable key

	sec
	rts
!:
	// .X contains index of the key code, we need offset to key string instead

	lda programmable_keys_offsets, x
	tax

	// Print all the characters assigned to key
!:
	lda programmable_keys_strings, x
	beq !+
	jsr CHROUT // our implementation preserves .X too
	inx
	bne !-     // jumps always
!:
	clc
	rts

#endif // CONFIG_PROGRAMMABLE_KEYS
