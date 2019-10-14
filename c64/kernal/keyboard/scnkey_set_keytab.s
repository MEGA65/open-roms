
//
// Well-known Kernal routine, described in:
//
// - [CM64] Compute's Mapping the Commodore 64 - pages 220, 221
//


scnkey_set_keytab:


#if CONFIG_SCNKEY_TWW_CTR // routine not compatible with legacy SCNKEY

	rts

#else


	// Set initial KEYTAB value

	lda #<kb_matrix
	sta KEYTAB+0
	lda #>kb_matrix
	sta KEYTAB+1

	// Calculate table index

	lda SHFLAG
	and #$07 // we are only interested in SHIFT / CTRL / VENDOR keys
	tax

	// Retrieve table offset
	lda kb_matrix_lookup, x
	cmp #$FF
	bne scnkey_valid_offset

	// $FF means we shouldn't decode anything, mark this by setting high byte
	// of KEYTAB to 0 (I don't think anyone would put keyboard decoding table
    // at zeropage)
	lda #$00
	beq !+ // branch always

scnkey_valid_offset:

	// Add offset to the vector
	clc
	adc KEYTAB+0
	sta KEYTAB+0
	lda #$00
	adc KEYTAB+1
!:
	sta KEYTAB+1

	// FALLTROUGH


#endif // no CONFIG_SCNKEY_TWW_CTR


scnkey_toggle_if_needed: // entry for SCNKEY (TWW/CTR version)

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
