;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


is_var_ST:

	; Always start with VARNAM+1, there is a sligtly bigger chance it won't match

	lda VARNAM+1
	cmp #$54       ; 'T'
	bne @1

	lda VARNAM+0
	cmp #$53       ; 'S'
@1:
	rts
