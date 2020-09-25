;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Common routines for tape support
;


!ifdef HAS_TAPE {


;
; Loading terminated by user
;

tape_break_error:

	pla
	pla
	cli
	jmp kernalerror_ROUTINE_TERMINATED


;
; Ask user to press PLAY on tape deck, 
; Unless user cancelled loading, blank screen and start motor
;

tape_ask_play:

!ifndef CONFIG_TAPE_NO_KEY_SENSE {

	; First check whether the button is already pressed

	lda CPU_R6510
	and #$10
	beq tape_wait_play_done
}

	; Display message

	ldx #__MSG_KERNAL_PRESS_PLAY
	jsr print_kernal_message

	; FALLTROUGH

!ifndef CONFIG_TAPE_NO_KEY_SENSE {

tape_wait_play_loop:

	jsr STOP
	bcs tape_break_error

	lda CPU_R6510
	and #$10                           ; check for pressed button
	bne tape_wait_play_loop

	; FALLTROUGH

} else {

	; The ROM is configured for tape adapter without the key sense - but it is still
	; possible, that regular Datasette or Tapuino is connected

	lda CPU_R6510
	and #$10
	beq tape_wait_first_pulse          ; branch if button reported pressed, most likely really no key sense

	; We have key sense - perform regular waiting
@1:
	jsr STOP
	bcs tape_break_error

	lda CPU_R6510
	and #$10
	beq @1

tape_wait_first_pulse:

	; We have no key sense - so just turn the motor on and wait for the first pulse

	jsr tape_motor_on

@2:
	jsr STOP
	bcs tape_break_error

	lda #$10
	bit CIA1_ICR    ; $DC0D
	bne @2
@3:
	jsr STOP
	bcs tape_break_error
	
	lda #$10
	bit CIA1_ICR    ; $DC0D
	beq @3
}

	; FALLTROUGH

tape_wait_play_done:

	lda #$01
	sta CAS1                           ; set the interlock

!ifdef CONFIG_TAPE_HEAD_ALIGN {

	rts

tape_prepare_reading:

} ; CONFIG_TAPE_HEAD_ALIGN

!ifdef CONFIG_MB_M65 {

	; Display confirmation

	ldx #__MSG_KERNAL_OK_SEARCHING
	jsr print_kernal_message
}

	; Prepare for reading

	jsr print_return
	jmp tape_screen_off_motor_on


;
; Handle file header - display it, decide whether load the file or not, etc.
;

tape_handle_header:

!ifndef CONFIG_TAPE_NO_MOTOR_CONTROL {

	jsr tape_screen_on_motor_off
}

	; Print FOUND + file name

	ldx #__MSG_KERNAL_FOUND
	jsr print_kernal_message

	ldy #$05
@4:
	lda (TAPE1), y
	jsr JCHROUT
	iny
	cpy #$15
	bne @4

!ifndef CONFIG_TAPE_NO_MOTOR_CONTROL {

	; Header, wait for user decision

	jsr tape_header_get_decision
	bcs tape_break_error
}

	; Check if file name matches

	jsr tape_match_filename
	bcs tape_handle_header_skip

	; Setup STAL and EAL

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

	; Handle the secondary address, 0 means loading to location from MEMUSS

	lda SA
	bne @5

	; EAL = EAL - STAL

	sec
	lda EAL+0
	sbc STAL+0
	sta EAL+0
	lda EAL+1
	sbc STAL+1
	sta EAL+1
	
	; STAL = MEMUSS

	lda MEMUSS+0
	sta STAL+0
	lda MEMUSS+1
	sta STAL+1

	; EAL = EAL + STAL

	clc
	lda EAL+0
	adc STAL+0
	sta EAL+0
	lda EAL+1
	adc STAL+1
	sta EAL+1
@5:
	; Setup MEMUSS (see Mapping the C64, page 36)

	jsr lvs_STAL_to_MEMUSS

!ifdef CONFIG_MB_M65 {

	; Switch to legacy mode if needed

	jsr m65_load_autoswitch_tape
}

	; Print LOADING and start address

	jsr lvs_display_loading_verifying

	; FALLTROUGH

!ifndef CONFIG_TAPE_NO_MOTOR_CONTROL {

tape_handle_header_displayed:

	; Load the file

	jsr tape_screen_off_motor_on

	; FALLTROUGH
}

tape_return_ok:

	clc
	rts

tape_handle_header_skip:

	; Skip this file

	jsr print_return
	jsr tape_screen_off_motor_on
	
	; FALLTROUGH

tape_return_not_ok:

	sec
	rts


;
; Check whether file name matches the pattern
;

tape_match_filename:

	lda FNLEN
	beq tape_return_ok                 ; no pattern to match

	ldy #$00

tape_match_loop:

	lda #$20                           ; default byte, for padding
	cpy FNLEN
	bcs @6                             ; end of pattern
	lda (FNADDR), y                    ; byte from pattern
@6:
	cmp #KEY_ASTERISK
	beq tape_return_ok

	iny
	iny
	iny
	iny
	iny

	cmp (TAPE1), y
	bne tape_return_not_ok

	dey
	dey
	dey
	dey

	cpy #$10
	bne tape_match_loop

	clc
	rts


!ifndef CONFIG_TAPE_NO_MOTOR_CONTROL {

;
; Get user decision whether to load the file or not
;

tape_header_get_decision:

	ldy #$00
@7:
	jsr udtim_keyboard
	lda STKEY
	bpl tape_header_wait_stop          ; STOP pressed
	and #$10
	beq tape_header_wait_space         ; SPACE pressed

	ldx #$80
	jsr wait_x_bars                    ; sets .X to 0
	dex
	jsr wait_x_bars

	dey
	bne @7

	; FALLTROUGH - timeout

tape_header_wait_space:
	
	clc
	rts

tape_header_wait_stop:
	
	sec
	rts
}


;
; Report that file loading succeeded (or not)
;

tape_load_success:

	jsr tape_screen_on_motor_off
	jsr lvs_display_done
	jmp lvs_return_last_address

tape_load_error:

	jsr tape_screen_on_motor_off
	jmp lvs_load_verify_error
}