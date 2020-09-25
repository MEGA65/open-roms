;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmer's Reference Guide   - page 295
; - [CM64] Compute's Mapping the Commodore 64 - page 215
;
; CPU registers that has to be preserved (see [RG64]): .A
;


SCREEN:

!ifndef CONFIG_MB_M65 {

	; There are only 2 sane ways to implement this routine,
	; I hope this one is different than what Commodore picked :)

	ldy #25 ; 25 columns
	ldx #40 ; 40 rows

	rts

} else {

	php
	jsr M65_MODEGET
	bcc @1

	plp

	ldy #25 ; 25 columns
	ldx #40 ; 40 rows

	rts
@1:
	; Screen dimensions depends on text mode

	plp
	pha
	ldy M65_SCRMODE

	ldx m65_scrtab_txtwidth, y
	lda m65_scrtab_txtheight, y
	tay

	pla
	rts
}