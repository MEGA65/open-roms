
; Monitor helper code - syntax checking


Syntax_Byte_AC:            ; ensure AC contains a 1-byte value

	php
	pha

	; XXX improve this - check for numeric system and Dig_Cnt, will require Got_Addr_To_LAC rework

	lda  Long_AC+1
	ora  Long_AC+2
	ora  Long_AC+3
	+bne Mon_Error         ; value above $FF

	pla
	plp
	rts

; XXX add routine to check if this was last character
