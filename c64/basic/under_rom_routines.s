// IMPORTANT:
// These routines lengths cannot be changed without changing
// the aliases for peek_under_roms, poke_under_roms etc
// in ,aliases.s.
// Thus those addresses are expressed using formulae.

#if CONFIG_MEMORY_MODEL_60K

install_ram_routines:
	// Copy routines into place
	ldx #ram_routines_end-ram_routines_start-1
!:
	lda ram_routines_start,x
	sta tiny_nmi_handler,x
	dex
	bpl !-

	// Point NMI handler to tiny_nmi_handler
	lda #<tiny_nmi_handler
	sta $FFFE
	lda #>tiny_nmi_handler
	sta $FFFF

	rts

ram_routines_start:	

	// XXX - Routine order must match that of the KERNAL version of the file.
	// (since it has fewer routines)
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

shift_mem_up_routine:
	// Move memmove_size bytes from memmove_src to memmove_dst,
	// where memmove_dst > memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.
	php
	jsr memmap_allram
smu1:	
	lda (memmove_src),y
	sta (memmove_dst),y
	dey
	bne smu1
	dec memmove_src+1
	dec memmove_dst+1
	dec memmove_size+1
	bne smu1
	plp
	jmp memmap_normal

shift_mem_down_routine:
	// Move memmove_size bytes from memmove_src to memmove_dst,
	// where memmove_dst > memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.
	php
	jsr memmap_allram
smd1:
	lda (memmove_src),y
	sta (memmove_dst),y
	iny
	bne smd1
	inc memmove_src+1
	inc memmove_dst+1
	dec memmove_size+1
	bne smd1
	plp
	jmp memmap_normal

ram_routines_end:

#else // CONFIG_MEMORY_MODEL_60K

shift_mem_up:
	// Move memmove_size bytes from memmove_src to memmove_dst,
	// where memmove_dst > memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.
	php
smu1:	
	lda (memmove_src),y
	sta (memmove_dst),y
	dey
	bne smu1
	dec memmove_src+1
	dec memmove_dst+1
	dec memmove_size+1
	bne smu1
	plp
	rts

shift_mem_down:
	// Move memmove_size bytes from memmove_src to memmove_dst,
	// where memmove_dst > memmove_src
	// This means we have to copy from the back end down.
	// This routine assumes the pointers are already pointed
	// to the end of the areas, and that Y is correctly initialised
	// to allow the copy to begin.
	php
smd1:
	lda (memmove_src),y
	sta (memmove_dst),y
	iny
	bne smd1
	inc memmove_src+1
	inc memmove_dst+1
	dec memmove_size+1
	bne smd1
	plp
	rts

#endif
