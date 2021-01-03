
;
; Z80 block processing and search instructions
;


Z80_instr_ED_A0:   ; LDI

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F

	+Z80_FETCH_VIA_HL
	+Z80_STORE_VIA_DE
	
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
	+Z80_FETCH_VIA_HL
	+Z80_STORE_VIA_DE
	
	inw REG_HL
	inw REG_DE

	dew REG_BC	
	bne @1
	jmp ZVM_next

Z80_instr_ED_A8:   ; LDD

	lda REG_F
	and #($FF - Z80_HF - Z80_PF - Z80_NF)
	sta REG_F

	+Z80_FETCH_VIA_HL
	+Z80_STORE_VIA_DE
	
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
	+Z80_FETCH_VIA_HL
	+Z80_STORE_VIA_DE
	
	dew REG_HL
	dew REG_DE

	dew REG_BC	
	bne @1
	jmp ZVM_next


!macro Z80_common_CP_block {

	; XXX provide precalculated tables in attic RAM to speed this up

	lda REG_F
	and #Z80_CF
	sta REG_F
	+Z80_PUT_1_NF

	+Z80_FETCH_VIA_HL
	sta REG_TMP1

	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	sec
	sbc REG_TMP2
	and #$F0
	beq @1
    +Z80_PUT_1_HF
@1:	
	lda REG_A
	sec
	sbc REG_TMP1
	bpl @2
    +Z80_PUT_1_SF	
@2:
	bne @3
    +Z80_PUT_1_ZF	
@3:
	; FALLTROUGH
}

Z80_instr_ED_A1:   ; CPI

	+Z80_common_CP_block
	inw REG_HL
	dew REG_BC
	+beq ZVM_next

    +Z80_PUT_1_VF
	jmp ZVM_next

Z80_instr_ED_A9:   ; CPD

	+Z80_common_CP_block
	dew REG_HL
	dew REG_BC
	+beq ZVM_next

    +Z80_PUT_1_VF
	jmp ZVM_next

Z80_instr_ED_B1:   ; CPIR
Z80_instr_ED_B9:   ; CPDR

	jmp ZVM_next ; XXX provide implementation