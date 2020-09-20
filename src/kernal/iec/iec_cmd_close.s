;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Kernal internal IEC routine
;
; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;


!ifdef CONFIG_IEC {


iec_cmd_close:

	jsr iec_check_channel_openclose
	+bcs kernalerror_FILE_NOT_INPUT

	ora #$E0

!ifdef CONFIG_MB_M65 {

	jsr m65dos_check
	+bcc m65dos_second                 ; branch if device is handeld by internal DOS
}

	jmp common_open_close_unlsn_second
}
