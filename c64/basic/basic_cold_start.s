	;; BASIC Cold start entry point
	;; Compute's Mapping the 64 p211

basic_cold_start:	
	;; Setup BASIC vectors at $0300
	;; Initialise interpretor
	;; Print start up message

	;; Print coloured part of the message
	;; ldy #>startup_message
	;; lda #<startup_message
	;; jsr print_string

	jsr printf
; Used 217 bytes
startup_banner:

	.byte $9A,$12,$A3,$A3,$A3,$A3,$A3,$A3,$DF,$9B,$92,$20,$05,$12,$A0,$A0
	.byte $DF,$9B,$92,$20,$05,$12,$A0,$A0,$DF,$9B,$92,$20,$05,$12,$A0,$A0
	.byte $DF,$9B,$92,$20,$05,$12,$A0,$A0,$DF,$9A,$92,$20,$05,$20,$20,$20
	.byte $4D,$20,$45,$20,$47,$20,$41,$0D,$99,$12,$A3,$A3,$A3,$A3,$A3,$A3
	.byte $A3,$DF,$92,$7F,$12,$CD,$CD,$DF,$92,$7F,$12,$DF,$05,$92,$20,$20
	.byte $99,$7F,$12,$DF,$05,$92,$20,$20,$99,$7F,$12,$DF,$92,$7F,$12,$DF
	.byte $05,$92,$20,$20,$99,$42,$20,$41,$20,$53,$20,$49,$20,$43,$0D,$9E
	.byte $12,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$DF,$9B,$92,$7F,$12,$DF,$92
	.byte $7F,$12,$DF,$92,$7F,$12,$CD,$05,$92,$20,$20,$9B,$7F,$12,$CD,$92
	.byte $7F,$12,$DF,$92,$7F,$12,$CD,$92,$7F,$12,$DF,$9A,$92,$20,$05,$20
	.byte $9A,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$0D,$96,$12,$A3,$A3,$A3,$A3,$A3
	.byte $A3,$A3,$A3,$A3,$DF,$9A,$92,$7F,$12,$DF,$92,$7F,$9B,$20,$9A,$7F
	.byte $12,$A0,$A0,$9B,$92,$20,$9A,$7F,$12,$A0,$A0,$9B,$92,$20,$9A,$7F
	.byte $12,$DF,$92,$7F,$9B,$20,$9A,$20,$9B,"0.2.0.0",$0D
	.byte $0D,$05,$92,$00

	;; Work out free bytes, and display
	jsr basic_do_new
	lda basic_top_of_memory_ptr+0
	sec
	sbc basic_end_of_text_ptr+0
	tax
	lda basic_top_of_memory_ptr+1
	sbc basic_end_of_text_ptr+1

	jsr print_integer	

	lda #$20
	jsr $ffd2
	
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

	.byte 0
