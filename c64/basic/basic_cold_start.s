	;; BASIC Cold start entry point
	;; Compute's Mapping the 64 p211

basic_cold_start:	
	;; Setup BASIC vectors at $0300
	;; Initialise interpretor
	;; Print start up message

	ldy #>startup_message
	lda #<startup_message
	jsr print_string
	
	;; jump into warm start loop
	jmp basic_warm_start
	
	
startup_message:
	;; Clear the screen
	.byte $93
	;; Vertical bars in different colours
	.byte $1C,$B4
	.byte $9E,$B5
	.byte $1E,$A1
	;; <RVS><WHITE>MEGA<NORMAL>BASIC
	.byte $12,$05,$4D,$45,$47,$41,$92,$42,$41,$53,$49,$43
	;; carriage return at end
	.byte $0D
	
	.byte 0
