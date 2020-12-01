;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Well-known Kernal routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - pages 220, 221
;


scnkey_set_keytab:


!ifdef CONFIG_LEGACY_SCNKEY { ; routine not compatible with legacy SCNKEY

	rts

} else {


	; Set initial KEYTAB value
	lda #<kb_matrix
	sta KEYTAB+0
	lda #>kb_matrix
	sta KEYTAB+1

	; Calculate table index
	lda SHFLAG
	and #$07                     ; we are interested in SHIFT, VENDOR and CTRL keys only
	tax

	; Retrieve table offset
	lda kb_matrix_lookup, x
	cmp #$FF
	bne scnkey_valid_offset

	; $FF means we should not decode anything, mark this by setting high byte
	; of KEYTAB to 0 (I do not think anyone would put keyboard decoding table
    ; at zeropage)
	lda #$00
	beq scnkey_valid_offset_cont ; branch always

scnkey_valid_offset:

	; Add offset to the vector
	clc
	adc KEYTAB+0
	sta KEYTAB+0
	lda #$00
	adc KEYTAB+1

	; FALLTROUGH

scnkey_valid_offset_cont:

	sta KEYTAB+1

	; FALLTROUGH

} ; no CONFIG_LEGACY_SCNKEY

scnkey_toggle_if_needed: ; entry for SCNKEY (TWW/CTR version)

	; Check if we should toggle the character set

	lda MODE
	bne @1 ; not allowed to toggle
	lda SHFLAG
	and #$03
	cmp #$03
	bne @1 ; no SHIFT + VENDOR pressed
	lda LSTSHF
	and #$03
	cmp #$03
	beq @1 ; already toggled

	; Toggle char set

!ifdef CONFIG_MB_M65 {

	jsr M65_MODEGET
	bcc @2

	; Toggling charsets for C64 mode

	lda VIC_YMCSB
	eor #$02
	sta VIC_YMCSB
@1:
	rts

	; Toggling charsets for M65 mode
@2:
	lda VIC_CHARPTR+1
	eor #%00001000
	sta VIC_CHARPTR+1
	rts

} else {

	lda VIC_YMCSB
	eor #$02
	sta VIC_YMCSB
@1:
	rts
}