//  As many errors are triggered from many places in the BASIC
// interprettor, it is important to have an efficicent means of
// calling them.
// LDX #$nn / jmp do_basic_error
// is the simplest, but takes 5 bytes.
// Having a direct JMP address for each error is preferable, as
// it reduces the overhead to 3 bytes, but at the cost of having
// a jump table of some sort. The .byte $2C method can be used
// to have a set of addresses that each execute a different
// LDX #$nn command, reducing the cost of the jump table to 3
// bytes per error number.
// But we can do better with a bit of scullduggery and carnal
// knowledge of ZP usage.
// The INC $nn opcode is $E6. ZP location $E6 is one of the screen
// link addresses.  In the original KERNAL, the lower bits of those
// addresses have meaning, but in our KERNAL, we ignore them, and just
// have them all zeroes.  So.... We can have a sequence of $E6 bytes,
// and know exactly how many of them have been executed, by checking
// the value of $E6.  Then all we need to worry about is if an odd
// number is required, then we have to have an exit that has a $E6
// opcode with some other address as target, but where the byte value
// of that argument can be safely executed as a CPU instruction.
// NOP = $EA is the obvious choice, as if used as an argument to
// $E6 will increment location $EA, which is another of the screen
// link addresses.

// This gives a total overhead of 18 bytes + 1 byte per error
// message.  This compares favourably to the 3 bytes per error
// message that the $2C method would result in.

do_NOT_IMPLEMENTED_error:
	.byte $E6
do_MEMORY_CORRUPT_error:
	.byte $E6
	// the message "BYTES FREE"
	.byte $E6
	// the word ERROR
	.byte $E6
	// The word "SAVING"
	.byte $E6
	// The word "VERIFYING"
	.byte $E6
	// The word "LOADING"
	.byte $E6
	// The word "READY."
	.byte $E6	
do_LOAD_error:
	.byte $E6
do_VERIFY_error:
	.byte $E6
do_UNDEFD_FUNCTION_error:
	.byte $E6
do_CANT_CONTINUE_error:
	.byte $E6
do_FORMULA_TOO_COMPLEX_error:
	.byte $E6
do_FILE_DATA_error:
	.byte $E6
do_STRING_TOO_LONG_error:
	.byte $E6
do_TYPE_MISMATCH_error:
	.byte $E6
do_ILLEGAL_DIRECT_error:
	.byte $E6
do_DIVISION_BY_ZERO_error:
	.byte $E6
do_REDIMD_ARRAY_error:
	.byte $E6
do_BAD_SUBSCRIPT_error:
	.byte $E6
do_UNDEFD_STATEMENT_error:
	.byte $E6
do_OUT_OF_MEMORY_error:
	.byte $E6
do_OVERFLOW_error:
	.byte $E6
do_ILLEGAL_QUANTITY_error:
	.byte $E6
do_OUT_OF_DATA_error:
	.byte $E6
do_RETURN_WITHOUT_GOSUB_error:
	.byte $E6
do_SYNTAX_error:
	.byte $E6
do_NEXT_WITHOUT_FOR_error:
	.byte $E6
do_ILLEGAL_DEVICE_NUMBER_error:
	.byte $E6	
do_MISSING_FILENAME_error:
	.byte $E6
do_NOT_OUTPUT_FILE_error:
	.byte $E6
do_NOT_INPUT_FILE_error:
	.byte $E6
do_DEVICE_NOT_PRESENT_error:
	.byte $E6
do_FILE_NOT_FOUND_error:
	.byte $E6
do_FILE_NOT_OPEN_error:
	.byte $E6
do_FILE_OPEN_error:
	.byte $E6
do_TO_MANY_FILES_error:
	.byte $EA

	// Now get the error # and restore $E6 to its correct value
	lda $E6
	pha
	and #$80
	sta $E6
	pla
	// $E6 has even part
	asl
	ora $EA
	and #$7f
	tax

	// Restore $EA to correct value in case the NOP above is used
	// as an argument to the preceeding INC $nn (opcode $E6).
	lda $EA
	and #$80
	sta $EA

	// FALL THROUGH

	// Error # in X

do_basic_error:
	// "?"
	txa
	pha
	jsr print_return
	lda #$3f
	jsr JCHROUT
	pla
	tax

	// Error message text
	jsr print_packed_message

	// A space between error name and word error
	jsr print_space

	// "ERROR"
	ldx #33
	jsr print_packed_message

	lda CURLIN+1
	cmp #$ff
	beq !+

	// We were in a program, so show IN <line>
	ldx #31
	jsr print_packed_message

	lda CURLIN+1
	ldx CURLIN+0
	jsr print_integer
!:
	// New lines
	jsr print_return
	lda #$00
	jsr JCHROUT

	// XXX - Restore stack depth first?

	jmp basic_main_loop
