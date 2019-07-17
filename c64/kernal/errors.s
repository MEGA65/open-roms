
;; Kernal error codes are described in 'Commodore 64 Programmer's Reference Guide', page 306

kernalerror_ROUTINE_TERMINATED: ; by a STOP key
	lda #K_ERR_ROUTINE_TERMINATED
	sec
	rts

kernalerror_TOO_MANY_OPEN_FILES:
	lda #K_ERR_TOO_MANY_OPEN_FILES
	sec
	rts

kernalerror_FILE_ALREADY_OPEN:
	lda #K_ERR_FILE_ALREADY_OPEN
	sec
	rts

kernalerror_FILE_NOT_OPEN:
	lda #K_ERR_FILE_NOT_OPEN
	sec
	rts

kernalerror_FILE_NOT_FOUND:
	lda #K_ERR_FILE_NOT_FOUND
	sec
	rts

kernalerror_DEVICE_NOT_FOUND:
	lda #K_ERR_DEVICE_NOT_FOUND
	sec
	rts

kernalerror_FILE_NOT_INPUT:
	lda #K_ERR_FILE_NOT_INPUT
	sec
	rts

kernalerror_FILE_NOT_OUTPUT:
	lda #K_ERR_FILE_NOT_OUTPUT
	sec
	rts

kernalerror_FILE_NAME_MISSING:
	lda #K_ERR_FILE_NAME_MISSING
	sec
	rts

kernalerror_ILLEGAL_DEVICE_NUMBER:
	lda #K_ERR_ILLEGAL_DEVICE_NUMBER
	sec
	rts

kernalerror_TOP_MEM_RS232:
	lda #K_ERR_TOP_MEM_RS232
	sec
	rts

;; Kernal status codes are described in 'Commodore 64 Programmer's Reference Guide', page 292

kernalstatus_reset:
	lda #$00
	sta IOSTATUS
	rts

kernalstatus_TIMEOUT_WRITE: ;; XXX detect this!
	lda IOSTATUS
	ora #K_STS_TIMEOUT_WRITE
	sta IOSTATUS
	rts

kernalstatus_TIMEOUT_READ: ;; XXX detect this!
	lda IOSTATUS
	ora #K_STS_TIMEOUT_READ
	sta IOSTATUS
	rts

kernalstatus_EOI:
	lda IOSTATUS
	ora #K_STS_EOI
	sta IOSTATUS
	rts

kernalstatus_DEVICE_NOT_FOUND:
	lda IOSTATUS
	ora #K_STS_DEVICE_NOT_FOUND
	sta IOSTATUS
	rts
