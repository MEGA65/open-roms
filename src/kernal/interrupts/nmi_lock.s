;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Routine to lock NMI interrupts, using a trick described here:
; - https://codebase64.org/doku.php?id=base:nmi_lock
;


!ifdef CONFIG_TAPE_HEAD_ALIGN {


; XXX consider broader usage of this method to make IO safer


nmi_lock:

	; We will have to change NMI vector to point empty routine,
	; which will not acknowledge the interrupt - thus preventing
	; the NMI to be triggered again
	
	; Our code considers zeropage address invalid, so put
	; it there as a preparation

	ldx #$00
	stx NMINV+1

	; We can now safelly replace the vector

	lda #<return_from_interrupt_rti
	sta NMINV+0
	lda #>return_from_interrupt_rti
	sta NMINV+1

	; Stop timer A

    stx CIA2_CRA ; $DD0E

    ; Set timer A to 0, after starting NMI will occur immediately

	stx CIA2_TIMALO ; $DD04
	stx CIA2_TIMAHI ; $DD05
        
	; Set timer A as source for NMI

    lda #$81
    sta CIA2_ICR ; $DD0D

    ; Start timer A to trigger the NMI

    lda #$01
    sta CIA2_CRA ; $DD0E

    ; All done. Unmaskable interrupts are now masked.

    rts
}
