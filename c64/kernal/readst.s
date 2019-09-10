
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 292
// - [CM64] Compute's Mapping the Commodore 64 - page 239
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//

READST:

	// Check the current device number

	lda current_device_number
	cmp #$02
	bne !+
	
	// This is RS-232 device - according to 'Compute's Mapping the Commodore 64' page 239
	// it reads status from RSSTAT
	lda RSSTAT
	rts
!:
	// According to 'Compute's Mapping the Commodore 64' page 239, it usually retrieves
	// status from IOSTATUS
	
	// XXX is it always the case if device is not RS-232 ?

	lda IOSTATUS
	rts
