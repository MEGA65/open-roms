
;
; Z80 Virtual Machine core routines
;

!addr REG_A            = $02    ; 8-bit accumulator
!addr REG_F            = $03    ; 8-bit flag register
!addr REG_B            = $04    ; general purpose 8-bit registers
!addr REG_C            = $05
!addr REG_D            = $06
!addr REG_E            = $07
!addr REG_H            = $08
!addr REG_L            = $09

!addr REG_A_SH         = $0A    ; shadow registers
!addr REG_F_SH         = $0B
!addr REG_B_SH         = $0C
!addr REG_C_SH         = $0D
!addr REG_D_SH         = $0E
!addr REG_E_SH         = $0F
!addr REG_H_SH         = $10
!addr REG_L_SH         = $11

!addr REG_IX           = $12    ; 16-bit index register
!addr REG_IY           = $14    ; 16-bit index register
!addr REG_SP           = $16    ; 16-bit stack pointer
!addr REG_PC           = $18    ; 16-bit program counter

!addr REG_I            = $1A    ; 8-bit interrupt vector base
!addr REG_R06          = $1B    ; refresh counter, bits 0-6 (bit 7 is garbage)
!addr REG_R7           = $1C    ; refresh counter, bit 7 (bits 0-6 are 0's)

!addr VEC_fetch_opcode = $1D
!addr VEC_fetch_via_HL = $1F
!addr VEC_store_via_HL = $21


ZVM_entry:

	jsr ZVM_init
	; XXX fetch BDOS and Command Processor 
	jmp ZVM_run

ZVM_init:

	; Reset all the registers
	
	lda #$00
	tay
@1:
	sta REG_A, y
	iny
	cmp #(REG_R7+1)
	bne @1
	
	; XXX what is the initial SP value?
	; XXX clean memory

	; FALLTROUGH
	
ZVM_bank_0:

	lda #<ZVM_fetch_instr_bank_0
	sta VEC_fetch_opcode+0
	lda #>ZVM_fetch_instr_bank_0
	sta VEC_fetch_opcode+1
	
	rts

ZVM_bank_1:

	lda #<ZVM_fetch_instr_bank_1
	sta VEC_fetch_opcode+0
	lda #>ZVM_fetch_instr_bank_1
	sta VEC_fetch_opcode+1
	
	rts

ZVM_fetch_opcode_bank_0:

	; XXX implement, should return byte in .A

ZVM_fetch_opcode_bank_1:

	; XXX implement, should return byte in .A

ZVM_run:

	; CPU main loop
	
	jsr (VEC_fetch_instr)
	asl
	bcs @1
	
	; Execute mnemonic $00-$7F

	; XXX
@1:
	; Execute mnemonic $80-$FF

	; XXX















;
; Not implemented yet - XXX implement them!
;

Z80_instr_01:      ; LD BC,nn
Z80_instr_02:      ; LD (BC),A
Z80_instr_03:      ; INC BC
Z80_instr_04:      ; INC B
Z80_instr_05:      ; DEC B
Z80_instr_06:      ; LD B,n
Z80_instr_07:      ; RLCA
Z80_instr_08:      ; EX AF,AF''
Z80_instr_09:      ; ADD HL,BC
Z80_instr_0A:      ; LD A,(BC)	
Z80_instr_0B:      ; DEC BC
Z80_instr_0C:      ; INC C
Z80_instr_0D:      ; DEC C
Z80_instr_0E:      ; LD C,n
Z80_instr_0F:      ; RRCA
Z80_instr_10:      ; DJNZ e
Z80_instr_11:      ; LD DE,nn
Z80_instr_12:      ; LD (DE),A
Z80_instr_13:      ; INC DE
Z80_instr_14:      ; INC D
Z80_instr_15:      ; DEC D
Z80_instr_16:      ; LD D,n
Z80_instr_17:      ; RLA
Z80_instr_18:      ; JR e
Z80_instr_19:      ; ADD HL,DE
Z80_instr_1A:      ; LD A,(DE)	
Z80_instr_1B:      ; DEC DE
Z80_instr_1C:      ; INC E
Z80_instr_1D:      ; DEC E
Z80_instr_1E:      ; LD E,n
Z80_instr_1F:      ; RRA
Z80_instr_20:      ; JR NZ,e
Z80_instr_21:      ; LD HL,nn
Z80_instr_22:      ; LD (nn),HL
Z80_instr_23:      ; INC HL
Z80_instr_24:      ; INC H
Z80_instr_25:      ; DEC H
Z80_instr_26:      ; LD H,n
Z80_instr_27:      ; DAA
Z80_instr_28:      ; JR Z,e
Z80_instr_29:      ; ADD HL,HL
Z80_instr_2A:      ; LD HL,(nn)
Z80_instr_2B:      ; DEC HL
Z80_instr_2C:      ; INC L
Z80_instr_2D:      ; DEC L
Z80_instr_2E:      ; LD L,n
Z80_instr_2F:      ; CPL
Z80_instr_30:      ; JR NC,e
Z80_instr_31:      ; LD SP,nn
Z80_instr_32:      ; LD (nn),A
Z80_instr_33:      ; INC SP
Z80_instr_34:      ; INC (HL)
Z80_instr_35:      ; DEC (HL)
Z80_instr_36:      ; LD (HL),n
Z80_instr_37:      ; SCF
Z80_instr_38:      ; JR C,e
Z80_instr_39:      ; ADD HL,SP
Z80_instr_3A:      ; LD A,(nn)
Z80_instr_3B:      ; DEC SP
Z80_instr_3C:      ; INC A
Z80_instr_3D:      ; DEC A
Z80_instr_3E:      ; LD A,n
Z80_instr_3F:      ; CCF
Z80_instr_76:      ; HALT
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
Z80_instr_A0:      ; AND B
Z80_instr_A1:      ; AND C
Z80_instr_A2:      ; AND D
Z80_instr_A3:      ; AND E
Z80_instr_A4:      ; AND H
Z80_instr_A5:      ; AND L
Z80_instr_A6:      ; AND (HL)
Z80_instr_A7:      ; AND A
Z80_instr_A8:      ; XOR B
Z80_instr_A9:      ; XOR C
Z80_instr_AA:      ; XOR D
Z80_instr_AB:      ; XOR E
Z80_instr_AC:      ; XOR H
Z80_instr_AD:      ; XOR L
Z80_instr_AE:      ; XOR (HL)
Z80_instr_AF:      ; XOR A
Z80_instr_B0:      ; OR B
Z80_instr_B1:      ; OR C
Z80_instr_B2:      ; OR D
Z80_instr_B3:      ; OR E
Z80_instr_B4:      ; OR H
Z80_instr_B5:      ; OR L
Z80_instr_B6:      ; OR (HL)
Z80_instr_B7:      ; OR A
Z80_instr_B8:      ; CP B
Z80_instr_B9:      ; CP C
Z80_instr_BA:      ; CP D
Z80_instr_BB:      ; CP E
Z80_instr_BC:      ; CP H
Z80_instr_BD:      ; CP L
Z80_instr_BE:      ; CP (HL)
Z80_instr_BF:      ; CP A
Z80_instr_C0:      ; RET NZ
Z80_instr_C1:      ; POP BC
Z80_instr_C2:      ; JP NZ,nn
Z80_instr_C3:      ; JP nn
Z80_instr_C4:      ; CALL NZ,nn
Z80_instr_C5:      ; PUSH BC
Z80_instr_C6:      ; ADD A,n
Z80_instr_C7:      ; RST 00H
Z80_instr_C8:      ; RET z
Z80_instr_C9:      ; RET
Z80_instr_CA:      ; JP Z,nn
Z80_instr_CB:      ; #CB
Z80_instr_CC:      ; CALL Z,nn
Z80_instr_CD:      ; CALL nn
Z80_instr_CE:      ;  ADC A,n
Z80_instr_CF:      ; RST 08H
Z80_instr_D0:      ; RET NC
Z80_instr_D1:      ; POP DE
Z80_instr_D2:      ; JP NC,nn
Z80_instr_D3:      ; OUT (n), A
Z80_instr_D4:      ; CALL NC,nn
Z80_instr_D5:      ; PUSH DE
Z80_instr_D6:      ; SUB n
Z80_instr_D7:      ; RST 10H
Z80_instr_D8:      ; RET C
Z80_instr_D9:      ; EXX
Z80_instr_DA:      ; JP C,nn
Z80_instr_DB:      ; IN A,(n)
Z80_instr_DC:      ; CALL C,nn
Z80_instr_DD:      ; #DD
Z80_instr_DE:      ; SBC A,n
Z80_instr_DF:      ; RST 18H
Z80_instr_E0:      ; RET PO
Z80_instr_E1:      ; POP HL
Z80_instr_E2:      ; JP PO,nn
Z80_instr_E3:      ; EX (SP),HL
Z80_instr_E4:      ; CALL PO,nn
Z80_instr_E5:      ; PUSH HL
Z80_instr_E6:      ; AND n
Z80_instr_E7:      ; RST 20H
Z80_instr_E8:      ; RET PE
Z80_instr_E9:      ; JP (HL)
Z80_instr_EA:      ; JP PE,nn
Z80_instr_EB:      ; EX DE,HL
Z80_instr_EC:      ; CALL PE,nn
Z80_instr_ED:      ; #ED
Z80_instr_EE:      ; XOR n
Z80_instr_EF:      ; RST 28H
Z80_instr_F0:      ; RET P
Z80_instr_F1:      ; POP AF
Z80_instr_F2:      ; JP P,nn
Z80_instr_F3:      ; DI
Z80_instr_F4:      ; CALL P,nn
Z80_instr_F5:      ; PUSH AF
Z80_instr_F6:      ; OR n
Z80_instr_F7:      ; RST 30H
Z80_instr_F8:      ; RET M
Z80_instr_F9:      ; LD SP,HL
Z80_instr_FA:      ; JP M,nn
Z80_instr_FB:      ; EI
Z80_instr_FC:      ; CALL M,nn
Z80_instr_FD:      ; #FD
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
Z80_instr_CB_40:   ; BIT 0,B
Z80_instr_CB_41:   ; BIT 0,C
Z80_instr_CB_42:   ; BIT 0,D
Z80_instr_CB_43:   ; BIT 0,E
Z80_instr_CB_44:   ; BIT 0,H
Z80_instr_CB_45:   ; BIT 0,L
Z80_instr_CB_46:   ; BIT 0,(HL)
Z80_instr_CB_47:   ; BIT 0,A
Z80_instr_CB_48:   ; BIT 1,B
Z80_instr_CB_49:   ; BIT 1,C
Z80_instr_CB_4A:   ; BIT 1,D
Z80_instr_CB_4B:   ; BIT 1,E
Z80_instr_CB_4C:   ; BIT 1,H
Z80_instr_CB_4D:   ; BIT 1,L
Z80_instr_CB_4E:   ; BIT 1,(HL)
Z80_instr_CB_4F:   ; BIT 1,A
Z80_instr_CB_50:   ; BIT 2,B
Z80_instr_CB_51:   ; BIT 2,C
Z80_instr_CB_52:   ; BIT 2,D
Z80_instr_CB_53:   ; BIT 2,E
Z80_instr_CB_54:   ; BIT 2,H
Z80_instr_CB_55:   ; BIT 2,L
Z80_instr_CB_56:   ; BIT 2,(HL)
Z80_instr_CB_57:   ; BIT 2,A
Z80_instr_CB_58:   ; BIT 3,B
Z80_instr_CB_59:   ; BIT 3,C
Z80_instr_CB_5A:   ; BIT 3,D
Z80_instr_CB_5B:   ; BIT 3,E
Z80_instr_CB_5C:   ; BIT 3,H
Z80_instr_CB_5D:   ; BIT 3,L
Z80_instr_CB_5E:   ; BIT 3,(HL)
Z80_instr_CB_5F:   ; BIT 3,A
Z80_instr_CB_60:   ; BIT 4,B
Z80_instr_CB_61:   ; BIT 4,C
Z80_instr_CB_62:   ; BIT 4,D
Z80_instr_CB_63:   ; BIT 4,E
Z80_instr_CB_64:   ; BIT 4,H
Z80_instr_CB_65:   ; BIT 4,L
Z80_instr_CB_66:   ; BIT 4,(HL)
Z80_instr_CB_67:   ; BIT 4,A
Z80_instr_CB_68:   ; BIT 5,B
Z80_instr_CB_69:   ; BIT 5,C
Z80_instr_CB_6A:   ; BIT 5,D
Z80_instr_CB_6B:   ; BIT 5,E
Z80_instr_CB_6C:   ; BIT 5,H
Z80_instr_CB_6D:   ; BIT 5,L
Z80_instr_CB_6E:   ; BIT 5,(HL)
Z80_instr_CB_6F:   ; BIT 5,A
Z80_instr_CB_70:   ; BIT 6,B
Z80_instr_CB_71:   ; BIT 6,C
Z80_instr_CB_72:   ; BIT 6,D
Z80_instr_CB_73:   ; BIT 6,E
Z80_instr_CB_74:   ; BIT 6,H
Z80_instr_CB_75:   ; BIT 6,L
Z80_instr_CB_76:   ; BIT 6,(HL)
Z80_instr_CB_77:   ; BIT 6,A
Z80_instr_CB_78:   ; BIT 7,B
Z80_instr_CB_79:   ; BIT 7,C
Z80_instr_CB_7A:   ; BIT 7,D
Z80_instr_CB_7B:   ; BIT 7,E
Z80_instr_CB_7C:   ; BIT 7,H
Z80_instr_CB_7D:   ; BIT 7,L
Z80_instr_CB_7E:   ; BIT 7,(HL)
Z80_instr_CB_7F:   ; BIT 7,A
Z80_instr_CB_80:   ; RES 0,B
Z80_instr_CB_81:   ; RES 0,C
Z80_instr_CB_82:   ; RES 0,D
Z80_instr_CB_83:   ; RES 0,E
Z80_instr_CB_84:   ; RES 0,H
Z80_instr_CB_85:   ; RES 0,L
Z80_instr_CB_86:   ; RES 0,(HL)
Z80_instr_CB_87:   ; RES 0,A
Z80_instr_CB_88:   ; RES 1,B
Z80_instr_CB_89:   ; RES 1,C
Z80_instr_CB_8A:   ; RES 1,D
Z80_instr_CB_8B:   ; RES 1,E
Z80_instr_CB_8C:   ; RES 1,H
Z80_instr_CB_8D:   ; RES 1,L
Z80_instr_CB_8E:   ; RES 1,(HL)
Z80_instr_CB_8F:   ; RES 1,A
Z80_instr_CB_90:   ; RES 2,B
Z80_instr_CB_91:   ; RES 2,C
Z80_instr_CB_92:   ; RES 2,D
Z80_instr_CB_93:   ; RES 2,E
Z80_instr_CB_94:   ; RES 2,H
Z80_instr_CB_95:   ; RES 2,L
Z80_instr_CB_96:   ; RES 2,(HL)
Z80_instr_CB_97:   ; RES 2,A
Z80_instr_CB_98:   ; RES 3,B
Z80_instr_CB_99:   ; RES 3,C
Z80_instr_CB_9A:   ; RES 3,D
Z80_instr_CB_9B:   ; RES 3,E
Z80_instr_CB_9C:   ; RES 3,H
Z80_instr_CB_9D:   ; RES 3,L
Z80_instr_CB_9E:   ; RES 3,(HL)
Z80_instr_CB_9F:   ; RES 3,A
Z80_instr_CB_A0:   ; RES 4,B
Z80_instr_CB_A1:   ; RES 4,C
Z80_instr_CB_A2:   ; RES 4,D
Z80_instr_CB_A3:   ; RES 4,E
Z80_instr_CB_A4:   ; RES 4,H
Z80_instr_CB_A5:   ; RES 4,L
Z80_instr_CB_A6:   ; RES 4,(HL)
Z80_instr_CB_A7:   ; RES 4,A
Z80_instr_CB_A8:   ; RES 5,B
Z80_instr_CB_A9:   ; RES 5,C
Z80_instr_CB_AA:   ; RES 5,D
Z80_instr_CB_AB:   ; RES 5,E
Z80_instr_CB_AC:   ; RES 5,H
Z80_instr_CB_AD:   ; RES 5,L
Z80_instr_CB_AE:   ; RES 5,(HL)
Z80_instr_CB_AF:   ; RES 5,A
Z80_instr_CB_B0:   ; RES 6,B
Z80_instr_CB_B1:   ; RES 6,C
Z80_instr_CB_B2:   ; RES 6,D
Z80_instr_CB_B3:   ; RES 6,E
Z80_instr_CB_B4:   ; RES 6,H
Z80_instr_CB_B5:   ; RES 6,L
Z80_instr_CB_B6:   ; RES 6,(HL)
Z80_instr_CB_B7:   ; RES 6,A
Z80_instr_CB_B8:   ; RES 7,B
Z80_instr_CB_B9:   ; RES 7,C
Z80_instr_CB_BA:   ; RES 7,D
Z80_instr_CB_BB:   ; RES 7,E
Z80_instr_CB_BC:   ; RES 7,H
Z80_instr_CB_BD:   ; RES 7,L
Z80_instr_CB_BE:   ; RES 7,(HL)
Z80_instr_CB_BF:   ; RES 7,A
Z80_instr_CB_C0:   ; SET 0,B
Z80_instr_CB_C1:   ; SET 0,C
Z80_instr_CB_C2:   ; SET 0,D
Z80_instr_CB_C3:   ; SET 0,E
Z80_instr_CB_C4:   ; SET 0,H
Z80_instr_CB_C5:   ; SET 0,L
Z80_instr_CB_C6:   ; SET 0,(HL)
Z80_instr_CB_C7:   ; SET 0,A
Z80_instr_CB_C8:   ; SET 1,B
Z80_instr_CB_C9:   ; SET 1,C
Z80_instr_CB_CA:   ; SET 1,D
Z80_instr_CB_CB:   ; SET 1,E
Z80_instr_CB_CC:   ; SET 1,H
Z80_instr_CB_CD:   ; SET 1,L
Z80_instr_CB_CE:   ; SET 1,(HL)
Z80_instr_CB_CF:   ; SET 1,A
Z80_instr_CB_D0:   ; SET 2,B
Z80_instr_CB_D1:   ; SET 2,C
Z80_instr_CB_D2:   ; SET 2,D
Z80_instr_CB_D3:   ; SET 2,E
Z80_instr_CB_D4:   ; SET 2,H
Z80_instr_CB_D5:   ; SET 2,L
Z80_instr_CB_D6:   ; SET 2,(HL)
Z80_instr_CB_D7:   ; SET 2,A
Z80_instr_CB_D8:   ; SET 3,B
Z80_instr_CB_D9:   ; SET 3,C
Z80_instr_CB_DA:   ; SET 3,D
Z80_instr_CB_DB:   ; SET 3,E
Z80_instr_CB_DC:   ; SET 3,H
Z80_instr_CB_DD:   ; SET 3,L
Z80_instr_CB_DE:   ; SET 3,(HL)
Z80_instr_CB_DF:   ; SET 3,A
Z80_instr_CB_E0:   ; SET 4,B
Z80_instr_CB_E1:   ; SET 4,C
Z80_instr_CB_E2:   ; SET 4,D
Z80_instr_CB_E3:   ; SET 4,E
Z80_instr_CB_E4:   ; SET 4,H
Z80_instr_CB_E5:   ; SET 4,L
Z80_instr_CB_E6:   ; SET 4,(HL)
Z80_instr_CB_E7:   ; SET 4,A
Z80_instr_CB_E8:   ; SET 5,B
Z80_instr_CB_E9:   ; SET 5,C
Z80_instr_CB_EA:   ; SET 5,D
Z80_instr_CB_EB:   ; SET 5,E
Z80_instr_CB_EC:   ; SET 5,H
Z80_instr_CB_ED:   ; SET 5,L
Z80_instr_CB_EE:   ; SET 5,(HL)
Z80_instr_CB_EF:   ; SET 5,A
Z80_instr_CB_F0:   ; SET 6,B
Z80_instr_CB_F1:   ; SET 6,C
Z80_instr_CB_F2:   ; SET 6,D
Z80_instr_CB_F3:   ; SET 6,E
Z80_instr_CB_F4:   ; SET 6,H
Z80_instr_CB_F5:   ; SET 6,L
Z80_instr_CB_F6:   ; SET 6,(HL)
Z80_instr_CB_F7:   ; SET 6,A
Z80_instr_CB_F8:   ; SET 7,B
Z80_instr_CB_F9:   ; SET 7,C
Z80_instr_CB_FA:   ; SET 7,D
Z80_instr_CB_FB:   ; SET 7,E
Z80_instr_CB_FC:   ; SET 7,H
Z80_instr_CB_FD:   ; SET 7,L
Z80_instr_CB_FE:   ; SET 7,(HL)
Z80_instr_CB_FF:   ; SET 7,A
Z80_instr_DD_09:   ; ADD IX,BC
Z80_instr_DD_19:   ; ADD IX,DE
Z80_instr_DD_21:   ; LD IX,nn
Z80_instr_DD_22:   ; LD (nn),IX
Z80_instr_DD_23:   ; DEC IX
Z80_instr_DD_29:   ; ADD IX,IX
Z80_instr_DD_2A:   ; LD IX,(nn)
Z80_instr_DD_2B:   ; DEC IX
Z80_instr_DD_34:   ; INC (IX+d)
Z80_instr_DD_35:   ; DEC (IX+d)
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
Z80_instr_DD_A6:   ; AND (IX+d)
Z80_instr_DD_AE:   ; XOR (IX+d)
Z80_instr_DD_B6:   ; OR (IX+d)
Z80_instr_DD_BE:   ; CP (IX+d)
Z80_instr_DD_CB:   ; #DDCB
Z80_instr_DD_E1:   ; POP IX
Z80_instr_DD_E3:   ; EX (SP),IX
Z80_instr_DD_E5:   ; PUSH IX
Z80_instr_DD_E9:   ; JP (IX)
Z80_instr_DD_F9:   ; LD SP,IX
Z80_instr_ED_40:   ; IN B,(C)
Z80_instr_ED_41:   ; OUT (C),B
Z80_instr_ED_42:   ; SBC HL,BC
Z80_instr_ED_43:   ; LD (nn),BC
Z80_instr_ED_44:   ; NEG
Z80_instr_ED_45:   ; RETN
Z80_instr_ED_46:   ; IM 0
Z80_instr_ED_47:   ; LD I,A
Z80_instr_ED_48:   ; IN C,(C)
Z80_instr_ED_49:   ; OUT (C),C
Z80_instr_ED_4A:   ; ADC HL,BC
Z80_instr_ED_4B:   ; LD BC,(nn)
Z80_instr_ED_4D:   ; RETTI
Z80_instr_ED_4F:   ; LD R,A
Z80_instr_ED_50:   ; IN D,(C)
Z80_instr_ED_51:   ; OUT (C),D
Z80_instr_ED_52:   ; SBC HL,DE
Z80_instr_ED_53:   ; LD (nn),DE
Z80_instr_ED_56:   ; IM 1
Z80_instr_ED_57:   ; LD A,I
Z80_instr_ED_58:   ; IN E,(C)
Z80_instr_ED_59:   ; OUT (C),E
Z80_instr_ED_5A:   ; ADC HL,DE
Z80_instr_ED_5B:   ; LD DE,(nn)
Z80_instr_ED_5E:   ; IM 2
Z80_instr_ED_5F:   ; LD A,R
Z80_instr_ED_60:   ; IN H,(C)
Z80_instr_ED_61:   ; OUT (C),H
Z80_instr_ED_62:   ; SBC HL,HL
Z80_instr_ED_67:   ; RRD
Z80_instr_ED_68:   ; IN L,(C)
Z80_instr_ED_69:   ; OUT (C),L
Z80_instr_ED_6A:   ; ADC HL,HL
Z80_instr_ED_6F:   ; RLD
Z80_instr_ED_72:   ; SBC HL,SP
Z80_instr_ED_73:   ; LD (nn),SP
Z80_instr_ED_78:   ; IN A,(C)
Z80_instr_ED_79:   ; OUT (C),A
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
Z80_instr_FD_21:   ; LD IY,nn
Z80_instr_FD_22:   ; LD (nn),IY
Z80_instr_FD_23:   ; INC IY
Z80_instr_FD_29:   ; ADD IY,IY
Z80_instr_FD_2A:   ; LD IY,(nn)
Z80_instr_FD_2B:   ; DEC IY
Z80_instr_FD_34:   ; INC (IY+d)
Z80_instr_FD_35:   ; DEC (IY+d)
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
Z80_instr_FD_A6:   ; AND (IY+d)
Z80_instr_FD_AE:   ; XOR (IY+d)
Z80_instr_FD_B6:   ; OR (IY+d)
Z80_instr_FD_BE:   ; CP (IY+d)
Z80_instr_FD_CB:   ; #FDCB
Z80_instr_FD_E1:   ; POP IY
Z80_instr_FD_E3:   ; EX (SP),IY
Z80_instr_FD_E5:   ; PUSH IY
Z80_instr_FD_E9:   ; JP (IY)
Z80_instr_FD_F9:   ; LD SP,IY
Z80_instr_DDCB_06: ; RLC (IX+d)
Z80_instr_DDCB_0E: ; RRC (IX+d)
Z80_instr_DDCB_16: ; RL (IX+d)
Z80_instr_DDCB_1E: ; RR (IX+d)
Z80_instr_DDCB_26: ; SLA (IX+d)
Z80_instr_DDCB_2E: ; SRA (IX+d)
Z80_instr_DDCB_3E: ; SRL (IX+d)
Z80_instr_DDCB_46: ; BIT 0,(IX+d)
Z80_instr_DDCB_4E: ; BIT 1,(IX+d)
Z80_instr_DDCB_56: ; BIT 2,(IX+d)
Z80_instr_DDCB_5E: ; BIT 3,(IX+d)
Z80_instr_DDCB_66: ; BIT 4,(IX+d)
Z80_instr_DDCB_6E: ; BIT 5,(IX+d)
Z80_instr_DDCB_76: ; BIT 6,(IX+d)
Z80_instr_DDCB_7E: ; BIT 7,(IX+d)
Z80_instr_DDCB_86: ; RES 0,(IX+d)
Z80_instr_DDCB_8E: ; RES 1,(IX+d)
Z80_instr_DDCB_96: ; RES 2,(IX+d)
Z80_instr_DDCB_9E: ; RES 3,(IX+d)
Z80_instr_DDCB_A6: ; RES 4,(IX+d)
Z80_instr_DDCB_AE: ; RES 5,(IX+d)
Z80_instr_DDCB_B6: ; RES 6,(IX+d)
Z80_instr_DDCB_BE: ; RES 7,(IX+d)
Z80_instr_DDCB_C6: ; SET 0,(IX+d)
Z80_instr_DDCB_CE: ; SET 1,(IX+d)
Z80_instr_DDCB_D6: ; SET 2,(IX+d)
Z80_instr_DDCB_DE: ; SET 3,(IX+d)
Z80_instr_DDCB_E6: ; SET 4,(IX+d)
Z80_instr_DDCB_EE: ; SET 5,(IX+d)
Z80_instr_DDCB_F6: ; SET 6,(IX+d)
Z80_instr_DDCB_FE: ; SET 7,(IX+d)
Z80_instr_FDCB_06: ; RLC (IY+d)
Z80_instr_FDCB_0E: ; RRC (IY+d)
Z80_instr_FDCB_16: ; RL (IY+d)
Z80_instr_FDCB_1E: ; RR (IY+d)
Z80_instr_FDCB_26: ; SLA (IY+d)
Z80_instr_FDCB_2E: ; SRA (IY+d)
Z80_instr_FDCB_3E: ; SRL (IY+d)
Z80_instr_FDCB_46: ; BIT 0,(IY+d)
Z80_instr_FDCB_4E: ; BIT 1,(IY+d)
Z80_instr_FDCB_56: ; BIT 2,(IY+d)
Z80_instr_FDCB_5E: ; BIT 3,(IY+d)
Z80_instr_FDCB_66: ; BIT 4,(IY+d)
Z80_instr_FDCB_6E: ; BIT 5,(IY+d)
Z80_instr_FDCB_76: ; BIT 6,(IY+d)
Z80_instr_FDCB_7E: ; BIT 7,(IY+d)
Z80_instr_FDCB_86: ; RES 0,(IY+d)
Z80_instr_FDCB_8E: ; RES 1,(IY+d)
Z80_instr_FDCB_96: ; RES 2,(IY+d)
Z80_instr_FDCB_9E: ; RES 3,(IY+d)
Z80_instr_FDCB_A6: ; RES 4,(IY+d)
Z80_instr_FDCB_AE: ; RES 5,(IY+d)
Z80_instr_FDCB_B6: ; RES 6,(IY+d)
Z80_instr_FDCB_BE: ; RES 7,(IY+d)
Z80_instr_FDCB_C6: ; SET 0,(IY+d)
Z80_instr_FDCB_CE: ; SET 1,(IY+d)
Z80_instr_FDCB_D6: ; SET 2,(IY+d)
Z80_instr_FDCB_DE: ; SET 3,(IY+d)
Z80_instr_FDCB_E6: ; SET 4,(IY+d)
Z80_instr_FDCB_EE: ; SET 5,(IY+d)
Z80_instr_FDCB_F6: ; SET 6,(IY+d)
Z80_instr_FDCB_FE: ; SET 7,(IY+d)

	rts ; XXX
