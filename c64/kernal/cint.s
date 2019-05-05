	;; Function defined on pp272-273 of C64 Programmers Reference Guide 
	;; Compute's Mapping the 64 p215
cint:
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
	
	;; Initialise cursor blink flags  (Compute's Mapping the 64 p215)
	lda #$00
	sta cursor_blink_disable

	;; Set keyboard decode vector  (Compute's Mapping the 64 p215)

	;; Set initial variables for our improved keyboard scan routine
	lda #$ff
	ldx #6
*	sta BufferOld,x
	dex
	bpl -
	sta BufferQuantity
	
	;; Set key repeat delay (Compute's Mapping the 64 p215)
	;; Making some numbers up here: Repeat every ~1/10th sec
	;; But require key to be held for ~1/3sec before
        ;; repeating (Compute's Mapping the 64 p58)
	ldx #22-2 		; Fudge factor to match speed
	stx key_first_repeat_delay

	;; Set current colour for text (Compute's Mapping the 64 p215)
	ldx #$0e  		; light blue by default
	stx $0286

	;; Set maximum keyboard buffer size (Compute's Mapping the 64 p215)
	ldx #10
	stx key_buffer_size
	;; Put non-zero value in enable_case_switch
	stx enable_case_switch
	
	;; Fallthrough/jump to screen clear routine (Compute's Mapping the 64 p215)
	jmp clear_screen

	rts

