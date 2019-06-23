
;; Kernal error codes are described in 'Commodore 64 Programmer's Reference Guide', page 306

kernalerror_common:
	sta DFLTN
	sec
	rts

kernalerror_ROUTINE_TERMINATED: ; by a STOP key
	lda #$00
	jmp kernalerror_common

kernalerror_TOO_MANY_OPEN_FILES:
	lda #$01
	jmp kernalerror_common

kernalerror_FILE_ALREADY_OPEN:
	lda #$02
	jmp kernalerror_common

kernalerror_FILE_NOT_OPEN:
	lda #$03
	jmp kernalerror_common

kernalerror_FILE_NOT_FOUND:
	lda #$04
	jmp kernalerror_common

kernalerror_DEVICE_NOT_FOUND:
	lda #$05
	jmp kernalerror_common

kernalerror_FILE_NOT_INPUT:
	lda #$06
	jmp kernalerror_common

kernalerror_FILE_NOT_OUTPUT:
	lda #$07
	jmp kernalerror_common

kernalerror_FILE_NAME_MISSING:
	lda #$08
	jmp kernalerror_common
	
kernalerror_ILLEGAL_DEVICE_NUMBER:
	lda #$09
	jmp kernalerror_common

kernalerror_TOP_MEM_RS232:
	lda #$F0
	sta RSSTAT
	sec
	rts
