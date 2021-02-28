
; Set current status or error


; XXX add code for handling the LEDs


; .A = status to set

util_status_SD:

	ldx #$00
	stx SD_STATUS_IDX                  ; set first byte of status to read
	ldx #$00                           ; offset to status buffer
	bra util_status_common

util_status_FD:

	ldx #$00
	stx FD_STATUS_IDX                  ; set first byte of status to read
	ldx #$20                           ; offset to status buffer
	bra util_status_common

util_status_RD:

	ldx #$00
	stx RD_STATUS_IDX                  ; set first byte of status to read
	ldx #$40                           ; offset to status buffer

	; FALLLTROUGH

util_status_common:

	; Store the error number

	taz
	jsr util_status_store_number
	jsr util_status_store_comma

	; Store the status / error string

	tza                                ; prepare helper routine
	tay
	lda dos_sts_tab_lo, y
	sta par_LDA_nnnn_Y+0
	lda dos_sts_tab_hi, y
	sta par_LDA_nnnn_Y+1

	ldy #$00                           ; copy the string
@lp:
	jsr code_LDA_nnnn_Y
	beq @lp_end
	sta XX_STATUS_STR, x
	iny
	inx
	bra @lp

@lp_end:

	; Store track and sector

	jsr util_status_store_comma
	lda PAR_TRACK
	jsr util_status_store_number
	jsr util_status_store_comma
	lda PAR_SECTOR
	jsr util_status_store_number

	; Mark end of status and quit

	lda #$00
	sta XX_STATUS_STR, x
	rts

util_status_store_comma:

	ldy #','
	sty XX_STATUS_STR, x
	inx
	rts

util_status_store_number:

	; Check if number to store is 200 or above

	cmp #200
	bcc @store_00_199
	ldy #'2'
	sty XX_STATUS_STR, x
	inx
	sec
	sbc #200
	bra @store_00_99

@store_00_199:     ; number to store is within 00-199 range

	cmp #100
	bcc @store_00_99
	ldy #'1'
	sty XX_STATUS_STR, x
	inx
	sec
	sbc #100

@store_00_99:      ; number to store is within 00-99 range - separate digits

	ldy #'0'
@lp:
	cmp #10
	bcc @store_finalize
	iny
	sec
	sbc #10
	bra @lp

@store_finalize:   ; first digit to store in .Y, second in .A (need no add '0')

	sty XX_STATUS_STR, x
	inx
	clc
	adc #'0'
	sta XX_STATUS_STR, x
	inx

	rts 
