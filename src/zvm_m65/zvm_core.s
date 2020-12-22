
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

	; unimplemented/illegal instructions
Z80_illegal__DD:
Z80_illegal__ED:
Z80_illegal__FD:
Z80_illegal__xDCB:
	; XXX add a separate handler for illegal instructions
	; LD instructions with no effect
Z80_instr_40:                                                                  ; LD B,B
Z80_instr_49:                                                                  ; LD C,C
Z80_instr_52:                                                                  ; LD D,D
Z80_instr_5B:                                                                  ; LD E,E
Z80_instr_64:                                                                  ; LD H,H
Z80_instr_6D:                                                                  ; LD L,L
Z80_instr_7F:                                                                  ; LD A,A
	; For interrupts (not emulated as of yet)
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
Z80_instr_02:      ; LD (BC),A
Z80_instr_09:      ; ADD HL,BC
Z80_instr_0A:      ; LD A,(BC)
Z80_instr_12:      ; LD (DE),A
Z80_instr_19:      ; ADD HL,DE
Z80_instr_1A:      ; LD A,(DE)
Z80_instr_22:      ; LD (nn),HL
Z80_instr_29:      ; ADD HL,HL
Z80_instr_2A:      ; LD HL,(nn)
Z80_instr_32:      ; LD (nn),A
Z80_instr_39:      ; ADD HL,SP
Z80_instr_3A:      ; LD A,(nn)
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
Z80_instr_C0:      ; RET NZ
Z80_instr_C4:      ; CALL NZ,nn
Z80_instr_C6:      ; ADD A,n
Z80_instr_C7:      ; RST 00H
Z80_instr_C8:      ; RET z
Z80_instr_C9:      ; RET
Z80_instr_CC:      ; CALL Z,nn
Z80_instr_CD:      ; CALL nn
Z80_instr_CE:      ; ADC A,n
Z80_instr_CF:      ; RST 08H
Z80_instr_D0:      ; RET NC
Z80_instr_D4:      ; CALL NC,nn
Z80_instr_D6:      ; SUB n
Z80_instr_D7:      ; RST 10H
Z80_instr_D8:      ; RET C
Z80_instr_DC:      ; CALL C,nn
Z80_instr_DE:      ; SBC A,n
Z80_instr_DF:      ; RST 18H
Z80_instr_E0:      ; RET PO
Z80_instr_E3:      ; EX (SP),HL
Z80_instr_E4:      ; CALL PO,nn
Z80_instr_E7:      ; RST 20H
Z80_instr_E8:      ; RET PE
Z80_instr_EC:      ; CALL PE,nn
Z80_instr_EF:      ; RST 28H
Z80_instr_F0:      ; RET P
Z80_instr_F4:      ; CALL P,nn
Z80_instr_F7:      ; RST 30H
Z80_instr_F8:      ; RET M
Z80_instr_F9:      ; LD SP,HL
Z80_instr_FC:      ; CALL M,nn
Z80_instr_FE:      ; CP n
Z80_instr_FF:      ; RST 38H
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
Z80_instr_DD_46:   ; LD B,(IX+d)
Z80_instr_DD_4E:   ; LD C,(IX+d)
Z80_instr_DD_56:   ; LD D,(IX+d)
Z80_instr_DD_5E:   ; LD E,(IX+d)
Z80_instr_DD_66:   ; LD H,(IX+d)
Z80_instr_DD_6E:   ; LD L,(IX+d)
Z80_instr_DD_70:   ; LD (IX+d),B
Z80_instr_DD_71:   ; LD (IX+d),C
Z80_instr_DD_72:   ; LD (IX+d),D
Z80_instr_DD_73:   ; LD (IX+d),E
Z80_instr_DD_74:   ; LD (IX+d),H
Z80_instr_DD_75:   ; LD (IX+d),L
Z80_instr_DD_77:   ; LD (IX+d),A
Z80_instr_DD_7E:   ; LD A,(IX+d)
Z80_instr_DD_86:   ; ADD A,(IX+d)
Z80_instr_DD_8E:   ; ADC A,(IX+d)
Z80_instr_DD_96:   ; SUB (IX+d)
Z80_instr_DD_9E:   ; SBC (IX+d)
Z80_instr_DD_BE:   ; CP (IX+d)
Z80_instr_DD_E3:   ; EX (SP),IX
Z80_instr_DD_F9:   ; LD SP,IX
Z80_instr_ED_42:   ; SBC HL,BC
Z80_instr_ED_43:   ; LD (nn),BC
Z80_instr_ED_44:   ; NEG
Z80_instr_ED_45:   ; RETN
Z80_instr_ED_4A:   ; ADC HL,BC
Z80_instr_ED_4B:   ; LD BC,(nn)
Z80_instr_ED_4D:   ; RETTI
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
Z80_instr_FD_46:   ; LD B,(IY+d)
Z80_instr_FD_4E:   ; LD C,(IY+d)
Z80_instr_FD_56:   ; LD D,(IY+d)
Z80_instr_FD_5E:   ; LD E,(IY+d)
Z80_instr_FD_66:   ; LD H,(IY+d)
Z80_instr_FD_6E:   ; LD L,(IY+d)
Z80_instr_FD_70:   ; LD (IY+d),B
Z80_instr_FD_71:   ; LD (IY+d),C
Z80_instr_FD_72:   ; LD (IY+d),D
Z80_instr_FD_73:   ; LD (IY+d),E
Z80_instr_FD_74:   ; LD (IY+d),H
Z80_instr_FD_75:   ; LD (IY+d),L
Z80_instr_FD_77:   ; LD (IY+d),A
Z80_instr_FD_7E:   ; LD A,(IY+d)
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
Z80_illeg_ED_4C:   ; NEG
Z80_illeg_ED_54:   ; NEG
Z80_illeg_ED_55:   ; RETN
Z80_illeg_ED_5C:   ; NEG
Z80_illeg_ED_5D:   ; RETN
Z80_illeg_ED_64:   ; NEG
Z80_illeg_ED_65:   ; RETN
Z80_illeg_ED_6C:   ; NEG
Z80_illeg_ED_6D:   ; RETN
Z80_illeg_ED_70:   ; IN F,(C)
Z80_illeg_ED_71:   ; OUT (C),0
Z80_illeg_ED_74:   ; NEG
Z80_illeg_ED_75:   ; RETN
Z80_illeg_ED_7C:   ; NEG
Z80_illeg_ED_7D:   ; RETN
Z80_illeg_xDCB_C0: ; SET 0,(IXY+d),B
Z80_illeg_xDCB_C1: ; SET 0,(IXY+d),C
Z80_illeg_xDCB_C2: ; SET 0,(IXY+d),D
Z80_illeg_xDCB_C3: ; SET 0,(IXY+d),E
Z80_illeg_xDCB_C4: ; SET 0,(IXY+d),H
Z80_illeg_xDCB_C5: ; SET 0,(IXY+d),L
Z80_illeg_xDCB_C7: ; SET 0,(IXY+d),A


	jmp ZVM_next ; XXX

	; XXX add illegal instructions for combination of prefixes

	; XXX include these in the table, add mnemonics

Z80_illeg_ED_63:
Z80_illeg_ED_6B:
Z80_illeg_DD_24:
Z80_illeg_DD_25:
Z80_illeg_DD_26:
Z80_illeg_DD_2C:
Z80_illeg_DD_2D:
Z80_illeg_DD_2E:
Z80_illeg_DD_44:
Z80_illeg_DD_45:
Z80_illeg_DD_4C:
Z80_illeg_DD_4D:
Z80_illeg_DD_54:
Z80_illeg_DD_55:
Z80_illeg_DD_5C:
Z80_illeg_DD_5D:
Z80_illeg_DD_60:
Z80_illeg_DD_61:
Z80_illeg_DD_62:
Z80_illeg_DD_63:
Z80_illeg_DD_64:
Z80_illeg_DD_65:
Z80_illeg_DD_67:
Z80_illeg_DD_68:
Z80_illeg_DD_69:
Z80_illeg_DD_6A:
Z80_illeg_DD_6B:
Z80_illeg_DD_6C:
Z80_illeg_DD_6D:
Z80_illeg_DD_6F:
Z80_illeg_DD_7C:
Z80_illeg_DD_6D:
Z80_illeg_DD_84:
Z80_illeg_DD_85:
Z80_illeg_DD_8C:
Z80_illeg_DD_8D:
Z80_illeg_DD_94:
Z80_illeg_DD_95:
Z80_illeg_DD_9C:
Z80_illeg_DD_9D:
Z80_illeg_DD_A4:
Z80_illeg_DD_A5:
Z80_illeg_DD_AC:
Z80_illeg_DD_AD:
Z80_illeg_DD_B4:
Z80_illeg_DD_B5:
Z80_illeg_DD_BC:
Z80_illeg_DD_BD:
Z80_illeg_FD_24:
Z80_illeg_FD_25:
Z80_illeg_FD_26:
Z80_illeg_FD_2C:
Z80_illeg_FD_2D:
Z80_illeg_FD_2E:
Z80_illeg_FD_44:
Z80_illeg_FD_45:
Z80_illeg_FD_4C:
Z80_illeg_FD_4D:
Z80_illeg_FD_54:
Z80_illeg_FD_55:
Z80_illeg_FD_5C:
Z80_illeg_FD_5D:
Z80_illeg_FD_60:
Z80_illeg_FD_61:
Z80_illeg_FD_62:
Z80_illeg_FD_63:
Z80_illeg_FD_64:
Z80_illeg_FD_65:
Z80_illeg_FD_67:
Z80_illeg_FD_68:
Z80_illeg_FD_69:
Z80_illeg_FD_6A:
Z80_illeg_FD_6B:
Z80_illeg_FD_6C:
Z80_illeg_FD_6D:
Z80_illeg_FD_6F:
Z80_illeg_FD_7C:
Z80_illeg_FD_6D:
Z80_illeg_FD_84:
Z80_illeg_FD_85:
Z80_illeg_FD_8C:
Z80_illeg_FD_8D:
Z80_illeg_FD_94:
Z80_illeg_FD_95:
Z80_illeg_FD_9C:
Z80_illeg_FD_9D:
Z80_illeg_FD_A4:
Z80_illeg_FD_A5:
Z80_illeg_FD_AC:
Z80_illeg_FD_AD:
Z80_illeg_FD_B4:
Z80_illeg_FD_B5:
Z80_illeg_FD_BC:
Z80_illeg_FD_BD:
Z80_illeg_xDCB_00:
Z80_illeg_xDCB_01:
Z80_illeg_xDCB_02:
Z80_illeg_xDCB_03:
Z80_illeg_xDCB_04:
Z80_illeg_xDCB_05:
Z80_illeg_xDCB_07:
Z80_illeg_xDCB_08:
Z80_illeg_xDCB_09:
Z80_illeg_xDCB_0A:
Z80_illeg_xDCB_0B:
Z80_illeg_xDCB_0C:
Z80_illeg_xDCB_0D:
Z80_illeg_xDCB_0F:
Z80_illeg_xDCB_10:
Z80_illeg_xDCB_11:
Z80_illeg_xDCB_12:
Z80_illeg_xDCB_13:
Z80_illeg_xDCB_14:
Z80_illeg_xDCB_15:
Z80_illeg_xDCB_17:
Z80_illeg_xDCB_18:
Z80_illeg_xDCB_19:
Z80_illeg_xDCB_1A:
Z80_illeg_xDCB_1B:
Z80_illeg_xDCB_1C:
Z80_illeg_xDCB_1D:
Z80_illeg_xDCB_1F:
Z80_illeg_xDCB_20:
Z80_illeg_xDCB_21:
Z80_illeg_xDCB_22:
Z80_illeg_xDCB_23:
Z80_illeg_xDCB_24:
Z80_illeg_xDCB_25:
Z80_illeg_xDCB_27:
Z80_illeg_xDCB_28:
Z80_illeg_xDCB_29:
Z80_illeg_xDCB_2A:
Z80_illeg_xDCB_2B:
Z80_illeg_xDCB_2C:
Z80_illeg_xDCB_2D:
Z80_illeg_xDCB_2F:
Z80_illeg_xDCB_30:
Z80_illeg_xDCB_31:
Z80_illeg_xDCB_32:
Z80_illeg_xDCB_33:
Z80_illeg_xDCB_34:
Z80_illeg_xDCB_35:
Z80_illeg_xDCB_36:
Z80_illeg_xDCB_37:
Z80_illeg_xDCB_38:
Z80_illeg_xDCB_39:
Z80_illeg_xDCB_3A:
Z80_illeg_xDCB_3B:
Z80_illeg_xDCB_3C:
Z80_illeg_xDCB_3D:
Z80_illeg_xDCB_3F:
Z80_illeg_xDCB_40:
Z80_illeg_xDCB_41:
Z80_illeg_xDCB_42:
Z80_illeg_xDCB_43:
Z80_illeg_xDCB_44:
Z80_illeg_xDCB_45:
Z80_illeg_xDCB_47:
Z80_illeg_xDCB_48:
Z80_illeg_xDCB_49:
Z80_illeg_xDCB_4A:
Z80_illeg_xDCB_4B:
Z80_illeg_xDCB_4C:
Z80_illeg_xDCB_4D:
Z80_illeg_xDCB_4F:
Z80_illeg_xDCB_50:
Z80_illeg_xDCB_51:
Z80_illeg_xDCB_52:
Z80_illeg_xDCB_53:
Z80_illeg_xDCB_54:
Z80_illeg_xDCB_55:
Z80_illeg_xDCB_57:
Z80_illeg_xDCB_58:
Z80_illeg_xDCB_59:
Z80_illeg_xDCB_5A:
Z80_illeg_xDCB_5B:
Z80_illeg_xDCB_5C:
Z80_illeg_xDCB_5D:
Z80_illeg_xDCB_5F:
Z80_illeg_xDCB_60:
Z80_illeg_xDCB_61:
Z80_illeg_xDCB_62:
Z80_illeg_xDCB_63:
Z80_illeg_xDCB_64:
Z80_illeg_xDCB_65:
Z80_illeg_xDCB_67:
Z80_illeg_xDCB_68:
Z80_illeg_xDCB_69:
Z80_illeg_xDCB_6A:
Z80_illeg_xDCB_6B:
Z80_illeg_xDCB_6C:
Z80_illeg_xDCB_6D:
Z80_illeg_xDCB_6F:
Z80_illeg_xDCB_70:
Z80_illeg_xDCB_71:
Z80_illeg_xDCB_72:
Z80_illeg_xDCB_73:
Z80_illeg_xDCB_74:
Z80_illeg_xDCB_75:
Z80_illeg_xDCB_77:
Z80_illeg_xDCB_80:
Z80_illeg_xDCB_81:
Z80_illeg_xDCB_82:
Z80_illeg_xDCB_83:
Z80_illeg_xDCB_84:
Z80_illeg_xDCB_85:
Z80_illeg_xDCB_87:
Z80_illeg_xDCB_88:
Z80_illeg_xDCB_89:
Z80_illeg_xDCB_8A:
Z80_illeg_xDCB_8B:
Z80_illeg_xDCB_8C:
Z80_illeg_xDCB_8D:
Z80_illeg_xDCB_8F:
Z80_illeg_xDCB_90:
Z80_illeg_xDCB_91:
Z80_illeg_xDCB_92:
Z80_illeg_xDCB_93:
Z80_illeg_xDCB_94:
Z80_illeg_xDCB_95:
Z80_illeg_xDCB_97:
Z80_illeg_xDCB_98:
Z80_illeg_xDCB_99:
Z80_illeg_xDCB_9A:
Z80_illeg_xDCB_9B:
Z80_illeg_xDCB_9C:
Z80_illeg_xDCB_9D:
Z80_illeg_xDCB_9F:
Z80_illeg_xDCB_A0:
Z80_illeg_xDCB_A1:
Z80_illeg_xDCB_A2:
Z80_illeg_xDCB_A3:
Z80_illeg_xDCB_A4:
Z80_illeg_xDCB_A5:
Z80_illeg_xDCB_A7:
Z80_illeg_xDCB_A8:
Z80_illeg_xDCB_A9:
Z80_illeg_xDCB_AA:
Z80_illeg_xDCB_AB:
Z80_illeg_xDCB_AC:
Z80_illeg_xDCB_AD:
Z80_illeg_xDCB_AF:
Z80_illeg_xDCB_B0:
Z80_illeg_xDCB_B1:
Z80_illeg_xDCB_B2:
Z80_illeg_xDCB_B3:
Z80_illeg_xDCB_B4:
Z80_illeg_xDCB_B5:
Z80_illeg_xDCB_B7:
Z80_illeg_xDCB_B8:
Z80_illeg_xDCB_B9:
Z80_illeg_xDCB_BA:
Z80_illeg_xDCB_BB:
Z80_illeg_xDCB_BC:
Z80_illeg_xDCB_BD:
Z80_illeg_xDCB_BF:
Z80_illeg_xDCB_C8:
Z80_illeg_xDCB_C9:
Z80_illeg_xDCB_CA:
Z80_illeg_xDCB_CB:
Z80_illeg_xDCB_CC:
Z80_illeg_xDCB_CD:
Z80_illeg_xDCB_CF:
Z80_illeg_xDCB_D0:
Z80_illeg_xDCB_D1:
Z80_illeg_xDCB_D2:
Z80_illeg_xDCB_D3:
Z80_illeg_xDCB_D4:
Z80_illeg_xDCB_D5:
Z80_illeg_xDCB_D7:
Z80_illeg_xDCB_D8:
Z80_illeg_xDCB_D9:
Z80_illeg_xDCB_DA:
Z80_illeg_xDCB_DB:
Z80_illeg_xDCB_DC:
Z80_illeg_xDCB_DD:
Z80_illeg_xDCB_DF:
Z80_illeg_xDCB_E0:
Z80_illeg_xDCB_E1:
Z80_illeg_xDCB_E2:
Z80_illeg_xDCB_E3:
Z80_illeg_xDCB_E4:
Z80_illeg_xDCB_E5:
Z80_illeg_xDCB_E7:
Z80_illeg_xDCB_E8:
Z80_illeg_xDCB_E9:
Z80_illeg_xDCB_EA:
Z80_illeg_xDCB_EB:
Z80_illeg_xDCB_EC:
Z80_illeg_xDCB_ED:
Z80_illeg_xDCB_EF:
Z80_illeg_xDCB_F0:
Z80_illeg_xDCB_F1:
Z80_illeg_xDCB_F2:
Z80_illeg_xDCB_F3:
Z80_illeg_xDCB_F4:
Z80_illeg_xDCB_F5:
Z80_illeg_xDCB_F7:
Z80_illeg_xDCB_F8:
Z80_illeg_xDCB_F9:
Z80_illeg_xDCB_FA:
Z80_illeg_xDCB_FB:
Z80_illeg_xDCB_FC:
Z80_illeg_xDCB_FD:
Z80_illeg_xDCB_FF:
