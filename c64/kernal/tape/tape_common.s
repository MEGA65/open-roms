
//
// Common routines for tape support
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


//
// Check if VERIFY asked - if yes, terminate loading
//

tape_ditch_verify:

	lda VERCKK
	bne !+
	rts
!:
	pla
	pla
	jmp lvs_device_not_found_error


//
// Loading terminated by user
//

tape_break_error:

	pla
	pla
	cli
	jmp kernalerror_ROUTINE_TERMINATED


//
// Handle tape deck motor
//

tape_motor_off:

	lda CPU_R6510
	ora #$20
	bne !+                             // branch always

tape_motor_on:

	lda CPU_R6510
	and #($FF - $20)
!:
	sta CPU_R6510 
	rts


//
// Handle screen (visible/blanked) + tape deck motor (on/off),
// store/restore screen color
//

tape_screen_show_motor_off:

	jsr tape_motor_off

	lda COLSTORE
	sta VIC_EXTCOL

	jmp screen_show

tape_screen_hide_motor_on:
	lda VIC_EXTCOL
	sta COLSTORE

	jsr screen_blank
	jmp tape_motor_on


//
// Ask user to press PLAY on tape deck, 
// Unless user cancelled loading, blank screen and start motor
//

tape_ask_play:

	sei                                // timing is critical for tape loading

	// First check whether the button is already pressed

	lda CPU_R6510
	and #$10
	beq tape_wait_play_done

	// Turn off the motor, display message

	jsr tape_motor_off

	ldx #__MSG_KERNAL_PRESS_PLAY
	jsr print_kernal_message

	// Clean the SID registers, we need it for sound effects

	lda #$00
	ldy #$1C
!:
	sta __SID_BASE, y
	dey
	bpl !-

	// FALLTROUGH

tape_wait_play_loop:

	jsr udtim_keyboard
	jsr STOP
	bcs tape_break_error

	lda CPU_R6510
	and #$10                           // check for pressed button
	bne tape_wait_play_loop

tape_wait_play_done:

	jsr print_return
	jmp tape_screen_hide_motor_on


//
// Handle file header - display it, decide whether load the file or not, etc.
//

tape_handle_header:

	jsr tape_screen_show_motor_off

	// Print FOUND + file name

	ldx #__MSG_KERNAL_FOUND
	jsr print_kernal_message

	ldy #$00
!:
	lda (TAPE1), y
	jsr JCHROUT
	iny
	cpy #$10
	bne !-

	// Header, wait for user decision

	jsr tape_header_get_decision
	bcs tape_break_error

	// Check if file name matches

	jsr tape_match_filename
	bcs tape_handle_header_skip

	// Setup STAL and EAL

	ldy #$10
	lda (TAPE1), y
	sta STAL+0

	iny
	lda (TAPE1), y
	sta STAL+1

	iny
	lda (TAPE1), y
	sta EAL+0

	iny
	lda (TAPE1), y
	sta EAL+1

	// Handle the secondary address, 0 means loading to location from MEMUSS

	lda SA
	bne !+

	// EAL = EAL - STAL

	sec
	lda EAL+0
	sbc STAL+0
	sta EAL+0
	lda EAL+1
	sbc STAL+1
	sta EAL+1
	
	// STAL = MEMUSS

	lda MEMUSS+0
	sta STAL+0
	lda MEMUSS+1
	sta STAL+1

	// EAL = EAL + STAL

	clc
	lda EAL+0
	adc STAL+0
	sta EAL+0
	lda EAL+1
	adc STAL+1
	sta EAL+1
!:
	// Print LOADING

	jsr lvs_display_loading_verifying

	// Load the file

	jsr tape_screen_hide_motor_on
	
	// FALLTROUGH

tape_return_ok:

	clc
	rts

tape_handle_header_skip:

	// Skip this file

	jsr print_return
	jsr tape_screen_hide_motor_on
	
	// FALLTROUGH

tape_return_not_ok:

	sec
	rts


//
// Check whether file name matches the pattern
//

tape_match_filename:

	lda FNLEN
	beq tape_return_ok                 // no pattern to match

	ldy #$00

tape_match_loop:

	lda #$20                           // default byte, for padding
	cpy FNLEN
	bcs !+                             // end of pattern
	lda (FNADDR), y                    // byte from pattern
!:
	cmp #KEY_ASTERISK
	beq tape_return_ok

	cmp (TAPE1), y
	bne tape_return_not_ok

	iny
	cpy #$10
	bne tape_match_loop

	clc
	rts


//
// Get user decision whether to load the file or not
//

tape_header_get_decision:

	ldy #$00
!:
	jsr udtim_keyboard
	lda STKEY
	bpl tape_header_wait_stop          // STOP pressed
	and #$10
	beq tape_header_wait_space         // space pressed

	ldx #$80
	jsr wait_x_bars                    // sets .X to 0
	dex
	jsr wait_x_bars

	dey
	bne !-

	// FALLTROUGH - timeout

tape_header_wait_space:
	
	clc
	rts

tape_header_wait_stop:
	
	sec
	rts


//
// Report that file loading succeeded (or not)
//

tape_load_success:

	jsr tape_screen_show_motor_off
	jsr lvs_display_done

	cli
	jmp lvs_return_last_address

tape_load_error:

	jsr tape_screen_show_motor_off

	cli
	jmp lvs_load_verify_error


#endif
