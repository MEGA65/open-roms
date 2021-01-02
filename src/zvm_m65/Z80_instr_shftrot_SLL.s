
;
; Z80 instruction implementation - SLL
;


!macro Z80_SLL_REGn .REGn {

	sec
	rol .REGn
	
	ldx .REGn
	bra Z80_common_SLL
}

!macro Z80_SLL_VIA_HL {

	+Z80_FETCH_VIA_HL
	sec
	rol

	+Z80_STORE_BACK_VIA_HL
	bra Z80_common_SLL_VIA
}

!macro Z80_SLL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	sec
	rol

	; FALLTROUGH
}

!macro Z80_SLL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	sec
	rol

	sta .REGn
	bra Z80_common_SLL_VIA_IXY_d
}

Z80_illeg_CB_30:   +Z80_SLL_REGn REG_B                                         ; SLL B
Z80_illeg_CB_31:   +Z80_SLL_REGn REG_C                                         ; SLL C
Z80_illeg_CB_32:   +Z80_SLL_REGn REG_D                                         ; SLL D
Z80_illeg_CB_33:   +Z80_SLL_REGn REG_E                                         ; SLL E
Z80_illeg_CB_34:   +Z80_SLL_REGn REG_H                                         ; SLL H
Z80_illeg_CB_35:   +Z80_SLL_REGn REG_L                                         ; SLL L
Z80_illeg_CB_37:   +Z80_SLL_REGn REG_A                                         ; SLL A
Z80_illeg_CB_36:   +Z80_SLL_VIA_HL                                             ; SLL (HL)
Z80_illeg_xDCB_36: +Z80_SLL_VIA_IXY_d                                          ; SLL (IXY+d)

	; FALLTROUGH

Z80_common_SLL_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_SLL_VIA:

	tax

	; FALLTROUGH

Z80_common_SLL:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_30: +Z80_SLL_VIA_IXY_d_REGn REG_B                               ; SLL (IXY+d),B
Z80_illeg_xDCB_31: +Z80_SLL_VIA_IXY_d_REGn REG_C                               ; SLL (IXY+d),C
Z80_illeg_xDCB_32: +Z80_SLL_VIA_IXY_d_REGn REG_D                               ; SLL (IXY+d),D
Z80_illeg_xDCB_33: +Z80_SLL_VIA_IXY_d_REGn REG_E                               ; SLL (IXY+d),E
Z80_illeg_xDCB_34: +Z80_SLL_VIA_IXY_d_REGn REG_H                               ; SLL (IXY+d),H
Z80_illeg_xDCB_35: +Z80_SLL_VIA_IXY_d_REGn REG_L                               ; SLL (IXY+d),L
Z80_illeg_xDCB_37: +Z80_SLL_VIA_IXY_d_REGn REG_A                               ; SLL (IXY+d),A
