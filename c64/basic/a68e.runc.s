
// Well-known BASIC routine, described in:
//
// - [CM64] Compute's Mapping the Commodore 64 - page 97
// - https://www.c64-wiki.com/wiki/BASIC-ROM
// - https://csdb.dk/forums/?roomid=11&topicid=137233
// 

// XXX use this routine to initialize TXTPTR

RUNC:
	// According to WIKI, we should load $7A/$7B with $2B-1/$2C-1), this does not makes sense.
	// But CSDB claims, that it should 'set current character pointer to start of basic - 1' - this
	// looks sane, also checked that the original BASIC routine does this (short test program)

	// Let's initialize TXTPTR using TXTTAB

	lda TXTTAB+0
	sec
	sbc #$01
	sta TXTPTR+0
	
	lda TXTTAB+1
	sbc #$00
	sta TXTPTR+1

	rts
