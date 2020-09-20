;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 302
; - [CM64] Computes Mapping the Commodore 64 - page 224
; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;
; CPU registers that has to be preserved (see [RG64]): .X, .Y
;


TKSA:

!ifdef CONFIG_MB_MEGA65 {

	jsr m65dos_check
	+bcc m65dos_tksa                     ; branch if device is handeld by internal DOS
}

!ifdef CONFIG_IEC {

	; Due to OPEN/CLOSE/TKSA/SECOND command encoding, allowed channels are 0-15; it is the caller
	; responsibility, hovewer, to provide value ORed with $60
	; - https://www.lemon64.com/forum/viewtopic.php?t=57694&sid=531ba3592bcffadef2ac8b9162f2e529
	; - https://www.pagetable.com/?p=1031 (Kernal API description)

	ora #$90

	jmp common_untlk_tksa

} else {

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
}
