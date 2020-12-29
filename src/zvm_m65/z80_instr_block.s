
;
; Z80 block processing and search instructions
;


Z80_instr_ED_A0:   ; LDI

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F

	jsr (VEC_fetch_via_HL)
	jsr (VEC_store_via_DE)
	
	inw REG_HL
	inw REG_DE
	
	dew REG_BC
	+beq ZVM_next
	+Z80_PUT_1_VF
	jmp ZVM_next

Z80_instr_ED_B0:   ; LDIR

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F
@1:
	jsr (VEC_fetch_via_HL)
	jsr (VEC_store_via_DE)
	
	inw REG_HL
	inw REG_DE

	dew REG_BC	
	bne @1
	jmp ZVM_next

Z80_instr_ED_A8:   ; LDD

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F

	jsr (VEC_fetch_via_HL)
	jsr (VEC_store_via_DE)
	
	dew REG_HL
	dew REG_DE

	dew REG_BC
	+beq ZVM_next
	+Z80_PUT_1_VF
	jmp ZVM_next

Z80_instr_ED_B8:   ; LDDR

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F
@1:
	jsr (VEC_fetch_via_HL)
	jsr (VEC_store_via_DE)
	
	dew REG_HL
	dew REG_DE

	dew REG_BC	
	bne @1
	jmp ZVM_next
