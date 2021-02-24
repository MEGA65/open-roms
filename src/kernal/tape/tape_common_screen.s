;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Handle screen (visible/blanked; on some hardware disable badlines instead) + tape deck motor (on/off),
; store/restore screen color
;


!ifdef HAS_TAPE {



tape_screen_on_motor_off:

	jsr tape_motor_off

	lda COLSTORE
	sta VIC_EXTCOL

!ifdef CONFIG_MB_M65 {

	; Restore standard CPU speed settings

	jmp m65_speed_restore

} else ifdef CONFIG_MB_U64 {

	lda NXTBIT
	sta U64_TURBOCTL                 ; restore turbo control settings
	jmp screen_on

} else {

	jmp screen_on
}


tape_screen_off_motor_on:

	; We do not want interrupts and CHROUT reenables them
	sei

	; Clear keyboard buffer
	lda #$00
	sta NDX	

	; Set screen color
	lda VIC_EXTCOL
	sta COLSTORE

!ifdef CONFIG_MB_M65 {

	; On MEGA65 we need to switch banks everytime we retrieve byte to be stored in memory,
	; additionally we perform advanced tape speed autocallibration - this is all too expensive
	; to be handled by 1 MHz CPU - so in case of compatibility mode, switch CPU to fast speed
	; (and disable badlines, so we will not have to blank the screen)

	jsr m65_speed_tape_cbdos

} else ifdef CONFIG_MB_U64 {

	lda U64_TURBOCTL
	sta NXTBIT
	cmp #$FF
	beq @2                             ; branch if no turbo control available

	jsr U64_FAST                       ; max speed, no badlines
	bne @3                             ; branch always
@2:
	jsr screen_off
@3:

} else {

	jsr screen_off
}

	jmp tape_motor_on
}
