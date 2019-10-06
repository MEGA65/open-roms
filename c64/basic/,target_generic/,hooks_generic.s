
// Target-specific hooks


.macro TARGET_HOOK_BANNER() {

#if CONFIG_BANNER_FANCY

	.byte $1C, $12, $A4, $A4, $A4, $A4, $A4, $A4, $A4, $92, $0D
    .byte $9E, $12, $A4, $A4, $A4, $A4, $A4, $A4, $92, $05, $20
    .text "   OPEN ROMS GENERIC BUILD"
    .byte $0D
    .byte $1E, $12, $A4, $A4, $A4, $A4, $A4, $92, $0D
    .byte $9F, $12, $A4, $A4, $A4, $A4, $92, $20, $05, $20, $20
    .text "   "

#else

	.text "  OPEN ROMS GENERIC BUILD"
	.byte $0D, $0D
	.text "  "

#endif

	.byte $00 // end of banner
}
