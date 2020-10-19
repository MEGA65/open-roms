;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Handle tape deck motor
;


!ifdef HAS_TAPE {


tape_motor_off:

	lda CPU_R6510
	ora #$20
	bne tape_motor_common              ; branch always

tape_motor_on:

	lda CPU_R6510
	and #($FF - $20)

	; FALLTROUGH

tape_motor_common:

	sta CPU_R6510 
	rts
}
