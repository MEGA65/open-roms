// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// RS-232 part of the CHKIN routine
//

// Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


#if CONFIG_RS232_UP9600


// XXX get rid of the ENABLE/DISABLE mechanism


chkin_rs232:

	pha
	lda XXX_UPFLAG
	bne !+
	pla
	jmp $F20E // XXX
	
!:
	pla
	jsr $F30F // XXX
	beq !+
	jmp $F701 // XXX

!:
	jsr $F31F // XXX
	lda FA
	cmp #$02
	beq !+
	cmp #$04
	bcc chkin_rs232_nochkin
	jsr XXX_DISABLE
	jmp chkin_rs232_nochkin
!:
	sta $99
	jsr XXX_ENABLE
	clc
	rts

chkin_rs232_nochkin
	jmp $F219 // XXX


#endif // CONFIG_RS232_UP9600
