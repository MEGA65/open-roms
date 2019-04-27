	;; IMPORTANT:
	;; These routines lengths cannot be changed without changing
	;; the aliases for peek_under_roms, poke_under_roms etc
	;; in ,aliases.s.
	;; Thus those addresses are expressed using formulae.

install_ram_routines:
	;; Copy routines into place
	ldx #ram_routines_len-1
*
	lda ram_routines_start,x
	sta tiny_nmi_handler,x
	dex
	bpl -

	;; Point NMI handler to tiny_nmi_handler
	lda #<tiny_nmi_handler
	sta $FFFE
	lda #>tiny_nmi_handler
	sta $FFFF

	rts
	
ram_routines_start:	

tiny_nmi_handler_routine:
	inc missed_nmi_flag
	rti

peek_under_roms_routine:
	stx peek_under_roms+7 	;Offset of arg of lda ($00),y
	jsr memmap_allram
	lda ($00),y
	jmp memmap_normal

poke_under_roms_routine:
	stx poke_under_roms+7 	;Offset of arg of lda ($00),y
	jsr memmap_allram
	sta ($00),y
	;; FALL THROUGH
memmap_normal_routine:
	pha
	lda #$37
	sta $01
	pla
	cli
	rts

memmap_allram_routine:
	sei
	lda #$04
	sta $01
	rts

ram_routines_end:
	.alias ram_routines_len ram_routines_end-ram_routines_start
	
