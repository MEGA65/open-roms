
//
// Something terrible happened - show the panic screen
//

// .A = 0 - just panic, no extra message
// .A = 1 - ROM version mismatch

panic:

	sei
	pha

	jsr IOINIT
	jsr setup_vicii
	jsr clear_screen

	// XXX disable NMIs

	ldx #$14
	ldy #$0E
	jsr plot_set

	ldx #__MSG_KERNAL_PANIC
	jsr print_kernal_message

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
	cmp #$01
	bne kernal_panic_infinite_loop

	ldx #__MSG_KERNAL_PANIC_VERSION
	jsr print_kernal_message

kernal_panic_infinite_loop:
	ldx #$00
	stx VIC_EXTCOL

	ldx #$80
!:
	dex
	bne !-

	ldx #$06
	stx VIC_EXTCOL
!:
	dex
	bne !-

	beq kernal_panic_infinite_loop // branch always
