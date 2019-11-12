
//
// JiffyDOS protocol support for IEC
//

// XXX finish this



#if CONFIG_IEC_JIFFYDOS


// JiffyDOS timing regime is very strict - before transmitting anything
// we need to disable sprites and (if screen is not disabled) wait for
// appropriate moment, so that no badline interruption can happen


iec_tx_byte_jiffydos:

	jsr jiffydos_hide_sprites
	pha                                // store previous sprite status on stack

	// XXX prepare bit pairs too send

	// XXX lda TBTCNT
	// XXX bits to stack: 0, 2
	// XXX bits to stack: 1, 3
	// XXX bits to stack: 7, 6
	// XXX bits to stack: 5, 4

	jsr jiffydos_wait_line

__jd_check1:

	// XXX send byte


	// Re-enable sprites
	pla
	lda VIC_SPENA

	// XXX reenable screen - temporary, just for testing
	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY

	rts
	

iec_rx_byte_jiffydos:
	
	jsr jiffydos_hide_sprites
	pha                                // store previous sprite status on stack
	
	// Wait until device is ready to send
	jsr iec_wait_for_clk_release

	// Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    // release
	pha

	// Wait for appropriate moment
	jsr jiffydos_wait_line

	// Ask device to start sending bits
	pla
	sta CIA2_PRA


	// XXX retrieve byte


	// Re-enable sprites
	pla
	lda VIC_SPENA

	// XXX reenable screen - temporary, just for testing
	tay
	lda VIC_SCROLY
	ora #$10
	sta VIC_SCROLY
	tya

	rts


jiffydos_wait_line:

	lda VIC_SCROLY
	and #$10
	beq jiffydos_wait_line_done        // screen is disabled, no need to watch for badlines

	// To give the transfer routine as much time as possible,
	// wait till a badline

	// XXX this is probably overkill, most likely it is enough to avoid 2 (3?) lines
	//     before badline - to be adjusted in the future
!:
	sec
	lda VIC_SCROLY
	sbc VIC_RASTER
	and #$07                           // we want 8 lowest bits
	bne !-

jiffydos_wait_line_done:
	rts


__jd_check2:
	
	
jiffydos_hide_sprites:

	lda VIC_SPENA
	ldx #$00
	stx VIC_SPENA
	
	rts


.function SAME_PAGE_CHECK(label_1, label_2)
{
#if PASS_SIZETEST
	.return (label_1 - label_1 % 256) == (label_2 - label_2 % 256)
#else
	.return true
#endif
}

.if (!SAME_PAGE_CHECK(__jd_check1, __jd_check2))
{
	// To meet the strict JiffyDOS timing, we need to make sure
	// it does not span across multiple pages, as this would add
	// 1 cycle to some jump instructions - maybe this wont cause
	// problems, but better safe than sorry.

	.error "JiffyDOS code can't span across multiple pages"
}


#endif // CONFIG_IEC_JIFFYDOS
