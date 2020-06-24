// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


#if CONFIG_MEMORY_MODEL_46K ||CONFIG_MEMORY_MODEL_50K


peek_under_roms_MEMUSS:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (MEMUSS), y

	// FALLTROUGH

peek_under_roms_finalize:

	// Store value in a safe place

	tax

	// Restore memory mapping

	pla
	sta CPU_R6510

	// Retrieve value and quit

	txa
	rts


peek_under_roms_FNADDR:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (FNADDR), y

	// Continue using common code

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif


peek_under_roms_EAL:

	// Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	// Retrieve value from under ROMs

	lda (EAL), y

	// Continue using common code

#if HAS_OPCODES_65C02
	bra peek_under_roms_finalize
#else
	jmp peek_under_roms_finalize
#endif


#elif CONFIG_MEMORY_MODEL_60K


// IMPORTANT:
// These routines lengths cannot be changed without changing
// the aliases for peek_under_roms, poke_under_roms, etc.
// Thus those addresses are expressed using formulae.

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


#endif
