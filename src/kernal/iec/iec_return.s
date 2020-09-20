;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routines to return with error/success
;
; All of them restore X/Y registers from stack,
; they take care about Carry flag,
; error return reeset IEC line to default state,
; take care about .A and IOSTATUS
;


!ifdef CONFIG_IEC {


iec_return_success:

	; BSOUR is certainly not valid anymore
	lda #$00
	sta C3PO
	; Restore registers
	+ply_trash_a
	+plx_trash_a
	; Report success
	clc
	rts

iec_return_DEVICE_NOT_FOUND:

	; Set IEC line to normal idle state
	jsr iec_set_idle
	; BSOUR is certainly not valid anymore
	lda #$00
	sta C3PO
	; Restore registers
	+ply_trash_a
	+plx_trash_a
	; Report error
	jmp kernalerror_DEVICE_NOT_FOUND
}
