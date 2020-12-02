;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; MEGA65 native mode version of a well-known Kernal routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - pages 220, 221
;


m65_scnkey_set_keytab:

	; Calculate table index

	lda SHFLAG
	and #KEY_FLAG_CAPSL      ; isolate CAPS LOCK bit
	php
	lda SHFLAG
	and #%00000111           ; take SHIFT, VENDOR, CTRL, cancel the rest
	plp
	beq @1
	ora #%00001000           ; apply CAPS lock bit at convenient position
@1:
	asl                      ; multiply by 2 - we have a list of addresses

	; Set KEYTAB

	lda kb_matrix_lookup+0, x
	sta KEYTAB+0	
	lda kb_matrix_lookup+1, x
	sta KEYTAB+1

	; Fall back to original routine

	jmp scnkey_toggle_if_needed
