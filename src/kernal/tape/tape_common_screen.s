;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Handle screen (visible/blanked) + tape deck motor (on/off),
; store/restore screen color
;


!ifdef HAS_TAPE {



tape_screen_on_motor_off:

	jsr tape_motor_off

	lda COLSTORE
	sta VIC_EXTCOL

!ifndef CONFIG_MB_M65 {

	jmp screen_on

} else {

	jsr M65_MODEGET
	+bcs screen_on                   ; MEGA65 native mode does not have badlines, no need to enable/disable screen
	rts
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

!ifndef CONFIG_MB_M65 {

	jsr screen_off

} else {

	jsr M65_MODEGET
	; XXX optimize this
	bcs @1                    	       ; MEGA65 native mode does not have badlines, no need to enable/disable screen
	jsr screen_off
@1:

}

	jmp tape_motor_on
}
