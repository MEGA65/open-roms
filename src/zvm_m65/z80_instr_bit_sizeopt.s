
;
; Z80 bit set/reset/test instructions - these illegals are size optimized
;


!macro Z80_RES0_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11111110
	sta .REGn
	bra Z80_common_res_0123
}

!macro Z80_RES1_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11111101
	sta .REGn
	bra Z80_common_res_0123
}

!macro Z80_RES2_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11111011
	sta .REGn
	bra Z80_common_res_0123
}

!macro Z80_RES3_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11110111
	sta .REGn
	bra Z80_common_res_0123
}

!macro Z80_RES4_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11101111
	sta .REGn
	bra Z80_common_res_4567
}

!macro Z80_RES5_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%11011111
	sta .REGn
	bra Z80_common_res_4567
}

!macro Z80_RES6_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%10111111
	sta .REGn
	bra Z80_common_res_4567
}

!macro Z80_RES7_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	and #%01111111
	sta .REGn
	bra Z80_common_res_4567
}

Z80_illeg_xDCB_80: +Z80_RES0_VIA_IXY_d_REGn REG_B                              ; RES 0,(IXY+d),B
Z80_illeg_xDCB_81: +Z80_RES0_VIA_IXY_d_REGn REG_C                              ; RES 0,(IXY+d),C
Z80_illeg_xDCB_82: +Z80_RES0_VIA_IXY_d_REGn REG_D                              ; RES 0,(IXY+d),D
Z80_illeg_xDCB_83: +Z80_RES0_VIA_IXY_d_REGn REG_E                              ; RES 0,(IXY+d),E
Z80_illeg_xDCB_84: +Z80_RES0_VIA_IXY_d_REGn REG_H                              ; RES 0,(IXY+d),H
Z80_illeg_xDCB_85: +Z80_RES0_VIA_IXY_d_REGn REG_L                              ; RES 0,(IXY+d),L

Z80_illeg_xDCB_88: +Z80_RES1_VIA_IXY_d_REGn REG_B                              ; RES 1,(IXY+d),B
Z80_illeg_xDCB_89: +Z80_RES1_VIA_IXY_d_REGn REG_C                              ; RES 1,(IXY+d),C
Z80_illeg_xDCB_8A: +Z80_RES1_VIA_IXY_d_REGn REG_D                              ; RES 1,(IXY+d),D
Z80_illeg_xDCB_8B: +Z80_RES1_VIA_IXY_d_REGn REG_E                              ; RES 1,(IXY+d),E
Z80_illeg_xDCB_8C: +Z80_RES1_VIA_IXY_d_REGn REG_H                              ; RES 1,(IXY+d),H
Z80_illeg_xDCB_8D: +Z80_RES1_VIA_IXY_d_REGn REG_L                              ; RES 1,(IXY+d),L

	lda [PTR_IXY_d],z
	and #%11111101
	sta REG_L

	; FALLTROUGH

Z80_common_res_0123:

	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_illeg_xDCB_90: +Z80_RES2_VIA_IXY_d_REGn REG_B                              ; RES 2,(IXY+d),B
Z80_illeg_xDCB_91: +Z80_RES2_VIA_IXY_d_REGn REG_C                              ; RES 2,(IXY+d),C
Z80_illeg_xDCB_92: +Z80_RES2_VIA_IXY_d_REGn REG_D                              ; RES 2,(IXY+d),D
Z80_illeg_xDCB_93: +Z80_RES2_VIA_IXY_d_REGn REG_E                              ; RES 2,(IXY+d),E
Z80_illeg_xDCB_94: +Z80_RES2_VIA_IXY_d_REGn REG_H                              ; RES 2,(IXY+d),H
Z80_illeg_xDCB_95: +Z80_RES2_VIA_IXY_d_REGn REG_L                              ; RES 2,(IXY+d),L

Z80_illeg_xDCB_98: +Z80_RES3_VIA_IXY_d_REGn REG_B                              ; RES 3,(IXY+d),B
Z80_illeg_xDCB_99: +Z80_RES3_VIA_IXY_d_REGn REG_C                              ; RES 3,(IXY+d),C
Z80_illeg_xDCB_9A: +Z80_RES3_VIA_IXY_d_REGn REG_D                              ; RES 3,(IXY+d),D
Z80_illeg_xDCB_9B: +Z80_RES3_VIA_IXY_d_REGn REG_E                              ; RES 3,(IXY+d),E
Z80_illeg_xDCB_9C: +Z80_RES3_VIA_IXY_d_REGn REG_H                              ; RES 3,(IXY+d),H
Z80_illeg_xDCB_9D: +Z80_RES3_VIA_IXY_d_REGn REG_L                              ; RES 3,(IXY+d),L

Z80_illeg_xDCB_A0: +Z80_RES4_VIA_IXY_d_REGn REG_B                              ; RES 4,(IXY+d),B
Z80_illeg_xDCB_A1: +Z80_RES4_VIA_IXY_d_REGn REG_C                              ; RES 4,(IXY+d),C
Z80_illeg_xDCB_A2: +Z80_RES4_VIA_IXY_d_REGn REG_D                              ; RES 4,(IXY+d),D
Z80_illeg_xDCB_A3: +Z80_RES4_VIA_IXY_d_REGn REG_E                              ; RES 4,(IXY+d),E
Z80_illeg_xDCB_A4: +Z80_RES4_VIA_IXY_d_REGn REG_H                              ; RES 4,(IXY+d),H
Z80_illeg_xDCB_A5: +Z80_RES4_VIA_IXY_d_REGn REG_L                              ; RES 4,(IXY+d),L

Z80_illeg_xDCB_A8: +Z80_RES5_VIA_IXY_d_REGn REG_B                              ; RES 5,(IXY+d),B
Z80_illeg_xDCB_A9: +Z80_RES5_VIA_IXY_d_REGn REG_C                              ; RES 5,(IXY+d),C
Z80_illeg_xDCB_AA: +Z80_RES5_VIA_IXY_d_REGn REG_D                              ; RES 5,(IXY+d),D
Z80_illeg_xDCB_AB: +Z80_RES5_VIA_IXY_d_REGn REG_E                              ; RES 5,(IXY+d),E
Z80_illeg_xDCB_AC: +Z80_RES5_VIA_IXY_d_REGn REG_H                              ; RES 5,(IXY+d),H
Z80_illeg_xDCB_AD: +Z80_RES5_VIA_IXY_d_REGn REG_L                              ; RES 5,(IXY+d),L

	lda [PTR_IXY_d],z
	and #%11011111
	sta REG_L

	; FALLTROUGH

Z80_common_res_4567:

	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_illeg_xDCB_B0: +Z80_RES6_VIA_IXY_d_REGn REG_B                              ; RES 6,(IXY+d),B
Z80_illeg_xDCB_B1: +Z80_RES6_VIA_IXY_d_REGn REG_C                              ; RES 6,(IXY+d),C
Z80_illeg_xDCB_B2: +Z80_RES6_VIA_IXY_d_REGn REG_D                              ; RES 6,(IXY+d),D
Z80_illeg_xDCB_B3: +Z80_RES6_VIA_IXY_d_REGn REG_E                              ; RES 6,(IXY+d),E
Z80_illeg_xDCB_B4: +Z80_RES6_VIA_IXY_d_REGn REG_H                              ; RES 6,(IXY+d),H
Z80_illeg_xDCB_B5: +Z80_RES6_VIA_IXY_d_REGn REG_L                              ; RES 6,(IXY+d),L

Z80_illeg_xDCB_B8: +Z80_RES7_VIA_IXY_d_REGn REG_B                              ; RES 7,(IXY+d),B
Z80_illeg_xDCB_B9: +Z80_RES7_VIA_IXY_d_REGn REG_C                              ; RES 7,(IXY+d),C
Z80_illeg_xDCB_BA: +Z80_RES7_VIA_IXY_d_REGn REG_D                              ; RES 7,(IXY+d),D
Z80_illeg_xDCB_BB: +Z80_RES7_VIA_IXY_d_REGn REG_E                              ; RES 7,(IXY+d),E
Z80_illeg_xDCB_BC: +Z80_RES7_VIA_IXY_d_REGn REG_H                              ; RES 7,(IXY+d),H
Z80_illeg_xDCB_BD: +Z80_RES7_VIA_IXY_d_REGn REG_L                              ; RES 7,(IXY+d),L

!macro Z80_SET0_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00000001
	sta .REGn
	bra Z80_common_set_0123
}

!macro Z80_SET1_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00000010
	sta .REGn
	bra Z80_common_set_0123
}

!macro Z80_SET2_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00000100
	sta .REGn
	bra Z80_common_set_0123
}

!macro Z80_SET3_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00001000
	sta .REGn
	bra Z80_common_set_0123
}

!macro Z80_SET4_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00010000
	sta .REGn
	bra Z80_common_set_4567
}

!macro Z80_SET5_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%00100000
	sta .REGn
	bra Z80_common_set_4567
}

!macro Z80_SET6_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%01000000
	sta .REGn
	bra Z80_common_set_4567
}

!macro Z80_SET7_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d],z
	ora #%10000000
	sta .REGn
	bra Z80_common_set_4567
}

Z80_illeg_xDCB_C0: +Z80_SET0_VIA_IXY_d_REGn REG_B                              ; SET 0,(IXY+d),B
Z80_illeg_xDCB_C1: +Z80_SET0_VIA_IXY_d_REGn REG_C                              ; SET 0,(IXY+d),C
Z80_illeg_xDCB_C2: +Z80_SET0_VIA_IXY_d_REGn REG_D                              ; SET 0,(IXY+d),D
Z80_illeg_xDCB_C3: +Z80_SET0_VIA_IXY_d_REGn REG_E                              ; SET 0,(IXY+d),E
Z80_illeg_xDCB_C4: +Z80_SET0_VIA_IXY_d_REGn REG_H                              ; SET 0,(IXY+d),H
Z80_illeg_xDCB_C5: +Z80_SET0_VIA_IXY_d_REGn REG_L                              ; SET 0,(IXY+d),L

Z80_illeg_xDCB_C8: +Z80_SET1_VIA_IXY_d_REGn REG_B                              ; SET 1,(IXY+d),B
Z80_illeg_xDCB_C9: +Z80_SET1_VIA_IXY_d_REGn REG_C                              ; SET 1,(IXY+d),C
Z80_illeg_xDCB_CA: +Z80_SET1_VIA_IXY_d_REGn REG_D                              ; SET 1,(IXY+d),D
Z80_illeg_xDCB_CB: +Z80_SET1_VIA_IXY_d_REGn REG_E                              ; SET 1,(IXY+d),E
Z80_illeg_xDCB_CC: +Z80_SET1_VIA_IXY_d_REGn REG_H                              ; SET 1,(IXY+d),H
Z80_illeg_xDCB_CD:                                                             ; SET 1,(IXY+d),L

	lda [PTR_IXY_d],z
	ora #%00000010
	sta REG_L

	; FALLTROUGH

Z80_common_set_0123:

	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_illeg_xDCB_D0: +Z80_SET2_VIA_IXY_d_REGn REG_B                              ; SET 2,(IXY+d),B
Z80_illeg_xDCB_D1: +Z80_SET2_VIA_IXY_d_REGn REG_C                              ; SET 2,(IXY+d),C
Z80_illeg_xDCB_D2: +Z80_SET2_VIA_IXY_d_REGn REG_D                              ; SET 2,(IXY+d),D
Z80_illeg_xDCB_D3: +Z80_SET2_VIA_IXY_d_REGn REG_E                              ; SET 2,(IXY+d),E
Z80_illeg_xDCB_D4: +Z80_SET2_VIA_IXY_d_REGn REG_H                              ; SET 2,(IXY+d),H
Z80_illeg_xDCB_D5: +Z80_SET2_VIA_IXY_d_REGn REG_L                              ; SET 2,(IXY+d),L

Z80_illeg_xDCB_D8: +Z80_SET3_VIA_IXY_d_REGn REG_B                              ; SET 3,(IXY+d),B
Z80_illeg_xDCB_D9: +Z80_SET3_VIA_IXY_d_REGn REG_C                              ; SET 3,(IXY+d),C
Z80_illeg_xDCB_DA: +Z80_SET3_VIA_IXY_d_REGn REG_D                              ; SET 3,(IXY+d),D
Z80_illeg_xDCB_DB: +Z80_SET3_VIA_IXY_d_REGn REG_E                              ; SET 3,(IXY+d),E
Z80_illeg_xDCB_DC: +Z80_SET3_VIA_IXY_d_REGn REG_H                              ; SET 3,(IXY+d),H
Z80_illeg_xDCB_DD: +Z80_SET3_VIA_IXY_d_REGn REG_L                              ; SET 3,(IXY+d),L

Z80_illeg_xDCB_E0: +Z80_SET4_VIA_IXY_d_REGn REG_B                              ; SET 4,(IXY+d),B
Z80_illeg_xDCB_E1: +Z80_SET4_VIA_IXY_d_REGn REG_C                              ; SET 4,(IXY+d),C
Z80_illeg_xDCB_E2: +Z80_SET4_VIA_IXY_d_REGn REG_D                              ; SET 4,(IXY+d),D
Z80_illeg_xDCB_E3: +Z80_SET4_VIA_IXY_d_REGn REG_E                              ; SET 4,(IXY+d),E
Z80_illeg_xDCB_E4: +Z80_SET4_VIA_IXY_d_REGn REG_H                              ; SET 4,(IXY+d),H
Z80_illeg_xDCB_E5: +Z80_SET4_VIA_IXY_d_REGn REG_L                              ; SET 4,(IXY+d),L

Z80_illeg_xDCB_E8: +Z80_SET5_VIA_IXY_d_REGn REG_B                              ; SET 5,(IXY+d),B
Z80_illeg_xDCB_E9: +Z80_SET5_VIA_IXY_d_REGn REG_C                              ; SET 5,(IXY+d),C
Z80_illeg_xDCB_EA: +Z80_SET5_VIA_IXY_d_REGn REG_D                              ; SET 5,(IXY+d),D
Z80_illeg_xDCB_EB: +Z80_SET5_VIA_IXY_d_REGn REG_E                              ; SET 5,(IXY+d),E
Z80_illeg_xDCB_EC: +Z80_SET5_VIA_IXY_d_REGn REG_H                              ; SET 5,(IXY+d),H
Z80_illeg_xDCB_ED:                                                             ; SET 5,(IXY+d),L

	lda [PTR_IXY_d],z
	ora #%00100000
	sta REG_L

	; FALLTROUGH

Z80_common_set_4567:

	sta [PTR_IXY_d],z
	jmp ZVM_next

Z80_illeg_xDCB_F0: +Z80_SET6_VIA_IXY_d_REGn REG_B                              ; SET 6,(IXY+d),B
Z80_illeg_xDCB_F1: +Z80_SET6_VIA_IXY_d_REGn REG_C                              ; SET 6,(IXY+d),C
Z80_illeg_xDCB_F2: +Z80_SET6_VIA_IXY_d_REGn REG_D                              ; SET 6,(IXY+d),D
Z80_illeg_xDCB_F3: +Z80_SET6_VIA_IXY_d_REGn REG_E                              ; SET 6,(IXY+d),E
Z80_illeg_xDCB_F4: +Z80_SET6_VIA_IXY_d_REGn REG_H                              ; SET 6,(IXY+d),H
Z80_illeg_xDCB_F5: +Z80_SET6_VIA_IXY_d_REGn REG_L                              ; SET 6,(IXY+d),L

Z80_illeg_xDCB_F8: +Z80_SET7_VIA_IXY_d_REGn REG_B                              ; SET 7,(IXY+d),B
Z80_illeg_xDCB_F9: +Z80_SET7_VIA_IXY_d_REGn REG_C                              ; SET 7,(IXY+d),C
Z80_illeg_xDCB_FA: +Z80_SET7_VIA_IXY_d_REGn REG_D                              ; SET 7,(IXY+d),D
Z80_illeg_xDCB_FB: +Z80_SET7_VIA_IXY_d_REGn REG_E                              ; SET 7,(IXY+d),E
Z80_illeg_xDCB_FC: +Z80_SET7_VIA_IXY_d_REGn REG_H                              ; SET 7,(IXY+d),H
Z80_illeg_xDCB_FD: +Z80_SET7_VIA_IXY_d_REGn REG_L                              ; SET 7,(IXY+d),L



; XXX turn code below into macros, rework remaining ones to use same concept


Z80_illeg_xDCB_87:                                                             ; RES 0,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11111110
	bra Z80_common_setres_A

Z80_illeg_xDCB_8F:                                                             ; RES 1,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11111101
	bra Z80_common_setres_A

Z80_illeg_xDCB_97:                                                             ; RES 2,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11111011
	bra Z80_common_setres_A

Z80_illeg_xDCB_9F:                                                             ; RES 3,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11110111
	bra Z80_common_setres_A

Z80_illeg_xDCB_A7:                                                             ; RES 4,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11101111
	bra Z80_common_setres_A

Z80_illeg_xDCB_AF:                                                             ; RES 5,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%11011111
	bra Z80_common_setres_A

Z80_illeg_xDCB_B7:                                                             ; RES 6,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%10111111
	bra Z80_common_setres_A

Z80_illeg_xDCB_BF:                                                             ; RES 7,(IXY+d),A

	lda [PTR_IXY_d],z
	and #%01111111
	bra Z80_common_setres_A

Z80_illeg_xDCB_C7:                                                             ; SET 0,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00000001
	bra Z80_common_setres_A

Z80_illeg_xDCB_CF:                                                             ; SET 1,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00000010
	bra Z80_common_setres_A

Z80_illeg_xDCB_D7:                                                             ; SET 2,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00000100
	bra Z80_common_setres_A

Z80_illeg_xDCB_DF:                                                             ; SET 3,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00001000
	bra Z80_common_setres_A

Z80_illeg_xDCB_E7:                                                             ; SET 4,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00010000
	bra Z80_common_setres_A

Z80_illeg_xDCB_EF:                                                             ; SET 5,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%00100000
	bra Z80_common_setres_A

Z80_illeg_xDCB_F7:                                                             ; SET 6,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%01000000
	bra Z80_common_setres_A

Z80_illeg_xDCB_FF:                                                             ; SET 7,(IXY+d),A

	lda [PTR_IXY_d],z
	ora #%10000000

	; FALLTROUGH

Z80_common_setres_A:

	sta REG_A
	sta [PTR_IXY_d],z
	jmp ZVM_next
