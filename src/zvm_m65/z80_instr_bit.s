
;
; Z80 bit set/reset/test instructions
;

; bits 0, 1, 4, 6

Z80_instr_CB_40:   ; BIT 0,B

	bbs0 REG_B, Z80_common_bitx_1
	bra  Z80_common_bitx_0
	
Z80_instr_CB_41:   ; BIT 0,C

	bbs0 REG_C, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_42:   ; BIT 0,D

	bbs0 REG_D, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_43:   ; BIT 0,E

	bbs0 REG_E, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_44:   ; BIT 0,H

	bbs0 REG_H, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_45:   ; BIT 0,L

	bbs0 REG_L, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_47:   ; BIT 0,A

	bbs0 REG_A, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_48:   ; BIT 1,B

	bbs1 REG_B, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_49:   ; BIT 1,C

	bbs1 REG_C, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_4A:   ; BIT 1,D

	bbs1 REG_D, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_4B:   ; BIT 1,E

	bbs1 REG_E, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_4C:   ; BIT 1,H

	bbs1 REG_H, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_4D:   ; BIT 1,L

	bbs1 REG_L, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_4F:   ; BIT 1,A

	bbs1 REG_A, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_50:   ; BIT 2,B

	bbs2 REG_B, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_51:   ; BIT 2,C

	bbs2 REG_C, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_52:   ; BIT 2,

	bbs2 REG_D, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_53:   ; BIT 2,E

	bbs2 REG_E, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_54:   ; BIT 2,H

	bbs2 REG_H, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_55:   ; BIT 2,L

	bbs2 REG_L, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_57:   ; BIT 2,A

	bbs2 REG_A, Z80_common_bitx_1
	
	; FALLTROUGH

Z80_common_bitx_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	jmp ZVM_next

Z80_common_bitx_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	jmp ZVM_next

Z80_instr_CB_60:   ; BIT 4,B

	bbs4 REG_B, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_61:   ; BIT 4,C

	bbs4 REG_C, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_62:   ; BIT 4,D

	bbs4 REG_D, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_63:   ; BIT 4,E

	bbs4 REG_E, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_64:   ; BIT 4,H

	bbs4 REG_H, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_65:   ; BIT 4,L

	bbs4 REG_L, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_67:   ; BIT 4,A

	bbs4 REG_A, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_70:   ; BIT 6,B

	bbs6 REG_B, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_71:   ; BIT 6,C

	bbs6 REG_C, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_72:   ; BIT 6,D

	bbs6 REG_D, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_73:   ; BIT 6,E

	bbs6 REG_E, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_74:   ; BIT 6,H

	bbs6 REG_H, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_75:   ; BIT 6,L

	bbs6 REG_L, Z80_common_bitx_1
	bra  Z80_common_bitx_0

Z80_instr_CB_77:   ; BIT 6,A

	bbs6 REG_A, Z80_common_bitx_1
	bra  Z80_common_bitx_0

; bits 3, 5, 7

Z80_instr_CB_58:   ; BIT 3,B

	bbs3 REG_B, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_59:   ; BIT 3,C

	bbs3 REG_C, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_5A:   ; BIT 3,D

	bbs3 REG_D, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_5B:   ; BIT 3,E

	bbs3 REG_E, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_5C:   ; BIT 3,H

	bbs3 REG_H, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_5D:   ; BIT 3,L

	bbs3 REG_L, Z80_common_bit3_1
	bra  Z80_common_bit3_0

Z80_instr_CB_5F:   ; BIT 3,A

	bbs3 REG_D, Z80_common_bit3_1
	
	; FALLTROUGH

Z80_common_bit3_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	jmp ZVM_next

Z80_common_bit3_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_XF)
	sta REG_F
	jmp ZVM_next

Z80_instr_CB_68:   ; BIT 5,B

	bbs5 REG_B, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_69:   ; BIT 5,C

	bbs5 REG_C, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_6A:   ; BIT 5,D

	bbs5 REG_D, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_6B:   ; BIT 5,E

	bbs5 REG_E, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_6C:   ; BIT 5,H

	bbs5 REG_H, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_6D:   ; BIT 5,L

	bbs5 REG_L, Z80_common_bit5_1
	bra  Z80_common_bit3_0

Z80_instr_CB_6F:   ; BIT 5,A

	bbs5 REG_A, Z80_common_bit5_1
	bra  Z80_common_bit3_0

	; FALLTROUGH

Z80_common_bit5_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	jmp ZVM_next

Z80_common_bit5_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_YF)
	sta REG_F
	jmp ZVM_next

Z80_instr_CB_78:   ; BIT 7,B

	bbs7 REG_B, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_79:   ; BIT 7,C

	bbs7 REG_C, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_7A:   ; BIT 7,D

	bbs7 REG_D, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_7B:   ; BIT 7,E

	bbs7 REG_E, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_7C:   ; BIT 7,H

	bbs7 REG_H, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_7D:   ; BIT 7,L

	bbs7 REG_L, Z80_common_bit7_1
	bra  Z80_common_bit7_0

Z80_instr_CB_7F:   ; BIT 7,A

	bbs7 REG_A, Z80_common_bit7_1

	; FALLTROUGH

Z80_common_bit7_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	jmp ZVM_next

Z80_common_bit7_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_SF)
	sta REG_F
	jmp ZVM_next

; bits taken from (HL)

Z80_instr_CB_46:   ; BIT 0,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00000001
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_4E:   ; BIT 1,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00000010
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_56:   ; BIT 2,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00000100
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_5E:   ; BIT 3,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00001000
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_66:   ; BIT 4,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00010000
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_6E:   ; BIT 5,(HL)

	jsr (VEC_fetch_via_HL)
	and #%00100000
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_76:   ; BIT 6,(HL)

	jsr (VEC_fetch_via_HL)
	and #%01000000
	bne Z80_common_bitHL_1
	bra Z80_common_bitHL_0

Z80_instr_CB_7E:   ; BIT 7,(HL)

	jsr (VEC_fetch_via_HL)
	and #%10000000
	beq Z80_common_bitHL_0

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_SF)
	sta REG_F
	jmp ZVM_next

Z80_common_bitHL_0:

	; XXX behaviour of undefined flags not fully known, thus not implemented
	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	jmp ZVM_next

Z80_common_bitHL_1:

	; XXX behaviour of undefined flags not fully known, thus not implemented
	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	jmp ZVM_next

; bits taken from index register + displacement

Z80_illeg_xDCB_40: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_41: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_42: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_43: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_44: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_45: ; BIT 0,(IXY+d)
Z80_instr_xDCB_46: ; BIT 0,(IXY+d)
Z80_illeg_xDCB_47: ; BIT 0,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00000001
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_48: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_49: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_4A: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_4B: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_4C: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_4D: ; BIT 1,(IXY+d)
Z80_instr_xDCB_4E: ; BIT 1,(IXY+d)
Z80_illeg_xDCB_4F: ; BIT 1,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00000010
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_50: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_51: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_52: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_53: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_54: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_55: ; BIT 2,(IXY+d)
Z80_instr_xDCB_56: ; BIT 2,(IXY+d)
Z80_illeg_xDCB_57: ; BIT 2,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00000100
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_58: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_59: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_5A: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_5B: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_5C: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_5D: ; BIT 3,(IXY+d)
Z80_instr_xDCB_5E: ; BIT 3,(IXY+d)
Z80_illeg_xDCB_5F: ; BIT 3,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00001000
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_60: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_61: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_62: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_63: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_64: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_65: ; BIT 4,(IXY+d)
Z80_instr_xDCB_66: ; BIT 4,(IXY+d)
Z80_illeg_xDCB_67: ; BIT 4,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00010000
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_68: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_69: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_6A: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_6B: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_6C: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_6D: ; BIT 5,(IXY+d)
Z80_instr_xDCB_6E: ; BIT 5,(IXY+d)
Z80_illeg_xDCB_6F: ; BIT 5,(IXY+d)

	lda [PTR_IXY_d],z
	and #%00100000
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_70: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_71: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_72: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_73: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_74: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_75: ; BIT 6,(IXY+d)
Z80_instr_xDCB_76: ; BIT 6,(IXY+d)
Z80_illeg_xDCB_77: ; BIT 6,(IXY+d)

	lda [PTR_IXY_d],z
	and #%01000000
	bne Z80_common_bitIXYx_1
	bra Z80_common_bitIXYx_0

Z80_illeg_xDCB_78: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_79: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_7A: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_7B: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_7C: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_7D: ; BIT 7,(IXY+d)
Z80_instr_xDCB_7E: ; BIT 7,(IXY+d)
Z80_illeg_xDCB_7F: ; BIT 7,(IXY+d)

	lda [PTR_IXY_d],z
	and #%10000000
	beq Z80_common_bitIXYx_0
	
	; FALLTROUGH

Z80_common_bitIXY7_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_SF)
	sta REG_F
	lda PTR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	jmp ZVM_next

Z80_common_bitIXYx_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	lda PTR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	jmp ZVM_next

Z80_common_bitIXYx_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	lda PTR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	jmp ZVM_next

; SET, RES

Z80_instr_CB_C0:   ; SET 0,B

	smb0 REG_B
	jmp ZVM_next

Z80_instr_CB_C1:   ; SET 0,C

	smb0 REG_C
	jmp ZVM_next

Z80_instr_CB_C2:   ; SET 0,D

	smb0 REG_D
	jmp ZVM_next

Z80_instr_CB_C3:   ; SET 0,E

	smb0 REG_E
	jmp ZVM_next

Z80_instr_CB_C4:   ; SET 0,H

	smb0 REG_H
	jmp ZVM_next

Z80_instr_CB_C5:   ; SET 0,L

	smb0 REG_L
	jmp ZVM_next

Z80_instr_CB_C7:   ; SET 0,A

	smb0 REG_A
	jmp ZVM_next

Z80_instr_CB_C8:   ; SET 1,B

	smb1 REG_B
	jmp ZVM_next

Z80_instr_CB_C9:   ; SET 1,

	smb1 REG_C
	jmp ZVM_next

Z80_instr_CB_CA:   ; SET 1,D

	smb1 REG_D
	jmp ZVM_next

Z80_instr_CB_CB:   ; SET 1,E

	smb1 REG_E
	jmp ZVM_next

Z80_instr_CB_CC:   ; SET 1,H

	smb1 REG_H
	jmp ZVM_next

Z80_instr_CB_CD:   ; SET 1,L

	smb1 REG_L
	jmp ZVM_next

Z80_instr_CB_CF:   ; SET 1,A

	smb1 REG_A
	jmp ZVM_next

Z80_instr_CB_D0:   ; SET 2,B

	smb2 REG_B
	jmp ZVM_next

Z80_instr_CB_D1:   ; SET 2,C

	smb2 REG_C
	jmp ZVM_next

Z80_instr_CB_D2:   ; SET 2,D

	smb2 REG_D
	jmp ZVM_next

Z80_instr_CB_D3:   ; SET 2,E

	smb2 REG_E
	jmp ZVM_next

Z80_instr_CB_D4:   ; SET 2,H

	smb2 REG_H
	jmp ZVM_next

Z80_instr_CB_D5:   ; SET 2,L

	smb2 REG_L
	jmp ZVM_next

Z80_instr_CB_D7:   ; SET 2,A

	smb2 REG_A
	jmp ZVM_next

Z80_instr_CB_D8:   ; SET 3,B

	smb3 REG_B
	jmp ZVM_next

Z80_instr_CB_D9:   ; SET 3,C

	smb3 REG_C
	jmp ZVM_next

Z80_instr_CB_DA:   ; SET 3,D

	smb3 REG_D
	jmp ZVM_next

Z80_instr_CB_DB:   ; SET 3,E

	smb3 REG_E
	jmp ZVM_next

Z80_instr_CB_DC:   ; SET 3,H

	smb3 REG_H
	jmp ZVM_next

Z80_instr_CB_DD:   ; SET 3,L

	smb3 REG_L
	jmp ZVM_next

Z80_instr_CB_DF:   ; SET 3,A

	smb3 REG_A
	jmp ZVM_next

Z80_instr_CB_E0:   ; SET 4,B

	smb4 REG_B
	jmp ZVM_next

Z80_instr_CB_E1:   ; SET 4,C

	smb4 REG_C
	jmp ZVM_next

Z80_instr_CB_E2:   ; SET 4,D

	smb4 REG_D
	jmp ZVM_next

Z80_instr_CB_E3:   ; SET 4,E

	smb4 REG_E
	jmp ZVM_next

Z80_instr_CB_E4:   ; SET 4,H

	smb4 REG_H
	jmp ZVM_next

Z80_instr_CB_E5:   ; SET 4,L

	smb4 REG_L
	jmp ZVM_next

Z80_instr_CB_E7:   ; SET 4,A

	smb4 REG_A
	jmp ZVM_next

Z80_instr_CB_E8:   ; SET 5,B

	smb5 REG_B
	jmp ZVM_next

Z80_instr_CB_E9:   ; SET 5,C

	smb5 REG_C
	jmp ZVM_next

Z80_instr_CB_EA:   ; SET 5,D

	smb5 REG_D
	jmp ZVM_next

Z80_instr_CB_EB:   ; SET 5,E

	smb5 REG_E
	jmp ZVM_next

Z80_instr_CB_EC:   ; SET 5,H

	smb5 REG_H
	jmp ZVM_next

Z80_instr_CB_ED:   ; SET 5,L

	smb5 REG_L
	jmp ZVM_next

Z80_instr_CB_EF:   ; SET 5,A

	smb5 REG_A
	jmp ZVM_next

Z80_instr_CB_F0:   ; SET 6,B

	smb6 REG_B
	jmp ZVM_next

Z80_instr_CB_F1:   ; SET 6,C

	smb6 REG_C
	jmp ZVM_next

Z80_instr_CB_F2:   ; SET 6,D

	smb6 REG_D
	jmp ZVM_next

Z80_instr_CB_F3:   ; SET 6,E

	smb6 REG_E
	jmp ZVM_next

Z80_instr_CB_F4:   ; SET 6,H

	smb6 REG_H
	jmp ZVM_next

Z80_instr_CB_F5:   ; SET 6,L

	smb6 REG_L
	jmp ZVM_next

Z80_instr_CB_F7:   ; SET 6,A

	smb6 REG_A
	jmp ZVM_next

Z80_instr_CB_F8:   ; SET 7,B

	smb7 REG_B
	jmp ZVM_next

Z80_instr_CB_F9:   ; SET 7,C

	smb7 REG_C
	jmp ZVM_next

Z80_instr_CB_FA:   ; SET 7,D

	smb7 REG_D
	jmp ZVM_next

Z80_instr_CB_FB:   ; SET 7,E

	smb7 REG_E
	jmp ZVM_next

Z80_instr_CB_FC:   ; SET 7,H

	smb7 REG_H
	jmp ZVM_next

Z80_instr_CB_FD:   ; SET 7,L

	smb7 REG_L
	jmp ZVM_next

Z80_instr_CB_FF:   ; SET 7,A

	smb7 REG_A
	jmp ZVM_next

Z80_instr_CB_C6:   ; SET 0,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000001
	jmp ZVM_store_via_HL_next

Z80_instr_CB_CE:   ; SET 1,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000010
	jmp ZVM_store_via_HL_next

Z80_instr_CB_D6:   ; SET 2,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000100
	jmp ZVM_store_via_HL_next

Z80_instr_CB_DE:   ; SET 3,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00001000
	jmp ZVM_store_via_HL_next

Z80_instr_CB_E6:   ; SET 4,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00010000
	jmp ZVM_store_via_HL_next

Z80_instr_CB_EE:   ; SET 5,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00100000
	jmp ZVM_store_via_HL_next

Z80_instr_CB_F6:   ; SET 6,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%01000000
	jmp ZVM_store_via_HL_next

Z80_instr_CB_FE:   ; SET 7,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%10000000
	jmp ZVM_store_via_HL_next

Z80_instr_xDCB_C6: ; SET 0,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00000001
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_CE: ; SET 1,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00000010
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_D6: ; SET 2,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00000100
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_DE: ; SET 3,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00001000
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_E6: ; SET 4,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00010000
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_EE: ; SET 5,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%00100000
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_F6: ; SET 6,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%01000000
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_FE: ; SET 7,(IXY+d)

	lda [PTR_IXY_d],z
	ora #%10000000
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_CB_80:   ; RES 0,B

	rmb0 REG_B
	jmp ZVM_next

Z80_instr_CB_81:   ; RES 0,C

	rmb0 REG_C
	jmp ZVM_next

Z80_instr_CB_82:   ; RES 0,D

	rmb0 REG_D
	jmp ZVM_next

Z80_instr_CB_83:   ; RES 0,E

	rmb0 REG_E
	jmp ZVM_next

Z80_instr_CB_84:   ; RES 0,H

	rmb0 REG_H
	jmp ZVM_next

Z80_instr_CB_85:   ; RES 0,L

	rmb0 REG_L
	jmp ZVM_next

Z80_instr_CB_87:   ; RES 0,A

	rmb0 REG_A
	jmp ZVM_next

Z80_instr_CB_88:   ; RES 1,B

	rmb1 REG_B
	jmp ZVM_next

Z80_instr_CB_89:   ; RES 1,C

	rmb1 REG_C
	jmp ZVM_next

Z80_instr_CB_8A:   ; RES 1,D

	rmb1 REG_D
	jmp ZVM_next

Z80_instr_CB_8B:   ; RES 1,E

	rmb1 REG_E
	jmp ZVM_next

Z80_instr_CB_8C:   ; RES 1,H

	rmb1 REG_H
	jmp ZVM_next

Z80_instr_CB_8D:   ; RES 1,L

	rmb1 REG_L
	jmp ZVM_next

Z80_instr_CB_8F:   ; RES 1,A

	rmb1 REG_A
	jmp ZVM_next

Z80_instr_CB_90:   ; RES 2,B

	rmb2 REG_B
	jmp ZVM_next

Z80_instr_CB_91:   ; RES 2,C

	rmb2 REG_C
	jmp ZVM_next

Z80_instr_CB_92:   ; RES 2,D

	rmb2 REG_D
	jmp ZVM_next

Z80_instr_CB_93:   ; RES 2,E

	rmb2 REG_E
	jmp ZVM_next

Z80_instr_CB_94:   ; RES 2,H

	rmb2 REG_H
	jmp ZVM_next

Z80_instr_CB_95:   ; RES 2,L

	rmb2 REG_L
	jmp ZVM_next

Z80_instr_CB_97:   ; RES 2,A

	rmb2 REG_A
	jmp ZVM_next

Z80_instr_CB_98:   ; RES 3,B

	rmb3 REG_B
	jmp ZVM_next

Z80_instr_CB_99:   ; RES 3,C

	rmb3 REG_C
	jmp ZVM_next

Z80_instr_CB_9A:   ; RES 3,D

	rmb3 REG_D
	jmp ZVM_next

Z80_instr_CB_9B:   ; RES 3,E

	rmb3 REG_E
	jmp ZVM_next

Z80_instr_CB_9C:   ; RES 3,H

	rmb3 REG_H
	jmp ZVM_next

Z80_instr_CB_9D:   ; RES 3,L

	rmb3 REG_L
	jmp ZVM_next

Z80_instr_CB_9F:   ; RES 3,A

	rmb3 REG_A
	jmp ZVM_next

Z80_instr_CB_A0:   ; RES 4,B

	rmb4 REG_B
	jmp ZVM_next

Z80_instr_CB_A1:   ; RES 4,C

	rmb4 REG_C
	jmp ZVM_next

Z80_instr_CB_A2:   ; RES 4,D

	rmb4 REG_D
	jmp ZVM_next

Z80_instr_CB_A3:   ; RES 4,E

	rmb4 REG_E
	jmp ZVM_next

Z80_instr_CB_A4:   ; RES 4,H

	rmb4 REG_H
	jmp ZVM_next

Z80_instr_CB_A5:   ; RES 4,L

	rmb4 REG_L
	jmp ZVM_next

Z80_instr_CB_A7:   ; RES 4,A

	rmb4 REG_A
	jmp ZVM_next

Z80_instr_CB_A8:   ; RES 5,B

	rmb5 REG_B
	jmp ZVM_next

Z80_instr_CB_A9:   ; RES 5,C

	rmb5 REG_C
	jmp ZVM_next

Z80_instr_CB_AA:   ; RES 5,D

	rmb5 REG_D
	jmp ZVM_next

Z80_instr_CB_AB:   ; RES 5,E

	rmb5 REG_E
	jmp ZVM_next

Z80_instr_CB_AC:   ; RES 5,H

	rmb5 REG_H
	jmp ZVM_next

Z80_instr_CB_AD:   ; RES 5,L

	rmb5 REG_L
	jmp ZVM_next

Z80_instr_CB_AF:   ; RES 5,A

	rmb5 REG_A
	jmp ZVM_next

Z80_instr_CB_B0:   ; RES 6,B

	rmb6 REG_B
	jmp ZVM_next

Z80_instr_CB_B1:   ; RES 6,C

	rmb6 REG_C
	jmp ZVM_next

Z80_instr_CB_B2:   ; RES 6,D

	rmb6 REG_D
	jmp ZVM_next

Z80_instr_CB_B3:   ; RES 6,E

	rmb6 REG_E
	jmp ZVM_next

Z80_instr_CB_B4:   ; RES 6,H

	rmb6 REG_H
	jmp ZVM_next

Z80_instr_CB_B5:   ; RES 6,L

	rmb6 REG_L
	jmp ZVM_next

Z80_instr_CB_B7:   ; RES 6,A

	rmb6 REG_A
	jmp ZVM_next

Z80_instr_CB_B8:   ; RES 7,B

	rmb7 REG_B
	jmp ZVM_next

Z80_instr_CB_B9:   ; RES 7,C

	rmb7 REG_C
	jmp ZVM_next

Z80_instr_CB_BA:   ; RES 7,D

	rmb7 REG_D
	jmp ZVM_next

Z80_instr_CB_BB:   ; RES 7,E

	rmb7 REG_E
	jmp ZVM_next

Z80_instr_CB_BC:   ; RES 7,H

	rmb7 REG_H
	jmp ZVM_next

Z80_instr_CB_BD:   ; RES 7,L

	rmb7 REG_L
	jmp ZVM_next

Z80_instr_CB_BF:   ; RES 7,A

	rmb7 REG_A
	jmp ZVM_next

Z80_instr_CB_86:   ; RES 0,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111110
	jmp ZVM_store_via_HL_next

Z80_instr_CB_8E:   ; RES 1,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111101
	jmp ZVM_store_via_HL_next

Z80_instr_CB_96:   ; RES 2,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111011
	jmp ZVM_store_via_HL_next

Z80_instr_CB_9E:   ; RES 3,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11110111
	jmp ZVM_store_via_HL_next

Z80_instr_CB_A6:   ; RES 4,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11101111
	jmp ZVM_store_via_HL_next

Z80_instr_CB_AE:   ; RES 5,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11011111
	jmp ZVM_store_via_HL_next

Z80_instr_CB_B6:   ; RES 6,(HL)

	jsr (VEC_fetch_via_HL)
	and #%10111111
	jmp ZVM_store_via_HL_next

Z80_instr_CB_BE:   ; RES 7,(HL)

	jsr (VEC_fetch_via_HL)
	and #%01111111
	jmp ZVM_store_via_HL_next

Z80_instr_xDCB_86: ; RES 0,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11111110
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_8E: ; RES 1,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11111101
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_96: ; RES 2,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11111011
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_9E: ; RES 3,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11110111
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_A6: ; RES 4,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11101111
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_AE: ; RES 5,(IXY+d)

	lda [PTR_IXY_d],z
	and #%11011111
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_B6: ; RES 6,(IXY+d)

	lda [PTR_IXY_d],z
	and #%10111111
	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_instr_xDCB_BE: ; RES 7,(IXY+d)

	lda [PTR_IXY_d],z
	and #%01111111
	sta [PTR_IXY_d],z
	jmp ZVM_next
