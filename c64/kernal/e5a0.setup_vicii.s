
setup_vicii:	
	;; Set up default IO values (Compute's Mapping the 64 p215)
	lda #$1b    		; Enable text mode
	sta $d011
	lda #$c8		; 40 column etc
	sta $d016

	;; Compute's Mapping the 64, p156
	;; We use a different colour scheme of white text on all blue
	lda #$06
	sta $D020
	sta $D021

	;; Turn off sprites
	;; (observed hanging around after running programs and resetting)
	lda #$00
	sta $D015	
	
