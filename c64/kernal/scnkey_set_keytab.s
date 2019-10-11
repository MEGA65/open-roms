
//
// Well-known Kernal routine, described in:
//
// - [CM64] Compute's Mapping the Commodore 64 - pages 220, 221
//

scnkey_set_keytab:

	// Set initial KEYTAB value

	lda #<keyboard_matrix
	sta KEYTAB+0
	lda #>keyboard_matrix
	sta KEYTAB+1

	// Calculate table index

	lda SHFLAG
	and #$07 // we are only interested in SHIFT / CTRL / VENDOR keys
	tax

	// Retrieve table offset
	lda keyboard_matrix_lookup, x

	// Add offset to the vector
	sec
	adc KEYTAB+0
	sta KEYTAB+0
	lda #$00
	adc KEYTAB+1
	sta KEYTAB+1

	// Check if we should toggle the character set

	lda MODE
	bne !+ // not allowed to toggle
	lda SHFLAG
	and #$03
	cmp #$03
	bne !+ // no SHIFT + VENDOR pressed
	lda LSTSHF
	and #$03
	cmp #$03
	beq !+ // alreeady toggled

	// Toggle char set

	lda VIC_YMCSB
	eor #$02
	sta VIC_YMCSB
!:
	rts
