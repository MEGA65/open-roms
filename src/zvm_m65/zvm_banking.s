
;
; Z80 Virtual Machine banking support
;

;
; Bank switching routines
;

ZVM_set_bank_0:

	lda #$00
	sta BANK_ID

	; XXX use DMAgic to copy common memory

	lda #$04
	bra ZVM_set_bank_common

ZVM_set_bank_1:

	lda #$01
	sta BANK_ID

	; XXX use DMAgic to copy common memory

	lda #$05
	
	; FALLTROUGH

ZVM_set_bank_common:

	sta REG_BC_EXT
	sta REG_DE_EXT
	sta REG_HL_EXT
	sta REG_SP_EXT
	sta REG_PC_EXT

	sta PTR_IXY_d+2
	sta PTR_DATA+2

	rts
