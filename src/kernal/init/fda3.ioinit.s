;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE-FLOAT
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 285
; - [CM64] Computes Mapping the Commodore 64 - page 238
;
; CPU registers that has to be preserved (see [RG64]): none
;


IOINIT:

!ifdef SEGMENT_M65_KERNAL_0 {

	jsr map_KERNAL_1
	jsr (VK1__IOINIT)
	jmp m65dos_init 	               ; end by initializing the MEGA65 internal DOS

} else {

	;
	; First initialize the CPU port, to make sure we have correct memory map
	;

	; We want BASIC and KERNAL ROMs mapped, and datasette motor off
	; (https://www.c64-wiki.com/wiki/Zeropage)
	; Work around for VICE bug: Writing $00 before $01 results in rubbish in $01
	; after. https://sourceforge.net/p/vice-emu/bugs/1057/

	ldx #$27
	stx CPU_R6510
	ldx #$2F                           ; checked real ROM value
	stx CPU_D6510

	;
	; Now prevent the CIAs from generating interrupts, who knows what damage they can do
	;

	; Disable IRQ generation for both CIAs - see [CM64], page 149

	ldx #$7F
	stx CIA1_ICR ; $DC0D
	stx CIA2_ICR ; $DD0D

	; See discussion here:
	; https://www.lemon64.com/forum/viewtopic.php?t=41744&sid=e294c254db2ba671cde643f100aae341
	; It seems that initializing this register to $7F is the best idea - UDTIM key scanning
	; also leaves this at $7F

	stx CIA1_PRA ; $DC00

	;
	; Now silence the SID chip(s), depending on the configuration - we want them silent ASAP
	;

	lda #$00

!ifndef CONFIG_MB_M65 {

	; First the standard chip (skip if it is covered by whole $D4XX range)

!ifndef CONFIG_SID_D4XX {
	sta SID_SIGVOL
}

	; Silence manually configured 2nd and 3rd SIDs

!ifdef CONFIG_SID_2ND_ADDRESS {
	sta SID_SIGVOL - __SID_BASE + CONFIG_SID_2ND_ADDRESS
}

!ifdef CONFIG_SID_3RD_ADDRESS {
	sta SID_SIGVOL - __SID_BASE + CONFIG_SID_3RD_ADDRESS
}
	; Silence whole D4XX and D5XX ranges (if configured)

!ifdef CONFIG_SID_D4XX_OR_D5XX {

	ldy #$00
@1:

!ifdef CONFIG_SID_D4XX {
	sta SID_SIGVOL + $000, Y
}
!ifdef CONFIG_SID_D5XX {
	sta SID_SIGVOL + $100, Y
}

	tya
	clc
	adc #$20
	tay
	bne @1

} ; CONFIG_SID_D4XX_OR_D5XX

} else { ; CONFIG_MB_M65

	; MEGA65 specific handling - it contains 4 SIDs

	sta SID_SIGVOL + __SID_R1_OFFSET
	sta SID_SIGVOL + __SID_R2_OFFSET
	sta SID_SIGVOL + __SID_L1_OFFSET
	sta SID_SIGVOL + __SID_L2_OFFSET

}

	;
	; Now continue the CIAs initialization
	;

	; For CIA #1 we need port A as output and port B as input to scan the keyboard

	ldx #$FF
	stx CIA1_DDRA    ; $DC02
	inx
	stx CIA1_DDRB    ; $DC03
	stx CIA2_DDRB    ; $DD03  ; XXX this port is used for RS-232, value here is most likely wrong!

!ifdef CONFIG_KEYBOARD_C65_OR_CAPS_LOCK {

	lda #$02
	sta C65_EXTKEYS_DDR ; output for most keys, input for CAPS LOCK bit
}

	; Set DDR on CIA2 for IEC bus, VIC-II banking (see [CM64], $DDOO description on page 193)
	lda #$3F
	sta CIA2_DDRA    ; $DD02

	; Checked using VICE that original ROM initializes timers this way
	ldx #$08
	stx CIA1_CRB     ; $DC0F
	stx CIA2_CRA     ; $DD0E
	stx CIA2_CRB     ; $DD0F

	; Set VIC-II bank - at least the 'Operacja Proboszcz' game needs this within IOINIT
	; Checked on original ROMs, that it sets bit #2 (RS-232 output) high

	ldx #%00000111 ; XXX adapt this to IEC idle state, JMP at the end won't be needed
	stx CIA2_PRA     ; $DD00

	; Put something sane in the IRQ timer
	jsr setup_irq_timer

	; Enable timer A to run continuously (http://codebase64.org/doku.php?id=base:timerinterrupts)
	ldx #$11
	stx CIA1_CRA     ; $DC0E

	; Enable timer interrupt
	ldx #$81
	stx CIA1_ICR     ; $DC0D

!ifdef CONFIG_IEC {

	; Set IEC bus to its initial idle state
	jmp iec_set_idle

} else {

	rts
}


} ; ROM layout
