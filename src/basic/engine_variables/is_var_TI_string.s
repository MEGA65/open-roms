;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


is_var_TI_string:

	; Always start with VARNAM+1, there is a sligtly bigger chance it won't match

	lda VARNAM+1
	cmp #$C9       ; 'I...$'
	bne @1

	lda VARNAM+0
	cmp #$54       ; 'T'
@1:
	rts
