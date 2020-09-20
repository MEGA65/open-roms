;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Official Kernal routine, described in:
;
; - [RG64] C64 Programmers Reference Guide   - page 304
; - [CM64] Computes Mapping the Commodore 64 - page 224
; - https://www.pagetable.com/?p=1031, , https://github.com/mist64/cbmbus_doc
; - http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
;
; CPU registers that has to be preserved (see [RG64]): .X, .Y
;


UNTLK:

!ifdef CONFIG_MB_M65 {

	; According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush

	jsr m65dos_check
	+bcc m65dos_untlk                  ; branch if device is handeld by internal DOS

} else ifdef CONFIG_IEC {

	; According to serial-bus.pdf (page 15) this routine flushes the IEC out buffer
	jsr iec_tx_flush
}


!ifdef CONFIG_IEC {

!ifdef CONFIG_IEC_JIFFYDOS_OR_DOLPHINDOS {

	lda #$FF                           ; do not use JiffyDOS / DolphinDOS anymore, trigger JiffyDOS detection
	sta IECPROTO
}

	; Buffer empty, send the command
	lda #$5F

common_untlk_tksa: ; common part of UNTLK and TKSA

	; XXX - for TKSA, is it really the right place to do a turnaround? I have some doubts
	; (it forces us to send the TKSA command 'manually' sometimes), but
	; Luigi Di Fraia (https://luigidifraia.wordpress.com/2017/06/27/codebase64-on-the-kernal-behaviour/)
	; claims TKSA Kernal routine actually does the turnaround

	sta TBTCNT
	jsr iec_tx_command
	+bcc iec_turnaround_to_listen

	rts

} else {

	jmp kernalerror_ILLEGAL_DEVICE_NUMBER
}
