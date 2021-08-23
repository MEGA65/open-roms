;; #LAYOUT# M65 *       #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifdef SEGMENT_BASIC_0 {

cmd_sysinfo:

	jsr map_BASIC_1
	jsr (VB1__cmd_sysinfo)
	jmp map_NORMAL

} else {

cmd_sysinfo:

	jsr print_return

	; Print mode and build information

	ldx #IDX__STR_SI_HEADER
	jsr print_packed_misc_str

	jsr M65_MODEGET
	bcc @1

	ldx #IDX__STR_SI_MODE64
	+skip_2_bytes_trash_nvz
@1:
	ldx #IDX__STR_SI_MODE65
	jsr print_packed_misc_str

	ldx #IDX__STR_SI_HDR_REL
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	jsr print_return

	jsr M65_MODEGET
	bcs print_sysinfo_video

	jsr print_return

	; FALLTROUGH

print_sysinfo_banner:

	; Print board type (information not accessible in native mode)

	ldx #IDX__STR_SI_HDR_HW
	jsr print_packed_misc_str

	lda MISC_BOARDID
	ldy #(__cmd_sysinfo_hw_ids_end - cmd_sysinfo_hw_ids - 1)
@2:
	cmp cmd_sysinfo_hw_ids, y
	beq @3
	dey
	bpl @2
	ldy #(__cmd_sysinfo_hw_ids_end - cmd_sysinfo_hw_ids)
@3:
	ldx cmd_sysinfo_hw_str, y
	phx
	jsr print_packed_misc_str
	plx
	cpx #IDX__STR_SI_HW_XX
	bne @4

	lda MISC_BOARDID
	jsr print_hex_byte
@4:

	; FALLTROUGH

print_sysinfo_video:

	; Print video system information

	ldx #IDX__STR_SI_HDR_VID
	jsr print_packed_misc_str

	jsr JSCREEN
	
	phy
	lda #$00
	jsr print_integer

	lda #$58
	jsr JCHROUT	

	ply
	tya
	tax
	lda #$00
	jsr print_integer

	jsr print_space

	ldx #IDX__STR_NTSC
	lda TVSFLG
	beq @5
	ldx #IDX__STR_PAL
@5:
	jsr print_packed_misc_str

	; Print build features information

	ldx #IDX__STR_SI_FEATURES
	jsr print_packed_misc_str

	; Print SD CARD unit ID

	lda #$00
	jsr cmd_sysinfo_print_dev

	ldx #IDX__STR_DOS_FD
	jsr print_packed_misc_str

	; Print floppy unit IDs

	lda #$01
	jsr cmd_sysinfo_print_dev

	ldx #IDX__STR_DOS_SEPAR
	jsr print_packed_misc_str

	lda #$02
	jsr cmd_sysinfo_print_dev

	; Print ram disk unit ID

	ldx #IDX__STR_DOS_RD
	jsr print_packed_misc_str

	lda #$03
	jsr cmd_sysinfo_print_dev

	jmp print_return

cmd_sysinfo_print_dev:

	jsr m65dos_unitnum
	bcs @nounit
	tax
	lda #$00
	jmp print_integer

@nounit:

	lda #'-'
	jmp JCHROUT

cmd_sysinfo_hw_ids:

	!byte $01
	!byte $02
	!byte $03
	!byte $21
	!byte $40
	!byte $41
	!byte $42
	!byte $FD
	!byte $FE

__cmd_sysinfo_hw_ids_end:

cmd_sysinfo_hw_str:

	!byte IDX__STR_SI_HW_01
	!byte IDX__STR_SI_HW_02
	!byte IDX__STR_SI_HW_03
	!byte IDX__STR_SI_HW_21
	!byte IDX__STR_SI_HW_40
	!byte IDX__STR_SI_HW_41
	!byte IDX__STR_SI_HW_42
	!byte IDX__STR_SI_HW_FD
	!byte IDX__STR_SI_HW_FE
	!byte IDX__STR_SI_HW_XX
}
