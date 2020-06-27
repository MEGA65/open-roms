
//
// Various configuration dependent aliases/macros/checks
//

.encoding "petscii_upper"



// Check that platform configuration is correct
{
	.var selected = 0;

#if CONFIG_PLATFORM_COMMODORE_64
	.eval selected++
#endif
#if CONFIG_PLATFORM_COMMANDER_X16
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

#if CONFIG_MB_MEGA_65 && (CONFIG_SID_2ND || CONFIG_SID_3RD || CONFIG_SID_D4XX || CONFIG_SID_D5XX)
	.error "CONFIG_MB_MEGA_65 cannot be used with CONFIG_SID_*"
#endif
}



// Check that brand configuration is correct
{
	.var selected = 0;

#if CONFIG_BRAND_CUSTOM_BUILD
	.eval selected++
#endif
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

#if CONFIG_MB_MEGA_65 && !(CONFIG_BRAND_MEGA_65 || CONFIG_BRAND_TESTING || CONFIG_BRAND_CUSTOM_BUILD)
	.error "Please select brand either matching the CONFIG_MB_*, or a testing/custom one"
#endif
#if CONFIG_MB_ULTIMATE_64 && !(CONFIG_BRAND_ULTIMATE_64 || CONFIG_BRAND_TESTING || CONFIG_BRAND_CUSTOM_BUILD)
	.error "Please select brand either matching the CONFIG_MB_*, or a testing/custom one"
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
#if CONFIG_CPU_M65_45GS02
	.eval selected++
#endif
#if CONFIG_CPU_WDC_65816
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_CPU_* option" 
}



// Check that memory model and ROM layout configurations is correct
{
#if ROM_LAYOUT_M65 && !CONFIG_CPU_M65_45GS02
	.error "Mega65 ROM layout requires CONFIG_CPU_M65_45GS02"
#endif
#if ROM_LAYOUT_M65 && !CONFIG_MB_MEGA_65
	.error "Mega65 ROM layout requires CONFIG_MB_MEGA_65"
#endif

	.var selected = 0;

#if CONFIG_MEMORY_MODEL_38K
	.eval selected++
#endif
#if CONFIG_MEMORY_MODEL_46K
	.eval selected++
#endif
#if CONFIG_MEMORY_MODEL_50K
	.eval selected++
#endif
#if CONFIG_MEMORY_MODEL_60K
	.eval selected++
#endif

	.if (selected != 1) .error "Please select exactly one CONFIG_MEMORY_MODEL_* option" 
}



// Check that IEC configuration is correct
{
#if CONFIG_IEC_JIFFYDOS && !CONFIG_IEC
	.error "CONFIG_IEC_JIFFYDOS requires CONFIG_IEC"
#endif

#if CONFIG_IEC_JIFFYDOS_BLANK && !CONFIG_IEC_JIFFYDOS
	.error "CONFIG_IEC_JIFFYDOS_BLANK requires CONFIG_IEC_JIFFYDOS"
#endif

#if CONFIG_IEC_DOLPHINDOS && !CONFIG_IEC
	.error "CONFIG_IEC_DOLPHINDOS requires CONFIG_IEC"
#endif

#if CONFIG_IEC_DOLPHINDOS_FAST && !CONFIG_IEC_DOLPHINDOS
	.error "CONFIG_IEC_DOLPHINDOS_FAST requires CONFIG_IEC_DOLPHINDOS"
#endif

#if (CONFIG_IEC_BURST_CIA1 || CONFIG_IEC_BURST_CIA1 || CONFIG_IEC_BURST_MEGA_65) && !CONFIG_IEC
	.error "CONFIG_IEC_BURST_* requires CONFIG_IEC"
#endif

#if CONFIG_IEC_BURST_MEGA_65 && !CONFIG_MB_MEGA_65
	.error "CONFIG_IEC_BURST_MEGA_65 requires CONFIG_MB_MEGA_65"
#endif

	.var selected_iec_burst = 0;

#if CONFIG_IEC_BURST_CIA1
	.eval selected_iec_burst++
#endif
#if CONFIG_IEC_BURST_CIA2
	.eval selected_iec_burst++
#endif
#if CONFIG_IEC_BURST_MEGA_65
	.eval selected_iec_burst++
#endif

	.if (selected_iec_burst > 1) .error "Please select at most one CONFIG_IEC_BURST_* option" 
}



// Check that tape configuration is correct
{
#if (!CONFIG_TAPE_NORMAL || !CONFIG_TAPE_TURBO) && CONFIG_TAPE_AUTODETECT
	.error "CONFIG_TAPE_AUTODETECT requires both CONFIG_TAPE_NORMAL and CONFIG_TAPE_TURBO"
#endif
}



// Check that RS-232 configuration is correct
{
#if CONFIG_RS232_UP9600 && (CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO)
	.error "CONFIG_RS232_UP9600 is not compatible with CONFIG_TAPE_*"
#endif

	.var selected_rs232 = 0;

#if CONFIG_RS232_UP2400
	.eval selected_rs232++
#endif
#if CONFIG_RS232_UP9600
	.eval selected_rs232++
#endif

	.if (selected_rs232 > 1) .error "Please select at most one CONFIG_RS232_* option" 
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

#if CONFIG_MB_MEGA_65 && CONFIG_SHOW_PAL_NTSC
	.error "MEGA65 can switch PAL/NTSC during run-time, CONFIG_SHOW_PAL_NTSC makes no sense"
#endif

}



// Check if keyboard options are correct
.function CHECK_KEYCMD(keycmd)
{
	.if (keycmd.size() > 0) .return 1
	.return 0
}
{
#if CONFIG_LEGACY_SCNKEY && CONFIG_RS232_UP9600
	.error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_RS232_UP9600"
#endif
#if CONFIG_LEGACY_SCNKEY && CONFIG_TAPE_NORMAL
	.error "CONFIG_LEGACY_SCNKEY is not compatible with CONFIG_TAPE_NORMAL"
#endif
#if CONFIG_LEGACY_SCNKEY && (CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C128_CAPS_LOCK || CONFIG_KEYBOARD_C65 || CONFIG_KEYBOARD_C65_CAPS_LOCK)
	.error "CONFIG_LEGACY_SCNKEY and CONFIG_KEYBOARD_C128* / CONFIG_KEYBOARD_C65* are mutually exclusive"
#endif

#if (CONFIG_MB_MEGA_65 || CONFIG_MB_ULTIMATE_64) && (CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C128_CAPS_LOCK)
	.error "Selected CONFIG_MB_* is not compatible with CONFIG_KEYBOARD_C128*"
#endif
#if CONFIG_MB_ULTIMATE_64 && (CONFIG_KEYBOARD_C65 || CONFIG_KEYBOARD_C65_CAPS_LOCK)
	.error "Selected CONFIG_MB_* is not compatible with CONFIG_KEYBOARD_C65*"
#endif

	.var num_pkeys_base = 0
	.var num_pkeys_ext1 = 0
	.var num_pkeys_ext2 = 0

	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_RUN)

	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F1)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F2)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F3)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F4)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F5)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F6)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F7)
	.eval num_pkeys_base += CHECK_KEYCMD(CONFIG_KEYCMD_F8)

	.eval num_pkeys_ext1 += CHECK_KEYCMD(CONFIG_KEYCMD_HELP)

	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F9)
	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F10)
	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F11)
	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F12)
	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F13)
	.eval num_pkeys_ext2 += CHECK_KEYCMD(CONFIG_KEYCMD_F14)

	.var num_pkeys = num_pkeys_base
#if !CONFIG_LEGACY_SCNKEY && (CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65)
	.eval num_pkeys += num_pkeys_ext1
#endif
#if !CONFIG_LEGACY_SCNKEY && CONFIG_KEYBOARD_C65
	.eval num_pkeys += num_pkeys_ext2
#endif

#if CONFIG_PROGRAMMABLE_KEYS
	.if (num_pkeys == 0) .error "CONFIG_PROGRAMMABLE_KEYS requires at least one defined key"
#endif
}



// Check that features are configured correctly
{
#if CONFIG_TAPE_WEDGE && !CONFIG_TAPE_TURBO && !CONFIG_TAPE_NORMAL
	.error "CONFIG_TAPE_WEDGE requires CONFIG_TAPE_TURBO or CONFIG_TAPE_NORMAL"
#endif
#if !CONFIG_TAPE_WEDGE && CONFIG_TAPE_HEAD_ALIGN
	.error "CONFIG_TAPE_HEAD_ALIGN requires CONFIG_TAPE_WEDGE"
#endif
}



// Handle I/O configuration

#if CONFIG_RS232_UP2400 || CONFIG_RS232_UP9600
#define HAS_RS232
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



// Setup colors

#if CONFIG_COLORS_BRAND && CONFIG_BRAND_ULTIMATE_64

	.const CONFIG_COLOR_BG  = $00
	.const CONFIG_COLOR_TXT = $01

#else

	.const CONFIG_COLOR_BG  = $06
	.const CONFIG_COLOR_TXT = $01

#endif
