;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; MEGA65 pseudo-IEC internal DOS support - part of the LOAD routine
;


m65dos_load_part:

	; Open channel for loading

	lda #$60
	jsr m65dos_tksa

	jsr m65dos_get_addr_byte
	sta EAL+0

	jsr m65dos_get_addr_byte
	sta EAL+1

	jmp load_iec_m65cont

m65dos_get_addr_byte:

	jsr m65dos_acptr
	bcs @1
	lda IOSTATUS
	and #K_STS_EOI
	bne @1
	lda TBTCNT
	rts
@1:
	pla
	pla

	jmp load_iec_file_not_found

m65dos_load_loop:

	jsr m65dos_acptr

	; Handle the byte (store in memory / verify)
	jsr lvs_handle_byte_load_verify
	+bcs load_iec_error

	; Advance pointer to data; it is OK if it advances past $FFFF,
	; one autostart technique does exactly this
	inw EAL+0

	; Check for EOI - if so, this was the last byte
	bit IOSTATUS
	bvc m65dos_load_loop

	; FALLTROUGH

	jmp load_iec_loop_end
