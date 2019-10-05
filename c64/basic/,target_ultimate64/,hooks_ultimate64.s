
// Target-specific hooks


.macro TARGET_HOOK_BANNER() {

#if CONFIG_FANCY_BANNER

	.byte $1C, $12, $A3, $A3, $A3, $A3, $A3, $A3, $A3, $92, $0D
    .byte $9E, $12, $A3, $A3, $A3, $A3, $A3, $A3, $92, $05, $20
    .text "   OPEN ROMS FOR ULTIMATE 64"
    .byte $0D
    .byte $1E, $12, $A3, $A3, $A3, $A3, $A3, $92, $0D
    .byte $9F, $12, $A3, $A3, $A3, $A3, $92, $20, $05, $20, $20
    .text "   "

#else

	.text "  OPEN ROMS FOR ULTIMATE 64"
	.byte $0D, $0D
	.text "  "

#endif

	.byte $00 // end of banner
}
