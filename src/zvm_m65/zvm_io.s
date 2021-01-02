
;
; Z80 Virtual Machine - I/O access
;


ZVM_fetch_IO:

	; XXX fetch addresses via ADDR_IO - but which ones are safe?
	;     should we have a whitelist?
	
	lda #$00
	sta REG_A
	rts

ZVM_store_IO:

	; XXX again, we should have a whitelist of addresses

	rts
