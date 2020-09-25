;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Fetches 8-bit unsigned integer
;


fetch_coma_uint8:

	jsr injest_comma
	bcs fetch_uint8_end

	; FALLTROUGH

fetch_uint8:

	lda #IDX__EV2_0E                             ; 'ILLEGAL QUANTITY ERROR'
	jsr fetch_uint16
	bcs fetch_uint8_end
	lda LINNUM+1
	+bne do_ILLEGAL_QUANTITY_error
	lda LINNUM+0
	clc

	; FALLTROUGH

fetch_uint8_end:
	
	rts
