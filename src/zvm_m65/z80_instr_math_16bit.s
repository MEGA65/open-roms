
;
; Z80 arithmetic instructions, 16 bit
;


!macro Z80_INC_REGnn .REGnn {
	inw .REGnn
	jmp ZVM_next
}

!macro Z80_DEC_REGnn .REGnn {
	dew .REGnn
	jmp ZVM_next
}

Z80_instr_03:      +Z80_INC_REGnn REG_BC                                       ; INC BC
Z80_instr_13:      +Z80_INC_REGnn REG_DE                                       ; INC DE
Z80_instr_23:      +Z80_INC_REGnn REG_HL                                       ; INC HL
Z80_instr_33:      +Z80_INC_REGnn REG_SP                                       ; INC SP
Z80_instr_DD_23:   +Z80_INC_REGnn REG_IX                                       ; INC IX
Z80_instr_FD_23:   +Z80_INC_REGnn REG_IY                                       ; INC IY

Z80_instr_0B:      +Z80_DEC_REGnn REG_BC                                       ; DEC BC
Z80_instr_1B:      +Z80_DEC_REGnn REG_DE                                       ; DEC DE
Z80_instr_2B:      +Z80_DEC_REGnn REG_HL                                       ; DEC HL
Z80_instr_3B:      +Z80_DEC_REGnn REG_SP                                       ; DEC SP
Z80_instr_DD_2B:   +Z80_DEC_REGnn REG_IX                                       ; DEC IX
Z80_instr_FD_2B:   +Z80_DEC_REGnn REG_IY                                       ; DEC IY

!macro Z80_ADD_REGnn_REGnn .REGnn1, .REGnn2 { ; XXX size-optimize this - extract common parts

	lda REG_F
	and #($FF - Z80_HF - Z80_YF - Z80_XF - Z80_NF - Z80_CF)
	sta REG_F
	
	; Handle low bytes
	
	clc
	lda .REGnn1+0
	adc .REGnn2+0
	sta .REGnn1+0
	
	; Handle HF flag
	
	php
	clc
	lda .REGnn1+1
	and #$0F
	sta REG_TMP1
	lda .REGnn2+1
	and #$0F
	adc REG_TMP1
	and #$F0
	beq @1
	+Z80_PUT_1_HF
@1:
	plp
	
	; Handle high bytes
	
	lda .REGnn1+1
	adc .REGnn2+1
	sta .REGnn1+1

	; Handle XF/YF flags
	
	and #%00101000
	ora REG_F
	sta REG_F

	; Handle CF flag
	
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_09:      +Z80_ADD_REGnn_REGnn REG_HL, REG_BC                         ; ADD HL,BC
Z80_instr_19:      +Z80_ADD_REGnn_REGnn REG_HL, REG_DE                         ; ADD HL,DE
Z80_instr_29:      +Z80_ADD_REGnn_REGnn REG_HL, REG_HL                         ; ADD HL,HL
Z80_instr_39:      +Z80_ADD_REGnn_REGnn REG_HL, REG_SP                         ; ADD HL,SP

Z80_instr_DD_09:   +Z80_ADD_REGnn_REGnn REG_IX, REG_BC                         ; ADD IX,BC
Z80_instr_DD_19:   +Z80_ADD_REGnn_REGnn REG_IX, REG_DE                         ; ADD IX,DE
Z80_instr_DD_29:   +Z80_ADD_REGnn_REGnn REG_IX, REG_IX                         ; ADD IX,IX
Z80_instr_DD_39:   +Z80_ADD_REGnn_REGnn REG_IX, REG_SP                         ; ADD IX,SP

Z80_instr_FD_09:   +Z80_ADD_REGnn_REGnn REG_IY, REG_BC                         ; ADD IY,BC
Z80_instr_FD_19:   +Z80_ADD_REGnn_REGnn REG_IY, REG_DE                         ; ADD IY,DE
Z80_instr_FD_29:   +Z80_ADD_REGnn_REGnn REG_IY, REG_IY                         ; ADD IY,IY
Z80_instr_FD_39:   +Z80_ADD_REGnn_REGnn REG_IY, REG_SP                         ; ADD IY,SP

!macro Z80_ADC_HL_REGnn .REGnn { ; XXX size-optimize this - extract common parts

	; Clear flags

	stz REG_F

	; Handle low bytes
	
	clc
	bbr0 REG_F, @1
	sec
@1:
	lda REG_HL+0
	adc .REGnn+0
	sta REG_HL+0

	; Handle HF flag
	
	php
	clc
	bbr0 REG_F, @2
	sec
@2:
	lda REG_HL+1
	and #$0F
	sta REG_TMP1
	lda .REGnn+1
	and #$0F
	adc REG_TMP1
	and #$F0
	beq @3
	+Z80_PUT_1_HF
@3:
	plp
	
	; Handle high bytes
	
	lda REG_HL+1
	adc .REGnn+1
	sta REG_HL+1
	
	; Handle SF flag
	
	bne @4
	+Z80_PUT_1_SF
@4:
	; Handle XF/YF flags
	
	and #%00101000
	ora REG_F
	sta REG_F
	
	; Handle CF flag
	
	bcc @5
	+Z80_PUT_1_CF
@5:
	; Handle VF flag
	
	bvc @6
	+Z80_PUT_1_VF
@6
	; Handle ZF flag
	
	lda REG_HL+0
	ora REG_HL+1
	+beq ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next
}

Z80_instr_ED_4A:   +Z80_ADC_HL_REGnn REG_BC                                    ; ADC HL,BC
Z80_instr_ED_5A:   +Z80_ADC_HL_REGnn REG_DE                                    ; ADC HL,DE
Z80_instr_ED_6A:   +Z80_ADC_HL_REGnn REG_HL                                    ; ADC HL,HL
Z80_instr_ED_7A:   +Z80_ADC_HL_REGnn REG_SP                                    ; ADC HL,SP

!macro Z80_SBC_HL_REGnn .REGnn { ; XXX size-optimize this - extract common parts

	; Clear flags, set NF

	lda #Z80_NF
	sta REG_F
	
	; Handle low bytes
	
	clc
	bbs0 REG_F, @1
	sec
@1:
	lda REG_HL+0
	adc .REGnn+0
	sta REG_HL+0
	
	; Handle HF flag
	
	php
	clc
	bbs0 REG_F, @2
	sec
@2:
	lda REG_HL+1
	and #$0F
	sta REG_TMP1
	lda .REGnn+1
	and #$0F
	sbc REG_TMP1
	and #$F0
	beq @3
	+Z80_PUT_1_HF
@3:
	plp
	
	; Handle high bytes
	
	lda REG_HL+1
	sbc .REGnn+1
	sta REG_HL+1
	
	; Handle SF flag
	
	bne @4
	+Z80_PUT_1_SF
@4:
	; Handle XF/YF flags
	
	and #%00101000
	ora REG_F
	sta REG_F
	
	; Handle CF flag
	
	bcs @5
	+Z80_PUT_1_CF
@5:
	
	; Handle VF flag
	
	bvc @6
	+Z80_PUT_1_VF
@6
	; Handle ZF flag
	
	lda REG_HL+0
	ora REG_HL+1
	+beq ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next
}

Z80_instr_ED_42:   +Z80_SBC_HL_REGnn REG_BC; SBC HL,BC
Z80_instr_ED_52:   +Z80_SBC_HL_REGnn REG_DE; SBC HL,DE
Z80_instr_ED_62:   +Z80_SBC_HL_REGnn REG_HL; SBC HL,HL
Z80_instr_ED_72:   +Z80_SBC_HL_REGnn REG_SP; SBC HL,SP
