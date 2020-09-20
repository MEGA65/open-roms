;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Kernal internal IEC routine
;
; - https://www.pagetable.com/?p=1031, https://github.com/mist64/cbmbus_doc
;


!ifdef CONFIG_IEC {


iec_cmd_open: ; similar to TKSA, but without turnaround

	jsr iec_check_channel_openclose
	+bcs kernalerror_FILE_NOT_INPUT

	ora #$F0

!ifdef CONFIG_MB_M65 {

	jsr m65dos_check
	+bcc m65dos_second                 ; branch if device is handeld by internal DOS
}

!ifdef HAS_IEC_BURST {
	pha
	jsr burst_advertise
	pla
}

!ifdef CONFIG_IEC_DOLPHINDOS {

	sta TBTCNT
	jsr iec_tx_command
	bcs common_open_close_unlsn_second_done
	jsr dolphindos_detect

	jmp iec_tx_command_finalize
}
	; FALLTROUGH

common_open_close_unlsn_second: ; common part of several commands

	sta TBTCNT
	jsr iec_tx_command
	+bcc iec_tx_command_finalize

	// FALLTROUGH

common_open_close_unlsn_second_done:

	rts

iec_check_channel_openclose:
	; Due to OPEN/CLOSE/TKSA/SECOND command encoding (see https://www.pagetable.com/?p=1031),
	; allowed channels are 0-15; report error if out of range
	cmp #$10
	bcc @1
	; Workaround to allow reading executable files and disk directory
	; using OPEN routine - see https://www.pagetable.com/?p=273 for
	; example usage
	cmp #$60
	beq @1
	sec ; mark unsuitable channel number
	rts
@1:
	clc ; mark suitable channel number
	rts
}

