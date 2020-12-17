
;
; Z80 arithmetic instructions, 8 bit
;

; XXX put BIT instructions here

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

; XXX put SET b,(IX+d) instructions here
; XXX put SET b,(IY+d) instructions here

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

; XXX put RES b,(IX+d) instructions here
; XXX put RES b,(IY+d) instructions here
