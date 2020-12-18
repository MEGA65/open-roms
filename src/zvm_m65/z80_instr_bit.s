
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
	rts

Z80_common_bitx_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	rts

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
	rts

Z80_common_bit3_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_XF)
	sta REG_F
	rts

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
	rts

Z80_common_bit5_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_YF)
	sta REG_F
	rts

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
	rts

Z80_common_bit7_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_SF)
	sta REG_F
	rts

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
	rts

Z80_common_bitHL_0:

	; XXX behaviour of undefined flags not fully known, thus not implemented
	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	rts

Z80_common_bitHL_1:

	; XXX behaviour of undefined flags not fully known, thus not implemented
	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	rts

; bits taken from index register + displacement

Z80_instr_DDCB_46: ; BIT 0,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00000001
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_4E: ; BIT 1,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00000010
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_56: ; BIT 2,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00000100
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_5E: ; BIT 3,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00001000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_66: ; BIT 4,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00010000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_6E: ; BIT 5,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%00100000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_76: ; BIT 6,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%01000000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_DDCB_7E: ; BIT 7,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%10000000
	beq Z80_common_bitXYx_0
	
	; FALLTROUGH

Z80_common_bitXY7_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF + Z80_SF)
	sta REG_F
	lda ADDR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	rts

Z80_common_bitXYx_0:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF)
	ora #($00 + Z80_HF + Z80_ZF + Z80_PF)
	sta REG_F
	lda ADDR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	rts

Z80_common_bitXYx_1:

	lda REG_F
	and #($FF - Z80_NF - Z80_XF - Z80_YF - Z80_SF - Z80_ZF - Z80_PF)
	ora #($00 + Z80_HF)
	sta REG_F
	lda ADDR_IXY_d+1
	and #(Z80_XF + Z80_YF)
	ora REG_F
	sta REG_F
	rts

Z80_instr_FDCB_46: ; BIT 0,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00000001
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_4E: ; BIT 1,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00000010
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_56: ; BIT 2,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00000100
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_5E: ; BIT 3,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00001000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_66: ; BIT 4,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00010000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_6E: ; BIT 5,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%00100000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_76: ; BIT 6,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%01000000
	bne Z80_common_bitXYx_1
	bra Z80_common_bitXYx_0

Z80_instr_FDCB_7E: ; BIT 7,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%10000000
	bne Z80_common_bitXY7_1
	bra Z80_common_bitXYx_0

; SET, RES

Z80_instr_CB_C0:   ; SET 0,B

	lda REG_B
	ora #%00000001
	sta REG_B
	rts

Z80_instr_CB_C1:   ; SET 0,C

	lda REG_C
	ora #%00000001
	sta REG_C
	rts

Z80_instr_CB_C2:   ; SET 0,D

	lda REG_D
	ora #%00000001
	sta REG_D
	rts

Z80_instr_CB_C3:   ; SET 0,E

	lda REG_E
	ora #%00000001
	sta REG_E
	rts

Z80_instr_CB_C4:   ; SET 0,H

	lda REG_H
	ora #%00000001
	sta REG_H
	rts

Z80_instr_CB_C5:   ; SET 0,L

	lda REG_L
	ora #%00000001
	sta REG_L
	rts

Z80_instr_CB_C7:   ; SET 0,A

	lda REG_A
	ora #%00000001
	sta REG_A
	rts

Z80_instr_CB_C8:   ; SET 1,B

	lda REG_B
	ora #%00000010
	sta REG_B
	rts

Z80_instr_CB_C9:   ; SET 1,

	lda REG_C
	ora #%00000010
	sta REG_C
	rts

Z80_instr_CB_CA:   ; SET 1,D

	lda REG_D
	ora #%00000010
	sta REG_D
	rts

Z80_instr_CB_CB:   ; SET 1,E

	lda REG_E
	ora #%00000010
	sta REG_E
	rts

Z80_instr_CB_CC:   ; SET 1,H

	lda REG_H
	ora #%00000010
	sta REG_H
	rts

Z80_instr_CB_CD:   ; SET 1,L

	lda REG_L
	ora #%00000010
	sta REG_L
	rts

Z80_instr_CB_CF:   ; SET 1,A

	lda REG_A
	ora #%00000010
	sta REG_A
	rts

Z80_instr_CB_D0:   ; SET 2,B

	lda REG_B
	ora #%00000100
	sta REG_B
	rts

Z80_instr_CB_D1:   ; SET 2,C

	lda REG_C
	ora #%00000100
	sta REG_C
	rts

Z80_instr_CB_D2:   ; SET 2,D

	lda REG_D
	ora #%00000100
	sta REG_D
	rts

Z80_instr_CB_D3:   ; SET 2,E

	lda REG_E
	ora #%00000100
	sta REG_E
	rts

Z80_instr_CB_D4:   ; SET 2,H

	lda REG_H
	ora #%00000100
	sta REG_H
	rts

Z80_instr_CB_D5:   ; SET 2,L

	lda REG_L
	ora #%00000100
	sta REG_L
	rts

Z80_instr_CB_D7:   ; SET 2,A

	lda REG_A
	ora #%00000100
	sta REG_A
	rts

Z80_instr_CB_D8:   ; SET 3,B

	lda REG_B
	ora #%00001000
	sta REG_B
	rts

Z80_instr_CB_D9:   ; SET 3,C

	lda REG_C
	ora #%00001000
	sta REG_C
	rts

Z80_instr_CB_DA:   ; SET 3,D

	lda REG_D
	ora #%00001000
	sta REG_D
	rts

Z80_instr_CB_DB:   ; SET 3,E

	lda REG_E
	ora #%00001000
	sta REG_E
	rts

Z80_instr_CB_DC:   ; SET 3,H

	lda REG_H
	ora #%00001000
	sta REG_H
	rts

Z80_instr_CB_DD:   ; SET 3,L

	lda REG_L
	ora #%00001000
	sta REG_L
	rts

Z80_instr_CB_DF:   ; SET 3,A

	lda REG_A
	ora #%00001000
	sta REG_A
	rts

Z80_instr_CB_E0:   ; SET 4,B

	lda REG_B
	ora #%00010000
	sta REG_B
	rts

Z80_instr_CB_E1:   ; SET 4,C

	lda REG_C
	ora #%00010000
	sta REG_C
	rts

Z80_instr_CB_E2:   ; SET 4,D

	lda REG_D
	ora #%00010000
	sta REG_D
	rts

Z80_instr_CB_E3:   ; SET 4,E

	lda REG_E
	ora #%00010000
	sta REG_E
	rts

Z80_instr_CB_E4:   ; SET 4,H

	lda REG_H
	ora #%00010000
	sta REG_H
	rts

Z80_instr_CB_E5:   ; SET 4,L

	lda REG_L
	ora #%00010000
	sta REG_L
	rts

Z80_instr_CB_E7:   ; SET 4,A

	lda REG_A
	ora #%00010000
	sta REG_A
	rts

Z80_instr_CB_E8:   ; SET 5,B

	lda REG_B
	ora #%00100000
	sta REG_B
	rts

Z80_instr_CB_E9:   ; SET 5,C

	lda REG_C
	ora #%00100000
	sta REG_C
	rts

Z80_instr_CB_EA:   ; SET 5,D

	lda REG_D
	ora #%00100000
	sta REG_D
	rts

Z80_instr_CB_EB:   ; SET 5,E

	lda REG_E
	ora #%00100000
	sta REG_E
	rts

Z80_instr_CB_EC:   ; SET 5,H

	lda REG_H
	ora #%00100000
	sta REG_H
	rts

Z80_instr_CB_ED:   ; SET 5,L

	lda REG_L
	ora #%00100000
	sta REG_L
	rts

Z80_instr_CB_EF:   ; SET 5,A

	lda REG_A
	ora #%00100000
	sta REG_A
	rts

Z80_instr_CB_F0:   ; SET 6,B

	lda REG_B
	ora #%01000000
	sta REG_B
	rts

Z80_instr_CB_F1:   ; SET 6,C

	lda REG_C
	ora #%01000000
	sta REG_C
	rts

Z80_instr_CB_F2:   ; SET 6,D

	lda REG_D
	ora #%01000000
	sta REG_D
	rts

Z80_instr_CB_F3:   ; SET 6,E

	lda REG_E
	ora #%01000000
	sta REG_E
	rts

Z80_instr_CB_F4:   ; SET 6,H

	lda REG_H
	ora #%01000000
	sta REG_H
	rts

Z80_instr_CB_F5:   ; SET 6,L

	lda REG_L
	ora #%01000000
	sta REG_L
	rts

Z80_instr_CB_F7:   ; SET 6,A

	lda REG_A
	ora #%01000000
	sta REG_A
	rts

Z80_instr_CB_F8:   ; SET 7,B

	lda REG_B
	ora #%10000000
	sta REG_B
	rts

Z80_instr_CB_F9:   ; SET 7,C

	lda REG_C
	ora #%10000000
	sta REG_C
	rts

Z80_instr_CB_FA:   ; SET 7,D

	lda REG_D
	ora #%10000000
	sta REG_D
	rts

Z80_instr_CB_FB:   ; SET 7,E

	lda REG_E
	ora #%10000000
	sta REG_E
	rts

Z80_instr_CB_FC:   ; SET 7,H

	lda REG_H
	ora #%10000000
	sta REG_H
	rts

Z80_instr_CB_FD:   ; SET 7,L

	lda REG_L
	ora #%10000000
	sta REG_L
	rts

Z80_instr_CB_FF:   ; SET 7,A

	lda REG_A
	ora #%10000000
	sta REG_A
	rts

Z80_instr_CB_C6:   ; SET 0,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000001
	jmp ZVM_store_back

Z80_instr_CB_CE:   ; SET 1,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000010
	jmp ZVM_store_back

Z80_instr_CB_D6:   ; SET 2,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00000100
	jmp ZVM_store_back

Z80_instr_CB_DE:   ; SET 3,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00001000
	jmp ZVM_store_back

Z80_instr_CB_E6:   ; SET 4,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00010000
	jmp ZVM_store_back

Z80_instr_CB_EE:   ; SET 5,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%00100000
	jmp ZVM_store_back

Z80_instr_CB_F6:   ; SET 6,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%01000000
	jmp ZVM_store_back

Z80_instr_CB_FE:   ; SET 7,(HL)

	jsr (VEC_fetch_via_HL)
	ora #%10000000
	jmp ZVM_store_back

Z80_instr_DDCB_C6: ; SET 0,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00000001
	jmp ZVM_store_back

Z80_instr_DDCB_CE: ; SET 1,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00000010
	jmp ZVM_store_back

Z80_instr_DDCB_D6: ; SET 2,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00000100
	jmp ZVM_store_back

Z80_instr_DDCB_DE: ; SET 3,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00001000
	jmp ZVM_store_back

Z80_instr_DDCB_E6: ; SET 4,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00010000
	jmp ZVM_store_back

Z80_instr_DDCB_EE: ; SET 5,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%00100000
	jmp ZVM_store_back

Z80_instr_DDCB_F6: ; SET 6,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%01000000
	jmp ZVM_store_back

Z80_instr_DDCB_FE: ; SET 7,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	ora #%10000000
	jmp ZVM_store_back

Z80_instr_FDCB_C6: ; SET 0,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00000001
	jmp ZVM_store_back

Z80_instr_FDCB_CE: ; SET 1,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00000010
	jmp ZVM_store_back

Z80_instr_FDCB_D6: ; SET 2,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00000100
	jmp ZVM_store_back

Z80_instr_FDCB_DE: ; SET 3,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00001000
	jmp ZVM_store_back

Z80_instr_FDCB_E6: ; SET 4,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00010000
	jmp ZVM_store_back

Z80_instr_FDCB_EE: ; SET 5,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%00100000
	jmp ZVM_store_back

Z80_instr_FDCB_F6: ; SET 6,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%01000000
	jmp ZVM_store_back

Z80_instr_FDCB_FE: ; SET 7,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	ora #%10000000
	jmp ZVM_store_back

Z80_instr_CB_80:   ; RES 0,B

	lda REG_B
	and #%11111110
	sta REG_B
	rts

Z80_instr_CB_81:   ; RES 0,C

	lda REG_C
	and #%11111110
	sta REG_C
	rts

Z80_instr_CB_82:   ; RES 0,D

	lda REG_D
	and #%11111110
	sta REG_D
	rts

Z80_instr_CB_83:   ; RES 0,E

	lda REG_E
	and #%11111110
	sta REG_E
	rts

Z80_instr_CB_84:   ; RES 0,H

	lda REG_H
	and #%11111110
	sta REG_H
	rts

Z80_instr_CB_85:   ; RES 0,L

	lda REG_L
	and #%11111110
	sta REG_L
	rts

Z80_instr_CB_87:   ; RES 0,A

	lda REG_A
	and #%11111110
	sta REG_A
	rts

Z80_instr_CB_88:   ; RES 1,B

	lda REG_B
	and #%11111101
	sta REG_B
	rts

Z80_instr_CB_89:   ; RES 1,C

	lda REG_C
	and #%11111101
	sta REG_C
	rts

Z80_instr_CB_8A:   ; RES 1,D

	lda REG_D
	and #%11111101
	sta REG_D
	rts

Z80_instr_CB_8B:   ; RES 1,E

	lda REG_E
	and #%11111101
	sta REG_E
	rts

Z80_instr_CB_8C:   ; RES 1,H

	lda REG_H
	and #%11111101
	sta REG_H
	rts

Z80_instr_CB_8D:   ; RES 1,L

	lda REG_L
	and #%11111101
	sta REG_L
	rts

Z80_instr_CB_8F:   ; RES 1,A

	lda REG_A
	and #%11111101
	sta REG_A
	rts

Z80_instr_CB_90:   ; RES 2,B

	lda REG_B
	and #%11111011
	sta REG_B
	rts

Z80_instr_CB_91:   ; RES 2,C

	lda REG_C
	and #%11111011
	sta REG_C
	rts

Z80_instr_CB_92:   ; RES 2,D

	lda REG_D
	and #%11111011
	sta REG_D
	rts

Z80_instr_CB_93:   ; RES 2,E

	lda REG_E
	and #%11111011
	sta REG_E
	rts

Z80_instr_CB_94:   ; RES 2,H

	lda REG_H
	and #%11111011
	sta REG_H
	rts

Z80_instr_CB_95:   ; RES 2,L

	lda REG_L
	and #%11111011
	sta REG_L
	rts

Z80_instr_CB_97:   ; RES 2,A

	lda REG_A
	and #%11111011
	sta REG_A
	rts

Z80_instr_CB_98:   ; RES 3,B

	lda REG_B
	and #%11110111
	sta REG_B
	rts

Z80_instr_CB_99:   ; RES 3,C

	lda REG_C
	and #%11110111
	sta REG_C
	rts

Z80_instr_CB_9A:   ; RES 3,D

	lda REG_D
	and #%11110111
	sta REG_D
	rts

Z80_instr_CB_9B:   ; RES 3,E

	lda REG_E
	and #%11110111
	sta REG_E
	rts

Z80_instr_CB_9C:   ; RES 3,H

	lda REG_H
	and #%11110111
	sta REG_H
	rts

Z80_instr_CB_9D:   ; RES 3,L

	lda REG_L
	and #%11110111
	sta REG_L
	rts

Z80_instr_CB_9F:   ; RES 3,A

	lda REG_A
	and #%11110111
	sta REG_A
	rts

Z80_instr_CB_A0:   ; RES 4,B

	lda REG_B
	and #%11101111
	sta REG_B
	rts

Z80_instr_CB_A1:   ; RES 4,C

	lda REG_C
	and #%11101111
	sta REG_C
	rts

Z80_instr_CB_A2:   ; RES 4,D

	lda REG_D
	and #%11101111
	sta REG_D
	rts

Z80_instr_CB_A3:   ; RES 4,E

	lda REG_E
	and #%11101111
	sta REG_E
	rts

Z80_instr_CB_A4:   ; RES 4,H

	lda REG_H
	and #%11101111
	sta REG_H
	rts

Z80_instr_CB_A5:   ; RES 4,L

	lda REG_L
	and #%11101111
	sta REG_L
	rts

Z80_instr_CB_A7:   ; RES 4,A

	lda REG_A
	and #%11101111
	sta REG_A
	rts

Z80_instr_CB_A8:   ; RES 5,B

	lda REG_B
	and #%11011111
	sta REG_B
	rts

Z80_instr_CB_A9:   ; RES 5,C

	lda REG_C
	and #%11011111
	sta REG_C
	rts

Z80_instr_CB_AA:   ; RES 5,D

	lda REG_D
	and #%11011111
	sta REG_D
	rts

Z80_instr_CB_AB:   ; RES 5,E

	lda REG_E
	and #%11011111
	sta REG_E
	rts

Z80_instr_CB_AC:   ; RES 5,H

	lda REG_H
	and #%11011111
	sta REG_H
	rts

Z80_instr_CB_AD:   ; RES 5,L

	lda REG_L
	and #%11011111
	sta REG_L
	rts

Z80_instr_CB_AF:   ; RES 5,A

	lda REG_A
	and #%11011111
	sta REG_A
	rts

Z80_instr_CB_B0:   ; RES 6,B

	lda REG_B
	and #%10111111
	sta REG_B
	rts

Z80_instr_CB_B1:   ; RES 6,C

	lda REG_C
	and #%10111111
	sta REG_C
	rts

Z80_instr_CB_B2:   ; RES 6,D

	lda REG_D
	and #%10111111
	sta REG_D
	rts

Z80_instr_CB_B3:   ; RES 6,E

	lda REG_E
	and #%10111111
	sta REG_E
	rts

Z80_instr_CB_B4:   ; RES 6,H

	lda REG_H
	and #%10111111
	sta REG_H
	rts

Z80_instr_CB_B5:   ; RES 6,L

	lda REG_L
	and #%10111111
	sta REG_L
	rts

Z80_instr_CB_B7:   ; RES 6,A

	lda REG_A
	and #%10111111
	sta REG_A
	rts

Z80_instr_CB_B8:   ; RES 7,B

	lda REG_B
	and #%01111111
	sta REG_B
	rts

Z80_instr_CB_B9:   ; RES 7,C

	lda REG_C
	and #%01111111
	sta REG_C
	rts

Z80_instr_CB_BA:   ; RES 7,D

	lda REG_D
	and #%01111111
	sta REG_D
	rts

Z80_instr_CB_BB:   ; RES 7,E

	lda REG_E
	and #%01111111
	sta REG_E
	rts

Z80_instr_CB_BC:   ; RES 7,H

	lda REG_H
	and #%01111111
	sta REG_H
	rts

Z80_instr_CB_BD:   ; RES 7,L

	lda REG_L
	and #%01111111
	sta REG_L
	rts

Z80_instr_CB_BF:   ; RES 7,A

	lda REG_A
	and #%01111111
	sta REG_A
	rts

Z80_instr_CB_86:   ; RES 0,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111110
	jmp ZVM_store_back

Z80_instr_CB_8E:   ; RES 1,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111101
	jmp ZVM_store_back

Z80_instr_CB_96:   ; RES 2,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11111011
	jmp ZVM_store_back

Z80_instr_CB_9E:   ; RES 3,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11110111
	jmp ZVM_store_back

Z80_instr_CB_A6:   ; RES 4,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11101111
	jmp ZVM_store_back

Z80_instr_CB_AE:   ; RES 5,(HL)

	jsr (VEC_fetch_via_HL)
	and #%11011111
	jmp ZVM_store_back

Z80_instr_CB_B6:   ; RES 6,(HL)

	jsr (VEC_fetch_via_HL)
	and #%10111111
	jmp ZVM_store_back

Z80_instr_CB_BE:   ; RES 7,(HL)

	jsr (VEC_fetch_via_HL)
	and #%01111111
	jmp ZVM_store_back

Z80_instr_DDCB_86: ; RES 0,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11111110
	jmp ZVM_store_back

Z80_instr_DDCB_8E: ; RES 1,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11111101
	jmp ZVM_store_back

Z80_instr_DDCB_96: ; RES 2,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11111011
	jmp ZVM_store_back

Z80_instr_DDCB_9E: ; RES 3,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11110111
	jmp ZVM_store_back

Z80_instr_DDCB_A6: ; RES 4,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11101111
	jmp ZVM_store_back

Z80_instr_DDCB_AE: ; RES 5,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%11011111
	jmp ZVM_store_back

Z80_instr_DDCB_B6: ; RES 6,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%10111111
	jmp ZVM_store_back

Z80_instr_DDCB_BE: ; RES 7,(IX+d)

	jsr (VEC_fetch_via_IX_d)
	and #%01111111
	jmp ZVM_store_back

Z80_instr_FDCB_86: ; RES 0,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11111110
	jmp ZVM_store_back

Z80_instr_FDCB_8E: ; RES 1,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11111101
	jmp ZVM_store_back

Z80_instr_FDCB_96: ; RES 2,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11111011
	jmp ZVM_store_back

Z80_instr_FDCB_9E: ; RES 3,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11110111
	jmp ZVM_store_back

Z80_instr_FDCB_A6: ; RES 4,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11101111
	jmp ZVM_store_back

Z80_instr_FDCB_AE: ; RES 5,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%11011111
	jmp ZVM_store_back

Z80_instr_FDCB_B6: ; RES 6,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%10111111
	jmp ZVM_store_back

Z80_instr_FDCB_BE: ; RES 7,(IY+d)

	jsr (VEC_fetch_via_IY_d)
	and #%01111111
	jmp ZVM_store_back
