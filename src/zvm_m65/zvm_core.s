
;
; Z80 Virtual Machine core routines
;

ZVM_entry:

	; XXX mark that this is the first start of CP/M iin the lifecycle, display BIOS information
	jmp zvm_BIOS_00_BOOT

ZVM_store_next:

	sta [PTR_DATA],z

	; FALLTROUGH

!macro ZVM_DISPATCH .TAB_LO, .TAB_HI {

	; Fetch and execute next opcode

	jsr (VEC_fetch_value)
	asl
	tax
	bcs @1
	jmp (.TAB_LO,x)          ; execute opcode $00-$7F
@1: jmp (.TAB_HI,x)          ; execute opcode $80-$FF

}

	; unsupported illegal instructions
Z80_unsupported:
	; XXX add a separate handler for illegal instructions
	; LD instructions with no effect
Z80_instr_40:                                                                  ; LD B,B
Z80_instr_49:                                                                  ; LD C,C
Z80_instr_52:                                                                  ; LD D,D
Z80_instr_5B:                                                                  ; LD E,E
Z80_instr_64:                                                                  ; LD H,H
Z80_instr_6D:                                                                  ; LD L,L
Z80_instr_7F:                                                                  ; LD A,A
Z80_illeg_DD_64:                                                               ; LD IXH,IXH
Z80_illeg_DD_6D:                                                               ; LD IXL,IXL
Z80_illeg_FD_64:                                                               ; LD IYH,IYH
Z80_illeg_FD_6D:                                                               ; LD IYL,IYL
	; For interrupts (emulation not needed for CP/M)
Z80_instr_ED_46:                                                               ; IM 0
Z80_illeg_ED_4E:                                                               ; IM 0
Z80_illeg_ED_66:                                                               ; IM 0
Z80_illeg_ED_6E:                                                               ; IM 0
Z80_instr_ED_56:                                                               ; IM 1
Z80_illeg_ED_76:                                                               ; IM 1
Z80_instr_ED_5E:                                                               ; IM 2
Z80_illeg_ED_7E:                                                               ; IM 2
	; Real NOP
Z80_instr_00:                                                                  ; NOP
Z80_illeg_ED_77:                                                               ; NOP
Z80_illeg_ED_7F:                                                               ; NOP
	; Dispatch via jumptable
ZVM_next:          +ZVM_DISPATCH Z80_vectab_0,    Z80_vectab_1
Z80_instr_CB:      +ZVM_DISPATCH Z80_vectab_CB_0, Z80_vectab_CB_1              ; #CB
Z80_instr_DD:      +ZVM_DISPATCH Z80_vectab_DD_0, Z80_vectab_DD_1              ; #DD
Z80_instr_ED:      +ZVM_DISPATCH Z80_vectab_ED_0, Z80_vectab_ED_1              ; #ED
Z80_instr_FD:      +ZVM_DISPATCH Z80_vectab_FD_0, Z80_vectab_FD_1              ; #FD
































;
; Not implemented yet - XXX implement them!
;


Z80_instr_DD_CB:   ; #DDCB
Z80_instr_FD_CB:   ; #FDCB
Z80_instr_09:      ; ADD HL,BC
Z80_instr_19:      ; ADD HL,DE
Z80_instr_22:      ; LD (nn),HL
Z80_instr_29:      ; ADD HL,HL
Z80_instr_2A:      ; LD HL,(nn)
Z80_instr_39:      ; ADD HL,SP
Z80_instr_80:      ; ADD A,B
Z80_instr_81:      ; ADD A,C
Z80_instr_82:      ; ADD A,D
Z80_instr_83:      ; ADD A,E
Z80_instr_84:      ; ADD A,H
Z80_instr_85:      ; ADD A,L
Z80_instr_86:      ; ADD A,(HL)
Z80_instr_87:      ; ADD A,A
Z80_instr_88:      ; ADC A,B
Z80_instr_89:      ; ADC A,C
Z80_instr_8A:      ; ADC A,D
Z80_instr_8B:      ; ADC A,E
Z80_instr_8C:      ; ADC A,H
Z80_instr_8D:      ; ADC A,L
Z80_instr_8E:      ; ADC A,(HL)
Z80_instr_8F:      ; ADC A,A
Z80_instr_90:      ; SUB B
Z80_instr_91:      ; SUB C
Z80_instr_92:      ; SUB D
Z80_instr_93:      ; SUB E
Z80_instr_94:      ; SUB H
Z80_instr_95:      ; SUB L
Z80_instr_96:      ; SUB (HL)
Z80_instr_97:      ; SUB A
Z80_instr_98:      ; SBC B
Z80_instr_99:      ; SBC C
Z80_instr_9A:      ; SBC D
Z80_instr_9B:      ; SBC E
Z80_instr_9C:      ; SBC H
Z80_instr_9D:      ; SBC L
Z80_instr_9E:      ; SBC (HL)
Z80_instr_9F:      ; SBC A
Z80_instr_B8:      ; CP B
Z80_instr_B9:      ; CP C
Z80_instr_BA:      ; CP D
Z80_instr_BB:      ; CP E
Z80_instr_BC:      ; CP H
Z80_instr_BD:      ; CP L
Z80_instr_BE:      ; CP (HL)
Z80_instr_BF:      ; CP A
Z80_instr_C6:      ; ADD A,n
Z80_instr_CE:      ; ADC A,n
Z80_instr_D6:      ; SUB n
Z80_instr_DE:      ; SBC A,n
Z80_instr_E3:      ; EX (SP),HL
Z80_instr_F9:      ; LD SP,HL
Z80_instr_FE:      ; CP n
Z80_instr_CB_00:   ; RLC B
Z80_instr_CB_01:   ; RLC C
Z80_instr_CB_02:   ; RLC D
Z80_instr_CB_03:   ; RLC E
Z80_instr_CB_04:   ; RLC H
Z80_instr_CB_05:   ; RLC L
Z80_instr_CB_06:   ; RLC (HL)
Z80_instr_CB_07:   ; RLC A
Z80_instr_CB_08:   ; RRC B
Z80_instr_CB_09:   ; RRC C
Z80_instr_CB_0A:   ; RRC D
Z80_instr_CB_0B:   ; RRC E
Z80_instr_CB_0C:   ; RRC H
Z80_instr_CB_0D:   ; RRC L
Z80_instr_CB_0E:   ; RRC (HL)
Z80_instr_CB_0F:   ; RRC A
Z80_instr_CB_10:   ; RL B
Z80_instr_CB_11:   ; RL C 
Z80_instr_CB_12:   ; RL D
Z80_instr_CB_13:   ; RL E
Z80_instr_CB_14:   ; RL H
Z80_instr_CB_15:   ; RL L
Z80_instr_CB_16:   ; RL (HL)
Z80_instr_CB_17:   ; RL A
Z80_instr_CB_18:   ; RR B
Z80_instr_CB_19:   ; RR C
Z80_instr_CB_1A:   ; RR D
Z80_instr_CB_1B:   ; RR E
Z80_instr_CB_1C:   ; RR H
Z80_instr_CB_1D:   ; RR L
Z80_instr_CB_1E:   ; RR (HL)
Z80_instr_CB_1F:   ; RR A
Z80_instr_CB_20:   ; SLA B
Z80_instr_CB_21:   ; SLA C
Z80_instr_CB_22:   ; SLA D
Z80_instr_CB_23:   ; SLA E
Z80_instr_CB_24:   ; SLA H
Z80_instr_CB_25:   ; SLA L
Z80_instr_CB_26:   ; SLA (HL)
Z80_instr_CB_27:   ; SLA A
Z80_instr_CB_28:   ; SRA B
Z80_instr_CB_29:   ; SRA C
Z80_instr_CB_2A:   ; SRA D
Z80_instr_CB_2B:   ; SRA E
Z80_instr_CB_2C:   ; SRA H
Z80_instr_CB_2D:   ; SRA L
Z80_instr_CB_2E:   ; SRA (HL)
Z80_instr_CB_2F:   ; SRA A
Z80_instr_CB_38:   ; SRL B
Z80_instr_CB_39:   ; SRL C
Z80_instr_CB_3A:   ; SRL D
Z80_instr_CB_3B:   ; SRL E
Z80_instr_CB_3C:   ; SRL H
Z80_instr_CB_3D:   ; SRL L
Z80_instr_CB_3E:   ; SRL (HL)
Z80_instr_CB_3F:   ; SRL A
Z80_instr_DD_09:   ; ADD IX,BC
Z80_instr_DD_19:   ; ADD IX,DE
Z80_instr_DD_22:   ; LD (nn),IX
Z80_instr_DD_29:   ; ADD IX,IX
Z80_instr_DD_2A:   ; LD IX,(nn)
Z80_instr_DD_39:   ; ADD IX,SP
Z80_instr_DD_86:   ; ADD A,(IX+d)
Z80_instr_DD_8E:   ; ADC A,(IX+d)
Z80_instr_DD_96:   ; SUB (IX+d)
Z80_instr_DD_9E:   ; SBC (IX+d)
Z80_instr_DD_BE:   ; CP (IX+d)
Z80_instr_DD_E3:   ; EX (SP),IX
Z80_instr_DD_F9:   ; LD SP,IX
Z80_instr_ED_42:   ; SBC HL,BC
Z80_instr_ED_43:   ; LD (nn),BC
Z80_instr_ED_4A:   ; ADC HL,BC
Z80_instr_ED_4B:   ; LD BC,(nn)
Z80_instr_ED_52:   ; SBC HL,DE
Z80_instr_ED_53:   ; LD (nn),DE
Z80_instr_ED_5A:   ; ADC HL,DE
Z80_instr_ED_5B:   ; LD DE,(nn)
Z80_instr_ED_62:   ; SBC HL,HL
Z80_instr_ED_67:   ; RRD
Z80_instr_ED_6A:   ; ADC HL,HL
Z80_instr_ED_6F:   ; RLD
Z80_instr_ED_72:   ; SBC HL,SP
Z80_instr_ED_73:   ; LD (nn),SP
Z80_instr_ED_7A:   ; ADC HL,SP
Z80_instr_ED_7B:   ; LD SP,(nn)
Z80_instr_ED_A0:   ; LDI
Z80_instr_ED_A1:   ; CPI
Z80_instr_ED_A2:   ; INI
Z80_instr_ED_A3:   ; OUTI
Z80_instr_ED_A8:   ; LDD
Z80_instr_ED_A9:   ; CPD
Z80_instr_ED_AA:   ; IND
Z80_instr_ED_AB:   ; OUTD
Z80_instr_ED_B0:   ; LDIR
Z80_instr_ED_B1:   ; CPIR
Z80_instr_ED_B2:   ; INIR
Z80_instr_ED_B3:   ; OTIR
Z80_instr_ED_B8:   ; LDDR
Z80_instr_ED_B9:   ; CPDR
Z80_instr_ED_BA:   ; INDR
Z80_instr_ED_BB:   ; OTDR
Z80_instr_FD_09:   ; ADD IY,BC
Z80_instr_FD_19:   ; ADD IY,DE
Z80_instr_FD_22:   ; LD (nn),IY
Z80_instr_FD_29:   ; ADD IY,IY
Z80_instr_FD_2A:   ; LD IY,(nn)
Z80_instr_FD_39:   ; ADD IY,SP
Z80_instr_FD_86:   ; ADD A,(IY+d)
Z80_instr_FD_8E:   ; ADC A,(IY+d)
Z80_instr_FD_96:   ; SUB (IY+d)
Z80_instr_FD_9E:   ; SBC (IY+d)
Z80_instr_FD_BE:   ; CP (IY+d)
Z80_instr_FD_E3:   ; EX (SP),IY
Z80_instr_FD_F9:   ; LD SP,IY
Z80_instr_xDCB_06: ; RLC (IXY+d)
Z80_instr_xDCB_0E: ; RRC (IXY+d)
Z80_instr_xDCB_16: ; RL (IXY+d)
Z80_instr_xDCB_1E: ; RR (IXY+d)
Z80_instr_xDCB_26: ; SLA (IXY+d)
Z80_instr_xDCB_2E: ; SRA (IXY+d)
Z80_instr_xDCB_3E: ; SRL (IXY+d)
Z80_illeg_CB_30:   ; SLL B
Z80_illeg_CB_31:   ; SLL C
Z80_illeg_CB_32:   ; SLL D
Z80_illeg_CB_33:   ; SLL E
Z80_illeg_CB_34:   ; SLL H
Z80_illeg_CB_35:   ; SLL L
Z80_illeg_CB_36:   ; SLL (HL)
Z80_illeg_CB_37:   ; SLL A
Z80_illeg_ED_70:   ; IN F,(C)
Z80_illeg_ED_71:   ; OUT (C),0
Z80_illeg_ED_63:   ; LD (nn),HL
Z80_illeg_ED_6B:   ; LD HL,(nn)
Z80_illeg_DD_84:   ; ADD A,IXH
Z80_illeg_DD_85:   ; ADD A,IXL
Z80_illeg_DD_8C:   ; ADC A,IXH
Z80_illeg_DD_8D:   ; ADC A,IXL
Z80_illeg_DD_94:   ; SUB A,IXH
Z80_illeg_DD_95:   ; SUB A,IXL
Z80_illeg_DD_9C:   ; SBC A,IXH
Z80_illeg_DD_9D:   ; SBC A,IXL
Z80_illeg_DD_BC:   ; CP IXH
Z80_illeg_DD_BD:   ; CP IXL
Z80_illeg_FD_84:   ; ADD A,IYH
Z80_illeg_FD_85:   ; ADD A,IYL
Z80_illeg_FD_8C:   ; ADC A,IYH
Z80_illeg_FD_8D:   ; ADC A,IYL
Z80_illeg_FD_94:   ; SUB A,IYH
Z80_illeg_FD_95:   ; SUB A,IYL
Z80_illeg_FD_9C:   ; SBC A,IYH
Z80_illeg_FD_9D:   ; SBC A,IYL
Z80_illeg_FD_BC:   ; CP IYH
Z80_illeg_FD_BD:   ; CP IYL
Z80_illeg_xDCB_00: ; RLC (IXY+d),B
Z80_illeg_xDCB_01: ; RLC (IXY+d),C
Z80_illeg_xDCB_02: ; RLC (IXY+d),D
Z80_illeg_xDCB_03: ; RLC (IXY+d),E
Z80_illeg_xDCB_04: ; RLC (IXY+d),H
Z80_illeg_xDCB_05: ; RLC (IXY+d),L
Z80_illeg_xDCB_07: ; RLC (IXY+d),A
Z80_illeg_xDCB_08: ; RRC (IXY+d),B
Z80_illeg_xDCB_09: ; RRC (IXY+d),C
Z80_illeg_xDCB_0A: ; RRC (IXY+d),D
Z80_illeg_xDCB_0B: ; RRC (IXY+d),E
Z80_illeg_xDCB_0C: ; RRC (IXY+d),H
Z80_illeg_xDCB_0D: ; RRC (IXY+d),L
Z80_illeg_xDCB_0F: ; RRC (IXY+d),A
Z80_illeg_xDCB_10: ; RL (IXY+d),B
Z80_illeg_xDCB_11: ; RL (IXY+d),C
Z80_illeg_xDCB_12: ; RL (IXY+d),D
Z80_illeg_xDCB_13: ; RL (IXY+d),E
Z80_illeg_xDCB_14: ; RL (IXY+d),H
Z80_illeg_xDCB_15: ; RL (IXY+d),L
Z80_illeg_xDCB_17: ; RL (IXY+d),A
Z80_illeg_xDCB_18: ; RR (IXY+d),B
Z80_illeg_xDCB_19: ; RR (IXY+d),C
Z80_illeg_xDCB_1A: ; RR (IXY+d),D
Z80_illeg_xDCB_1B: ; RR (IXY+d),E
Z80_illeg_xDCB_1C: ; RR (IXY+d),H
Z80_illeg_xDCB_1D: ; RR (IXY+d),L
Z80_illeg_xDCB_1F: ; RR (IXY+d),A
Z80_illeg_xDCB_20: ; SLA (IXY+d),B
Z80_illeg_xDCB_21: ; SLA (IXY+d),C
Z80_illeg_xDCB_22: ; SLA (IXY+d),D
Z80_illeg_xDCB_23: ; SLA (IXY+d),E
Z80_illeg_xDCB_24: ; SLA (IXY+d),H
Z80_illeg_xDCB_25: ; SLA (IXY+d),L
Z80_illeg_xDCB_27: ; SLA (IXY+d),A
Z80_illeg_xDCB_28: ; SRA (IXY+d),B
Z80_illeg_xDCB_29: ; SRA (IXY+d),C
Z80_illeg_xDCB_2A: ; SRA (IXY+d),D
Z80_illeg_xDCB_2B: ; SRA (IXY+d),E
Z80_illeg_xDCB_2C: ; SRA (IXY+d),H
Z80_illeg_xDCB_2D: ; SRA (IXY+d),L
Z80_illeg_xDCB_2F: ; SRA (IXY+d),A
Z80_illeg_xDCB_30: ; SLL (IXY+d),B
Z80_illeg_xDCB_31: ; SLL (IXY+d),C
Z80_illeg_xDCB_32: ; SLL (IXY+d),D
Z80_illeg_xDCB_33: ; SLL (IXY+d),E
Z80_illeg_xDCB_34: ; SLL (IXY+d),H
Z80_illeg_xDCB_35: ; SLL (IXY+d),L
Z80_illeg_xDCB_36: ; SLL (IXY+d)
Z80_illeg_xDCB_37: ; SLL (IXY+d),A
Z80_illeg_xDCB_38: ; SLR (IXY+d),B
Z80_illeg_xDCB_39: ; SLR (IXY+d),C
Z80_illeg_xDCB_3A: ; SLR (IXY+d),D
Z80_illeg_xDCB_3B: ; SLR (IXY+d),E
Z80_illeg_xDCB_3C: ; SLR (IXY+d),H
Z80_illeg_xDCB_3D: ; SLR (IXY+d),L
Z80_illeg_xDCB_3F: ; SLR (IXY+d),A
Z80_illeg_xDCB_80: ; RES 0,(IXY+d),B
Z80_illeg_xDCB_81: ; RES 0,(IXY+d),C
Z80_illeg_xDCB_82: ; RES 0,(IXY+d),D
Z80_illeg_xDCB_83: ; RES 0,(IXY+d),E
Z80_illeg_xDCB_84: ; RES 0,(IXY+d),H
Z80_illeg_xDCB_85: ; RES 0,(IXY+d),L
Z80_illeg_xDCB_87: ; RES 0,(IXY+d),A
Z80_illeg_xDCB_88: ; RES 1,(IXY+d),B
Z80_illeg_xDCB_89: ; RES 1,(IXY+d),C
Z80_illeg_xDCB_8A: ; RES 1,(IXY+d),D
Z80_illeg_xDCB_8B: ; RES 1,(IXY+d),E
Z80_illeg_xDCB_8C: ; RES 1,(IXY+d),H
Z80_illeg_xDCB_8D: ; RES 1,(IXY+d),L
Z80_illeg_xDCB_8F: ; RES 1,(IXY+d),A
Z80_illeg_xDCB_90: ; RES 2,(IXY+d),B
Z80_illeg_xDCB_91: ; RES 2,(IXY+d),C
Z80_illeg_xDCB_92: ; RES 2,(IXY+d),D
Z80_illeg_xDCB_93: ; RES 2,(IXY+d),E
Z80_illeg_xDCB_94: ; RES 2,(IXY+d),H
Z80_illeg_xDCB_95: ; RES 2,(IXY+d),L
Z80_illeg_xDCB_97: ; RES 2,(IXY+d),A
Z80_illeg_xDCB_98: ; RES 3,(IXY+d),B
Z80_illeg_xDCB_99: ; RES 3,(IXY+d),C
Z80_illeg_xDCB_9A: ; RES 3,(IXY+d),D
Z80_illeg_xDCB_9B: ; RES 3,(IXY+d),E
Z80_illeg_xDCB_9C: ; RES 3,(IXY+d),H
Z80_illeg_xDCB_9D: ; RES 3,(IXY+d),L
Z80_illeg_xDCB_9F: ; RES 3,(IXY+d),A
Z80_illeg_xDCB_A0: ; RES 4,(IXY+d),B
Z80_illeg_xDCB_A1: ; RES 4,(IXY+d),C
Z80_illeg_xDCB_A2: ; RES 4,(IXY+d),D
Z80_illeg_xDCB_A3: ; RES 4,(IXY+d),E
Z80_illeg_xDCB_A4: ; RES 4,(IXY+d),H
Z80_illeg_xDCB_A5: ; RES 4,(IXY+d),L
Z80_illeg_xDCB_A7: ; RES 4,(IXY+d),A
Z80_illeg_xDCB_A8: ; RES 5,(IXY+d),B
Z80_illeg_xDCB_A9: ; RES 5,(IXY+d),C
Z80_illeg_xDCB_AA: ; RES 5,(IXY+d),D
Z80_illeg_xDCB_AB: ; RES 5,(IXY+d),E
Z80_illeg_xDCB_AC: ; RES 5,(IXY+d),H
Z80_illeg_xDCB_AD: ; RES 5,(IXY+d),L
Z80_illeg_xDCB_AF: ; RES 5,(IXY+d),A
Z80_illeg_xDCB_B0: ; RES 6,(IXY+d),B
Z80_illeg_xDCB_B1: ; RES 6,(IXY+d),C
Z80_illeg_xDCB_B2: ; RES 6,(IXY+d),D
Z80_illeg_xDCB_B3: ; RES 6,(IXY+d),E
Z80_illeg_xDCB_B4: ; RES 6,(IXY+d),H
Z80_illeg_xDCB_B5: ; RES 6,(IXY+d),L
Z80_illeg_xDCB_B7: ; RES 6,(IXY+d),A
Z80_illeg_xDCB_B8: ; RES 7,(IXY+d),B
Z80_illeg_xDCB_B9: ; RES 7,(IXY+d),C
Z80_illeg_xDCB_BA: ; RES 7,(IXY+d),D
Z80_illeg_xDCB_BB: ; RES 7,(IXY+d),E
Z80_illeg_xDCB_BC: ; RES 7,(IXY+d),H
Z80_illeg_xDCB_BD: ; RES 7,(IXY+d),L
Z80_illeg_xDCB_BF: ; RES 7,(IXY+d),A
Z80_illeg_xDCB_C0: ; SET 0,(IXY+d),B
Z80_illeg_xDCB_C1: ; SET 0,(IXY+d),C
Z80_illeg_xDCB_C2: ; SET 0,(IXY+d),D
Z80_illeg_xDCB_C3: ; SET 0,(IXY+d),E
Z80_illeg_xDCB_C4: ; SET 0,(IXY+d),H
Z80_illeg_xDCB_C5: ; SET 0,(IXY+d),L
Z80_illeg_xDCB_C7: ; SET 0,(IXY+d),A
Z80_illeg_xDCB_C8: ; SET 1,(IXY+d),B
Z80_illeg_xDCB_C9: ; SET 1,(IXY+d),C
Z80_illeg_xDCB_CA: ; SET 1,(IXY+d),D
Z80_illeg_xDCB_CB: ; SET 1,(IXY+d),E
Z80_illeg_xDCB_CC: ; SET 1,(IXY+d),H
Z80_illeg_xDCB_CD: ; SET 1,(IXY+d),L
Z80_illeg_xDCB_CF: ; SET 1,(IXY+d),A
Z80_illeg_xDCB_D0: ; SET 2,(IXY+d),B
Z80_illeg_xDCB_D1: ; SET 2,(IXY+d),C
Z80_illeg_xDCB_D2: ; SET 2,(IXY+d),D
Z80_illeg_xDCB_D3: ; SET 2,(IXY+d),E
Z80_illeg_xDCB_D4: ; SET 2,(IXY+d),H
Z80_illeg_xDCB_D5: ; SET 2,(IXY+d),L
Z80_illeg_xDCB_D7: ; SET 2,(IXY+d),A
Z80_illeg_xDCB_D8: ; SET 3,(IXY+d),B
Z80_illeg_xDCB_D9: ; SET 3,(IXY+d),C
Z80_illeg_xDCB_DA: ; SET 3,(IXY+d),D
Z80_illeg_xDCB_DB: ; SET 3,(IXY+d),E
Z80_illeg_xDCB_DC: ; SET 3,(IXY+d),H
Z80_illeg_xDCB_DD: ; SET 3,(IXY+d),L
Z80_illeg_xDCB_DF: ; SET 3,(IXY+d),A
Z80_illeg_xDCB_E0: ; SET 4,(IXY+d),B
Z80_illeg_xDCB_E1: ; SET 4,(IXY+d),C
Z80_illeg_xDCB_E2: ; SET 4,(IXY+d),D
Z80_illeg_xDCB_E3: ; SET 4,(IXY+d),E
Z80_illeg_xDCB_E4: ; SET 4,(IXY+d),H
Z80_illeg_xDCB_E5: ; SET 4,(IXY+d),L
Z80_illeg_xDCB_E7: ; SET 4,(IXY+d),A
Z80_illeg_xDCB_E8: ; SET 5,(IXY+d),B
Z80_illeg_xDCB_E9: ; SET 5,(IXY+d),C
Z80_illeg_xDCB_EA: ; SET 5,(IXY+d),D
Z80_illeg_xDCB_EB: ; SET 5,(IXY+d),E
Z80_illeg_xDCB_EC: ; SET 5,(IXY+d),H
Z80_illeg_xDCB_ED: ; SET 5,(IXY+d),L
Z80_illeg_xDCB_EF: ; SET 5,(IXY+d),A
Z80_illeg_xDCB_F0: ; SET 6,(IXY+d),B
Z80_illeg_xDCB_F1: ; SET 6,(IXY+d),C
Z80_illeg_xDCB_F2: ; SET 6,(IXY+d),D
Z80_illeg_xDCB_F3: ; SET 6,(IXY+d),E
Z80_illeg_xDCB_F4: ; SET 6,(IXY+d),H
Z80_illeg_xDCB_F5: ; SET 6,(IXY+d),L
Z80_illeg_xDCB_F7: ; SET 6,(IXY+d),A
Z80_illeg_xDCB_F8: ; SET 7,(IXY+d),B
Z80_illeg_xDCB_F9: ; SET 7,(IXY+d),C
Z80_illeg_xDCB_FA: ; SET 7,(IXY+d),D
Z80_illeg_xDCB_FB: ; SET 7,(IXY+d),E
Z80_illeg_xDCB_FC: ; SET 7,(IXY+d),H
Z80_illeg_xDCB_FD: ; SET 7,(IXY+d),L
Z80_illeg_xDCB_FF: ; SET 7,(IXY+d),A

	jmp ZVM_next ; XXX provide implementation

