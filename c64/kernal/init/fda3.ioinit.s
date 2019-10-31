
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 285
// - [CM64] Compute's Mapping the Commodore 64 - page 238
//
// CPU registers that has to be preserved (see [RG64]): none
//


IOINIT:

	// Set $00/$01 port mode and value
	// We want BASIC and KERNAL ROMs mapped, and datasette motor off
	// (https://www.c64-wiki.com/wiki/Zeropage)
	// Work around for VICE bug: Writing $00 before $01 results in rubbish in $01
	// after. https://sourceforge.net/p/vice-emu/bugs/1057/
	lda #$27
	ldx #$2F
	sta CPU_R6510
	stx CPU_D6510

	// Silence the SID chips, depending on the configuration

#if !CONFIG_SID_D4XX
	lda SID_SIGVOL
	and #$F0
	sta SID_SIGVOL
#endif // !CONFIG_SID_D4XX

#if CONFIG_SID_D4XX || CONFIG_SID_D5XX
	ldy #$00
!:

#if CONFIG_SID_D4XX 
	lda SID_SIGVOL, Y
	and #$F0
	sta SID_SIGVOL, Y
#endif // CONFIG_SID_D4XX

#if CONFIG_SID_D5XX 
	// SIDs under $D5xx
	lda SID_SIGVOL + $100, Y
	and #$F0
	sta SID_SIGVOL + $100, Y
#endif // CONFIG_SID_D4XX

	tya
	clc
	adc #$20
	tay
	bne !-
#endif // CONFIG_SID_D4XX || CONFIG_SID_D5XX

#if CONFIG_SID_2ND
	lda SID_SIGVOL - __SID_BASE + CONFIG_SID_2ND_ADDRESS
	and #$F0
	sta SID_SIGVOL - __SID_BASE + CONFIG_SID_2ND_ADDRESS
#endif // CONFIG_SID_2ND

#if CONFIG_SID_3RD
	lda SID_SIGVOL - __SID_BASE + CONFIG_SID_3RD_ADDRESS
	and #$F0
	sta SID_SIGVOL - __SID_BASE + CONFIG_SID_3RD_ADDRESS
#endif // CONFIG_SID_3RD

    // Initialize CIAs

	// XXX: calibrate TOD for both CIA's, see here: https://codebase64.org/doku.php?id=base:efficient_tod_initialisation

	// Enable CIA1 IRQ and ~50Hz timer (https://csdb.dk/forums/?roomid=11&topicid=69037)
	
	// First disable IRQ generation for both CIA's
	lda #$7F
	sta CIA2_ICR
	sta CIA1_ICR

	// Enable timer interrupt
	lda #$81
	sta CIA1_ICR

	// Enable timer A to run continuously (http://codebase64.org/doku.php?id=base:timerinterrupts)
	lda #$11
	sta CIA1_CRA
	lda CIA1_ICR

	// Setup the CIA1 for reading the keyboard - 'POKE 56322, 0' on original ROMs proves this
	// is done during initialization, not during the interrupt

	ldx #$FF
	stx CIA1_DDRA  // output
	inx            // $00
	stx CIA1_DDRB  // input

	// Value checked on original ROM
	stx CIA2_DDRA

#if CONFIG_KEYBOARD_C65 || CONFIG_KEYBOARD_C65_CAPS_LOCK

	lda #$02
	sta C65_EXTKEYS_DDR // output for most keys, input for CAPS LOCK bit

#endif

	// Set DDR on CIA2 for IEC bus, VIC-II banking
	lda #$3F
	sta CIA2_DDRA

	// Set VIC-II bank - needed at least for 'Operacja Proboszcz' game
	lda #%00000011
	sta CIA2_PRA

#if CONFIG_IEC

	// Set IEC bus to its initial idle state
	jmp iec_set_idle

#else

	rts

#endif
