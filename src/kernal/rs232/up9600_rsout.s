;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Put byte to serial interface
;

; Based on UP9600 code by Daniel Dallman with Bo Zimmerman adaptations


!ifdef CONFIG_RS232_UP9600 {


up9600_rsout:

	pha
	sta $9E     ; XXX synchronize with aliases
	cmp #$80
	and #$7F
	stx $A8     ; XXX synchronize with aliases
	sty $A7     ; XXX synchronize with aliases
	tax
	jsr up9600_rsout_time
	
	lda REVTAB, x
	adc #$00
	lsr
	sei
	sta CIA1_SDR ; $DC0C
	lda #$02
	sta XXX_OUTSTAT
	ror
	ora #$7F
	sta CIA1_SDR ; $DC0C
	cli
	ldx $A8    ; XXX synchronize with aliases
	ldy $A7    ; XXX synchronize with aliases
	pla
	rts
	
up9600_rsout_time:

	cli
	lda #$FD
	sta TIME+2 ; XXX check if this is the lowest byte
	
rs232_rsout_wait:

	lda XXX_OUTSTAT
	beq @1
	bit TIME+2
	bmi up9600_rsout_wait
@1:
	jmp $F490 ; XXX 
}

