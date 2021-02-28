;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 274
; - [CM64] Computes Mapping the Commodore 64 - page 224/225
;
; CPU registers that has to be preserved (see [RG64]): .Y
;


ACPTR:

	lda IOSTATUS
	beq @1

	clc
	lda #$0D                           ; tested on real ROMs
	rts
@1:

!ifdef CONFIG_MB_M65 {
	jsr m65dos_check
	+bcc m65dos_acptr                  ; branch if device is handeld by internal DOS
}

!ifdef CONFIG_IEC {
!ifdef CONFIG_IEC_JIFFYDOS {
	jmp iec_rx_dispatch
} else {
	jmp iec_rx_byte
}
} else { ; no CONFIG_IEC
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
}
