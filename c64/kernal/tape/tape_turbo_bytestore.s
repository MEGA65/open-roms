
//
// Tape (turbo) helper routine - storing byte uder I/O
//

// This helper routine is meant to be copiet to the start of CPU stack.
// Original ROM tape loading routines uses this area to store information
// about bytes that did not read properly for the first time
// (see Mapping the C64, page 47); this mechanism is useless for turbo tape,
// but it means we can safely use this area for our purposes


#if CONFIG_TAPE_TURBO


.label __tape_turbo_bytestore         = STACK
.label __tape_turbo_bytestore_defmap  = __tape_turbo_bytestore + 7
.label __tape_turbo_bytestore_size    = __tape_turbo_bytestore_source_end - tape_turbo_bytestore_source


tape_turbo_bytestore_source:

	// Set all memory as RAM, tape motor ON
	ldx #$00
	stx CPU_R6510

	// Store byte in memory
	sta (MEMUSS), y

	// Restore default memory layout
	ldx #$00                           // value will be determined later, offset from start: 7 bytes
	stx CPU_R6510

	// Go back
	rts

__tape_turbo_bytestore_source_end:


#endif // CONFIG_TAPE_TURBO
