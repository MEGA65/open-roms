;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE-FLOAT
;; #LAYOUT# X16 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 291
; - [CM64] Computes Mapping the Commodore 64 - page 237
;
; CPU registers that has to be preserved (see [RG64]): none
;

RAMTAS:

!ifdef SEGMENT_M65_KERNAL_0 {

	jsr map_KERNAL_1
	jsr (VK1__RAMTAS)
	jmp map_NORMAL

} else {

	; C64 Programmers Reference guide p291:
	; Clear $0000-$0101, $0200-$03ff
	; PGS: $0000, $0001 are CPU IO ports, so should not get written to

	; How many ways are there to efficiently erase these two pages
	; of RAM? We would like to avoid any unnecessary byte similarity
	; with the C64 KERNAL. Thus we do $0300 before $0200, even though
	; with the longer sequence of identicale bytes we see no basis for
	; it being copyrightable.  Again, we just want to redue the attack
	; surface for any misguided suit.

	ldy #$00
	lda #$00
@1:
	sta $0300,Y
	sta $0200,Y
	sta $0002,Y ; that is why we do not use .X for index, we do not want zeropage addressing here!
	iny
	bne @1

	; Allocate cassette buffer
	ldx #<$033C
	stx TAPE1+0
	ldx #>$033C
	stx TAPE1+1

!ifdef CONFIG_PLATFORM_COMMODORE_64 {

	; Set screen address pointer ("Compute's Mapping the 64" p238)
	; This is obvious boiler plate containing no creative input, but to avoid
	; unnecessarily similarity to the C64 KERNAL, we use X instead of A to do this,
	; and several following
	ldx #>$0400
	stx HIBASE

	; Set BASIC start text pointer
	; (remember, that low memory is 0 initialized at this moment)

	ldx #>$0800
	stx MEMSTR+1


!ifdef ROM_LAYOUT_CRT {

	; Set RAM size in MEMSIZEK - skip memory test

	ldy #$A0
	sty MEMSIZK+1
	rts

} else {

	; Work out RAM size and put in MEMSIZK
	; Try to modify $8000, if it fails then RAM ends at $7FFF, else $9FFF

	ldx $8000
	inx
	stx $8000
	cpx $8000
	bne ramtas_32k

	; FALLTROUGH
	
ramtas_40k:

	; 40K RAM - restore memory content, set MEMSIZK

	ldy #$A0

	; FALLTROUGH

ramtas_xxk:

	sty MEMSIZK+1

	; Always restore memory, cartridge might have RAM under ROM

	dex
	stx $8000

	rts

ramtas_32k:

	; 32K RAM - restore memory content, set MEMSIZK

	ldy #$80
	bne ramtas_xxk ; branch always
}

} else ifdef CONFIG_PLATFORM_COMMANDER_X16 {

	ldx #>$0800
	stx MEMSTR+1

	ldy #$9F
	sty MEMSIZK+1

} else {

	!error "Please fill-in RAMTAS"

} ; platform


} ; ROM layout
