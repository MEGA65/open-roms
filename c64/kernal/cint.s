	;; Function defined on pp272-273 of C64 Programmers Reference Guide 
	;; Compute's Mapping the 64 p215
cint:
	;; Set up default IO values (Compute's Mapping the 64 p215)
	lda #$1b    		; Enable text mode
	sta $d011
	lda #$c8		; 40 column etc
	sta $d016

	;; Initialise cursor blink flags  (Compute's Mapping the 64 p215)
	lda #$00
	sta cursor_blink_disable
	sta cursor_blink_countdown

	;; Set keyboard decode vector  (Compute's Mapping the 64 p215)

	;; Set key repeat delay (Compute's Mapping the 64 p215)
	;; Making some numbers up here: Repeat every ~1/10th sec
	;; But require key to be held for 4x that long before
        ;; repeating		
	lda #$05
	sta key_repeat_speed

	;; Set key frequency counters (Compute's Mapping the 64 p215)
	asl
	asl
	sta key_first_repeat_delay

	;; Set current colour for text (Compute's Mapping the 64 p215)
	lda #$0e  		; light blue by default
	sta $0286

	;; Set maximum keyboard buffer size (Compute's Mapping the 64 p215)
	lda #10
	sta key_buffer_size
	
	;; Fallthrough/jump to screen clear routine (Compute's Mapping the 64 p215)
	;; 	jmp clear_screen


	rts

