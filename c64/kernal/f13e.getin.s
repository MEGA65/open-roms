
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 283
// - [CM64] Compute's Mapping the Commodore 64 - page 227/228
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//


GETIN:

	// XXX this should be a dispatcher for several different devices!

	jmp read_kb_buf
