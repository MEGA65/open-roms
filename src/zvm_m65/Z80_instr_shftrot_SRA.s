
;
; Z80 instruction implementation - RLC
;


!macro Z80_SRA_REGn .REGn {

	clc
	bbr7 .REGn, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	bra Z80_common_SRA
}

!macro Z80_SRA_VIA_HL {

	jsr (VEC_fetch_via_HL)
	
	tax
	ror
	txa
	
	ror

	sta [PTR_DATA],z	
	bra Z80_common_SRA_VIA
}

!macro Z80_SRA_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	
	tax
	ror
	txa
	
	ror

	; FALLTROUGH
}

!macro Z80_SRA_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	
	tax
	ror
	txa
	
	ror

	sta .REGn
	bra Z80_common_SRA_VIA_IXY_d
}

Z80_instr_CB_28:   +Z80_SRA_REGn REG_B                                         ; SRA B
Z80_instr_CB_29:   +Z80_SRA_REGn REG_C                                         ; SRA C
Z80_instr_CB_2A:   +Z80_SRA_REGn REG_D                                         ; SRA D
Z80_instr_CB_2B:   +Z80_SRA_REGn REG_E                                         ; SRA E
Z80_instr_CB_2C:   +Z80_SRA_REGn REG_H                                         ; SRA H
Z80_instr_CB_2D:   +Z80_SRA_REGn REG_L                                         ; SRA L
Z80_instr_CB_2F:   +Z80_SRA_REGn REG_A                                         ; SRA A
Z80_instr_CB_2E:   +Z80_SRA_VIA_HL                                             ; SRA (HL)
Z80_instr_xDCB_2E: +Z80_SRA_VIA_IXY_d                                          ; SRA (IXY+d)

	; FALLTROUGH

Z80_common_SRA_VIA_IXY_d:

	sta [PTR_IXY_d],z

	; FALLTROUGH

Z80_common_SRA_VIA:

	tax

	; FALLTROUGH

Z80_common_SRA:

	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_illeg_xDCB_28: +Z80_SRA_VIA_IXY_d_REGn REG_B                               ; SRA (IXY+d),B
Z80_illeg_xDCB_29: +Z80_SRA_VIA_IXY_d_REGn REG_C                               ; SRA (IXY+d),C
Z80_illeg_xDCB_2A: +Z80_SRA_VIA_IXY_d_REGn REG_D                               ; SRA (IXY+d),D
Z80_illeg_xDCB_2B: +Z80_SRA_VIA_IXY_d_REGn REG_E                               ; SRA (IXY+d),E
Z80_illeg_xDCB_2C: +Z80_SRA_VIA_IXY_d_REGn REG_H                               ; SRA (IXY+d),H
Z80_illeg_xDCB_2D: +Z80_SRA_VIA_IXY_d_REGn REG_L                               ; SRA (IXY+d),L
Z80_illeg_xDCB_2F: +Z80_SRA_VIA_IXY_d_REGn REG_A                               ; SRA (IXY+d),A
