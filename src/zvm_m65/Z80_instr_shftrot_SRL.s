
;
; Z80 instruction implementation - SRL
;


!macro Z80_SRL_REGn .REGn {

	clc
	ror .REGn
	
	ldx .REGn
	bra Z80_common_SRL
}

!macro Z80_SRL_VIA_HL {

	+Z80_FETCH_VIA_HL
	clc
	ror

	+Z80_STORE_BACK_VIA_HL
	bra Z80_common_SRL_VIA
}

!macro Z80_SRL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	clc
	ror

	; FALLTROUGH
}

!macro Z80_SRL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	clc
	ror

	sta .REGn
	bra Z80_common_SRL_VIA_IXY_d
}

Z80_instr_CB_38:   +Z80_SRL_REGn REG_B                                         ; SRL B
Z80_instr_CB_39:   +Z80_SRL_REGn REG_C                                         ; SRL C
Z80_instr_CB_3A:   +Z80_SRL_REGn REG_D                                         ; SRL D
Z80_instr_CB_3B:   +Z80_SRL_REGn REG_E                                         ; SRL E
Z80_instr_CB_3C:   +Z80_SRL_REGn REG_H                                         ; SRL H
Z80_instr_CB_3D:   +Z80_SRL_REGn REG_L                                         ; SRL L
Z80_instr_CB_3F:   +Z80_SRL_REGn REG_A                                         ; SRL A
Z80_instr_CB_3E:   +Z80_SRL_VIA_HL                                             ; SRL (HL)
Z80_instr_xDCB_3E: +Z80_SRL_VIA_IXY_d                                          ; SRL (IXY+d)

	; FALLTROUGH

Z80_common_SRL_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_SRL_VIA:

	tax

	; FALLTROUGH

Z80_common_SRL:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_38: +Z80_SRL_VIA_IXY_d_REGn REG_B                               ; SLR (IXY+d),B
Z80_illeg_xDCB_39: +Z80_SRL_VIA_IXY_d_REGn REG_C                               ; SLR (IXY+d),C
Z80_illeg_xDCB_3A: +Z80_SRL_VIA_IXY_d_REGn REG_D                               ; SLR (IXY+d),D
Z80_illeg_xDCB_3B: +Z80_SRL_VIA_IXY_d_REGn REG_E                               ; SLR (IXY+d),E
Z80_illeg_xDCB_3C: +Z80_SRL_VIA_IXY_d_REGn REG_H                               ; SLR (IXY+d),H
Z80_illeg_xDCB_3D: +Z80_SRL_VIA_IXY_d_REGn REG_L                               ; SLR (IXY+d),L
Z80_illeg_xDCB_3F: +Z80_SRL_VIA_IXY_d_REGn REG_A                               ; SLR (IXY+d),A
