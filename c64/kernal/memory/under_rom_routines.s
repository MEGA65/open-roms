#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// IMPORTANT:
// These routines lengths cannot be changed without changing
// the aliases for peek_under_roms, poke_under_roms etc
// in ,aliases.s.
// Thus those addresses are expressed using formulae.

#if CONFIG_MEMORY_MODEL_60K

install_ram_routines:
	// Copy routines into place
	ldx #__ram_routines_end-__ram_routines_start-1
!:
	lda __ram_routines_start,x
	sta tiny_nmi_handler,x
	dex
	bpl !-

	// Point NMI handler to tiny_nmi_handler
	lda #<tiny_nmi_handler
	sta $FFFE
	lda #>tiny_nmi_handler
	sta $FFFF

	rts

__ram_routines_start:

tiny_nmi_handler_routine:
	inc missed_nmi_flag
	rti
peek_under_roms_routine:
	php
	// Offset of arg of lda ($00),y	
	stx peek_under_roms+pa-peek_under_roms_routine+1
	jsr memmap_allram
pa:	lda ($00),y
	jsr memmap_normal
	plp
	rts

poke_under_roms_routine:
	php
	// Offset of arg of lda ($00),y	
	stx poke_under_roms+pb-poke_under_roms_routine+1
	jsr memmap_allram
pb:	sta ($00),y
	jsr memmap_normal
	plp
	rts

memmap_normal_routine:
	pha
	lda #$37
	sta $01
	pla
	rts

memmap_allram_routine:
	sei
	pha
	lda #$04
	sta $01
	pla
	rts

__ram_routines_end:

#endif // CONFIG_MEMORY_MODEL_60K


#endif // ROM layout
