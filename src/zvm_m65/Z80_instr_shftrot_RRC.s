
;
; Z80 instruction implementation - RLC
;


!macro Z80_RRC_REGn .REGn {

	clc
	bbr0 .REGn, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	bra Z80_common_RRC
}

!macro Z80_RRC_VIA_HL {

	jsr (VEC_fetch_via_HL_back)

	tax
	ror
	txa

	ror

	sta [PTR_DATA],z
	bra Z80_common_RRC_VIA
}

!macro Z80_RRC_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	tax
	ror
	txa

	ror

	; FALLTROUGH
}

!macro Z80_RRC_VIA_IXY_d_REGn .REGn  {

	lda [PTR_IXY_d] ,z

	tax
	ror
	txa

	ror

	sta .REGn
	bra Z80_common_RRC_VIA_IXY_d
}

Z80_instr_CB_08:   +Z80_RRC_REGn REG_B                                         ; RRC B
Z80_instr_CB_09:   +Z80_RRC_REGn REG_C                                         ; RRC C
Z80_instr_CB_0A:   +Z80_RRC_REGn REG_D                                         ; RRC D
Z80_instr_CB_0B:   +Z80_RRC_REGn REG_E                                         ; RRC E
Z80_instr_CB_0C:   +Z80_RRC_REGn REG_H                                         ; RRC H
Z80_instr_CB_0D:   +Z80_RRC_REGn REG_L                                         ; RRC L
Z80_instr_CB_0F:   +Z80_RRC_REGn REG_A                                         ; RRC A
Z80_instr_CB_0E:   +Z80_RRC_VIA_HL                                             ; RRC (HL)
Z80_instr_xDCB_0E: +Z80_RRC_VIA_IXY_d                                          ; RRC (IXY+d)

	; FALLTROUGH

Z80_common_RRC_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_RRC_VIA:

	tax

	; FALLTROUGH

Z80_common_RRC:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_08: +Z80_RRC_VIA_IXY_d_REGn REG_B                               ; RRC (IXY+d),B
Z80_illeg_xDCB_09: +Z80_RRC_VIA_IXY_d_REGn REG_C                               ; RRC (IXY+d),C
Z80_illeg_xDCB_0A: +Z80_RRC_VIA_IXY_d_REGn REG_D                               ; RRC (IXY+d),D
Z80_illeg_xDCB_0B: +Z80_RRC_VIA_IXY_d_REGn REG_E                               ; RRC (IXY+d),E
Z80_illeg_xDCB_0C: +Z80_RRC_VIA_IXY_d_REGn REG_H                               ; RRC (IXY+d),H
Z80_illeg_xDCB_0D: +Z80_RRC_VIA_IXY_d_REGn REG_L                               ; RRC (IXY+d),L
Z80_illeg_xDCB_0F: +Z80_RRC_VIA_IXY_d_REGn REG_A                               ; RRC (IXY+d),A
