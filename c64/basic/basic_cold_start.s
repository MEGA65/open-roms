	;; BASIC Cold start entry point
	;; Compute's Mapping the 64 p211

basic_cold_start:	
	;; Setup BASIC vectors at $0300
	;; Initialise interpretor
	;; Print start up message

	;; Print coloured part of the message
	ldy #>startup_message
	lda #<startup_message
	jsr print_string

	;; Print the rest of the start up message
	ldx #34
	jsr print_packed_message
	
	;; jump into warm start loop
	jmp basic_warm_start
	
	
startup_message:
	;; Clear the screen
	.byte $93
	;; Vertical bars in different colours
	.byte $1C,$B4
	.byte $9E,$B5
	.byte $1E,$A1
	;; <RVS><WHITE>MEGA<NORMAL>BASIC\r\r
	.byte $12,$05,$4D,$45,$47,$41,$92
	.byte $42,$41,$53,$49,$43
	.byte $20,$56,$32,$2e,$30,$2e,$30
	.byte $0D,$0D

	;; XXX - Hard code in the 38911 for now
	.byte $33,$38,$39,$31,$31,$20
	
	.byte 0
