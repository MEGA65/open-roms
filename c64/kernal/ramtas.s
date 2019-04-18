; Function defined on pp272-273 of C64 Programmers Reference Guide
ramtas:
	; C64 Programmer's Reference guide p291:

	; Clear $0000-$0101, $0200-$03ff
	; PGS: $0000, $0001 are CPU IO ports, so shouldn't get written to
	LDY #$02
	LDA #$00
ramtas_l1:
	STA $02,Y
	INY
	BNE ramtas_l1
ramtas_l2:
	STA $0200,Y
	STA $0300,Y
	INY
	BNE ramtas_l2

	; allocate cassette buffer

	; set screen address to $0400
	; https://www.c64-wiki.com/wiki/Screen_RAM
	; Since we are setting $D018, we also make sure we are using the 
	; ROM character set (C64 Programmer's Reference Guide p322)
	LDA #$14
	STA $D018

	; Make sure we have the correct VIC-II memory bank for the screen to really be at $0400
	; and not $4400, $8400 or $C400
	; https://www.c64-wiki.com/wiki/VIC_bank#Selecting_VIC_banks
	LDA $DD02
	ORA #$03
	STA $DD02
	LDA $DD00
	ORA #$03
	STA $DD00
	
	rts
