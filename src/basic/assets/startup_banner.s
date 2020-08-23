// #LAYOUT# STD *       #TAKE
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
	.var SET_COLOR_0 = $05
	.var SET_COLOR_1 = $1C
	.var SET_COLOR_2 = $9E
	.var SET_COLOR_3 = $1E
	.var SET_COLOR_4 = $9F

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

#endif
