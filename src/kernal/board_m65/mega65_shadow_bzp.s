;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Exchanges BASIC part of the zero page with it's shadow location; tries to destroy as little memory as possible


m65_shadow_BZP:

!ifdef SEGMENT_M65_KERNAL_0 {

	jsr map_KERNAL_1
	jsr (VK1__m65_shadow_BZP)
	jmp map_NORMAL

} else {


	; Preserve CPU status and registers

	php
	phz
	pha
	phx

	; We need a 4-byte pointer on the zero page; let's use the ones starting from FNLEN

	ldx #$03
@1:
	lda FNLEN,x
	pha
	dex
	bpl @1

	; Store the address of the ZP shadow location

	lda #MEMCONF_SHADOW_BZP_0
	sta FNLEN+0
	lda #MEMCONF_SHADOW_BZP_1
	sta FNLEN+1
	lda #MEMCONF_SHADOW_BZP_2
	sta FNLEN+2
	lda #MEMCONF_SHADOW_BZP_3
	sta FNLEN+3

	; Exchange the ZP content

	ldz #$00
	ldx #$00
@2:
	lda [FNLEN],z
	pha
	lda $02,x
	sta [FNLEN],z
	pla
	sta $02,x
	inz
	inx
	cpx #$8E
	bne @2

	; Restore FNLEN and further bytes

	ldx #$00
@3:
	pla
	sta FNLEN,x
	inx
	cpx #$04
	bne @3

	; Restore registers and quit

	plx
	pla
	plz
	plp

	rts
}
