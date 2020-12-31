
;
; Z80 rotate/shift instructions
;

; XXX for RRD/RLD generate tables


Z80_instr_ED_67:   ; RRD

	jsr (VEC_fetch_via_HL_back)
	sta REG_TMP1
	
	lda REG_A
	tax
	and #$F0
	sta REG_A
	txa
	
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	
	clc
	ror
	asr
	asr
	asr
	
	ora REG_A
	sta REG_A
	
	tax
	lda REG_F
	and #Z80_CF
	ora z80_ftable_RRD_RLD,x
	sta REG_F
	
	lda REG_TMP1
	jmp ZVM_store_next

Z80_instr_ED_6F:   ; RLD

	jsr (VEC_fetch_via_HL_back)
	sta REG_TMP1
	
	lda REG_A
	tax
	and #$F0
	sta REG_A
	txa
	
	asl
	asl
	asl
	asl
	
	asl
	rol REG_TMP1
	rol
	rol REG_TMP1
	rol	
	rol REG_TMP1
	rol
	rol REG_TMP1
	rol

	ora REG_A
	sta REG_A
	
	tax
	lda REG_F
	and #Z80_CF
	ora z80_ftable_RRD_RLD,x
	sta REG_F
	
	lda REG_TMP1
	jmp ZVM_store_next

Z80_instr_07:      ; RLCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	asl REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	inc REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_17:      ; RLA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_0F:      ; RRCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	ror REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	smb7 REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_1F:      ; RRA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
