
//
// CHROUT routine - screen support, control codes in quote mode
//


chrout_screen_quote:

	// Low control codes are just +$80
	clc
	adc #$80

	// If it overflowed, then it is a high control code,
	// so we need to make it be $80 + $40 + char
	// as we will have flipped back to just $00 + char, we should
	// now add $c0 if C is set from overflow
	bcc !+
	adc #$BF    // C=1, so adding $BF + C = add $C0
!:	
	jmp chrout_screen_literal
