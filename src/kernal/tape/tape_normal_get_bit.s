;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (normal) helper routine - bit reading
;
; Returns bit in Zero flag, Carry set means error, on 0 bit .A is 0 too
;


!ifdef CONFIG_TAPE_NORMAL {


tape_normal_get_bit:

	; Fetch the first pulse

	jsr tape_common_get_pulse
	bcc tape_normal_get_bit_1

	; First impulse was short, second should be medium

	jsr tape_normal_calibrate_after_S

	jsr tape_common_get_pulse
	bcs tape_normal_get_bit_error

	jsr tape_normal_calibrate_after_M

	; We have a bit '0'

	lda #$00

	; FALLTROUGH

tape_normal_get_bit_done:

	sta VIC_EXTCOL
	clc
	rts


tape_normal_get_bit_1:

	; First impulse was medium, second should be short

	jsr tape_normal_calibrate_after_M

	jsr tape_common_get_pulse
	bcc tape_normal_get_bit_error

	jsr tape_normal_calibrate_after_S

	; We have a bit '1'

	clc
	lda #$06
	bne tape_normal_get_bit_done       ; branch always


tape_normal_get_bit_error:
	
	sec
	rts


} ; CONFIG_TAPE_NORMAL
