
;
; Set current error or status
;


; XXX add methods for remaining codes
; XXX size-optimize this, move some parts into subroutines


; .A = 0 for SD card, 1 for FDD, 2 for RAM disk

dos_status_00: ; OK

	pha
	phx
	phy

	; Set status byte pointer to the beginning

	tax
	lda #$00
	sta XX_STATUS_IDX, x

	; Set .X to offset from XX_STATUS_STR

	lda dos_status_offset, x
	tax

	; Store '00,'

	lda #'0'
	sta XX_STATUS_STR, x
	inx
	sta XX_STATUS_STR, x
	inx
	lda #','
	sta XX_STATUS_STR, x
	inx

	; Store 'OK'

	dex
	ldy #$FF
@1:
	inx
	iny
	lda dos_err_00, y
	beq @2
	sta XX_STATUS_STR, x
	bra @1
@2:
	; Store ',00,00'

	lda #','
	sta XX_STATUS_STR, x
	inx
	lda #'0'
	sta XX_STATUS_STR, x
	inx
	sta XX_STATUS_STR, x
	inx
	lda #','
	sta XX_STATUS_STR, x
	inx
	lda #'0'
	sta XX_STATUS_STR, x
	inx
	sta XX_STATUS_STR, x
	inx

	; Store 0 (mark end of the status)

	lda #$00
	sta XX_STATUS_STR, x 

	; End

	ply
	plx
	pla

	clc ; mark status as OK 
	rts




dos_status_offset:

	!byte $00,$20,$40
