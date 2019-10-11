
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

	ldx KOUNT
	beq sk_start
	dec KOUNT

	// Setup the CIA registers XXX check whether the C64 does it every time

	ldx #$FF
	stx CIA1_DDRA  // output
	ldy #$00
	sty CIA1_DDRB  // input

	// Prepare for SHFLAG update

	lda SHFLAG
	sta LSTSHF
	ldy #$00
	sty SHFLAG

	// XXX retrieve ALT and NO_SCRL status for C128/C65 keyboards

	// Check for any activity

	sty CIA1_PRA  // connect all the lines
	ldx #$FF
	cpx CIA1_PRB
	beq scnkey_no_keys

	// XXX retrieve SHIFT / CTRL / VENDOR status

	// Set pointer in KEYTAB
	jsr scnkey_via_keytab

	// XXX check for joystick activity

	// Scan the keyboard matrix







	// XXX

scnkey_no_keys:

	// ldx #$FF
	stx LSTX

	rts

scnkey_via_keytab:
	jmp (KEYTAB)

#endif // No CONFIG_SCNKEY_TWW_CTR
