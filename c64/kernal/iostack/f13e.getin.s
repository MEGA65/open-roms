
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 283
// - [CM64] Compute's Mapping the Commodore 64 - page 227/228
//
// CPU registers that has to be preserved (see [RG64]): for RS-232: .X, .Y
//


GETIN:
	jmp getin_real
