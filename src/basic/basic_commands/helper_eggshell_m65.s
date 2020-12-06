;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE


helper_eggshell:

!ifdef SEGMENT_M65_BASIC_0 {

	jsr map_BASIC_1
	jsr (VB1__helper_eggshell)
	jmp map_NORMAL

} else {

	; Make sure this is direct mode

	ldx CURLIN+1
	inx
	bne helper_eggshell_end

	; Make sure this is native mode

	jsr M65_MODEGET
	bcs helper_eggshell_end

	; Make sure screen mode is 80x50 characters and it is the output device

	jsr JSCREEN
	cpy #50
	bne helper_eggshell_end
	cpx #80
	bne helper_eggshell_end

	lda DFLTO
	cmp #$03
	bne helper_eggshell_end

	; Check key values

	ldx #$03
@1:
	lda INDEX, x
	cmp helper_eggshell_key, x
	bne helper_eggshell_end
	dex
	bpl @1

	; FALLTROUGH

helper_eggshell_prepare:

	; Enforce lowercase mode

	lda MODE
	pha
	lda #$FF
	sta MODE

	lda VIC_CHARPTR+1
	pha
	ora #%00001000
	sta VIC_CHARPTR+1

	; FALLTROUGH

helper_eggshell_effect:

	ldy #$00
@1:
	lda helper_eggshell_content, y
	eor #$65
	beq helper_eggshell_wait
	jsr JCHROUT
	iny
	bra @1

	; FALLTROUGH

helper_eggshell_wait:

	; Wait for a key

	lda #$00
	sta NDX
@1:
	ldx NDX
	beq @1
	sta NDX

	; FALLTROUGH

helper_eggshell_restore:

	; Clear screen, restore mode

	lda #147
	jsr JCHROUT

	pla
	sta VIC_CHARPTR+1

	pla
	sta MODE

	; FALLTROUGH

helper_eggshell_end:

	rts

helper_eggshell_key:

	!byte <6502, >6502, 65, 0

helper_eggshell_content:

	!byte $93 XOR $65

	!byte $0D XOR $65, $0D XOR $65, $0D XOR $65, $0D XOR $65
	!byte $12 XOR $65, $20 XOR $65
	!byte $D4 XOR $65, $48 XOR $65, $45 XOR $65, $20 XOR $65, $CF XOR $65, $50 XOR $65, $45 XOR $65, $4E XOR $65
	!byte $20 XOR $65, $D2 XOR $65, $CF XOR $65, $CD XOR $65, $53 XOR $65, $20 XOR $65, $50 XOR $65, $52 XOR $65
	!byte $4F XOR $65, $4A XOR $65, $45 XOR $65, $43 XOR $65, $54 XOR $65, $20 XOR $65, $4E XOR $65, $45 XOR $65
	!byte $45 XOR $65, $44 XOR $65, $53 XOR $65, $20 XOR $65, $D9 XOR $65, $CF XOR $65, $D5 XOR $65, $D2 XOR $65
	!byte $20 XOR $65, $43 XOR $65, $4F XOR $65, $4E XOR $65, $54 XOR $65, $52 XOR $65, $49 XOR $65, $42 XOR $65
	!byte $55 XOR $65, $54 XOR $65, $49 XOR $65, $4F XOR $65, $4E XOR $65, $21 XOR $65
	!byte $20 XOR $65 

	!byte $00 XOR $65
}
