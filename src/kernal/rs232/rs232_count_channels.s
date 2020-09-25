;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Sets .X to number of open RS-232 channels
;


!ifdef HAS_RS232 {


rs232_count_channels:

	ldx #$00
	ldy LDTND
@1:
	dey
	bmi @2
	lda FAT, y
	cmp #$02
	bne @1
	inx
	bpl @1 ; branch always
@2:
	rts
}

