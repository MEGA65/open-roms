;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Reset (hardware initialization) to be used when Open ROMs is used under hypervisor
; XXX for now this is just a proposal


m65_hypervisor_reset:

	; Proceed like with normal reset, skip problematic parts

	sei                      ; disable the interrupts, as fast as possible
	cld                      ; Kernal is not designed to operate in decimal mode

	see                      ; disable extended stack
	ldx #$FF                 ; initial stack size
	txs

	; XXX size-optimize this; share code with regular reset
	
	jsr m65_reset_part       ; initialize MEGA65 specific hardware

	ldx #$28                 ; 40 columns, screen disabled for now
	stx VIC_SCROLX
	
	jsr IOINIT_skip_DOS      ; DOS needs to map memory over $8000 - not allowed under hypervisor
	jsr JRAMTAS
	jsr JRESTOR
	jsr JCINT

	; Finished

	cli
	rts
