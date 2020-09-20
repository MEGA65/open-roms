;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the SAVE routine
;


!ifdef CONFIG_IEC {


save_iec_dev_not_found:
	jmp lvs_device_not_found_error


save_iec:

	; Check file name
	lda FNLEN
	+beq kernalerror_FILE_NAME_MISSING

	; Display SAVING
	jsr lvs_display_saving

	; Call device to LISTEN
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

	; Open channel 1 (reserved for file writing)
	lda #$01
	jsr iec_cmd_open
	bcs save_iec_dev_not_found

	; Send file name
	jsr iec_send_file_name
	bcs save_iec_dev_not_found

	; Call device to LISTEN once again
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

!ifdef HAS_BURST {
	jsr burst_advertise
}

	lda #$61 ; open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcs save_iec_dev_not_found

!ifdef CONFIG_IEC_DOLPHINDOS {
	jsr dolphindos_detect
}

	; Save start address
	lda STAL+0
	sta TBTCNT
	clc
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_tx_dispatch
} else {
	jsr iec_tx_byte
}

	lda STAL+1
	sta TBTCNT
	clc
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_tx_dispatch
} else {
	jsr iec_tx_byte
}

	jsr lvs_STAL_to_MEMUSS
	ldy #$00

	; FALLTROUGH

iec_save_loop:

	; Retrieve byte to send
!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<MEMUSS+0
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_MEMUSS
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (MEMUSS),y
}

	; Send the byte
	sta TBTCNT
	clc
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_tx_dispatch
} else {
	jsr iec_tx_byte
}

	; Next iteration
!ifndef HAS_OPCODES_65CE02 {
	jsr lvs_advance_MEMUSS
} else {
	inw MEMUSS+0
}
	jsr lvs_check_EAL
	bne iec_save_loop

iec_save_loop_end:

	; Close file on drive
	lda FA
	jsr UNLSN

	lda FA
	jsr LISTEN

	lda #$E1 ; CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	; Tell drive to unlisten
	lda FA
	jsr UNLSN

	; Return success
	clc
	rts
}
