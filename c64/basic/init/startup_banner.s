// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Startup banner, to be displayed during cold start
//

.encoding "petscii_upper"


.macro BANNER_TEXT() {

#if CONFIG_BRAND_CUSTOM_BUILD
	.text "OPEN ROMS "
	.text CONFIG_CUSTOM_BRAND
#elif CONFIG_BRAND_GENERIC
	.text "OPEN ROMS GENERIC BUILD"
#elif CONFIG_BRAND_TESTING
	.text "OPEN ROMS TESTING BUILD"
#elif CONFIG_BRAND_MEGA_65
	.text "OPEN ROMS FOR MEGA65"
#elif CONFIG_BRAND_ULTIMATE_64
	.text "OPEN ROMS FOR ULTIMATE 64"
#endif

}

startup_banner:

#if CONFIG_BANNER_SIMPLE

	.text "    " 
	BANNER_TEXT()
	.byte $00

#elif CONFIG_BANNER_FANCY

	BANNER_TEXT()
	.byte $00

rainbow_logo:

{
#if CONFIG_COLORS_BRAND && CONFIG_BRAND_MEGA_65

	.var SET_COLOR_0 = $05
	.var SET_COLOR_1 = $9A
	.var SET_COLOR_2 = $1E
	.var SET_COLOR_3 = $9E
	.var SET_COLOR_4 = $96

#else

	.var SET_COLOR_0 = $05
	.var SET_COLOR_1 = $1C
	.var SET_COLOR_2 = $9E
	.var SET_COLOR_3 = $1E
	.var SET_COLOR_4 = $9F

#endif

	.byte SET_COLOR_1, $12, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    .byte SET_COLOR_2, $12, $A4, $A4, $A4, $A4, $A4, $A4, $0D
    .byte SET_COLOR_3, $12, $A4, $A4, $A4, $A4, $A4, $0D
    .byte SET_COLOR_4, $12, $A4, $A4, $A4, $A4, $92
    .byte SET_COLOR_0, $00
}

#if !CONFIG_BRAND_CUSTOM_BUILD

pre_revision_string:

	.text "RELEASE "
	.byte $00

#endif // no CONFIG_BRAND_CUSTOM_BUILD

#elif CONFIG_BANNER_BRAND && CONFIG_BRAND_MEGA_65

	// Fancy Mega65 banner - from Retrofan
	.byte $9a, $12, $20, $20, $7f, $a9, $20, $20, $1f, $20, $9a, $20, $20, $20
	.byte $20, $1f, $20, $9a, $a9, $20, $20, $20, $92, $a1, $1f, $12, $20, $9a, $a9, $20
	.byte $20, $20, $7f, $1f, $20, $20, $9a, $a3, $a3, $a3, $a3, $a3, $a3, $a3, $1f, $20
	.byte $20, $20, $20, $05, $92, $4d, $45, $47, $41, $9a, $12, $20, $20, $20, $20, $20
	.byte $20, $1f, $20, $9a, $20, $20, $92, $a2, $bb, $1f, $12, $20, $9a, $20, $20, $92
	.byte $ac, $a2, $a2, $1f, $12, $20, $9a, $20, $20, $1f, $20, $9a, $20, $20, $1f, $20
	.byte $20, $1e, $a3, $a3, $a3, $a3, $a3, $a3, $1f, $20, $20, $20, $20, $05, $92, $42
	.byte $41, $53, $49, $43, $9a, $12, $20, $20, $92, $7f, $a9, $12, $20, $20, $1f, $20
	.byte $9a, $20, $20, $a2, $92, $be, $1f, $12, $20, $9a, $20, $20, $92, $bc, $12, $20
	.byte $20, $1f, $20, $9a, $20, $20, $20, $20, $20, $1f, $20, $20, $9e, $a3, $a3, $a3
	.byte $a3, $a3, $1f, $20, $20, $20, $20, $05, $92, $2d, $2d, $2d, $2d, $2d, $2d, $9a
	.byte $12, $20, $20, $1f, $20, $20, $9a, $20, $20, $1f, $20, $9a, $20, $20, $20, $20
	.byte $1f, $20, $9a, $20, $20, $20, $20, $20, $1f, $20, $9a, $20, $20, $1f, $20, $9a
	.byte $20, $20, $1f, $20, $20, $96, $a3, $a3, $a3, $a3, $1f
	.byte $92, $0D, $0D, $05, $00

	// Original Mega65 banner - supplied by Deft
	// .byte $9A,$12,$A3,$A3,$A3,$A3,$A3,$A3,$DF,$9B,$92,$20,$05,$12,$A0,$A0
	// .byte $DF,$9B,$92,$20,$05,$12,$A0,$A0,$DF,$9B,$92,$20,$05,$12,$A0,$A0
	// .byte $DF,$9B,$92,$20,$05,$12,$A0,$A0,$DF,$9A,$92,$20,$05,$20,$20,$20
	// .byte $4D,$20,$45,$20,$47,$20,$41,$0D,$99,$12,$A3,$A3,$A3,$A3,$A3,$A3
	// .byte $A3,$DF,$92,$7F,$12,$CD,$CD,$DF,$92,$7F,$12,$DF,$05,$92,$20,$20
	// .byte $99,$7F,$12,$DF,$05,$92,$20,$20,$99,$7F,$12,$DF,$92,$7F,$12,$DF
	// .byte $05,$92,$20,$20,$99,$42,$20,$41,$20,$53,$20,$49,$20,$43,$0D,$9E
	// .byte $12,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$DF,$9B,$92,$7F,$12,$DF,$92
	// .byte $7F,$12,$DF,$92,$7F,$12,$CD,$05,$92,$20,$20,$9B,$7F,$12,$CD,$92
	// .byte $7F,$12,$DF,$92,$7F,$12,$CD,$92,$7F,$12,$DF,$9A,$92,$20,$05,$20
	// .byte $9A,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$0D,$96,$12,$A3,$A3,$A3,$A3,$A3
	// .byte $A3,$A3,$A3,$A3,$DF,$9A,$92,$7F,$12,$DF,$92,$7F,$9B,$20,$9A,$7F
	// .byte $12,$A0,$A0,$9B,$92,$20,$9A,$7F,$12,$A0,$A0,$9B,$92,$20,$9A,$7F
	// .byte $12,$DF,$92,$7F,$9B,$20,$9A,$20,$9B,"0.2.0.0",$0D
	// .byte $0D,$05,$92,$00

#endif
