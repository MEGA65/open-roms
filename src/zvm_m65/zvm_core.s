
;
; Z80 Virtual Machine core routines
;

ZVM_entry:

	; Reset stack pointer, set .Z to 0 - this routine will never return

	ldx #$FF
	txs
	ldz #$00

	; Skip the IRQ processing, even if Kernal reenables it

	sei
	lda #<return_from_interrupt
	sta CINV+0 
	lda #>return_from_interrupt
	sta CINV+1

	; Make sure $C000-$CFFF ROM is mapped-in, we keep our proxies there
	; Also make sure the palette is taken from RAM

	lda VIC_CTRLA
	ora #%00100100
	sta VIC_CTRLA

	; Setup colours to ressemble vintage green monitor from the 70s, print welcome message

	lda #$00
	sta VIC_EXTCOL
	sta VIC_BGCOL0
	sta PALETTE_R+0
	sta PALETTE_G+0
	sta PALETTE_B+0

	lda #$01
	sta PALETTE_R+5
	lda #$47
	sta PALETTE_G+5
	lda #$02
	sta PALETTE_B+5

	jsr PRIMM
	!byte KEY_GREEN, KEY_ESC, 'o', KEY_CLR, KEY_C65_SHIFT_ON, KEY_TXT, KEY_C65_SHIFT_OFF
	!pet "Open ROMs MEGA65 BIOS for CP/M", $0D
	!pet "Zilog Z80 to 45GS02 translator", $0D
	!byte $0D,$0D
	!byte 0

	; Check if extended memory is present

	jsr ZVM_memtest

	; Initialize constants    XXX consider moving this to a dedicated reset CPU routine

	lda #$00                           ; all the Z80 memory is located below $0100:$0000
	sta PTR_DATA+3
	sta PTR_IXY_d+3

	; Generate CPU tables

	jsr z80_table_gen

	; XXX code is not ready to progress further
	jsr PRIMM
	!pet $0D, "Implementation not finished yet.", 0
	jmp ZVM_halt

	jmp zvm_BIOS_00_BOOT

ZVM_store_via_HL_next:

	sta [REG_HL],z

	; FALLTROUGH

!macro ZVM_DISPATCH .TAB_LO, .TAB_HI {

	; Fetch and execute next opcode

	jsr (VEC_fetch_via_PC_inc)
	asl
	tax
	bcs @1
	jmp (.TAB_LO,x)          ; execute opcode $00-$7F
@1: jmp (.TAB_HI,x)          ; execute opcode $80-$FF

}

	; unsupported illegal instructions
Z80_unsupported:
	; XXX add a separate handler to warn about illegal instructions
	
	; block I/O transfer - not implemented for now    XXX implement them
Z80_instr_ED_A2:   ; INI
Z80_instr_ED_B2:   ; INIR
Z80_instr_ED_AA:   ; IND
Z80_instr_ED_BA:   ; INDR
Z80_instr_ED_A3:   ; OUTI
Z80_instr_ED_B3:   ; OTIR
Z80_instr_ED_AB:   ; OUTD
Z80_instr_ED_BB:   ; OTDR
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




; XXX addition and subtraction are slow; pre-calculate data/flag tables in the extended 8MB RAM
; XXX use TRB/TSB instead of LDA + AND/ORA + STA when applicable
; XXX all dispatch routines shall have separate versions for bank 0/1



















































;
; Not implemented yet - XXX implement them!
;


Z80_instr_DD_CB:   ; #DDCB
Z80_instr_FD_CB:   ; #FDCB
Z80_instr_ED_A1:   ; CPI
Z80_instr_ED_A9:   ; CPD
Z80_instr_ED_B1:   ; CPIR
Z80_instr_ED_B9:   ; CPDR




	jmp ZVM_next ; XXX provide implementation





ZVM_memtest:

	; Simple memory test
	; XXX this test is temporary
	
	lda #$00
	sta PTR_DATA+0
	sta PTR_DATA+1
	sta PTR_DATA+2
	lda #$08
	sta PTR_DATA+3

	ldx #$F0
@1:
	ldy #$00
@2:
	lda PTR_DATA+2
	eor #%01111111
	sta PTR_DATA+2

	stx PTR_DATA+0
	eor PTR_DATA+0
	sta PTR_DATA+0

	sty PTR_DATA+1
	tya

	sta [PTR_DATA], z
	lda [PTR_DATA], z
	cmp PTR_DATA+1
	bne ZVM_halt_memtest_failed

	iny
	bne @2
	inx
	bne @1

	rts

ZVM_halt_memtest_failed:

	jsr PRIMM
	!pet $0D, "ATTIC RAM failure.", 0

	; FALLTROUGH

ZVM_halt:

	jsr PRIMM
	!pet "   * System HALTED *", 0
@1:
	bra @1
