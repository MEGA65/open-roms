// #LAYOUT# M65 *       #TAKE
// #LAYOUT# *   *       #IGNORE


#if SEGMENT_BASIC_0

cmd_sysinfo:

	jsr     map_BASIC_1
	jsr_ind VB1__cmd_sysinfo
	jmp     map_NORMAL

#else

cmd_sysinfo:

	jsr print_return

	// Print mode and build information

	ldx #IDX__STR_SI_HEADER
	jsr print_packed_misc_str

	jsr M65_ISMODE65
	bcc !+ 

	ldx #IDX__STR_SI_MODE64
	skip_2_bytes_trash_nvz
!:
	ldx #IDX__STR_SI_MODE65
	jsr print_packed_misc_str

	ldx #IDX__STR_SI_HDR_REL
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	jsr print_return
	jsr print_return

	// FALLTROUGH

print_sysinfo_banner:

	// Print board type

	ldx #IDX__STR_SI_HDR_HW
	jsr print_packed_misc_str

	lda MISC_BOARDID
	ldy #(__cmd_sysinfo_hw_ids_end - cmd_sysinfo_hw_ids - 1)
!:
	cmp cmd_sysinfo_hw_ids, y
	beq !+
	dey
	bpl !-
	ldy #(__cmd_sysinfo_hw_ids_end - cmd_sysinfo_hw_ids)
!:
	ldx cmd_sysinfo_hw_str, y
	phx
	jsr print_packed_misc_str
	plx
	cpx #IDX__STR_SI_HW_XX
	bne !+

	lda MISC_BOARDID
	jsr print_hex_byte
!:
	// Print video system information

	ldx #IDX__STR_SI_HDR_VID
	jsr print_packed_misc_str

	ldx #IDX__STR_NTSC
	lda TVSFLG
	beq !+
	ldx #IDX__STR_PAL
!:
	jsr print_packed_misc_str

	// Print build featires information

	ldx #IDX__STR_SI_FEATURES
	jmp print_packed_misc_str



cmd_sysinfo_hw_ids:

	.byte $01
	.byte $02
	.byte $03
	.byte $21
	.byte $40
	.byte $41
	.byte $42
	.byte $FD
	.byte $FE

__cmd_sysinfo_hw_ids_end:

cmd_sysinfo_hw_str:

	.byte IDX__STR_SI_HW_01
	.byte IDX__STR_SI_HW_02
	.byte IDX__STR_SI_HW_03
	.byte IDX__STR_SI_HW_21
	.byte IDX__STR_SI_HW_40
	.byte IDX__STR_SI_HW_41
	.byte IDX__STR_SI_HW_42
	.byte IDX__STR_SI_HW_FD
	.byte IDX__STR_SI_HW_FE
	.byte IDX__STR_SI_HW_XX



#endif
