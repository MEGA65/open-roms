
;; Consummes a comma in a BASIC code, C set for no coma found

injest_comma:

	jsr basic_fetch_and_consume_character
	cmp #$2C ; comma character
	beq injest_comma_found
	cmp #$20
	beq injest_comma ; space, can always be skipped
	
	;; not found
	jsr basic_unconsume_character
	sec
	rts

injest_comma_found:
	clc
	rts

