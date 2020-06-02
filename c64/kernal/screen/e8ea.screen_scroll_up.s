// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Scroll the whole screen up by 1 logical line, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 218
//


screen_scroll_up:

	// First handle CTRL and NO_SCRL keys

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

	// FALLTROUGH

screen_scroll_up_delay_done: // entry point for cursor move control codes

	// Scroll the LDTB1 (line link table)

	ldy #$00
!:
	lda LDTB1+1, y
	sta LDTB1+0, y
	iny
	cpy #24
	bne !-

	lda #$80
	sta LDTB1+24

	// Preserve SAL and EAL, prepare initial SAL/EAL/PNT/USER values

	jsr screen_preserve_sal_eal

	lda HIBASE
	sta SAL+1
	sta EAL+1

	lda #>COLOR_RAM
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

	jsr screen_restore_sal_eal

	// Clear the newly introduced line

	ldx #24
	jsr screen_clear_line

	// Decrement the current physical line number

	dec TBLX

	// If the first line is linked, scroll once more

	bit LDTB1+0
	bpl screen_scroll_up

 	// Recalculate PNT and USER

	jmp screen_calculate_PNT_USER
