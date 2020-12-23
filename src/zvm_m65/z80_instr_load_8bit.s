
;
; Z80 data load instructions, 8 bit
;


!macro Z80_LD_REGn_REGn .REGn1, .REGn2 {
	lda .REGn2
	sta .REGn1
	jmp ZVM_next
}

Z80_instr_41:      +Z80_LD_REGn_REGn REG_B, REG_C                              ; LD B,C
Z80_instr_42:      +Z80_LD_REGn_REGn REG_B, REG_D                              ; LD B,D
Z80_instr_43:      +Z80_LD_REGn_REGn REG_B, REG_E                              ; LD B,E
Z80_instr_44:      +Z80_LD_REGn_REGn REG_B, REG_H                              ; LD B,H
Z80_instr_45:      +Z80_LD_REGn_REGn REG_B, REG_L                              ; LD B,L
Z80_instr_47:      +Z80_LD_REGn_REGn REG_B, REG_A                              ; LD B,A

Z80_instr_48:      +Z80_LD_REGn_REGn REG_C, REG_B                              ; LD C,B
Z80_instr_4A:      +Z80_LD_REGn_REGn REG_C, REG_D                              ; LD C,D
Z80_instr_4B:      +Z80_LD_REGn_REGn REG_C, REG_E                              ; LD C,E
Z80_instr_4C:      +Z80_LD_REGn_REGn REG_C, REG_H                              ; LD C,H
Z80_instr_4D:      +Z80_LD_REGn_REGn REG_C, REG_L                              ; LD C,L
Z80_instr_4F:      +Z80_LD_REGn_REGn REG_C, REG_A                              ; LD C,A

Z80_instr_50:      +Z80_LD_REGn_REGn REG_D, REG_B                              ; LD D,B
Z80_instr_51:      +Z80_LD_REGn_REGn REG_D, REG_C                              ; LD D,C
Z80_instr_53:      +Z80_LD_REGn_REGn REG_D, REG_E                              ; LD D,E
Z80_instr_54:      +Z80_LD_REGn_REGn REG_D, REG_H                              ; LD D,H
Z80_instr_55:      +Z80_LD_REGn_REGn REG_D, REG_L                              ; LD D,L
Z80_instr_57:      +Z80_LD_REGn_REGn REG_D, REG_A                              ; LD D,A

Z80_instr_58:      +Z80_LD_REGn_REGn REG_E, REG_B                              ; LD E,B
Z80_instr_59:      +Z80_LD_REGn_REGn REG_E, REG_C                              ; LD E,C
Z80_instr_5A:      +Z80_LD_REGn_REGn REG_E, REG_D                              ; LD E,D
Z80_instr_5C:      +Z80_LD_REGn_REGn REG_E, REG_H                              ; LD E,H
Z80_instr_5D:      +Z80_LD_REGn_REGn REG_E, REG_L                              ; LD E,L
Z80_instr_5F:      +Z80_LD_REGn_REGn REG_E, REG_A                              ; LD E,A

Z80_instr_60:      +Z80_LD_REGn_REGn REG_H, REG_B                              ; LD H,B
Z80_instr_61:      +Z80_LD_REGn_REGn REG_H, REG_C                              ; LD H,C
Z80_instr_62:      +Z80_LD_REGn_REGn REG_H, REG_D                              ; LD H,D
Z80_instr_63:      +Z80_LD_REGn_REGn REG_H, REG_E                              ; LD H,E
Z80_instr_65:      +Z80_LD_REGn_REGn REG_H, REG_L                              ; LD H,L
Z80_instr_67:      +Z80_LD_REGn_REGn REG_H, REG_A                              ; LD H,A

Z80_instr_68:      +Z80_LD_REGn_REGn REG_L, REG_B                              ; LD L,B
Z80_instr_69:      +Z80_LD_REGn_REGn REG_L, REG_C                              ; LD L,C
Z80_instr_6A:      +Z80_LD_REGn_REGn REG_L, REG_D                              ; LD L,D
Z80_instr_6B:      +Z80_LD_REGn_REGn REG_L, REG_E                              ; LD L,E
Z80_instr_6C:      +Z80_LD_REGn_REGn REG_L, REG_H                              ; LD L,H
Z80_instr_6F:      +Z80_LD_REGn_REGn REG_L, REG_A                              ; LD L,A

Z80_instr_78:      +Z80_LD_REGn_REGn REG_A, REG_B                              ; LD A,B
Z80_instr_79:      +Z80_LD_REGn_REGn REG_A, REG_C                              ; LD A,C
Z80_instr_7A:      +Z80_LD_REGn_REGn REG_A, REG_D                              ; LD A,D
Z80_instr_7B:      +Z80_LD_REGn_REGn REG_A, REG_E                              ; LD A,E
Z80_instr_7C:      +Z80_LD_REGn_REGn REG_A, REG_H                              ; LD A,H
Z80_instr_7D:      +Z80_LD_REGn_REGn REG_A, REG_L                              ; LD A,L

Z80_illeg_DD_44:   +Z80_LD_REGn_REGn REG_B, REG_IXH                            ; LD B,IXH
Z80_illeg_DD_45:   +Z80_LD_REGn_REGn REG_B, REG_IXL                            ; LD B,IXL
Z80_illeg_DD_4C:   +Z80_LD_REGn_REGn REG_C, REG_IXH                            ; LD C,IXH
Z80_illeg_DD_4D:   +Z80_LD_REGn_REGn REG_C, REG_IXL                            ; LD C,IXL
Z80_illeg_DD_54:   +Z80_LD_REGn_REGn REG_D, REG_IXH                            ; LD D,IXH
Z80_illeg_DD_55:   +Z80_LD_REGn_REGn REG_D, REG_IXL                            ; LD D,IXL
Z80_illeg_DD_5C:   +Z80_LD_REGn_REGn REG_E, REG_IXH                            ; LD E,IXH
Z80_illeg_DD_5D:   +Z80_LD_REGn_REGn REG_E, REG_IXL                            ; LD E,IXL
Z80_illeg_DD_7C:   +Z80_LD_REGn_REGn REG_A, REG_IXH                            ; LD A,IXH
Z80_illeg_DD_7D:   +Z80_LD_REGn_REGn REG_A, REG_IXL                            ; LD A,IXL

Z80_illeg_FD_44:   +Z80_LD_REGn_REGn REG_B, REG_IYH                            ; LD B,IYH
Z80_illeg_FD_45:   +Z80_LD_REGn_REGn REG_B, REG_IYL                            ; LD B,IYL
Z80_illeg_FD_4C:   +Z80_LD_REGn_REGn REG_C, REG_IYH                            ; LD C,IYH
Z80_illeg_FD_4D:   +Z80_LD_REGn_REGn REG_C, REG_IYL                            ; LD C,IYL
Z80_illeg_FD_54:   +Z80_LD_REGn_REGn REG_D, REG_IYH                            ; LD D,IYH
Z80_illeg_FD_55:   +Z80_LD_REGn_REGn REG_D, REG_IYL                            ; LD D,IYL
Z80_illeg_FD_5C:   +Z80_LD_REGn_REGn REG_E, REG_IYH                            ; LD E,IYH
Z80_illeg_FD_5D:   +Z80_LD_REGn_REGn REG_E, REG_IYL                            ; LD E,IYL
Z80_illeg_FD_7C:   +Z80_LD_REGn_REGn REG_A, REG_IYH                            ; LD A,IYH
Z80_illeg_FD_7D:   +Z80_LD_REGn_REGn REG_A, REG_IYL                            ; LD A,IYL

Z80_illeg_DD_60:   +Z80_LD_REGn_REGn REG_IXH, REG_B                            ; LD IXH,B
Z80_illeg_DD_61:   +Z80_LD_REGn_REGn REG_IXH, REG_C                            ; LD IXH,C
Z80_illeg_DD_62:   +Z80_LD_REGn_REGn REG_IXH, REG_D                            ; LD IXH,D
Z80_illeg_DD_63:   +Z80_LD_REGn_REGn REG_IXH, REG_E                            ; LD IXH,E
Z80_illeg_DD_65:   +Z80_LD_REGn_REGn REG_IXH, REG_IXL                          ; LD IXH,IXL
Z80_illeg_DD_67:   +Z80_LD_REGn_REGn REG_IXH, REG_A                            ; LD IXH,A

Z80_illeg_DD_68:   +Z80_LD_REGn_REGn REG_IXL, REG_B                            ; LD IXL,B
Z80_illeg_DD_69:   +Z80_LD_REGn_REGn REG_IXL, REG_C                            ; LD IXL,C
Z80_illeg_DD_6A:   +Z80_LD_REGn_REGn REG_IXL, REG_D                            ; LD IXL,D
Z80_illeg_DD_6B:   +Z80_LD_REGn_REGn REG_IXL, REG_E                            ; LD IXL,E
Z80_illeg_DD_6C:   +Z80_LD_REGn_REGn REG_IXL, REG_IXH                          ; LD IXL,IXH
Z80_illeg_DD_6F:   +Z80_LD_REGn_REGn REG_IXL, REG_A                            ; LD IXL,A

Z80_illeg_FD_60:   +Z80_LD_REGn_REGn REG_IYH, REG_B                            ; LD IYH,B
Z80_illeg_FD_61:   +Z80_LD_REGn_REGn REG_IYH, REG_C                            ; LD IYH,C
Z80_illeg_FD_62:   +Z80_LD_REGn_REGn REG_IYH, REG_D                            ; LD IYH,D
Z80_illeg_FD_63:   +Z80_LD_REGn_REGn REG_IYH, REG_E                            ; LD IYH,E
Z80_illeg_FD_65:   +Z80_LD_REGn_REGn REG_IYH, REG_IYL                          ; LD IYH,IYL
Z80_illeg_FD_67:   +Z80_LD_REGn_REGn REG_IYH, REG_A                            ; LD IYH,A

Z80_illeg_FD_68:   +Z80_LD_REGn_REGn REG_IYL, REG_B                            ; LD IYL,B
Z80_illeg_FD_69:   +Z80_LD_REGn_REGn REG_IYL, REG_C                            ; LD IYL,C
Z80_illeg_FD_6A:   +Z80_LD_REGn_REGn REG_IYL, REG_D                            ; LD IYL,D
Z80_illeg_FD_6B:   +Z80_LD_REGn_REGn REG_IYL, REG_E                            ; LD IYL,E
Z80_illeg_FD_6C:   +Z80_LD_REGn_REGn REG_IYL, REG_IYH                          ; LD IYL,IYH
Z80_illeg_FD_6F:   +Z80_LD_REGn_REGn REG_IYL, REG_A                            ; LD IYL,A

!macro Z80_LD_REGn_n .REGn {
	jsr (VEC_fetch_value)
	sta .REGn
	jmp ZVM_next
}

Z80_instr_06:      +Z80_LD_REGn_n REG_B                                        ; LD B,n
Z80_instr_0E:      +Z80_LD_REGn_n REG_C                                        ; LD C,n
Z80_instr_16:      +Z80_LD_REGn_n REG_D                                        ; LD D,n
Z80_instr_1E:      +Z80_LD_REGn_n REG_E                                        ; LD E,n
Z80_instr_26:      +Z80_LD_REGn_n REG_H                                        ; LD H,n
Z80_instr_2E:      +Z80_LD_REGn_n REG_L                                        ; LD L,n
Z80_instr_3E:      +Z80_LD_REGn_n REG_A                                        ; LD A,n

Z80_illeg_DD_26:   +Z80_LD_REGn_n REG_IXH                                      ; LD IXH,n
Z80_illeg_DD_2E:   +Z80_LD_REGn_n REG_IXL                                      ; LD IXL,n
Z80_illeg_FD_26:   +Z80_LD_REGn_n REG_IYH                                      ; LD IYH,n
Z80_illeg_FD_2E:   +Z80_LD_REGn_n REG_IYL                                      ; LD IYL,n

!macro Z80_LD_REGn_VIA_HL .REGn {
	jsr (VEC_fetch_via_HL)
	sta .REGn
	jmp ZVM_next
}

Z80_instr_46:      +Z80_LD_REGn_VIA_HL REG_B                                   ; LD B,(HL)
Z80_instr_4E:      +Z80_LD_REGn_VIA_HL REG_C                                   ; LD C,(HL)
Z80_instr_56:      +Z80_LD_REGn_VIA_HL REG_D                                   ; LD D,(HL)
Z80_instr_5E:      +Z80_LD_REGn_VIA_HL REG_E                                   ; LD E,(HL)
Z80_instr_66:      +Z80_LD_REGn_VIA_HL REG_H                                   ; LD H,(HL)
Z80_instr_6E:      +Z80_LD_REGn_VIA_HL REG_L                                   ; LD L,(HL)
Z80_instr_7E:      +Z80_LD_REGn_VIA_HL REG_A                                   ; LD A,(HL)

!macro Z80_LD_VIA_HL_REGn .REGn {
	lda .REGn
	jsr (VEC_store_via_HL)
	jmp ZVM_next
}

Z80_instr_70:      +Z80_LD_VIA_HL_REGn REG_B                                   ; LD (HL),B
Z80_instr_71:      +Z80_LD_VIA_HL_REGn REG_C                                   ; LD (HL),C
Z80_instr_72:      +Z80_LD_VIA_HL_REGn REG_D                                   ; LD (HL),D
Z80_instr_73:      +Z80_LD_VIA_HL_REGn REG_E                                   ; LD (HL),E
Z80_instr_74:      +Z80_LD_VIA_HL_REGn REG_H                                   ; LD (HL),H
Z80_instr_75:      +Z80_LD_VIA_HL_REGn REG_L                                   ; LD (HL),L
Z80_instr_77:      +Z80_LD_VIA_HL_REGn REG_A                                   ; LD (HL),A

Z80_instr_02:                                                                  ; LD (BC),A

	lda REG_A
	jsr (VEC_store_via_BC)
	jmp ZVM_next

Z80_instr_0A:                                                                  ; LD A,(BC)

	jsr (VEC_fetch_via_BC)
	sta REG_A
	jmp ZVM_next

Z80_instr_12:                                                                  ; LD (DE),A

	lda REG_A
	jsr (VEC_store_via_DE)
	jmp ZVM_next

Z80_instr_1A:                                                                  ; LD A,(DE)

	jsr (VEC_fetch_via_DE)
	sta REG_A
	jmp ZVM_next

Z80_instr_32:                                                                  ; LD (nn),A

	lda REG_A
	jsr (VEC_store_via_nn)
	jmp ZVM_next

Z80_instr_3A:                                                                  ; LD A,(nn)

	jsr (VEC_fetch_via_nn)
	sta REG_A
	jmp ZVM_next

!macro Z80_LD_REGn_VIA_IX_d .REGn {
	jsr (VEC_fetch_via_IX_d)
	sta .REGn
	jmp ZVM_next
}

Z80_instr_DD_46:   +Z80_LD_REGn_VIA_IX_d REG_B                                 ; LD B,(IX+d)
Z80_instr_DD_4E:   +Z80_LD_REGn_VIA_IX_d REG_C                                 ; LD C,(IX+d)
Z80_instr_DD_56:   +Z80_LD_REGn_VIA_IX_d REG_D                                 ; LD D,(IX+d)
Z80_instr_DD_5E:   +Z80_LD_REGn_VIA_IX_d REG_E                                 ; LD E,(IX+d)
Z80_instr_DD_66:   +Z80_LD_REGn_VIA_IX_d REG_H                                 ; LD H,(IX+d)
Z80_instr_DD_6E:   +Z80_LD_REGn_VIA_IX_d REG_L                                 ; LD L,(IX+d)
Z80_instr_DD_7E:   +Z80_LD_REGn_VIA_IX_d REG_A                                 ; LD A,(IX+d)

!macro Z80_LD_REGn_VIA_IY_d .REGn {
	jsr (VEC_fetch_via_IY_d)
	sta .REGn
	jmp ZVM_next
}

Z80_instr_FD_46:   +Z80_LD_REGn_VIA_IY_d REG_B                                 ; LD B,(IY+d)
Z80_instr_FD_4E:   +Z80_LD_REGn_VIA_IY_d REG_C                                 ; LD C,(IY+d)
Z80_instr_FD_56:   +Z80_LD_REGn_VIA_IY_d REG_D                                 ; LD D,(IY+d)
Z80_instr_FD_5E:   +Z80_LD_REGn_VIA_IY_d REG_E                                 ; LD E,(IY+d)
Z80_instr_FD_66:   +Z80_LD_REGn_VIA_IY_d REG_H                                 ; LD H,(IY+d)
Z80_instr_FD_6E:   +Z80_LD_REGn_VIA_IY_d REG_L                                 ; LD L,(IY+d)
Z80_instr_FD_7E:   +Z80_LD_REGn_VIA_IY_d REG_A                                 ; LD A,(IY+d)

!macro Z80_LD_VIA_IX_d_REG_n .REGn {
	lda .REGn
	jsr (VEC_store_via_IX_d)
	jmp ZVM_next
}

Z80_instr_DD_70:   +Z80_LD_VIA_IX_d_REG_n REG_B                                ; LD (IX+d),B
Z80_instr_DD_71:   +Z80_LD_VIA_IX_d_REG_n REG_C                                ; LD (IX+d),C
Z80_instr_DD_72:   +Z80_LD_VIA_IX_d_REG_n REG_D                                ; LD (IX+d),D
Z80_instr_DD_73:   +Z80_LD_VIA_IX_d_REG_n REG_E                                ; LD (IX+d),E
Z80_instr_DD_74:   +Z80_LD_VIA_IX_d_REG_n REG_H                                ; LD (IX+d),H
Z80_instr_DD_75:   +Z80_LD_VIA_IX_d_REG_n REG_L                                ; LD (IX+d),L
Z80_instr_DD_77:   +Z80_LD_VIA_IX_d_REG_n REG_A                                ; LD (IX+d),A

!macro Z80_LD_VIA_IY_d_REG_n .REGn {
	lda .REGn
	jsr (VEC_store_via_IY_d)
	jmp ZVM_next
}

Z80_instr_FD_70:   +Z80_LD_VIA_IY_d_REG_n REG_B                                ; LD (IY+d),B
Z80_instr_FD_71:   +Z80_LD_VIA_IY_d_REG_n REG_C                                ; LD (IY+d),C
Z80_instr_FD_72:   +Z80_LD_VIA_IY_d_REG_n REG_D                                ; LD (IY+d),D
Z80_instr_FD_73:   +Z80_LD_VIA_IY_d_REG_n REG_E                                ; LD (IY+d),E
Z80_instr_FD_74:   +Z80_LD_VIA_IY_d_REG_n REG_H                                ; LD (IY+d),H
Z80_instr_FD_75:   +Z80_LD_VIA_IY_d_REG_n REG_L                                ; LD (IY+d),L
Z80_instr_FD_77:   +Z80_LD_VIA_IY_d_REG_n REG_A                                ; LD (IY+d),A

Z80_instr_36:      ; LD (HL),n

	jsr (VEC_fetch_value)
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_ED_57:   ; LD A,I

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF)
	ora REG_IFF2
	sta REG_F

	lda REG_I
	sta REG_A
	bpl @1
	+Z80_PUT_1_SF
@1:
	+bne ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next

Z80_instr_ED_5F:   ; LD A,R

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF)
	ora REG_IFF2
	sta REG_F

	lda REG_R06              ; register R only simulates random numbers
	eor VIC_RASTER
	adc TIME+2
	eor VIC_XPOS
	sta REG_R06

	and #%01111111
	eor REG_R7               ; not 'ora', we want to reuse the 'garbage'
	sta REG_A
	bpl @1
	+Z80_PUT_1_SF
@1:
	+bne ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next

Z80_instr_ED_47:   ; LD I,A

	lda REG_A
	sta REG_I
	jmp ZVM_next

Z80_instr_ED_4F:   ; LD R,A

	lda REG_A
	; Do not do 'sta REG_R06', it will generate a random number
	; Do not do 'and #%01111111', let it have some garbage
	sta REG_R7
	jmp ZVM_next
