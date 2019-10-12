
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 295
// - [CM64] Compute's Mapping the Commodore 64 - page 220
//
// CPU registers that has to be preserved (see [RG64]): none
//

// Variables used:
// - KEYTAB  - keyboard matrix pointer
// - DELAY   - counter for first delay between key repeats
// - KOUNT   - counter for next delays between key repeats
// - SHFLAG  - SHIFT / CTRL / VENDOR keypress status
// - NDX     - number of characters in keyboard buffer
// - XMAX    - maximum size of keyboard buffer
// - LSTX    - matrix coordinate of last pressed key
// - LSTSHF  - previous status of SHFLAG
// - MODE    - flag, whether charset toggle (SHIFT+VENDOR) is allowed


#if !CONFIG_SCNKEY_TWW_CTR

// Routine is heavily inspired by TWW/CTR proposal, see here:
// - http://codebase64.org/doku.php?id=base:scanning_the_keyboard_the_correct_and_non_kernal_way


SCNKEY:

	// Handle repeat timer

	lda KOUNT
	beq !+
	dec KOUNT
!:
	// Prepare for SHFLAG update

	lda SHFLAG
	sta LSTSHF
	lda #$00
	sta SHFLAG

	// XXX retrieve ALT and NO_SCRL status for C128/C65 keyboards

	// Check for any activity

	lda #$00
	sta CIA1_PRA  // connect all the rows
	lda #$FF
	cmp CIA1_PRB
	beq scnkey_no_keys

	// Retrieve SHIFT / VENDOR / CTRL status
	ldy #$03
scnkey_bucky_loop:
	lda kb_matrix_bucky_confmask, y
	sta CIA1_PRA
	lda kb_matrix_bucky_testmask, y
	and CIA1_PRB
	bne !+ // not pressed
	lda SHFLAG
	ora kb_matrix_bucky_shflag, y
	sta SHFLAG
!:
	dey
	bpl scnkey_bucky_loop

	// Set KEYTAB vector

	jsr scnkey_via_keylog // XXX for some CPUs we have indirect jsr

	// XXX check for joystick activity

	// Scan the keyboard matrix

	ldy #$07
scnkey_matrix_loop:
	lda kb_matrix_row_keys, y
	sta CIA1_PRA
	lda kb_matrix_bucky_filter, y
	ora CIA1_PRB

	// XXX
	dey
	bpl scnkey_matrix_loop





	// XXX

scnkey_no_keys:

	lda #$FF
	sta LSTX

	rts

scnkey_via_keylog:
	jmp (KEYLOG)

#endif // no CONFIG_SCNKEY_TWW_CTR
