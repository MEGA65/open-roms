;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Sends file (stream) name to IEC device
;


!ifdef CONFIG_IEC {


iec_send_file_name:
	ldy #0

iec_send_file_name_loop:
	cpy FNLEN
	beq iec_send_file_name_done

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<FNADDR+0
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_FNADDR
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (FNADDR),y
}

	iny
	; Set Carry flag on the last file name character, to mark EOI
	cpy FNLEN
	clc
	bne @1
	sec
@1:
	; Transmit one character
	sta TBTCNT
!ifdef CONFIG_IEC_JIFFYDOS {
	jsr iec_tx_dispatch
} else {
	jsr iec_tx_byte
}
	jmp iec_send_file_name_loop

iec_send_file_name_done:
	jmp UNLSN
}
