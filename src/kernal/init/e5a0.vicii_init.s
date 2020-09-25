;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE-FLOAT
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   *        #IGNORE

;
; Well-known Kernal routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - page 215
;


vicii_init:

!ifdef SEGMENT_M65_KERNAL_0 {

	jsr map_KERNAL_1
	jsr (VK1__vicii_init)
	jmp map_NORMAL

} else {

	; Clear everything - turn off sprites (observed hanging around after
 	; running programs and resetting), etc.

	lda #$00
 	ldx #$2E
@1:
 	sta __VIC_BASE, x
 	dex
 	bpl @1

!ifndef CONFIG_MB_M65 { !ifndef CONFIG_MB_U64 {

 	; Disable C128 extra keys - just to be sure they will not interfere with anything

 	stx VIC_XSCAN

 	; Disable the C128 2MHz mode, it prevents VIC-II display from working correctly

 	stx VIC_CLKRATE
} }

	; Set up default IO values
	; - [CM64] page 129       - VIC_SCROLY
	; - [CM64] pages 140-144  - VIC_SCROLX
	; - [CM64] pages 145-146  - VIC_YMCSB

	lda #$1B                           ; according to [CM64] page 137 some software assumes oldest bit is 0
	sta VIC_SCROLY
	lda #$C8
	sta VIC_SCROLX                     ; 40 column, etc.
	lda #$14
	sta VIC_YMCSB
	lda #$0F
	sta VIC_IRQ                        ; clear all interrupts

	; We use a different colour scheme of white text on all blue by default,
	; but brand-specific color scheme can also be enabled

	lda #CONFIG_COLOR_BG
	sta VIC_EXTCOL
	sta VIC_BGCOL0

	; Setup default I/O devices

!ifdef CONFIG_IEC {
	jmp clrchn_reset
} else {
	jmp CLRCHN
}

} ; ROM layout
