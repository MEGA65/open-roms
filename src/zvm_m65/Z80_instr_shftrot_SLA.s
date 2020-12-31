
;
; Z80 instruction implementation - SLA
;


!macro Z80_SLA_REGn .REGn {

	asl .REGn
	
	ldx .REGn
	bra Z80_common_SLA
}

!macro Z80_SLA_VIA_HL {

	jsr (VEC_fetch_via_HL_back)
	asl

	sta [PTR_DATA],z	
	bra Z80_common_SLA_VIA
}

!macro Z80_SLA_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	asl

	; FALLTROUGH
}

!macro Z80_SLA_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	asl

	sta .REGn
	bra Z80_common_SLA_VIA_IXY_d
}

Z80_instr_CB_20:   +Z80_SLA_REGn REG_B                                         ; SLA B
Z80_instr_CB_21:   +Z80_SLA_REGn REG_C                                         ; SLA C
Z80_instr_CB_22:   +Z80_SLA_REGn REG_D                                         ; SLA D
Z80_instr_CB_23:   +Z80_SLA_REGn REG_E                                         ; SLA E
Z80_instr_CB_24:   +Z80_SLA_REGn REG_H                                         ; SLA H
Z80_instr_CB_25:   +Z80_SLA_REGn REG_L                                         ; SLA L
Z80_instr_CB_27:   +Z80_SLA_REGn REG_A                                         ; SLA A
Z80_instr_CB_26:   +Z80_SLA_VIA_HL                                             ; SLA (HL)
Z80_instr_xDCB_26: +Z80_SLA_VIA_IXY_d                                          ; SLA (IXY+d)

	; FALLTROUGH

Z80_common_SLA_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_SLA_VIA:

	tax

	; FALLTROUGH

Z80_common_SLA:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_20: +Z80_SLA_VIA_IXY_d_REGn REG_B                               ; SLA (IXY+d),B
Z80_illeg_xDCB_21: +Z80_SLA_VIA_IXY_d_REGn REG_C                               ; SLA (IXY+d),C
Z80_illeg_xDCB_22: +Z80_SLA_VIA_IXY_d_REGn REG_D                               ; SLA (IXY+d),D
Z80_illeg_xDCB_23: +Z80_SLA_VIA_IXY_d_REGn REG_E                               ; SLA (IXY+d),E
Z80_illeg_xDCB_24: +Z80_SLA_VIA_IXY_d_REGn REG_H                               ; SLA (IXY+d),H
Z80_illeg_xDCB_25: +Z80_SLA_VIA_IXY_d_REGn REG_L                               ; SLA (IXY+d),L
Z80_illeg_xDCB_27: +Z80_SLA_VIA_IXY_d_REGn REG_A                               ; SLA (IXY+d),A
