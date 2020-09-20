;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape head alignemnt tool - helper code generator
;


!ifdef CONFIG_TAPE_HEAD_ALIGN {


; Helper variables - reuse BASIC numeric work area on zero page

!addr __ha_lda_addr = TEMPF1 + 0;     ; 2 bytes, for code generator
!addr __ha_sta_addr = TEMPF1 + 2;     ; 2 bytes, for code generator


tape_head_align_gen_code:

	; Setup generated code start address

	lda #<__ha_scroll
	sta SAL+0
	lda #>__ha_scroll
	sta SAL+1

	; Setup initial source and destination addresses

	ldy #<(__ha_chart + __ha_rows * (8 * 40) + 6)
	sty __ha_lda_addr + 0
	iny
	sty __ha_sta_addr + 0

	ldy #>(__ha_chart + __ha_rows * (8 * 40) + 6)
	sty __ha_lda_addr + 1
	sty __ha_sta_addr + 1

	; Emit code to move 7 rows of one 8x8 cell
@1:
	ldx #$07
@2:
	jsr tape_head_align_gen_code_emit_pair

	dec __ha_lda_addr + 0
	dec __ha_sta_addr + 0

	dex
	bne @2

	; Emit code to fetch a top row from the cell above

    inc __ha_lda_addr + 0
	sec
	lda __ha_lda_addr + 0
	sbc #<(8 * 40 - 7)
	sta __ha_lda_addr + 0
	lda __ha_lda_addr + 1
	sbc #>(8 * 40 - 7)

	sta __ha_lda_addr + 1

	jsr tape_head_align_gen_code_emit_pair

	; Prepare addresses for the next iteration

	lda __ha_lda_addr + 0
	sta __ha_sta_addr + 0
	lda __ha_lda_addr + 1
	sta __ha_sta_addr + 1

	dec __ha_lda_addr + 0

	; Now, new iteration - if needed

	lda __ha_sta_addr + 0
	cmp #<(__ha_chart + 7)
	bne @1
	lda __ha_sta_addr + 1
	cmp #>(__ha_chart + 7)
	bne @1

	; Last pair to be generated starts from LDA #$00

	lda #$A9
	jsr tape_head_align_gen_code_emit_byte
	lda #$00
	jsr tape_head_align_gen_code_emit_byte

	jsr tape_head_align_gen_code_emit_sta

	; Emit RTS and quit

	lda #$60
	jmp tape_head_align_gen_code_emit_byte



tape_head_align_gen_code_emit_pair:

	lda #$BD                           ; LDA absolute, x
	jsr tape_head_align_gen_code_emit_byte

	lda __ha_lda_addr + 0
	jsr tape_head_align_gen_code_emit_byte
	lda __ha_lda_addr + 1
	jsr tape_head_align_gen_code_emit_byte

	; FALLTROUGH

tape_head_align_gen_code_emit_sta:

	lda #$9D                           ; STA absolute, x
	jsr tape_head_align_gen_code_emit_byte

	lda __ha_sta_addr + 0
	jsr tape_head_align_gen_code_emit_byte
	lda __ha_sta_addr + 1
	
	; FALLTROUGH

tape_head_align_gen_code_emit_byte:

	ldy #$00
	sta (SAL), y
!ifdef HAS_OPCODES_65CE02 {
	inw SAL
} else {
	inc SAL+0
	bne @3
	inc SAL+1
@3:
}
	rts


} ; CONFIG_TAPE_HEAD_ALIGN
