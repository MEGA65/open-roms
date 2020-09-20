;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 296
; - [CM64] Computes Mapping the Commodore 64 - page 223/224
; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
;
; CPU registers that has to be preserved (see [RG64]): .X, .Y
;


; XXX cleanup: iec_cmd_open and iec_cmd_close should just do ORA and jump directly here


SECOND:

!ifdef CONFIG_MB_M65 {

	jsr m65dos_check
	+bcc m65dos_second                   ; branch if device is handeld by internal DOS
}

!ifdef CONFIG_IEC {

	; Due to OPEN/CLOSE/TKSA/SECOND command encoding, allowed channels are 0-15; it is the caller
	; responsibility, hovewer, to provide value ORed with $60
	; - https://www.lemon64.com/forum/viewtopic.php?t=57694&sid=531ba3592bcffadef2ac8b9162f2e529
	; - https://www.pagetable.com/?p=1031 (Kernal API description)

	jmp common_open_close_unlsn_second

} else {

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
}
