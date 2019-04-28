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

shift_mem_up_routine:
	;; Move memmove_size bytes from memmove_src to memmove_dst,
	;; where memmove_dst > memmove_src
	;; This means we have to copy from the back end down.
	;; This routine assumes the pointers are already pointed
	;; to the end of the areas, and that Y is correctly initialised
	;; to allow the copy to begin.
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
	
	jmp memmap_normal

shift_mem_down_routine:
	;; Move memmove_size bytes from memmove_src to memmove_dst,
	;; where memmove_dst > memmove_src
	;; This means we have to copy from the back end down.
	;; This routine assumes the pointers are already pointed
	;; to the end of the areas, and that Y is correctly initialised
	;; to allow the copy to begin.
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
	
	jmp memmap_normal

	
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
	pha
	lda #$04
	sta $01
	pla
	rts

ram_routines_end:
	.alias ram_routines_len ram_routines_end-ram_routines_start
	
