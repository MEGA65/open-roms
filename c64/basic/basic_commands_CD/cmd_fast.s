// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_fast:

#if CONFIG_MB_MEGA_65

	// Command implementation for Mega65

	lda #$41
	sta CPU_D6510

	jmp execute_statements

#elif CONFIG_MB_ULTIMATE_64

	// Try to enable turbo in SuperCPU compatible way
	sta SCPU_SPEED_TURBO

	jmp execute_statements

#elif CONFIG_PLATFORM_COMMODORE_64

	// Command implementation for generic C64 platform

	// Try to enable turbo mode in C128 compatible way
	lda #$01
	sta VIC_CLKRATE

	// Try to enable turbo in SuperCPU compatible way
	sta SCPU_SPEED_TURBO

	jmp execute_statements

#else

	jmp do_NOT_IMPLEMENTED_error

#endif
