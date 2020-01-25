// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Common routines for tape support
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


//
// Loading terminated by user
//

tape_break_error:

	pla
	pla
	cli
	jmp kernalerror_ROUTINE_TERMINATED


//
// Ask user to press PLAY on tape deck, 
// Unless user cancelled loading, blank screen and start motor
//

tape_ask_play:

#if !CONFIG_TAPE_NO_KEY_SENSE

	// First check whether the button is already pressed

	lda CPU_R6510
	and #$10
	beq tape_wait_play_done

#endif

	// Display message

	ldx #__MSG_KERNAL_PRESS_PLAY
	jsr print_kernal_message

	// FALLTROUGH

#if !CONFIG_TAPE_NO_KEY_SENSE

tape_wait_play_loop:

	jsr STOP
	bcs tape_break_error

	lda CPU_R6510
	and #$10                           // check for pressed button
	bne tape_wait_play_loop

	// FALLTROUGH

#else

	// We have no key sense - so just turn the motor on and wait for the first pulse

	jsr tape_motor_on

	lda #$10
!:
	bit CIA1_ICR    // $DC0D
	bne !-
!:
	bit CIA1_ICR    // $DC0D
	beq !-

#endif

	// FALLTROUGH

tape_wait_play_done:

	// Prepare for reading

	lda #$01
	sta CAS1                           // set the interlock

	jsr print_return
	jmp tape_screen_off_motor_on


//
// Handle file header - display it, decide whether load the file or not, etc.
//

tape_handle_header:

#if !CONFIG_TAPE_NO_MOTOR_CONTROL

	jsr tape_screen_on_motor_off

#endif

	// Print FOUND + file name

	ldx #__MSG_KERNAL_FOUND
	jsr print_kernal_message

	ldy #$05
!:
	lda (TAPE1), y
	jsr JCHROUT
	iny
	cpy #$15
	bne !-

#if !CONFIG_TAPE_NO_MOTOR_CONTROL

	// Header, wait for user decision

	jsr tape_header_get_decision
	bcs tape_break_error

#endif

	// Check if file name matches

	jsr tape_match_filename
	bcs tape_handle_header_skip

	// Setup STAL and EAL

	ldy #$01
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
	// Setup MEMUSS (see Mapping the C64, page 36)

	jsr lvs_STAL_to_MEMUSS

	// Print LOADING and start address

	jsr lvs_display_loading_verifying

	// FALLTROUGH

#if !CONFIG_TAPE_NO_MOTOR_CONTROL

tape_handle_header_displayed:

	// Load the file

	jsr tape_screen_off_motor_on

	// FALLTROUGH

#endif

tape_return_ok:

	clc
	rts

tape_handle_header_skip:

	// Skip this file

	jsr print_return
	jsr tape_screen_off_motor_on
	
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


#if !CONFIG_TAPE_NO_MOTOR_CONTROL

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
	beq tape_header_wait_space         // SPACE pressed

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

#endif


//
// Report that file loading succeeded (or not)
//

tape_load_success:

	jsr tape_screen_on_motor_off
	jsr lvs_display_done
	jmp lvs_return_last_address

tape_load_error:

	jsr tape_screen_on_motor_off
	jmp lvs_load_verify_error


#endif
