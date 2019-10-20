
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

	// Set timer interval to ~1/60th of a second
	
	// Probably NTSC is the default one, as PAL support was introduced later,
	// in a patch - see [CM64] page 242 and page:
	// - http://commodore64.se/wiki/index.php/Commodore_64_KERNAL_ROM_versions
	// "The KERNAL ROM R1 was obviously used only in early NTSC systems. It lacks the PAL/NTSC detection"

	// NTSC C64 (https://codebase64.org/doku.php?id=base:cpu_clocking),
	// is clocked at 1.022727 MHz, so that 1/60s is 17045 CPU cycles

	ldy #<17045
	ldx #>17045

	sty CIA1_TIMALO
	stx CIA1_TIMAHI

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

	// Set DDR on CIA2 for IEC bus, VIC-II banking
	lda #$3F
	sta CIA2_DDRA

	// Set IEC bus to its initial idle state
	jmp iec_set_idle

