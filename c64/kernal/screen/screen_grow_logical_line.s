
// YYY test all the cases!


screen_grow_logical_line_screen_up:

	jsr screen_scroll_up

	// FALLTROUGH

screen_grow_logical_line_done:

	inc TBLX
	jmp screen_calculate_PNT_USER


screen_grow_logical_line:

	// Do not grow line if previus one is grown
	ldy TBLX
	lda LDTBL,y
	bpl screen_grow_logical_line_done

	// If last line, scroll the screen up
	cpy #24
	beq screen_grow_logical_line_screen_up

	// Do not grow line if already grown
	iny
	lda LDTBL,y
	bpl screen_grow_logical_line_done
	
	// Mark current line as grown
	lda #$00
	sta LDTBL,y

	// Now we have to scroll lines downwards to make space. We start from the end,
	// and work backwards. We cannot be as simple and efficient here as we are
	// for scrolling up, because we do not know how much must be scrolled.

	// Preserve SAL and EAL

	jsr screen_preserve_sal_eal

	// Work out how many physical lines to scroll down

	lda #23
	sec
	sbc TBLX
	beq screen_grow_logical_line_copy_done       // branch if no need to copyy
	tax

	// Prepare initial SAL/EAL/PNT/USER values

	lda HIBASE
	clc
	adc #3
	sta SAL+1
	sta EAL+1

	lda #>$DB00                        // 3rd page of the color memory
	sta PNT+1
	sta USER+1

	lda #<$03C0                        // start of destination row
	sta EAL+0
	sta USER+0
	lda #<$03C0                        // start of source row
	sta SAL+0
	sta PNT+0

screen_grow_logical_line_loop:

	// Scroll down one line each loop iteration

	ldy #39
!:
	lda (SAL),  y
	sta (EAL),  y
	lda (PNT),  y
	sta (USER), y
	dey
	bpl !-

	// Decrement SAL/PNT pointers by 40 (optimized due to fact they share LSB)

	lda SAL+0
	sec
	sbc #40
	sta SAL+0
	sta PNT+0
	bcs !+
	dec SAL+1
	dec PNT+1
!:
	// Decrement EAL/USER pointers by 40 (optimized due to fact they share LSB)

	lda EAL+0
	sec
	sbc #40
	sta EAL+0
	sta USER+0
	bcs !+
	dec EAL+1
	dec USER+1
!:
	// Next loop iteration

	dex
	bne screen_grow_logical_line_loop

screen_grow_logical_line_copy_done:

	// Restore SAL and EAL

	jsr screen_restore_sal_eal

	// Erase newly inserted line and quit

	ldx TBLX
	inx
	jmp screen_clear_line
