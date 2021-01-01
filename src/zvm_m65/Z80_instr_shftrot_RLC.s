
;
; Z80 instruction implementation - RLC
;


!macro Z80_RLC_REGn .REGn {

	clc
	bbr7 .REGn, @1
	sec
@1:
	rol .REGn
	
	ldx .REGn
	bra Z80_common_RLC
}

!macro Z80_RLC_VIA_HL {

	jsr (VEC_fetch_via_HL)

	tax
	rol
	txa
	
	rol

	sta [REG_HL],z	
	bra Z80_common_RLC_VIA
}

!macro Z80_RLC_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	tax
	rol
	txa
	
	rol

	; FALLTROUGH
}

!macro Z80_RLC_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	tax
	rol
	txa
	
	rol

	sta .REGn
	bra Z80_common_RLC_VIA_IXY_d
}

Z80_instr_CB_00:   +Z80_RLC_REGn REG_B                                         ; RLC B
Z80_instr_CB_01:   +Z80_RLC_REGn REG_C                                         ; RLC C
Z80_instr_CB_02:   +Z80_RLC_REGn REG_D                                         ; RLC D
Z80_instr_CB_03:   +Z80_RLC_REGn REG_E                                         ; RLC E
Z80_instr_CB_04:   +Z80_RLC_REGn REG_H                                         ; RLC H
Z80_instr_CB_05:   +Z80_RLC_REGn REG_L                                         ; RLC L
Z80_instr_CB_07:   +Z80_RLC_REGn REG_A                                         ; RLC A
Z80_instr_CB_06:   +Z80_RLC_VIA_HL                                             ; RLC (HL)
Z80_instr_xDCB_06: +Z80_RLC_VIA_IXY_d                                          ; RLC (IXY+d)

	; FALLTROUGH

Z80_common_RLC_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_RLC_VIA:

	tax

	; FALLTROUGH

Z80_common_RLC:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_00: +Z80_RLC_VIA_IXY_d_REGn REG_B                               ; RLC (IXY+d),B
Z80_illeg_xDCB_01: +Z80_RLC_VIA_IXY_d_REGn REG_C                               ; RLC (IXY+d),C
Z80_illeg_xDCB_02: +Z80_RLC_VIA_IXY_d_REGn REG_D                               ; RLC (IXY+d),D
Z80_illeg_xDCB_03: +Z80_RLC_VIA_IXY_d_REGn REG_E                               ; RLC (IXY+d),E
Z80_illeg_xDCB_04: +Z80_RLC_VIA_IXY_d_REGn REG_H                               ; RLC (IXY+d),H
Z80_illeg_xDCB_05: +Z80_RLC_VIA_IXY_d_REGn REG_L                               ; RLC (IXY+d),L
Z80_illeg_xDCB_07: +Z80_RLC_VIA_IXY_d_REGn REG_A                               ; RLC (IXY+d),A
