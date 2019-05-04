cmd_load:

	;; Parse filename
	;; (we can tell the KERNAL where it is in memory directly, since the
	;; KERNAL will be able to peek under ROMs to read it, since it will have
	;; to be able to peek under the ROMs for SAVE and VERIFY).
	;; Parse optional device #
	;; Parse optional secondary address
	
	;; XXX - C64 BASIC apparently doesn't clear variables after a LOAD in the
	;; middle of a program. For safety, we do.
	jsr basic_do_clr
	
	;; Try to load an IEC file
	lda #0			; use supplied load address, not the one from the file
	sta current_secondary_address
	lda #$00 		; LOAD not verify
	ldx #<$0801		; LOAD address = $0801
	ldy #>$0801
	jsr $ffd5
	bcc +

	;; A = KERNAL error code, which also almost match
	;; basic ERROR codes, so we can just copy the
	;; error code to X, decrement, and handle normally
	tax
	dex
	jmp do_basic_error
	
*
	;; $YYXX is the last loaded address, so store it
	stx basic_end_of_text_ptr+0
	sty basic_end_of_text_ptr+1

	;; Now relink the loaded program, as we cannot trust the line
	;; links supplied. For example, the VICE virtual drive emulation
	;; always supplies $0101 as the address of the next line.
	
	;; After LOADing, we either start the program from the beginning,
	;; or go back to the READY prompt if LOAD was called from direct mode.

	;; Reset to start of program
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

	;; Try to keep executing
	jmp basic_execute_statement
