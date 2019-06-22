; Function defined on pp272-273 of C64 Programmers Reference Guide

listen:

	;; This trivial routine is documented in 'Compute's Mapping the Commodore 64', page 223 and
	;; https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
	and #$1F ; make sure bits encoding the command are cleared out
	ora #$20
	jmp iec_tx_command
