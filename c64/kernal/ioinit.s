; Function defined on pp272-273 of C64 Programmers Reference Guide
ioinit:

	; Set $00/$01 port mode and value
	; We want BASIC and KERNAL ROMs mapped, and datasette motor off
	; (https://www.c64-wiki.com/wiki/Zeropage)
	LDA #$2F
	STA $00
	LDA #$27
	STA $01

	rts
