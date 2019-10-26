
//
// Various configuration dependent aliases/macros/checks
//



// Check that platform configuration is correct

{
	.var selected = 0;

#if CONFIG_PLATFORM_COMMODORE_64
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_PLATFORM_* option" 
}



// Check that motherboard extras configuration is correct

{
	.var selected = 0;

#if CONFIG_MB_MEGA_65
	.eval selected++
#endif
#if CONFIG_MB_ULTIMATE_64
	.eval selected++
#endif

	.if (selected > 1) .error "Please select at most one CONFIG_MB_* option"

#if !CONFIG_PLATFORM_COMMODORE_64 && CONFIG_BRAND_MEGA_65 &&
	.error "CONFIG_BRAND_MEGA_65 can only be used with CONFIG_PLATFORM_COMMODORE_64"
#endif
#if !CONFIG_PLATFORM_COMMODORE_64 && CONFIG_BRAND_ULTIMATE_64 &&
	.error "CONFIG_BRAND_ULTIMATE_64 can only be used with CONFIG_PLATFORM_COMMODORE_64"
#endif
}



// Check that brand configuration is correct

{
	.var selected = 0;

#if CONFIG_BRAND_GENERIC
	.eval selected++
#endif
#if CONFIG_BRAND_TESTING
	.eval selected++
#endif
#if CONFIG_BRAND_MEGA_65
	.eval selected++
#endif
#if CONFIG_BRAND_ULTIMATE_64
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_BRAND_* option"

#if CONFIG_MB_MEGA_65 && !(CONFIG_BRAND_MEGA_65 || CONFIG_BRAND_TESTING)
	.error "Please select brand either matching the CONFIG_MB_*, or a testing one"
#endif
#if CONFIG_MB_ULTIMATE_64 && !(CONFIG_BRAND_ULTIMATE_64 || CONFIG_BRAND_TESTING)
	.error "Please select brand either matching the CONFIG_MB_*, or a testing one"
#endif
}



// Check that processor configuration is correct

{
	.var selected = 0;

#if CONFIG_CPU_MOS_6502
	.eval selected++
#endif
#if CONFIG_CPU_WDC_65C02
	.eval selected++
#endif
#if CONFIG_CPU_CSG_65CE02
	.eval selected++
#endif
#if CONFIG_CPU_WDC_65816
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_CPU_* option" 
}



// Check that memory model configuration is correct

{
	.var selected = 0;

#if CONFIG_MEMORY_MODEL_38K
	.eval selected++
#endif
#if CONFIG_MEMORY_MODEL_60K
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_MEMORY_MODEL_* option" 
}



// Check that startup banner configuration is correct

{
	.var selected = 0;

#if CONFIG_BANNER_SIMPLE
	.eval selected++
#endif
#if CONFIG_BANNER_FANCY
	.eval selected++
#endif
#if CONFIG_BANNER_BRAND
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_BANNER_* option" 

#if CONFIG_BANNER_BRAND && !CONFIG_BRAND_MEGA_65
	.error "CONFIG_BANNER_BRAND is not supported for your CONFIG_BRAND_*" 
#endif

#if CONFIG_BANNER_BRAND && CONFIG_BRAND_MEGA_65 && CONFIG_SHOW_PAL_NTSC
	.error "MEGA65 brand banner does not support showing PAL/NTSC" 
#endif

}



// Check if keyboard options are correct

{
#if CONFIG_LEGACY_SCNKEY && (CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C128_CAPS_LOCK || CONFIG_KEYBOARD_C65 || CONFIG_KEYBOARD_C65_CAPS_LOCK)
	.error "CONFIG_LEGACY_SCNKEY and CONFIG_KEYBOARD_C128* / CONFIG_KEYBOARD_C65* are mutually exclusive"
#endif

#if (CONFIG_MB_MEGA_65 || CONFIG_MB_ULTIMATE_64) && (CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C128_CAPS_LOCK)
	.error "Selected CONFIG_MB_* is not compatible with CONFIG_KEYBOARD_C128*"
#endif
#if CONFIG_MB_ULTIMATE_64 && (CONFIG_KEYBOARD_C65 || CONFIG_KEYBOARD_C65_CAPS_LOCK)
	.error "Selected CONFIG_MB_* is not compatible with CONFIG_KEYBOARD_C65*"
#endif
}



// Handle processor configuration

#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816

#define HAS_BCD_SAFE_INTERRUPTS

	.pseudocommand phx { .byte $DA }
	.pseudocommand phy { .byte $5A }
	.pseudocommand plx { .byte $FA }
	.pseudocommand ply { .byte $7A }

#endif



// Handle configuration of various features

#if CONFIG_BCD_SAFE_INTERRUPTS
#define HAS_BCD_SAFE_INTERRUPTS
#endif



// Handle configuration of debug infrastructure

.macro STUB_IMPLEMENTATION_RTS() {
	rts
}

.macro STUB_IMPLEMENTATION_BRK() {
	.break
	brk
	brk
	jmp *-2
}

.macro STUB_IMPLEMENTATION()
{
#if CONFIG_DBG_STUBS_BRK
	STUB_IMPLEMENTATION_BRK()
#else
	STUB_IMPLEMENTATION_RTS()
#endif
}
