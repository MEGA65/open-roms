
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



// Check that platform variant configuration is correct

{
	.var selected = 0;

#if CONFIG_VARIANT_GENERIC
	.eval selected++
#endif
#if CONFIG_VARIANT_MEGA_65
	.eval selected++
#endif
#if CONFIG_VARIANT_ULTIMATE_64
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_VARIANT_* option"

#if !CONFIG_PLATFORM_COMMODORE_64 && CONFIG_VARIANT_MEGA_65 &&
	.error "CONFIG_VARIANT_MEGA_65 can only be used with CONFIG_PLATFORM_COMMODORE_64"
#endif
#if !CONFIG_PLATFORM_COMMODORE_64 && CONFIG_VARIANT_ULTIMATE_64 &&
	.error "CONFIG_VARIANT_ULTIMATE_64 can only be used with CONFIG_PLATFORM_COMMODORE_64"
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



// Handle processor configuration

#if CONFIG_CPU_WDC_65C02 || CONFIG_CPU_CSG_65CE02 || CONFIG_CPU_WDC_65816

#define HAS_BCD_SAFE_INTERRUPTS
#define HAS_BCD_SAFE_RESET

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
