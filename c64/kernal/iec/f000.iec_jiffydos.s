
//
// JiffyDOS protocol support for IEC
//

// XXX finish this



#if CONFIG_IEC_JIFFYDOS


iec_tx_byte_jiffydos:

	// JiffyDOS timing regime is very strict - before transmitting anything
	// we need to disable sprites and (if screen is not disabled) wait for
	// appropriate moment, so that no badline interruption can happen
	
	jsr jiffydos_hide_sprites
	jsr jiffydos_wait_line

__jd_check1:

	// XXX send byte

	// Re-enable sprites
	jsr jiffydos_restore_sprites

	rts
	

iec_rx_byte_jiffydos:

	// JiffyDOS timing regime is very strict - before transmitting anything
	// we need to disable sprites and (if screen is not disabled) wait for
	// appropriate moment, so that no badline interruption can happen
	
	jsr jiffydos_hide_sprites
	jsr jiffydos_wait_line

	// XXX retrieve byte

	// Re-enable sprites
	jsr jiffydos_restore_sprites

	rts


jiffydos_wait_line:

	lda VIC_SCROLY
	and #$10
	beq jiffydos_wait_line_done        // screen is disabled, no need to watch for badlines

	// XXX wait for badline to pass


jiffydos_wait_line_done:
	rts


__jd_check2:
	
	
jiffydos_hide_sprites:

	// XXX implement
	
	rts


jiffydos_restore_sprites:

	// XXX implement
	
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
