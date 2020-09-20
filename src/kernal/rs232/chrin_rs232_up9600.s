;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CHRIN routine
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


chrin_rs232:

	+phy_trash_a
	+phx_trash_a

	lda #$00
	sta XXX_SAVBYTE
    sta RSSTAT
	jsr up9600_rsin
    bcc @1
	+plx_trash_a
	+ply_trash_a
	
	lda #$08    ; XXX don't we have some routine for this?
	sta RSSTAT
    lda #$00
    clc
    rts
@1:
	sta XXX_SAVBYTE

XXX_DOGET4:

	+plx_trash_a
	+ply_trash_a

	lda XXX_SAVBYTE
	clc
	rts


} ; CONFIG_RS232_UP9600
