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

!ifdef CONFIG_MB_M65 {

	jsr M65_MODEGET
	+bcs screen_on                   ; MEGA65 native mode does not have badlines, no need to enable/disable screen
	rts

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

	jsr M65_MODEGET
	; XXX optimize this
	bcs @1                    	       ; MEGA65 native mode does not have badlines, no need to enable/disable screen
	jsr screen_off
@1:

} else ifdef CONFIG_MB_U64 {

	lda U64_TURBOCTL
	sta NXTBIT
	cmp #$FF
	beq @1                             ; branch if no turbo control available

	lda #$8F                           ; max speed, no badlines
	sta U64_TURBOCTL
	bne @2                             ; branch always

@1:
	jsr screen_off
@2:

} else {

	jsr screen_off
}

	jmp tape_motor_on
}
