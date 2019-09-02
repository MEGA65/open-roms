	;; Clear screen etc, show READY prompt.

basic_warm_start:
	jsr install_ram_routines

	;; If warm start caused by BRK, print it address
	lda CMP0
	ora CMP0+1
	beq +

	ldx #32
	jsr print_packed_message

	lda CMP0+1
	jsr printf_printhexbyte
	lda CMP0+0
	jsr printf_printhexbyte
	lda #$0D
	jsr JCHROUT

*
	jmp basic_main_loop

