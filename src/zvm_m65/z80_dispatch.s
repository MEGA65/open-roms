
;
; Z80 instruction dispatchers
;

!macro ZVM_DISPATCH .TAB_LO, .TAB_HI {

	; Fetch and execute next opcode

	+Z80_FETCH_VIA_PC_INC

	; jsr DBG_print_PC_opcode

	asl
	tax
	bcs @1
	jmp (.TAB_LO,x)          ; execute opcode $00-$7F
@1: jmp (.TAB_HI,x)          ; execute opcode $80-$FF

}

ZVM_store_via_HL_next:

	+Z80_STORE_BACK_VIA_HL

	; FALLTROUGH

	; unsupported illegal instructions
Z80_unsupported:
	; XXX add a separate handler to warn about illegal instructions
	
	; block I/O transfer - not implemented for now    XXX implement them
Z80_instr_ED_A2:                                                               ; INI
Z80_instr_ED_B2:                                                               ; INIR
Z80_instr_ED_AA:                                                               ; IND
Z80_instr_ED_BA:                                                               ; INDR
Z80_instr_ED_A3:                                                               ; OUTI
Z80_instr_ED_B3:                                                               ; OTIR
Z80_instr_ED_AB:                                                               ; OUTD
Z80_instr_ED_BB:                                                               ; OTDR
	; XXX add a separate handler to warn about them
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
	; Instructions needed only for interrupts (emulation not needed for CP/M)
Z80_instr_ED_46:                                                               ; IM 0
Z80_illeg_ED_4E:                                                               ; IM 0
Z80_illeg_ED_66:                                                               ; IM 0
Z80_illeg_ED_6E:                                                               ; IM 0
Z80_instr_ED_56:                                                               ; IM 1
Z80_illeg_ED_76:                                                               ; IM 1
Z80_instr_ED_5E:                                                               ; IM 2
Z80_illeg_ED_7E:                                                               ; IM 2
	; NOP
Z80_instr_00:                                                                  ; NOP
Z80_illeg_ED_77:                                                               ; NOP
Z80_illeg_ED_7F:                                                               ; NOP
	; Fetch and execute the next instruction
ZVM_next:          +ZVM_DISPATCH Z80_vectab_0,    Z80_vectab_1
	; Dispatch via jumptable
Z80_instr_CB:      +ZVM_DISPATCH Z80_vectab_CB_0, Z80_vectab_CB_1              ; #CB
Z80_instr_DD:      +ZVM_DISPATCH Z80_vectab_DD_0, Z80_vectab_DD_1              ; #DD
Z80_instr_ED:      +ZVM_DISPATCH Z80_vectab_ED_0, Z80_vectab_ED_1              ; #ED
Z80_instr_FD:      +ZVM_DISPATCH Z80_vectab_FD_0, Z80_vectab_FD_1              ; #FD


!macro ZVM_DISPATCH_REG_IXY .REG_nn {

	; XXX is the displacement calculated correctly?

	; Fetch value from IX/IY, subtract 128

	lda .REG_nn+1
	sta PTR_IXY_d+1
	lda .REG_nn+0
	bmi @1
	dec PTR_IXY_d+1
@1:
	eor #%10000000
	sta PTR_IXY_d+0

	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc REG_PC+0
	sta REG_PC+0
	bcc @2
	inc REG_PC+1
@2:
	+ZVM_DISPATCH Z80_vectab_xDCB_0, Z80_vectab_xDCB_1
}

Z80_instr_DD_CB:   +ZVM_DISPATCH_REG_IXY REG_IX                                ; #DDCB
Z80_instr_FD_CB:   +ZVM_DISPATCH_REG_IXY REG_IY                                ; #FDCB
