
;
; Z80 Virtual Machine banking support
;


ZVM_bank0_vectab:

	!word ZVM_bank0_fetch_via_PC_inc
	!word ZVM_bank0_fetch_stack
	!word ZVM_bank0_store_stack

	; XXX add remaining routines here

ZVM_bank1_vectab:

	!word ZVM_bank1_fetch_via_PC_inc
	!word ZVM_bank1_fetch_stack
	!word ZVM_bank1_store_stack

	; XXX add remaining routines here

;
; Bank switching routines
;

ZVM_set_bank_0:

	lda #$00
	sta BANK_ID

	; XXX use DMAgic to switch banks (vectors on zeropage)

	rts

ZVM_set_bank_1:

	lda #$01
	sta BANK_ID

	; XXX use DMAgic to switch banks (vectors on zeropage)

	; Since all the Z80 bank 1 memory is located in $0005:$xxxx,
	; we can set some bytes in certain pointers for faster execution

	lda #$05
	
	sta PTR_IXY_d+2
	sta PTR_DATA+2

	rts

;
; Memory access routines
;

ZVM_bank0_fetch_via_PC_inc:

	lda REG_PC+0
	sta PTR_DATA+0
	ldy REG_PC+1
	lda z80_atable_mi_bank0,y
	sta PTR_DATA+1
	lda z80_atable_hi_bank0,y
	sta PTR_DATA+2
	
	lda [PTR_DATA], z
	inw REG_PC

	rts

ZVM_bank1_fetch_via_PC_inc:

	lda [REG_PC], z
	inw REG_PC

	rts

ZVM_bank0_fetch_stack:

	ldx REG_SP+0
	stx PTR_DATA+0
	ldy REG_SP+1
	ldx z80_atable_mi_bank0,y
	stx PTR_DATA+1
	ldx z80_atable_hi_bank0,y
	stx PTR_DATA+2
	
	lda [PTR_DATA], z
	inw REG_SP

	rts

ZVM_bank1_fetch_stack:

	lda [REG_SP], z
	inw REG_SP

	rts

ZVM_bank0_store_stack:

	dew REG_SP

	ldx REG_SP+0
	stx PTR_DATA+0
	ldy REG_SP+1
	ldx z80_atable_mi_bank0,y
	stx PTR_DATA+1
	ldx z80_atable_hi_bank0,y
	stx PTR_DATA+2

	sta [PTR_DATA], z

	rts

ZVM_bank1_store_stack:

	dew REG_SP
	sta [REG_SP], z

	rts






; XXX cleanup code below



ZVM_fetch_IO:

	; XXX fetch addresses via ADDR_IO - but which ones are safe? Should we have a whitelist?
	lda #$00
	sta REG_A
	rts

ZVM_store_IO:

	; XXX again, we should have a whitelist of addresses
	rts
