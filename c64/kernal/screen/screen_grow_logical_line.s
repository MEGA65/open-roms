

screen_grow_logical_line_done:
	rts

screen_grow_logical_line:
	
	// Do not grow line if it is already grown
	ldy TBLX
	lda LDTBL,y
	bmi screen_grow_logical_line_done

	// Do not grow line if previous grown
	dey
	bmi !+
	lda LDTBL,y
	bmi screen_grow_logical_line_done
!:
	iny

	// Mark current line as grown
	lda #$80
	sta LDTBL,y

	// Now make space for the extra line added.
	// If we are on the last physical line of the screen,
	// Then we need to scroll the screen up
	jsr screen_scroll_up_if_on_last_line

	// Count the number of physical lines to scroll down
	ldx #$01
	ldy TBLX
!:
	iny
	cpy #23
	bcs !+

	lda LDTBL,y
	bmi !-
	inx
	bne !-                             // branch always
!:
	cpx #$00
	beq no_copy_down

	// Scroll screen down to make space
	// As we are scrolling down, we start from the end,
	// and work backwards. We can't be as simple and efficient
	// here as we are for scrolling up, because we don't know
	// how much must be scrolled.
	// Simple solution is to work out how many physical lines
	// need shifting down, and then move lines at a time after
	// initialising the pointers to the end area of the screen.

	// Preserve EAL
	lda EAL+0
	pha
	lda EAL+1
	pha

	// XXX prevent cursor from interfering
	// XXX fix TBLX value

	// Set pointers to end of screen line, and one line
	// above.  (It is always one physical line, because
	// this can only happen when expanding a line from 40 to
	// 80 characters).
	// XXX - This is not very efficient, and longer than it
	// needs to be. Better would be to work out size to
	// copy, and count it down in a pointer somewhere, so
	// that loop iteration logic is simpler.
	lda HIBASE
	clc
	adc #3
	sta PNT+1
	sta SAL+1
	lda #>$DBC0
	sta EAL+1
	sta USER+1

	lda #<$03C0
	sta PNT+0
	sta USER+0
	//  souce address is line above
	sec
	sbc #40
	sta SAL+0
	sta EAL+0

copy_line_down_loop:
	ldy #39
cl_inner:
	lda (EAL),y
	sta (USER),y
	lda (SAL),y
	sta (PNT),y
	dey
	bpl cl_inner

	// Decrement all pointers by 40
	// Low bytes are in common pairs

	// Old source is new destination
	// Use different registers to minimise byte similarity with C64 KERNAl
	ldy SAL+1
	sty PNT+1
	lda EAL+1
	ldy SAL+0
	sta USER+1
	sty PNT+0
	sty USER+0
	
	// Decrementing source pointers
	lda SAL+0
	sec
	sbc #<40
	sta SAL+0
	sta EAL+0
	lda SAL+1
	sbc #>40
	sta SAL+1
	// convert to screen equivalent
	sec
	sbc HIBASE
	clc
	adc #>$D800
	sta EAL+1

	dex
	bne copy_line_down_loop

 	// Restore EAL
 	pla
 	sta EAL+1
 	pla
 	sta EAL+0

no_copy_down:
	jsr screen_calculate_line_pointer

	// Erase newly inserted line
	ldy #79
!:
	lda COLOR
	sta (USER),y
	lda #$20
	sta (PNT),y
	dey
	cpy #39
	bne !-

	rts
