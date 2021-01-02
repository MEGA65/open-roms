
;
; Z80 instruction implementation - RR
;


!macro Z80_RR_REGn .REGn {

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	bra Z80_common_RR
}

!macro Z80_RR_VIA_HL {

	+Z80_FETCH_VIA_HL

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror

	+Z80_STORE_BACK_VIA_HL
	bra Z80_common_RR_VIA
}

!macro Z80_RR_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror

	; FALLTROUGH
}

!macro Z80_RR_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror

	sta .REGn
	bra Z80_common_RR_VIA_IXY_d
}

Z80_instr_CB_18:   +Z80_RR_REGn REG_B                                          ; RR B
Z80_instr_CB_19:   +Z80_RR_REGn REG_C                                          ; RR C
Z80_instr_CB_1A:   +Z80_RR_REGn REG_D                                          ; RR D
Z80_instr_CB_1B:   +Z80_RR_REGn REG_E                                          ; RR E
Z80_instr_CB_1C:   +Z80_RR_REGn REG_H                                          ; RR H
Z80_instr_CB_1D:   +Z80_RR_REGn REG_L                                          ; RR L
Z80_instr_CB_1F:   +Z80_RR_REGn REG_A                                          ; RR A
Z80_instr_CB_1E:   +Z80_RR_VIA_HL                                              ; RR (HL)
Z80_instr_xDCB_1E: +Z80_RR_VIA_IXY_d                                           ; RR (IXY+d)

	; FALLTROUGH

Z80_common_RR_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_RR_VIA:

	tax

	; FALLTROUGH

Z80_common_RR:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_18: +Z80_RR_VIA_IXY_d_REGn REG_B                                ; RR (IXY+d),B
Z80_illeg_xDCB_19: +Z80_RR_VIA_IXY_d_REGn REG_C                                ; RR (IXY+d),C
Z80_illeg_xDCB_1A: +Z80_RR_VIA_IXY_d_REGn REG_D                                ; RR (IXY+d),D
Z80_illeg_xDCB_1B: +Z80_RR_VIA_IXY_d_REGn REG_E                                ; RR (IXY+d),E
Z80_illeg_xDCB_1C: +Z80_RR_VIA_IXY_d_REGn REG_H                                ; RR (IXY+d),H
Z80_illeg_xDCB_1D: +Z80_RR_VIA_IXY_d_REGn REG_L                                ; RR (IXY+d),L
Z80_illeg_xDCB_1F: +Z80_RR_VIA_IXY_d_REGn REG_A                                ; RR (IXY+d),A
