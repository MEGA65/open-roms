
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 296
// - [CM64] Compute's Mapping the Commodore 64 - page 223/224
// - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//


SECOND:

	// Due to OPEN/CLOSE/TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	// allowed channels are 0-15; report error if out of range
	cmp #$10
	bcc !+ 
	jmp kernalerror_DEVICE_NOT_FOUND // XXX find a better error message for wrong channel (create new one?)
!:
	ora #$60

	jmp common_open_close_unlsn_second


