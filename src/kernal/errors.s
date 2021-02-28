;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


; Kernal error codes are described in 'Commodore 64 Programmers Reference Guide', page 306

kernalerror_ROUTINE_TERMINATED: ; by a STOP key

	lda #K_ERR_ROUTINE_TERMINATED
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_TOO_MANY_OPEN_FILES:

	lda #K_ERR_TOO_MANY_OPEN_FILES
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_ALREADY_OPEN:

	lda #K_ERR_FILE_ALREADY_OPEN
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_NOT_OPEN:

	lda #K_ERR_FILE_NOT_OPEN
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_NOT_FOUND:

	lda #K_ERR_FILE_NOT_FOUND
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_DEVICE_NOT_FOUND:

	lda #K_ERR_DEVICE_NOT_FOUND
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_NOT_INPUT:

	lda #K_ERR_FILE_NOT_INPUT
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_NOT_OUTPUT:

	lda #K_ERR_FILE_NOT_OUTPUT
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_FILE_NAME_MISSING:

	lda #K_ERR_FILE_NAME_MISSING
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

kernalerror_ILLEGAL_DEVICE_NUMBER:

	lda #K_ERR_ILLEGAL_DEVICE_NUMBER
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

!ifdef CONFIG_IEC_JIFFYDOS {

kernalerror_IEC_TIMEOUT_READ:

    lda #K_STS_TIMEOUT_READ
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

} ; CONFIG_IEC_JIFFYDOS

kernalerror_TOP_MEM_RS232:

	lda #K_ERR_TOP_MEM_RS232

!ifdef CONFIG_MB_M65 {
	; Restore the proper speed
	jsr m65_speed_restore
}
	sec
	rts
