;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Something terrible happened - show the panic screen
;


!ifdef CONFIG_PANIC_SCREEN {

panic:

	; Store error code on stack

	pha

	; Reinitialize the hardware

	sei
	jsr IOINIT

!ifdef CONFIG_MB_M65 {

	; Make sure we are in legacy mode with normal memory mapping

	jsr map_NORMAL
	sec
	jsr M65_MODESET          ; switch to legacy C64 compatibility mode
	sei

} else {

	jsr vicii_init
}

	jsr clear_screen

	; Disable NMIs

!ifdef CONFIG_TAPE_HEAD_ALIGN {

	jsr nmi_lock

} else {

	lda #$00
	sta NMINV + 1            ; our routine does not allow zeropage vectors
}

	; Display KERNAL PANIC message

	ldx #$14
	ldy #$0E
	jsr plot_set

	ldx #__MSG_KERNAL_PANIC
	jsr print_kernal_message

	; Display error code and message (if known)

	pla
	beq kernal_panic_infinite_loop
	pha

	ldx #$02
	ldy #$02
	jsr plot_set

	pla
	pha
	jsr print_hex_byte

	pla
	cmp #P_ERR_ROM_MISMATCH
	bne kernal_panic_infinite_loop

	ldx #__MSG_KERNAL_PANIC_ROM_MISMATCH
	jsr print_kernal_message

	; Display some raster effect in the infinitew loop

kernal_panic_infinite_loop:

	ldx #$00
	stx VIC_EXTCOL
@1:
	inx
	bpl @1

	ldx #$06
	stx VIC_EXTCOL

	+nop

	bne kernal_panic_infinite_loop ; branch always
}
