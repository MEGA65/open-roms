;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Flush the IEC output buffer (if not empty) - send byte with EOI
;
; Preserves .X, .Y and .A registers


!ifdef CONFIG_IEC {


iec_tx_flush:

	pha
	lda C3PO
	beq @1
	sec ; send it with EOI
	jsr iec_tx_byte ; send the command regardless of the status
@1:
	pla
	rts
}
