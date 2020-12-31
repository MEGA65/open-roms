
;
; Z80 instruction implementation - RL
;


!macro Z80_RL_REGn .REGn {

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol .REGn
	
	ldx .REGn
	bra Z80_common_RL
}

!macro Z80_RL_VIA_HL {

	jsr (VEC_fetch_via_HL_back)

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol

	sta [PTR_DATA],z
	bra Z80_common_RL_VIA
}

!macro Z80_RL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol

	; FALLTROUGH
}

!macro Z80_RL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol

	sta .REGn
	bra Z80_common_RL_VIA_IXY_d
}

Z80_instr_CB_10:   +Z80_RL_REGn REG_B                                          ; RL B
Z80_instr_CB_11:   +Z80_RL_REGn REG_C                                          ; RL C 
Z80_instr_CB_12:   +Z80_RL_REGn REG_D                                          ; RL D
Z80_instr_CB_13:   +Z80_RL_REGn REG_E                                          ; RL E
Z80_instr_CB_14:   +Z80_RL_REGn REG_H                                          ; RL H
Z80_instr_CB_15:   +Z80_RL_REGn REG_L                                          ; RL L
Z80_instr_CB_17:   +Z80_RL_REGn REG_A                                          ; RL A
Z80_instr_CB_16:   +Z80_RL_VIA_HL                                              ; RL (HL)
Z80_instr_xDCB_16: +Z80_RL_VIA_IXY_d                                           ; RL (IXY+d)

	; FALLTROUGH

Z80_common_RL_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_RL_VIA:

	tax

	; FALLTROUGH

Z80_common_RL:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_10: +Z80_RL_VIA_IXY_d_REGn REG_B                                ; RL (IXY+d),B
Z80_illeg_xDCB_11: +Z80_RL_VIA_IXY_d_REGn REG_C                                ; RL (IXY+d),C
Z80_illeg_xDCB_12: +Z80_RL_VIA_IXY_d_REGn REG_D                                ; RL (IXY+d),D
Z80_illeg_xDCB_13: +Z80_RL_VIA_IXY_d_REGn REG_E                                ; RL (IXY+d),E
Z80_illeg_xDCB_14: +Z80_RL_VIA_IXY_d_REGn REG_H                                ; RL (IXY+d),H
Z80_illeg_xDCB_15: +Z80_RL_VIA_IXY_d_REGn REG_L                                ; RL (IXY+d),L
Z80_illeg_xDCB_17: +Z80_RL_VIA_IXY_d_REGn REG_A                                ; RL (IXY+d),A
