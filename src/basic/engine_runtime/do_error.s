;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; As many errors are triggered from many places in the BASIC
; interprettor, it is important to have an efficicent means of
; calling them.
; LDX #$nn / jmp do_basic_error
; is the simplest, but takes 5 bytes.
; Having a direct JMP address for each error is preferable, as
; it reduces the overhead to 3 bytes, but at the cost of having
; a jump table of some sort. The .byte $2C method can be used
; to have a set of addresses that each execute a different
; LDX #$nn command, reducing the cost of the jump table to 3
; bytes per error number.
; But we can do better with a bit of scullduggery and carnal
; knowledge of ZP usage.
; The INC $nn opcode is $E6. ZP location $E6 is one of the screen
; link addresses.  In the original KERNAL, the lower bits of those
; addresses have meaning, but in our KERNAL, we ignore them, and just
; have them all zeroes.  So.... We can have a sequence of $E6 bytes,
; and know exactly how many of them have been executed, by checking
; the value of $E6.  Then all we need to worry about is if an odd
; number is required, then we have to have an exit that has a $E6
; opcode with some other address as target, but where the byte value
; of that argument can be safely executed as a CPU instruction.
; NOP = $EA is the obvious choice, as if used as an argument to
; $E6 will increment location $EA, which is another of the screen
; link addresses.

; This gives a total overhead of 18 bytes + 1 byte per error
; message.  This compares favourably to the 3 bytes per error
; message that the $2C method would result in.


	; Error messages reported by KERNAL

do_kernal_error:                       ; .A = KERNAL error code, also almost matches BASIC error codes

	; Convert to BASIC error code

	tax
	beq do_BREAK_error                 ; XXX is 0 really a proper error code?

	dex
!ifdef SEGMENT_M65_BASIC_1 {
	jmp do_basic_error
} else ifdef SEGMENT_CRT_BASIC_1 {
	jmp do_basic_error
} else {
	bpl do_basic_error                 ; branch always
}

	; Error messages specific to Open ROMs BASIC dialect

!ifdef CONFIG_MB_M65 {

do_LEGACY_MODE_ONLY_error:
	!byte $E6
do_NATIVE_MODE_ONLY_error:
	!byte $E6
}

do_MEMORY_CORRUPT_error:
	!byte $E6

	; Error messages compatible with CBM BASIC V7 dialect

do_FILE_READ_error:
	!byte $E6
do_NOT_IMPLEMENTED_error:
	!byte $E6
do_UNRESOLVED_REFERENCE_error:
	!byte $E6
do_LINE_NUMBER_TOO_LARGE_error:
	!byte $E6
do_BEND_NOT_FOUND_error:
	!byte $E6
do_BAD_DISK_error:
	!byte $E6
do_NO_GRAPHICS_AREA_error:
	!byte $E6
do_DIRECT_MODE_ONLY_error:
	!byte $E6
do_LOOP_WITHOUT_DO_error:
	!byte $E6
do_LOOP_NOT_FOUND_error:
	!byte $E6
do_CANT_RESUME_error:
	!byte $E6

	; Error messages compatible with CBM BASIC V2 dialect

do_BREAK_error:
	!byte $E6
do_LOAD_error:
	!byte $E6
do_VERIFY_error:
	!byte $E6
do_UNDEFD_FUNCTION_error:
	!byte $E6
do_CANT_CONTINUE_error:
	!byte $E6
do_FORMULA_TOO_COMPLEX_error:
	!byte $E6
do_FILE_DATA_error:
	!byte $E6
do_STRING_TOO_LONG_error:
	!byte $E6
do_TYPE_MISMATCH_error:
	!byte $E6
do_ILLEGAL_DIRECT_error:
	!byte $E6
do_DIVISION_BY_ZERO_error:
	!byte $E6
do_REDIMD_ARRAY_error:
	!byte $E6
do_BAD_SUBSCRIPT_error:
	!byte $E6
do_UNDEFD_STATEMENT_error:
	!byte $E6
do_OUT_OF_MEMORY_error:
	!byte $E6
do_OVERFLOW_error:
	!byte $E6
do_ILLEGAL_QUANTITY_error:
	!byte $E6
do_OUT_OF_DATA_error:
	!byte $E6
do_RETURN_WITHOUT_GOSUB_error:
	!byte $E6
do_SYNTAX_error:
	!byte $E6
do_NEXT_WITHOUT_FOR_error:
	!byte $E6
do_ILLEGAL_DEVICE_NUMBER_error:
	!byte $E6	
do_MISSING_FILENAME_error:
	!byte $E6
do_NOT_OUTPUT_FILE_error:
	!byte $E6
do_NOT_INPUT_FILE_error:
	!byte $E6
do_DEVICE_NOT_PRESENT_error:
	!byte $E6
do_FILE_NOT_FOUND_error:
	!byte $E6
do_FILE_NOT_OPEN_error:
	!byte $E6
do_FILE_OPEN_error:
	!byte $E6
do_TO_MANY_FILES_error:
	!byte $EA

!ifdef SEGMENT_M65_BASIC_1 {
	jmp do_error_fetch
} else ifdef SEGMENT_CRT_BASIC_1 {
	jmp do_error_fetch
} else {

	; FALLTROUGH

do_error_fetch:

	; Now get the error id and restore $E6 to its correct value
	
	lda $E6
	pha
	and #$80
	sta $E6
	pla
	; $E6 has even part
	asl
	ora $EA
	and #$7F
	tax

	; Restore $EA to correct value in case the NOP above is used
	; as an argument to the preceeding INC $nn (opcode $E6).
	
	lda $EA
	and #$80
	sta $EA

	; FALLTHROUGH

do_basic_error:                        ; error code in .X

	; Make sure we are back with normal memory map

!ifdef ROM_LAYOUT_M65 {
	jsr map_NORMAL
} else ifdef ROM_LAYOUT_CRT {
	jsr map_NORMAL
}

	; Clear all temporary variables, print "?"
	
	+phx_trash_a
	jsr tmpstr_free_all

	ldx #IDX__STR_RET_QM
	jsr print_packed_misc_str
	+plx_trash_a

	; Error message text + " ERROR"

	jsr print_packed_error

	ldx #IDX__STR_ERROR
	jsr print_packed_misc_str

	; Check if direct mode

	lda CURLIN+1
	cmp #$FF
	beq @1

	; We were in a program, so show IN <line>

	ldx #IDX__STR_IN
	jsr print_packed_misc_str

	lda CURLIN+1
	ldx CURLIN+0
	jsr print_integer
@1:
	; Reset stack, and go back to main loop

	ldx #$FE
	txs

	jmp shell_main_loop

!ifdef CONFIG_MB_M65 {

do_error_print_only:                   ; used by DOS Wedge

	+phx_trash_a
	lda #'?'
	jsr JCHROUT
	+plx_trash_a

	jsr print_packed_error

	ldx #IDX__STR_ERROR
	jmp print_packed_misc_str
}



} ; ROM layout
