; Function defined on pp272-273 of C64 Programmers Reference Guide

listen:

	;; This trivial routine is documented in 'Compute's Mapping the Commodore 64', page 223
	ora $20
	jmp iec_tx_byte
