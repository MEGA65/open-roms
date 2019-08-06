	;; Clear screen and initialise line link table
	;; (Compute's Mapping the 64 p215-216)

clear_screen:

	;; Clear line link table 
	;; (Compute's Mapping the 64 p215)

	lda #$00
	ldy #24
clearscreen_l1:
	sta screen_line_link_table,y
	dey
	bpl clearscreen_l1

	;; Y now = #$FF

	;; Clear screen RAM.
	;; We should do this at HIBASE, which annoyingly
	;; is no ZP, so we need to make a vector
	;; (Compute's Mapping the 64 p216)
	;; Get pointer to the screen into current_screen_line_ptr
	;; as it is the first appropriate place for it found when
	;; searching through the ZP allocations listed in
	;; Compute's Mapping the 64
	sta current_screen_line_ptr+0
	lda hibase
	sta current_screen_line_ptr+1
	ldx #$03		; countdown for pages to update
	iny 			; Y now = #$00
	lda #$20		; space character
clearscreen_l2:
	sta (current_screen_line_ptr),y
	iny
	bne clearscreen_l2
	;; To draw only 1000 bytes, add 250 to address each time
	lda current_screen_line_ptr
	clc
	adc #<250
	sta current_screen_line_ptr
	lda current_screen_line_ptr+1
	adc #>250
	sta current_screen_line_ptr+1
	lda #$20		; get space character again
	dex
	bpl clearscreen_l2

	;; Clear colour RAM
	;; (Compute's Mapping the 64 p216)
	lda text_colour
clearscreen_l3:	
	sta $d800,y
	sta $d900,y
	sta $da00,y
	sta $db00-24,y    	; so we only erase 1000 bytes
	iny
	bne clearscreen_l3

	;; (Compute's Mapping the 64 p216)
	jmp home_cursor
