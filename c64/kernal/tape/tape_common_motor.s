
//
// Handle tape deck motor
//


#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO


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


#endif
