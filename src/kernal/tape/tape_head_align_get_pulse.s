;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape head alignemnt tool - reading pulses from tape
;


!ifdef CONFIG_TAPE_HEAD_ALIGN {


tape_head_align_get_pulse:

	; This routine differs from the one used to read pulse during tape reading:
	; - it is not as precise
	; - it terminates when timer reaches $FF
	; - it returns value in .Y

	lda #$10
@1:
	; Loop to detect signal

	ldy CIA2_TIMBLO ; $DD06
	bit CIA1_ICR    ; $DC0D
	bne @2

	cpy #$FF
	bne @1
@2:
	; FALLTROUGH

tape_head_align_get_pulse_start_timer:

	; Start timer again, force latch reload, count timer A underflows

	lda #%01010001
	sta CIA2_CRB    ; $DD0F

	; Return with time elapsed in .Y

	rts


} ; CONFIG_TAPE_HEAD_ALIGN
