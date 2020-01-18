// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Something terrible happened - show the panic screen
//


#if CONFIG_PANIC_SCREEN

panic:

	// Disable interrupts, store error code on stack

	sei
	pha

	// Reinitialize the hardware

	jsr IOINIT
	jsr setup_vicii
	jsr clear_screen

	// Disable NMIs - our routine checks for NULL vector

	lda #$00
	sta NMINV+0
	sta NMINV+1

	// Display KERNAL PANIC message

	ldx #$14
	ldy #$0E
	jsr plot_set

	ldx #__MSG_KERNAL_PANIC
	jsr print_kernal_message

	// Display error code and message (if known)

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

	// Display some raster effect in the infinitew loop

kernal_panic_infinite_loop:
	ldx #$00
	stx VIC_EXTCOL
!:
	inx
	bpl !-

	ldx #$06
	stx VIC_EXTCOL

	nop

	bne kernal_panic_infinite_loop // branch always

#endif // CONFIG_PANIC_SCREEN
