
//
// Helper routine for JiffyDOS detection
//

// The standard parallel cable (used by SpeedDOS, DolphinDOS 2, etc.) connects the following UserPort lines:
// - PB0-PB7    - CIA2_PRB ($DD01), CIA #2 port B
// - PC2, FLAG2 - CIA2_ICR ($DD0D), CIA #2 handshaking line
//
// See:
// - http://sta.c64.org/cbmpar41c.html
// - http://sta.c64.org/cbmpar71c.html
// - Commodore 64 Programers Referencee Guide, pages 360-361, 429
// - Computes Mapping the C64, page 183



#if CONFIG_IEC_DOLPHINDOS


dolphindos_detect:

	// Make sure the port settings are correct

	lda #$7F
	sta CIA2_ICR                       // disable interrupt generation
	lda #$00
	sta CIA2_DDRB                      // set all port B lines as input

	// According to logs collected from modified VICE emulator, original DolphinDOS ROM
	// constantly reads $DD0D and $DD01 until handshake bit of $DD0D is set, or some kind
	// of timeout occurs

	ldx #$20

dolphindos_detect_loop:

	lda CIA2_ICR
	cmp #$10
	beq dolphindos_detect_success
	lda CIA2_PRB                       // XXX do we need this read?

	dex
	bne dolphindos_detect_loop

	// FALLTROUGH - protocol not detected

dolphindos_detect_fail:

	rts

dolphindos_detect_success:

	// Protocol detected

	lda #$02
	sta IECPROTO

	rts


#endif // CONFIG_IEC_DOLPHINDOS
