;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This routine prints strings that have been packed using the 'generate_trings' tool.
; The general idea is to save space in the ROM.


!ifdef SEGMENT_M65_BASIC_0 {

print_packed_error:

	jsr map_BASIC_1
	jsr (VB1__print_packed_error)
	jmp map_NORMAL

print_packed_misc_str:

	jsr map_BASIC_1
	jsr (VB1__print_packed_misc_str)
	jmp map_NORMAL

} else ifdef SEGMENT_CRT_BASIC_0 {

print_packed_error:

	jsr map_BASIC_1
	jsr JB1__print_packed_error
	jmp map_NORMAL

print_packed_misc_str:

	jsr map_BASIC_1
	jsr JB1__print_packed_misc_str
	jmp map_NORMAL

} else {

!ifndef CONFIG_COMPRESSION_LVL_2 {

print_packed_error:                    ; .X - error string index

	lda #<packed_freq_errors
	ldy #>packed_freq_errors
	bne print_freq_packed_string       ; branch always

print_packed_misc_str:                 ; .X - misc string index

	lda #<packed_freq_misc
	ldy #>packed_freq_misc
	bne print_freq_packed_string       ; branch always
}

print_packed_keyword_01:               ; .X - token number

	lda #<packed_freq_keywords_01
	ldy #>packed_freq_keywords_01
	bne print_freq_packed_string       ; branch always

!ifdef CONFIG_MB_M65 {

print_packed_keyword_04:               ; .X - token number

	lda #<packed_freq_keywords_04
	ldy #>packed_freq_keywords_04
	bne print_freq_packed_string       ; branch always

print_packed_keyword_06:               ; .X - token number

	lda #<packed_freq_keywords_06
	ldy #>packed_freq_keywords_06
	bne print_freq_packed_string       ; branch always
}

print_packed_keyword_V2:               ; .X - token number

	lda #<packed_freq_keywords_V2
	ldy #>packed_freq_keywords_V2

	; FALLTROUGH

print_freq_packed_string:              ; not to be used directly   XXX rename to print_packed_string

	; Search for the packed string on the list

	jsr print_packed_search

	; At this point FRESPC contains a pointer to the string to display
	; and we should start from the lower nibble

	ldy #$00

	; FALLTROUGH

print_freq_packed_string_nibble_lo:

	; Get the low nibble and check for the end of packed string

	lda (FRESPC), y
	and #$0F
	beq print_freq_packed_string_end

	; Not the end - check if this is a common character, encoded by a single nibble

	cmp #$0F
	beq print_freq_packed_string_3n_split

	; Character is encoded by a single nibble - fetch it and display

	tax
	lda packed_as_1n-1, x
	jsr JCHROUT                        ; preserves .Y

	; FALLTROUGH

print_freq_packed_string_nibble_hi:

	; Get the high nibble and check for the end of packed string

	lda (FRESPC), y
	and #$F0
	beq print_freq_packed_string_end

	; Not the end - check if this is a common character, encoded by a single nibble

	cmp #$F0
	beq print_freq_packed_string_3n_single

	; Character is encoded by a single nibble - fetch it and display

	lsr
	lsr
	lsr
	lsr

	tax
	lda packed_as_1n-1, x
	+bra print_freq_packed_string_3n_single_cont

print_freq_packed_string_3n_single:

	; Character is encoded using 3 nibbles (1st is a mark, already interpreted)

	iny
	lda (FRESPC), y
	tax
	lda packed_as_3n-1, x

	; FALLTROUGH

print_freq_packed_string_3n_single_cont:

	jsr JCHROUT                        ; preserves .Y

	; Advance to next nibble

	iny
	bne print_freq_packed_string_nibble_lo  ; branch always

print_freq_packed_string_3n_split:

	; Character is encoded using 3 nibbles (1st is a mark, already interpreted),
	; but the 2 remaining nibbles are in two neighbour bytes; use a stack to combine them

	lda (FRESPC), y
	and #$F0
	tsx
	pha

	iny
	lda (FRESPC), y
	and #$0F

	clc
	adc STACK, x

	txs                                ; one cycle faster than PLA

	tax
	lda packed_as_3n-1, x
	jsr JCHROUT                        ; preserves .Y
                           
	jmp print_freq_packed_string_nibble_hi

print_freq_packed_string_end:

	rts


} ; ROM layout
