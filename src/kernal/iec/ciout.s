;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 279/280
; - [CM64] Computes Mapping the Commodore 64 - page 224
;
; CPU registers that has to be preserved (see [RG64]): .X, .Y
;


CIOUT:

!ifdef CONFIG_IEC {

	pha
	lda C3PO
	bne ciout_send_byte

	; Nothing to send - set buffer as valid, store byte there
	inc C3PO

	; Clear carry flag to indicate success
	clc
	
ciout_store_in_buffer:

	; Store in the buffer data to be sent next, return
	pla
	sta BSOUR
	rts
	
ciout_send_byte:

!ifdef CONFIG_MB_M65 {
	jsr m65dos_check
	+bcc m65dos_ciout                  ; branch if device is handeld by internal DOS
}

	clc                                ; send without EOI
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_tx_dispatch
} else {
	jsr iec_tx_byte
}
	inc C3PO                           ; tx byte routine sets to 0, but we still have something to send
	jmp ciout_store_in_buffer

} else {

	sec ; indicate failure
	rts
}
