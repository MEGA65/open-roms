
//
// Scroll the whole screen up by 1 logical line
//


screen_scroll_up:


#if CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65

	// Do not scroll if NO_SCRL is pressed and interrupts are enabled
!:
	php
	pla
	and #%00000010
	bne !+                             // branch if IRQs disabled, we cannot detect NO_SCRL status

	lda SHFLAG
	and #KEY_FLAG_NO_SCRL
	bne !-
!:
#endif

	// Check if CTRL key pressed - if so, perform a delay

	lda SHFLAG
	and #KEY_FLAG_CTRL
	beq screen_scroll_up_delay_done

	ldy #$09
!:
	ldx #$FF
	jsr wait_x_bars
	dey
	bne !-

screen_scroll_up_delay_done:

	// First scroll the LDTBL (line link table)

	ldy #$00
!:
	lda LDTBL+1, y
	sta LDTBL+0, y
	iny
	cpy #24
	bne !-

	lda #$80
	sta LDTBL+24

	// Preserve SAL and EAL

	lda SAL+0
	pha
	lda SAL+1
	pha	
	lda EAL+0
	pha
	lda EAL+1
	pha

	// Now, we need to scroll both screen memory and color memory; first create start/end pointers

	lda HIBASE
	sta SAL+1
	sta EAL+1

	lda #>$D800
	sta PNT+1
	sta USER+1

	lda #$00
	sta EAL+0
	sta USER+0
	lda #40
	sta SAL+0
	sta PNT+0

	// Now copy, SAL->EAL, PNT->USER, in a loop

	ldy #$00

screen_scroll_up_loop:

	lda (SAL),  y
	sta (EAL),  y
	lda (PNT),  y
	sta (USER), y

	// Check if this was the last byte (last destination byte for color copy is #DBBF)

	cpy #$BF
	bne !+                             // definitely not the last byte
	lda USER+1
	cmp #$DB
	beq screen_scroll_up_loop_done
!:
	// Increment .Y, possibly advance pointers

	iny
	bne screen_scroll_up_loop

	inc SAL+1
	inc EAL+1
	inc USER+1
	inc PNT+1
	bne screen_scroll_up_loop          // branch alwayys

screen_scroll_up_loop_done:

	// Restore SAL and EAL
	
 	pla
 	sta EAL+1
 	pla
 	sta EAL+0
 	pla
 	sta SAL+1
 	pla
 	sta SAL+0

	// Clear the newly introduced line

	ldx #24
	jsr screen_clear_line

	// Decrement the current physical line number

	dec TBLX

	// If the first line is linked, scroll once more

	bit LDTBL+0
#if CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65
	bpl_far screen_scroll_up
#else
	bpl screen_scroll_up
#endif

 	// Recalculate PNT and USER

	jmp screen_calculate_PNT_USER






/* YYY disabled for rework, add CTRL and NO_SCROLL support

not_last_line:
	rts

screen_scroll_up_if_on_last_line:

	// Colour RAM is always in fixed place, so is easiest
	// to use to check if we are on the last line.
	// The last line is at $D800 + 24*40 = $DBC0
	lda USER+1
	cmp #>$DBC0
	bne not_last_line

	lda USER+0
	cmp #<$DBC0
	beq is_last_line

	jsr screen_get_current_line_logical_length
	clc
	adc USER+0
	cmp #<$DBE7-1
	bcc not_last_line

is_last_line:

	dec TBLX

	// FALLTHROUGH to screen_scroll_up

*/