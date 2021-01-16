
; Monitor helper code - syntax checking


Syntax_Byte_AC:            ; ensure AC contains a 1-byte value

	php
	pha

	lda  Long_AC+1
	ora  Long_AC+2
	ora  Long_AC+3
	+bne Mon_Error         ; value above $FF

	pla
	plp
	rts
