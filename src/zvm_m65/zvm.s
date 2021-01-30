
;
; Z80 Virtual Machine core routines
;

ZVM: ; entry point

	; Reset stack pointer, set .Z to 0 - this routine will never return

	ldx #$FF
	txs
	ldz #$00

	; Skip the IRQ processing, even if Kernal reenables it

	sei
	; XXX uncomment this when debugging is finished
	; lda #<return_from_interrupt
	; sta CINV+0 
	; lda #>return_from_interrupt
	; sta CINV+1

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

	; XXX enable test jsr ZVM_memtest

	; Generate CPU tables, reset the CPU

	jsr Z80_table_gen
	; XXX jsr Z80_reset_MEM
	jsr Z80_reset_CPU

	; Try CPU test

	jsr ZVM_cputest



	; XXX code is not ready to progress further
	jsr PRIMM
	!pet $0D, "Implementation not finished yet.", 0
	jmp ZVM_syshalt

	jmp zvm_BIOS_00_BOOT




; XXX addition and subtraction are slow; pre-calculate data/flag tables in the extended 8MB RAM
; XXX use TRB/TSB instead of LDA + AND/ORA + STA when applicable













ZVM_memtest:

	; Simple memory test
	; XXX this test fails for now
	
	lda #$00
	sta PTR_DATA+0
	sta PTR_DATA+1
	sta PTR_DATA+2
	lda #$08
	sta PTR_DATA+3

	ldx #$F0
@1:
	ldy #$10
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

ZVM_syshalt:

	jsr PRIMM
	!pet "   * System HALTED *", 0
@1:
	bra @1
