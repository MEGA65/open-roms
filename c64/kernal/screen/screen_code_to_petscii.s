// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


screen_code_to_petscii:
	cmp #$1B
	bcc s2p_adc_40
	
s2p_not_alpha:
	cmp #$40
	bcc s2p_end

	// FALLTROUGH

s2p_not_punctuation:
	cmp #$5B
	bcs s2p_not_shifted

	// carry already clear here
	adc #$80

	rts

s2p_not_shifted:

	cmp #$80
	bcs s2p_end // not vendor

	// $60-$7F -> $A0-$BF

s2p_adc_40:

	clc
	adc #$40
	
	// FALLTROUGH

s2p_end:
	rts
