// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Keyboard scanning routine extension for C128 keyboards
//
// - [CM128] Computes Mapping the Commodore 128 - pages 212 (SHFLAG), 290 (matrix)
//


#if CONFIG_KEYBOARD_C128 && !CONFIG_LEGACY_SCNKEY


// Inlining this within SCNKEY would both overcomplicate the implementation
// and disrupt a lot of branches (they would cross the 127 bytes distance limit)

// .Y is now $FF - try to put there a key code from extended keyboard


scnkey_128:

	sty CIA1_PRA                        // disconnect all the classic keys first

	ldx #$02
scnkey_matrix_128_loop:
	lda kb_matrix_row_keys, x
	sta VIC_XSCAN
	lda kb_matrix_128_bucky_filter, x  // filter out bucky keys
	ora CIA1_PRB
	cmp #$FF
	beq scnkey_matrix_128_loop_next    // skip if no key pressed from this row
	cpy #$FF
	bne scnkey_128_no_keys             // jam, more than one key pressed
	// We have at least one key pressed in this row, we need to find which one exactly
	ldy #$07
scnkey_matrix_128_loop_inner:
	cmp kb_matrix_row_keys, y
	bne !+                             // not this particular key
	tya                                // now .A contains key offset within a row
	clc
	adc kb_matrix_row_offsets, x       // now .A contains key offset from the matrix start
	adc #$41                           // now .A contains offset after the standard matrix
	tay
	jmp scnkey_matrix_128_loop_next
!:
	dey
	bpl scnkey_matrix_128_loop_inner
	bmi scnkey_128_no_keys             // branch always, multiple keys must have been pressed
scnkey_matrix_128_loop_next:
	dex
	bpl scnkey_matrix_128_loop

	// Scanning the C128 keyboard part complete

scnkey_128_done:

	stx VIC_XSCAN                  // $FF, disconnects C128 keys
	rts


scnkey_128_no_keys:

	pla                            // get rid of return address from the stack
	pla

	jmp scnkey_no_keys             // pass controll to original routine


#endif // CONFIG_KEYBOARD_C128 and no CONFIG_LEGACY_SCNKEY
