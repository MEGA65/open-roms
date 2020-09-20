;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef CONFIG_COMPRESSION_LVL_2 {

print_packed_error:                    ; .X - error string index

	lda #<packed_dict_errors
	ldy #>packed_dict_errors
	bne print_dict_packed_string       ; branch always

print_packed_misc_str:                 ; .X - misc string index

	lda #<packed_dict_misc
	ldy #>packed_dict_misc

	; FALLTROUGH

print_dict_packed_string:

	; Search for the packed string on the list

	jsr print_packed_search

	ldy #$00
@1:
	; At this point FRESPC contains a pointer to the string to display
	; Fetch a byte-code

	lda (FRESPC), y
	beq print_dict_packed_string_end   ; branch if everything displayed
	tax
	dex

	; Call 'print_freq_packed_string' - but preserve all the data needed to progress further

	+phy_trash_a
	lda FRESPC+0
	pha
	lda FRESPC+1
	pha

	lda #<packed_dictionary
	ldy #>packed_dictionary

	jsr print_freq_packed_string

	pla
	sta FRESPC+1
	pla
	sta FRESPC+0
	+ply_trash_a 

	; Next iteration

	iny
	bne @1                             ; branch always

print_dict_packed_string_end:

	rts
}
