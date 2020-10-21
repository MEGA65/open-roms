;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; Register meaning according to http://wiki.icomp.de/wiki/Retro_Replay
;
; $DE00 - write:
; bit 7 - bit 15 of ROM bank address
; bit 6 - needed by freeze, not useful for Open ROMs
; bit 5 - 0 = ROM, 1 = RAM
; bit 4 - bit 14 of ROM/RAM bank address
; bit 3 - bit 13 of ROM/RAM bank address
; bit 2 - 1 = disable cartridge
; bit 1 - EXROM, 0 = assert
; bit 0 - GAME, 0 = assert
;
; $DE01 - write:
; bit 7 - bit 15 of ROM bank address
; bit 6 - 1 = REU compatible memory map
; bit 5 - needed by flash mode, not useful for Open ROMs
; bit 4 - bit 14 of ROM/RAM bank address
; bit 3 - bit 13 of ROM/RAM bank address
; bit 2 - NoFreeze, 1 = disable freeze function
; bit 1 - AllowBank, 1 = enables banking of RAM in $DF00/$DE02 area
; bit 0 - 1 = enables accessory connector
;
; $DE00 / $DE01 - read:
; bit 7 - bit 15 of ROM bank address
; bit 6 - 1 = REU compatible memory map
; bit 5 - needed by flash mode, not useful for Open ROMs
; bit 4 - bit 14 of ROM/RAM bank address
; bit 3 - bit 13 of ROM/RAM bank address
; bit 2 - 1 = FREEZE button pressed
; bit 1 - AllowBank
; bit 0 - 1 = flash mode activated by jumper


crt_init:

	; Setup the cart

	lda #%01000100           ; REU compatible memory map, no freezing
	sta $DE01

	; Bank-in the first ROM bank

	lda #%00000000
	sta $DE00

	; Check if ROM revision matches the cartridge
	
	ldy #$FF
@1:
	iny
	lda $E4B9, y            ; Kernal ROM revision address
	cmp $9FEC, y
	bne crt_init_fail
	cmp #$00
	bne @1

	; Unmap cartridge memory     XXX provide separate map functions

	lda #%00000010
	sta $DE00

	rts

crt_init_fail:

	+panic P_ERR_ROM_MISMATCH
