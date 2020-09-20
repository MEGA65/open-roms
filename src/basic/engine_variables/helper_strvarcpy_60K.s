;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper routine to copy string descriptor
;


!ifdef CONFIG_MEMORY_MODEL_60K {

helper_strvarcpy:

	ldx #<VARPNT

	; Retrieve pointer to destination

	ldy #$02
	jsr peek_under_roms
	sta DSCPNT+2
	dey
	jsr peek_under_roms
	sta DSCPNT+1
	dey

	; .Y is now 0 - copy the content
@1:

	ldx #<__FAC1+1
	jsr peek_under_roms
	ldx #<DSCPNT+1
	jsr poke_under_roms
	iny
	cpy __FAC1+0
	bne @1

	rts
}
