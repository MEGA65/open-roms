;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 285
; - [CM64] Computes Mapping the Commodore 64 - page 223
; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
; - http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
;
; CPU registers that has to be preserved (see [RG64]): .X, .Y
;


LISTEN:

!ifdef CONFIG_MB_M65 {

	; According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush

	jsr m65dos_detect
	+bcc m65dos_listen                   ; branch if device is handeld by internal DOS

} else ifdef CONFIG_IEC {

	; According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush
}


!ifdef CONFIG_IEC {

	; Check whether device number is correct
	jsr iec_check_devnum_oc
	bcc @1
	jmp kernalerror_DEVICE_NOT_FOUND
@1:
	; Encode and execute the command
	ora #$20

	jmp common_talk_listen

} else {

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
}
