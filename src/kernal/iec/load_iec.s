;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the LOAD routine
;


!ifdef CONFIG_IEC {


load_iec_dev_not_found:
	jmp lvs_device_not_found_error

load_iec_error:
	lda FA
	jsr iec_close_load
	jmp lvs_load_verify_error 

load_iec_break_error:
	pla
	lda FA
	jsr iec_close_load
	jmp kernalerror_ROUTINE_TERMINATED 


load_iec:

	; Check file name
	lda FNLEN
	+beq kernalerror_FILE_NAME_MISSING

	; Display SEARCHING FOR + filename
	jsr lvs_display_searching_for

	; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	; p13, 16; also p16 tells us this routine does not mess with the file
	; table in the C64, only in the drive.

	; Call device to LISTEN (p16)
	lda FA
	jsr LISTEN
	bcs load_iec_dev_not_found

	; Open channel 0 (reserved for file reading)
	lda #$00
	jsr iec_cmd_open
	bcs load_iec_dev_not_found

	; Send file name
	jsr iec_send_file_name
	bcs load_iec_error

	; Now command device to talk (p16)
	lda FA
	jsr TALK
	bcs load_iec_error

!ifdef HAS_IEC_BURST {
	jsr burst_advertise
}

	lda #$60 ; open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcs load_iec_error

!ifdef CONFIG_IEC_DOLPHINDOS {
	jsr dolphindos_detect
}

	; We are currently talker, so do the IEC turn around so that we
	; are the listener (p16)
	jsr iec_turnaround_to_listen
	bcs load_iec_error

	; Get load address

	jsr load_iec_get_addr_byte
	sta EAL+0

	jsr load_iec_get_addr_byte
	sta EAL+1

	; If secondary address is 0, override EAL with STAL

	lda SA
	bne @1
	lda STAL+0
	sta EAL+0
	lda STAL+1
	sta EAL+1	
@1:
!ifdef CONFIG_MB_M65 {

	; Switch to legacy mode if needed

	jsr m65_load_autoswitch
}

	; Display start address

	jsr lvs_display_loading_verifying

!ifdef CONFIG_IEC_JIFFYDOS_OR_DOLPHINDOS { !ifndef CONFIG_MEMORY_MODEL_60K {

	; If feasible, use protocol-specific optimized LOAD loop

	lda VERCKK
	bne load_iec_loop                  ; branch if VERIFY
	lda IECPROTO

!ifdef CONFIG_IEC_JIFFYDOS {
	cmp #IEC_JIFFY
	+beq jiffydos_load                 ; branch if JiffyDOS
}

!ifdef CONFIG_IEC_DOLPHINDOS {
	cmp #IEC_DOLPHIN
	+beq dolphindos_load               ; branch if DolphinDOS
}

} }


load_iec_loop:

	; We are now ready to receive bytes
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_rx_dispatch
} else {
	jsr iec_rx_byte
}
	bcs load_iec_error

	; Handle the byte (store in memory / verify)
	jsr lvs_handle_byte_load_verify
	bcs load_iec_error

	; Advance pointer to data; it is OK if it advances past $FFFF,
	; one autostart technique does exactly this
!ifndef HAS_OPCODES_65CE02 {
	inc EAL+0
	bne @2
	inc EAL+1
@2:
} else {
	inw EAL+0
}

	; Handle STOP key; it is probably an overkill to do it
	; with every byte, once per 32 bytes should be enough
	lda EAL
	and #$1F
	bne @3
	+phx_trash_a
	jsr udtim_keyboard
	jsr STOP
	+bcs load_iec_break_error
	+plx_trash_a
@3:
	; Check for EOI - if so, this was the last byte
	bit IOSTATUS
	bvc load_iec_loop

	; FALLTROUGH

load_iec_loop_end:

	; Display end address
	jsr lvs_display_done

	; Close file on drive

	lda FA
	jsr iec_close_load

	; Return last address
	jmp lvs_return_last_address


load_iec_get_addr_byte:

!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_rx_dispatch
} else {
	jsr iec_rx_byte
}
	bcs @4
	lda IOSTATUS
	and #K_STS_EOI
	bne @4
	lda TBTCNT
	rts
@4:
	pla
	pla

	; FALLTROUGH

load_iec_file_not_found:

	lda FA
	jsr iec_close_load
	jmp kernalerror_FILE_NOT_FOUND


} ; CONFIG_IEC
