;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; MEGA65 native mode version of a well-known Kernal routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - pages 220, 221
;


m65_scnkey_set_keytab:

	; Set initial KEYTAB value
	lda #<kb_matrix
	sta KEYTAB+0
	lda #>kb_matrix
	sta KEYTAB+1

	; Calculate table index
	lda SHFLAG
	asl                          ; multiply by 2 - keyboard matrix lookup table consists of words
	and #$2E                     ; we are interested in SHIFT, VENDOR, CTRL and CAPS LOCK keys only
	tax
	and #$20                     ; isolate CAPS LOCK bit
	beq @1
	txa                          ; we have to move the CAPS LOCK bit (only) by one position down
	and #$0E
	ora #$10
	tax
@1:

	; XXX finish the implementation


	jmp scnkey_toggle_if_needed
