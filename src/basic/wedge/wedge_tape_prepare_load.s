;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_TAPE_WEDGE {

;
; Common part for LOAD and MERGE operations via tape wedge
;

wedge_tape_prepare_load:

	; Make sure the syntax is correct

	jsr fetch_character_skip_spaces

	cmp #$00
	beq wedge_tape_prepare_load_no_filename      ; branch if no file name given
	cmp #$22
	+bne do_SYNTAX_error                       ; branch if no opening quote

	; Fetch the file name

	lda TXTPTR+0
	sta FNADDR+0
	lda TXTPTR+1
	sta FNADDR+1

	ldx #$00
@1:
	jsr fetch_character

	cmp #$00
	beq @2
	cmp #$22
	beq @2

	inx
	bne @1
@2:
	stx FNLEN

	lda #$00
	beq wedge_tape_prepare_load_got_filename

wedge_tape_prepare_load_no_filename:
	
	sta FNLEN                                    ; .A is 0 here, default file name is empty
	
	; FALLTROUGH

wedge_tape_prepare_load_got_filename:            ; .A has to be 0

	sta VERCKB                                   ; operation is LOAD, not VERIFY

	ldy #$01
!ifdef CONFIG_TAPE_TURBO {
	ldx #$07                                     ; turbo tape device
} else {
	ldx #$01                                     ; normal tape device
}

	jmp JSETFLS

} ; CONFIG_TAPE_WEDGE
